#!/bin/bash

#
# This script agressivly compresses the magento sample data images and mp3 files
# Use at your own risk!
#
# It is a quick hack, intended only to run on OSX with the following dependencies:
# - ImageMagick (that is, the convert command)
# - ImageOptim
# - lame
# - grealpath
# - curl (only for downloading the sample data)
# - 7za
#
# (c) 2014 Vinai Kopp <vinai@netzarbeiter.com>
#

###############################################################################
# PREREQUISITES
###############################################################################
# ImageMagick
# sudo apt-get install imagemagick

# ImageOptim
# gem install image_optim image_optim_pack
# ImageOptim Dependencies:
#   Dep 1:
#   sudo apt-get install -y advancecomp gifsicle jhead jpegoptim libjpeg-progs optipng pngcrush pngquant
#   Dep 2:
#   SVGO
#   npm install -g svgo
#   Dep 3:
#   PNG Out
#   http://www.jonof.id.au/kenutils

# Lame for compressing mp3s
# sudo apt-get install lame libmp3lame0

TARGET_MP3_BITRATE=48
TARGET_IMAGE_QUALITY_PERCENTAGE=40
EXCLUDE_FILES='\._*'
BASE_DIRECTORY="$(realpath .)"


if [ -z "$1" ]; then
    echo "No sample data specified."
    read -r -p "Do you want to download the 1.9 sample data? [yN] "
    [[ "$REPLY" = [Yy] ]] && download=http://www.magentocommerce.com/downloads/assets/1.9.1.0/magento-sample-data-1.9.1.0.tar.bz2

elif echo "$1" | grep -q '^https\?:'; then
    download="$1"
fi

if [ -n "$download" ]; then
    echo "Downloading $download"
    curl -O "$download"
    SOURCE_ARCHIVE="$(realpath "$(basename "$download")")"

elif [ -n "$1" ]; then
    SOURCE_ARCHIVE="$(realpath "$1")"
fi

[ ! -e "$SOURCE_ARCHIVE" ] && {
    echo -e "Usage:\n$0 magento-sample-data-1.x.x.x.tar.bz2"
    exit 2
}
echo "Using sample data $SOURCE_ARCHIVE"

ORIG_SIZE=$(du -sh "$SOURCE_ARCHIVE" | awk '{ print $1 }')

IMAGE_OPTIM_PATH="image_optim"

WORK_DIR="./tmp-work-dir"
echo "Creating temporary working dir $WORK_DIR"
mkdir "$WORK_DIR" && cd "$WORK_DIR"
echo "Extracting sample data..."
tar -xzf "$SOURCE_ARCHIVE"


echo "Removing resized images cache files"
SAMPLE_DATA_DIR="$(realpath .)"
rm -rf "$SAMPLE_DATA_DIR"/media/catalog/product/cache/*

echo "Compressing images...found in $SAMPLE_DATA_DIR"
find "$SAMPLE_DATA_DIR" -type f \( -iname '*.jpg' -o -iname '*.png' -o -iname '*.gif' \) -exec convert -quality $TARGET_IMAGE_QUALITY_PERCENTAGE "{}" "{}" \;
image_optim 2>/dev/null "$SAMPLE_DATA_DIR"

echo "Removing MP3 files"
find "$SAMPLE_DATA_DIR" -type f -iname '*.mp3' -exec rm "{}" \; -exec touch "{}" \;

#echo "Compressing mp3 files..."
#find "$SAMPLE_DATA_DIR" -type f -iname '*.mp3' -exec lame --silent -b $TARGET_MP3_BITRATE "{}" "{}.out" \; -exec mv "{}.out" "{}" \;

echo "Building new sample data archive ../compressed-sample-data.tgz..."
tar --exclude $EXCLUDE_FILES -czf "../compressed-sample-data.tgz" "./"

cd .. # get out of the tmp-work-dir
rm -r "$WORK_DIR"

echo "New compressed sample data archive:"
echo "Original size:   $ORIG_SIZE"
NEW_SIZE=$(du -sh "$BASE_DIRECTORY/compressed-sample-data.tgz"  | awk '{ print $1 }');
echo "Compressed size tgz:    $NEW_SIZE"