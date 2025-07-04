# game_logic.pyx
import functions as fun
import pygame, sys, time ,math, os, cyfunctions
#import saves.world_0.strings.string as string
import saves.world_0.strings.string as stringfile

folder_texture_blocks = "resources/textures/blocks"
textures_blocks = {}

tilesize = 8
ww, wh = 1854, 1010

win = pygame.display.set_mode((ww,wh))

world_width = 32
world_height = 32

#LAND OF THE FREE MIND

def load_textures(folder,scale):
    for filename in os.listdir(folder):
        if filename.endswith(".png")or filename.endswith(".jpg"):
            texture_path = os.path.join(folder, filename)
            texture_name = os.path.splitext(filename)[0]  
            texture = pygame.image.load(texture_path).convert_alpha()
            textures_blocks[texture_name] = pygame.transform.scale(texture, ((tilesize*scale),(tilesize*scale)))


def projector(texture, xpos,ypos,scale):
    xposp=((ww/2)+(xpos*scale))
    yposp=((wh/2)+(ypos*scale))
    win.blit(textures_blocks[texture],(xposp,yposp))

def terrainproject(scale):
    string = stringfile.string
    for curry in range(world_height):
        for currx in range(world_width):
            tileposx=((0-(tilesize*(world_width/2)))+(currx*tilesize))
            tileposy=((0-(tilesize*(world_height/2)))+(curry*tilesize))
            tilestring = tilestringcalculate(currx,curry,string)
            if tilestring in textures_blocks:
                projector(tilestring,tileposx,tileposy,scale)
            else:
                projector("default",tileposx,tileposy,scale)

def tilestringcalculate(currx,curry,string):
    currtile=((world_width*(curry+1))+currx)
    indices=[((currtile-1)),((currtile-world_width)),((currtile+1)),((currtile+world_width))]
    tilestring=string[currtile]
    for currneighbour in indices:
        if string[currneighbour]==string[currtile]:
            tilestring+="a"
        else:
            tilestring+="b"
    return(tilestring)