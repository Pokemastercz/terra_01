# game_logic.pyx
import functions as fun
import pygame, sys, time ,math, os, cyfunctions
#import saves.world_0.strings.string as string
import saves.world_0.strings.string as stringfile

folder_texture_blocks = "resources/textures/blocks"
string_filepath = "saves/world_0/strings/string.py"
textures_blocks = {}

tilesize = 8
ww, wh = 1854, 1010

win = pygame.display.set_mode((ww,wh))

world_width = 32
world_height = 32

#LAND OF THE FREE MIND

def load_textures(folder,scale): #Loads the textures from the specified folder and scales them
    for filename in os.listdir(folder):
        if filename.endswith(".png")or filename.endswith(".jpg"):
            texture_path = os.path.join(folder, filename)
            texture_name = os.path.splitext(filename)[0]  
            texture = pygame.image.load(texture_path).convert_alpha()
            textures_blocks[texture_name] = pygame.transform.scale(texture, ((tilesize*scale),(tilesize*scale)))


def projector(texture, xpos,ypos,scale): #Projects the texture to the screen based on the position and scale
    xposp=((ww/2)+(xpos*scale))
    yposp=((wh/2)+(ypos*scale))
    win.blit(textures_blocks[texture],(xposp,yposp))

def terrainproject(plx,ply,scale): #Projects the terrain based on the player position and the world string
    string = stringfile.string
    for curry in range(world_height):
        for currx in range(world_width):
            tileposx=((0-plx)+(currx*tilesize))
            tileposy=((0-ply)+(curry*tilesize))
            tilestring = tilestringcalculate(currx,curry,string)
            if tilestring in textures_blocks:
                projector(tilestring,tileposx,tileposy,scale)
            else:
                projector("default",tileposx,tileposy,scale)

def tilestringcalculate(currx,curry,string): #Calculates the string for the tile based on the worldstring and its neighbours
    currtile=((world_width*(curry+1))+currx)
    indices=[((currtile-1)*5),((currtile-world_width)*5),((currtile+1)*5),((currtile+world_width)*5)]
    tilestring=string[((currtile*5)+1)]
    tilestring+=string[((currtile*5)+3)]
    tilestring+=string[((currtile*5)+4)]
    for currneighbour in indices:
        if string[currneighbour+3]==string[(currtile*5)+3]:
            tilestring+="a"
        else:
            tilestring+="b"
    return(tilestring)

def tileind(plx,ply,msx,msy,scale): #Detects the tile under the mouse cursor
    indtx=((0-plx)+((math.floor(((plx)-(((ww/2)-msx)/scale))/(tilesize)))*tilesize))
    indty=((0-ply)+((math.floor(((ply)-(((wh/2)-msy)/scale))/(tilesize)))*tilesize))
    tilex=(math.floor(((plx)-(((ww/2)-msx)/scale))/(tilesize)))
    tiley=(math.floor(((ply)-(((wh/2)-msy)/scale))/(tilesize)))
    print(tilex,tiley)
    projector("tileindicator",indtx,indty,scale)
    return(tilex,tiley)