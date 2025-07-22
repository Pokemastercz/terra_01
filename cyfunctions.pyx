# game_logic.pyx
import functions as fun
import pygame, sys, time ,math,random, os
#import saves.world_0.strings.string as string
import saves.world_0.strings.string as stringfile
with open("saves/world_0/strings/spawn.wstr", "r") as f:
    strings = f.read()

folder_texture_blocks = "resources/textures/blocks"
string_filepath = "saves/world_0/strings/string.py"
textures_blocks = {}

tilesize = 8
cdef int ww=1854
cdef int wh=1010

cdef int x = 5

cpdef int get_x():
    return x


win = pygame.display.set_mode((ww,wh))
cdef int chunkcountx = 2
cdef int chunkcounty = 2
cdef int chunksize=16
cdef int world_width = chunksize*chunkcountx
cdef int world_height = chunksize*chunkcounty
def load_textures(folder,scale): #Loads the textures from the specified folder and scales them
    for filename in os.listdir(folder):
        if filename.endswith(".png")or filename.endswith(".jpg"):
            texture_path = os.path.join(folder, filename)
            texture_name = os.path.splitext(filename)[0]  
            texture = pygame.image.load(texture_path).convert()
            textures_blocks[texture_name] = pygame.transform.scale(texture, ((tilesize*scale),(tilesize*scale)))
    textures_blocks["tileindicator"] = pygame.transform.scale(pygame.image.load("resources/textures/entities/tileindicator.png").convert_alpha(), ((tilesize*scale),(tilesize*scale)))


cdef projector(texture, xpos,ypos,scale): #Projects the texture to the screen based on the position on the map and scale
    cdef int xposp=((ww/2)+(xpos*scale))
    cdef int yposp=((wh/2)+(ypos*scale))
    win.blit(textures_blocks[texture],(xposp,yposp))

cpdef terrainproject(plx,ply,scale,string): #Projects the terrain based on the player position and the world string
    for curry in range(world_height):
        for currx in range(world_width):
            tileposx=((0-plx)+(currx*tilesize))
            tileposy=((0-ply)+(curry*tilesize))
            if not ((ww/2)+(tileposx*scale)) < ((tilesize*scale)*-1) and not ((wh/2)+(tileposy*scale)) < ((tilesize*scale)*-1) and not((ww/2)+(tileposx*scale)) > ww and not((wh/2)+(tileposy*scale)) > wh:
                tilestring = tilestringcalculate(currx,curry,string)
                if tilestring in textures_blocks:
                    projector(tilestring,tileposx,tileposy,scale)
                else:
                    projector("default",tileposx,tileposy,scale)

cdef int wang_hash(int seed):
    seed=(seed^61)^(seed>>16)
    seed=seed+(seed<<3)
    seed=seed^(seed>>4)
    seed=seed*0x27d4eb2d
    seed=seed^(seed>>15)
    return seed & 0x7fffffff

cdef str tilestringcalculate(int currx,int curry,str string):
    cdef int currtile=(world_width*(curry+1))+currx

    cdef int idx=currtile*5
    cdef char underlying=string[idx+1]
    cdef char tile=string[idx+3]
    cdef char tileexact=string[idx+4]

    cdef char result[8]
    result[7]=0
    result[0]=underlying
    result[1]=tile
    result[2]=tileexact

    cdef int hashval = wang_hash(currx * 928371 + curry * 425897)
    result[3] = <char>(48 + (hashval % 4))

    cdef int neighbor_indices[4]
    neighbor_indices[0]=(currtile-1)*5
    neighbor_indices[1]=(currtile-world_width)*5
    neighbor_indices[2]=(currtile+1)*5
    neighbor_indices[3]=(currtile+world_width)*5

    cdef int i
    for i in range(4):
        if string[neighbor_indices[i]+3]==tile:
            result[4+i]='a'
        else:
            result[4+i]='b'
    return result.decode('ascii')

def tileind(plx,ply,msx,msy,scale): #Detects the tile under the mouse cursor
    indtx=((0-plx)+((math.floor(((plx)-(((ww/2)-msx)/scale))/(tilesize)))*tilesize))
    indty=((0-ply)+((math.floor(((ply)-(((wh/2)-msy)/scale))/(tilesize)))*tilesize))
    tilex=(math.floor(((plx)-(((ww/2)-msx)/scale))/(tilesize)))
    tiley=(math.floor(((ply)-(((wh/2)-msy)/scale))/(tilesize)))
    #print(tilex,tiley)
    projector("tileindicator",indtx,indty,scale)
    return(tilex,tiley)