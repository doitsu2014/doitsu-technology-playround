@ECHO OFF
CLS
SETLOCAL enableextensions enabledelayedexpansion
CALL :SET_ESC

SET RELATIVE_SETTING_PATH=../OpenSearch
SET DEVOPS_TOOL_FOLDER=../../tools/

SET K8S_NAMESPACE=%1

rem evn : dev, dev1, qc, test,stg, prod
SET ENV=%2

SET AZURE_REGION=%3

FOR /F "delims=" %%R in ('java -jar !DEVOPS_TOOL_FOLDER!/ExtractValueFromRegEx.jar -f -s "!RELATIVE_SETTING_PATH!/security.csv" -r "(kibanaserver,)(.*)(,true)" -p 2 -t base64encode') DO (
	set kibanaserver_password=%%R
)

call az aks get-credentials --resource-group amex-!ENV! --name amex-!ENV!-aks

CALL:LOG  "Create internal users yaml value file from security.csv file"
java -jar !DEVOPS_TOOL_FOLDER!/OpenSearchUtil.jar -a generate-internal-user-file -i "!RELATIVE_SETTING_PATH!\security.csv" -o "!RELATIVE_SETTING_PATH!/apps/02.opensearch\secrets-chart\secret-values\security\internal_users_value.yml"

kubectl create namespace !K8S_NAMESPACE!
kubectl create namespace cert-manager

CALL:LOG  "Replace kibanaserver password"
java -jar !DEVOPS_TOOL_FOLDER!/SearchAndReplace.jar -f "!RELATIVE_SETTING_PATH!/apps/02.opensearch/secrets-chart/templates/secrets/kibana-user.yaml" -s "(password:)(.*)"  -r "$1 !kibanaserver_password!"
rem helmfile --file ./helmfile.yaml  --state-values-set env=!ENV!,ns=!K8S_NAMESPACE! --log-level info sync

rem install cert-manager with forceNamespace to force namesapce to be cert-manager (override helmfile --namespace) but
rem  meta.helm.sh/release-namespace in some cert-manager resouce still get --namespace value
rem --> install cert-manager (using same cert-manager) will be failed because helm expect diferrent value of meta.helm.sh/release-namespace 
rem --> Seperate to 2 routines to install

rem install cert-manager first
CALL:LOG  "Deploy cert-manager"
helmfile --file ./apps/01.cert-manager/helmfile.yaml --namespace cert-manager --log-level info sync

rem then install opensearch
CALL:LOG  "Deploy opensearch"
helmfile --file ./apps/02.opensearch/helmfile.yaml  --state-values-set env=!ENV! --namespace !K8S_NAMESPACE! --log-level info sync

GOTO DONE 
:ERROR
 CALL:LOG_ERR "Cannot finish Setup process"
 endlocal
 GOTO:eof

:DONE
 CALL:LOG "Finish Setup process"
 endlocal
 GOTO:eof
 
:LOG
  ECHO.
  REM ECHO %~1
  ECHO %ESC%[32m%~1%ESC%[0m
  GOTO:eof

:LOG_ERR
 ECHO.
 REM ECHO %~1
 ECHO %ESC%[31m%~1%ESC%[0m
 GOTO:eof

:SET_ESC
FOR /F "tokens=1,2 delims=#" %%a in ('"prompt #$H#$E# & ECHO on & FOR %%b in (1) do rem"') do (
  SET ESC=%%b
  EXIT /B 0
)
EXIT /B 0