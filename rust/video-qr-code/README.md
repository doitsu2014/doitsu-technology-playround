# Introduction

## Installation

1. Upgrade packages
```bash
sudo apt update
sudo apt upgrade
```

2. Reboot kernel to make sure the behavior is going to the good state
```bash
sudo systemctl reboot
```

3. OpenCV Python package using the commands below.
```bash
sudo apt update
sudo apt install python3-opencv
```

4. Install builders for OpenCV
```bash
sudo apt update
sudo apt install git gcc g++ ffmpeg cmake make python3-dev python3-numpy libavcodec-dev libavformat-dev libswscale-dev libgstreamer-plugins-base1.0-dev libgstreamer1.0-dev libgtk-3-dev libpng-dev libjpeg-dev libopenexr-dev libtiff-dev libwebp-dev
```

5. Clone and build the opencv sources
```bash
cd ~/
git clone https://github.com/opencv/opencv.git
git clone https://github.com/opencv/opencv_contrib.git

cd ~/
cd opencv
mkdir build
cd build

# build sources
cmake -D OPENCV_EXTRA_MODULES_PATH=~/opencv_contrib/modules ..

# Install sources
make -j $(nproc)
sudo make install
```

## References
- Based on this source: https://github.com/rajeshpachaikani/QR-Reader-Rust-OpenCV-Demo/blob/main/src/main.rs
- Follow this link to install opencv: https://computingforgeeks.com/how-to-install-opencv-on-ubuntu-linux/