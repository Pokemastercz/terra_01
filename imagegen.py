from PIL import Image
import os,math
filepathsource="resources/textures/blocksource/"
filepathgoal="resources/textures/blocks/"


#Imports the palette
paletteimg=Image.open("resources/textures/entities/palette.png").convert("RGBA")
palette={}
print(paletteimg.width,paletteimg.height)
for currpixelx in range(paletteimg.width):
    for currpixely in range(paletteimg.height):
            if not paletteimg.getpixel((currpixelx,currpixely))==(0,0,0,0):
                palette[(currpixelx,currpixely)]=paletteimg.getpixel((currpixelx,currpixely))
                print(currpixelx,currpixely,palette[(currpixelx,currpixely)])
currimg=0
currstatecount=0

# Counts the images in our source folder
def count_images(folder):
    return len([file for file in os.listdir(folder) if file.lower().endswith(".png")])

# Different indices for the 16 different neighbour states
indices=[
    "aaaa",
    "bbbb",
    "abbb",
    "babb",
    "bbab",
    "bbba",
    "aabb",
    "baab",
    "bbaa",
    "abba",
    "aaab",
    "baaa",
    "abaa",
    "aaba",
    "abab",
    "baba",

]

# Function to draw the state on the image
def drawstate(image,filename,state,goal_path,imgcount,currimg,currstatecount):
    imagemask=[False]*64
    if state[0]=="b":
        for y in range(8):
            imagemask[y*8]=True
    if state[1]=="b":
        for x in range(8):
            imagemask[x]=True
    if state[2] == "b":
        for y in range(8):
            imagemask[y*8+7]=True
    if state[3] == "b":
        for x in range(8):
            imagemask[56+x]=True
    imgpalettebind = {}
    for currx in range(image.width):
        for curry in range(image.height):
            pixel=image.getpixel((currx,curry))
            for pal_coord,pal_color in palette.items():
                if pixel==pal_color:
                    imgpalettebind[(currx,curry)]=pal_coord
                    break
            else:
                print(f"[WARN] Pixel {pixel} at ({currx},{curry}) not found in palette in {filename}")
    for currx in range(image.width):
        for curry in range(image.height):
            index=currx+curry*image.width
            if imagemask[index]:
                if (currx,curry)in imgpalettebind:
                    old_cell=imgpalettebind[(currx,curry)]
                    new_y=max(0,old_cell[1]-1)
                    new_cell=(old_cell[0],new_y)
                    if new_cell in palette:
                        image.putpixel((currx,curry),palette[new_cell])
                    else:
                        print(f"[WARN] New palette cell {new_cell} not found for {filename}")
                else:
                    print(f"[WARN] No palette binding for pixel ({currx},{curry}) in {filename}")

    image.save(goal_path)
    print("(",currimg,"/",imgcount,") ",
          (math.floor(((((currimg-1)*16)+currstatecount)/(imgcount*16))*1000))/10,
          "%  ",currstatecount,"/16",sep="")


# Main loop to process images
imgcount=count_images(filepathsource)
for filename in os.listdir(filepathsource):
    currimg+=1
    pass
    if filename.endswith(".png"):
        source_path=os.path.join(filepathsource,filename)
        currstatecount=0
        for currstate in indices:
            currstatecount+=1
            with Image.open(source_path).convert("RGBA") as img:
                texture_name=os.path.splitext(filename)[0]
                goal_path=os.path.join(filepathgoal,texture_name+currstate+".png")
                drawstate(img,texture_name,currstate,goal_path,imgcount,currimg,currstatecount)
print("DONE")