using nClam;

var clamClient   = new ClamClient("localhost", 3310);
var text         = await File.ReadAllTextAsync("./scanner.txt");
var memoryStream = new MemoryStream();
var streamWriter = new StreamWriter(memoryStream);
await streamWriter.WriteAsync(text);

var result = await clamClient.SendAndScanFileAsync(memoryStream);

streamWriter.Close();
memoryStream.Flush();
memoryStream.Close();

switch (result.Result)
{
    case ClamScanResults.Clean:
        Console.WriteLine("File is clean");
        break;
    default:
        Console.WriteLine("File is not clean");
        break;
}