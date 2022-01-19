# autocrop
A face-aware crop utility using OSX's Vision framework

This utility takes a photo, detect every face in the image file and 
save it as a jpg file in the directory you specified. 

Here are a few examples:

```shell
# To locate and safe all faces into `Faces` folder
autocrop ~/Documents/Photos/IMG_1772.JPG ~/Documents/Faces/

# To batch process of images, use `find`
find ~/Documents/Photos -name *.JPG -exec autocrop {} ~/Documents/Faces/ \;

# If you need to resize the file to 250x250, use `imagemagick`
find ~/Documents/Faces -name *.jpg -exec convert {} -resize 250x250 {} \;
```

## Improvements

1. For a portrait mug shot, we might end up with an image not entirely square.


