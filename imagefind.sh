#!/bin/bash

#mount image as a read-only virtual device to /mnt/analysis
sudo mount -o ro,loop "$image"

#this command does the following:
# find all files at the mount point
# add a null character at the end of each file name, so that xargs can distinguish between files which may contain spaces in the file name
# uses xargs to execute 'file' command using the "magic file" for images based on the hexadecimal of the header allowing us to modify PNG, BMP etc. extensions to match the _image_ tag of other image filetypes.
# searches the list of file types for ones which are of an image type
# cuts the output to just the file location, and wraps it in html tags
# saves the list to a text file for future reference/notekeeping
# concatenates the output with html templates to allow formatting, then saves to an html file 
find /mnt/analysis/ -type f -print0 | xargs --null file -m magic.short | grep "_image_" | awk -F: '{print $1 $2}' | awk '{print "<li> <a href=\""$1"\" target=dynamic>"$1 " Filetype: " $2" file.</a></li>"}' > image_list.txt
cat template_head.html image_list.txt template_tail.html > image_list.html 

#opens the output in firefox
firefox image_view.html



exit 0