# Tool for Compressing Magento Sample Data

## Why
Its kind of ridiculous having a sample data package that is 317MB in size, and since I couldn't find
a good alternative source, I decided to hack together a little script to compress the hell out of the images and the MP3 files
in the sample data archive.  
My intention is that it can be downloaded faster and used more easily for quicker development.

## How
This is accomplished with image quality setting of 40% and by removing all .mp3 files. The compression script in the src/ directory is intended to run on linux. Feel free to use and modify it, but be aware that you are doing so at your own risk!

## Usage
Move a tarball of Magento sample data into the src directory of the repository. The first parameter of the script is either a url or filename.

```sh
./compress-sample-data.sh 1.14.2.1.tar.gz
```

## Dependencies
##### ImageMagick
```sh
sudo apt-get install imagemagick
```
##### ImageOptim
```sh
sudo gem install image_optim image_optim_pack
```
###### ImageOptim Dependencies:
```sh
sudo apt-get install -y advancecomp gifsicle jhead jpegoptim libjpeg-progs optipng pngcrush pngquant
npm install -g svgo
```
######   PNG Out
Visit http://www.jonof.id.au/kenutils to download binary

#### Lame for compressing mp3s (if desired)
```sh
sudo apt-get install lame libmp3lame0
```