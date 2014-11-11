# Compressed Magento 1.9.0.0 Sample Data

Its kind of ridiculous having a sample data package that is 317MB in size, and since I couldn't find
a good alternative source, I decided to hack together a little script to compress the hell out of the images and the MP3 files
in the sample data archive.  
My intention is that it can be downloaded faster and used more easily.

With a image quality setting of 50% and by sampling all .mp3 files down to a bitrate of 48, the size of the sample data archive is reduced to 66MB.

This is okay for my purposes.  
If you don't want to have the .mp3 files in there at all you can save another 40MB by running the command

    find magento-sample-data-1.9.0.0 -type f -iname '*.mp3' -exec rm "{}" \; -exec touch "{}" \;

The compression script is intended to run on OS X. Feel free to use and modify it, but be aware that you are doing so at your own risk!

