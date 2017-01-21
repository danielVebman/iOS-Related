import PIL
import sys
import os
import shutil
from PIL import Image

print("A png of size 1024x1024 would be ideal.")
image_loc = raw_input("Image location: ").replace(" ", "")
image = PIL.Image.open(image_loc)
w, h = image.size
croppedImage = image.crop((0, 0, min(w, h), min(w, h)))

filenames = [
"iphone-20-2x.png",
"iphone-20-3x.png",
"iphone-29-2x.png",
"iphone-29-3x.png",
"iphone-40-2x.png",
"iphone-40-3x.png",
"iphone-60-2x.png",
"iphone-60-3x.png",
"ipad-20-1x.png",
"ipad-20-2x.png",
"ipad-29-1x.png",
"ipad-29-2x.png",
"ipad-40-1x.png",
"ipad-40-2x.png",
"ipad-76-1x.png",
"ipad-76-2x.png",
"ipad-83.5-2x.png"
]

data = [filename[:-4].split("-")[1:] for filename in filenames]

dir = os.path.dirname(image_loc)
folder = dir + "/AppIcon.appiconset/"

if os.path.exists(folder):
    if raw_input(folder + " already seems to exist. Remove it and procede? y/n ") == "y":
        shutil.rmtree(folder)
    else:
        sys.exit()

os.makedirs(folder)
print("Folder created at " + folder)

for n in range(len(data)):
    d = data[n]
    length = int(float(d[0]) * int(d[1].replace("x", "")))
    resizedImage = image.resize((length, length), PIL.Image.ANTIALIAS)
    resizedImage.save(folder + "/" + filenames[n])
    print("Saved " + filenames[n])


contents = """
{
  "images" : [
    {
      "size" : "20x20",
      "idiom" : "iphone",
      "filename" : "iphone-20-2x.png",
      "scale" : "2x"
    },
    {
      "size" : "20x20",
      "idiom" : "iphone",
      "filename" : "iphone-20-3x.png",
      "scale" : "3x"
    },
    {
      "size" : "29x29",
      "idiom" : "iphone",
      "filename" : "iphone-29-2x.png",
      "scale" : "2x"
    },
    {
      "size" : "29x29",
      "idiom" : "iphone",
      "filename" : "iphone-29-3x.png",
      "scale" : "3x"
    },
    {
      "size" : "40x40",
      "idiom" : "iphone",
      "filename" : "iphone-40-2x.png",
      "scale" : "2x"
    },
    {
      "size" : "40x40",
      "idiom" : "iphone",
      "filename" : "iphone-40-3x.png",
      "scale" : "3x"
    },
    {
      "size" : "60x60",
      "idiom" : "iphone",
      "filename" : "iphone-60-2x.png",
      "scale" : "2x"
    },
    {
      "size" : "60x60",
      "idiom" : "iphone",
      "filename" : "iphone-60-3x.png",
      "scale" : "3x"
    },
    {
      "size" : "20x20",
      "idiom" : "ipad",
      "filename" : "ipad-20-1x.png",
      "scale" : "1x"
    },
    {
      "size" : "20x20",
      "idiom" : "ipad",
      "filename" : "ipad-20-2x.png",
      "scale" : "2x"
    },
    {
      "size" : "29x29",
      "idiom" : "ipad",
      "filename" : "ipad-29-1x.png",
      "scale" : "1x"
    },
    {
      "size" : "29x29",
      "idiom" : "ipad",
      "filename" : "ipad-29-2x.png",
      "scale" : "2x"
    },
    {
      "size" : "40x40",
      "idiom" : "ipad",
      "filename" : "ipad-40-1x.png",
      "scale" : "1x"
    },
    {
      "size" : "40x40",
      "idiom" : "ipad",
      "filename" : "ipad-40-2x.png",
      "scale" : "2x"
    },
    {
      "size" : "76x76",
      "idiom" : "ipad",
      "filename" : "ipad-76-1x.png",
      "scale" : "1x"
    },
    {
      "size" : "76x76",
      "idiom" : "ipad",
      "filename" : "ipad-76-2x.png",
      "scale" : "2x"
    },
    {
      "size" : "83.5x83.5",
      "idiom" : "ipad",
      "filename" : "ipad-83.5-2x.png",
      "scale" : "2x"
    }
  ],
  "info" : {
    "version" : 1,
    "author" : "xcode"
  }
}
"""

file = open(folder + "Contents.json", "a")
file.write(contents)
file.close()

print("Saved Contents.json")
print("Wrote 28 files in 1 directory")
