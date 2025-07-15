# game_logic.pyx
import functions as fun
import pygame, sys, time ,math,random, os, cyfunctions
#import saves.world_0.strings.string as string
import saves.world_0.strings.string as stringfile
with open("saves/world_0/strings/spawn.wstr", "r") as f:
    strings = f.read()

folder_texture_blocks = "resources/textures/blocks"
string_filepath = "saves/world_0/strings/string.py"
textures_blocks = {}

tilesize = 8
ww, wh = 1854, 1010

win = pygame.display.set_mode((ww,wh))
chunkcountx = 5
chunkcounty = 5
chunksize=16
world_width = chunksize*chunkcountx
world_height = chunksize*chunkcounty
def load_textures(folder,scale): #Loads the textures from the specified folder and scales them
    for filename in os.listdir(folder):
        if filename.endswith(".png")or filename.endswith(".jpg"):
            texture_path = os.path.join(folder, filename)
            texture_name = os.path.splitext(filename)[0]  
            texture = pygame.image.load(texture_path).convert_alpha()
            textures_blocks[texture_name] = pygame.transform.scale(texture, ((tilesize*scale),(tilesize*scale)))


def projector(texture, xpos,ypos,scale): #Projects the texture to the screen based on the position on the map and scale
    xposp=((ww/2)+(xpos*scale))
    yposp=((wh/2)+(ypos*scale))
    win.blit(textures_blocks[texture],(xposp,yposp))

def terrainproject(plx,ply,scale,string): #Projects the terrain based on the player position and the world string
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
    print(currx,curry)
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

def lerp(a,b,t):
    return a+(b-a)*t

def worldgen(world_width,world_height,chunksize,rnd):
    chunkcountx=int(world_width/chunksize)
    chunkcounty=int(world_height/chunksize)
    string=""
    dirs={}
    heightmap={}

    # Generate direction vectors per chunk
    for i in range((chunkcountx+1)*(chunkcounty+1)):
        angle=random.uniform(0,2*math.pi)
        dirs[i]=(math.cos(angle),math.sin(angle))

    for curry in range(world_height):
        for currx in range(world_width):
            chunkx=currx//chunksize
            chunky=curry//chunksize
            localx=(currx%chunksize)/chunksize
            localy=(curry%chunksize)/chunksize
            a=dirs[chunkx+(chunky*chunkcountx)]
            b=dirs[chunkx+1+(chunky*chunkcountx)]
            c=dirs[chunkx+((chunky+1)*chunkcountx)]
            d=dirs[chunkx+1+((chunky+1)*chunkcountx)]
            def dot(dx,dy,x,y):
                return dx*x+dy*y
            coorda=dot(*a,localx,localy)
            coordb=dot(*b,localx-1,localy)
            coordc=dot(*c,localx,localy-1)
            coordd=dot(*d,localx-1,localy-1)
            def fade(t):return t*t*t*(t*(t*6-15)+10)
            tx,ty=fade(localx),fade(localy)
            lerp1=lerp(coorda,coordb,tx)
            lerp2=lerp(coordc,coordd,tx)
            fvalue=lerp(lerp1,lerp2,ty)
            heightmap[(currx,curry)]=(fvalue+(rnd*random.uniform(-1,1)))
            #if fvalue>=0:
            #    if fvalue>=0.1:
            #        string+="DDACA"
            #    else:
            #        string+="CEAEA"
            #else:
            #    string+="BAAAA"
    return heightmap

def worldgens(world_width,world_height,chunksize,heightmap,hmod):
    chunkcountx=int(world_width/chunksize)
    chunkcounty=int(world_height/chunksize)
    string=""
    dirs={}

    # Generate direction vectors per chunk
    for i in range((chunkcountx+1)*(chunkcounty+1)):
        angle=random.uniform(0,2*math.pi)
        dirs[i]=(math.cos(angle),math.sin(angle))

    for curry in range(world_height):
        for currx in range(world_width):
            chunkx=currx//chunksize
            chunky=curry//chunksize
            localx=(currx%chunksize)/chunksize
            localy=(curry%chunksize)/chunksize
            a=dirs[chunkx+(chunky*chunkcountx)]
            b=dirs[chunkx+1+(chunky*chunkcountx)]
            c=dirs[chunkx+((chunky+1)*chunkcountx)]
            d=dirs[chunkx+1+((chunky+1)*chunkcountx)]
            def dot(dx,dy,x,y):
                return dx*x+dy*y
            coorda=dot(*a,localx,localy)
            coordb=dot(*b,localx-1,localy)
            coordc=dot(*c,localx,localy-1)
            coordd=dot(*d,localx-1,localy-1)
            def fade(t):return t*t*t*(t*(t*6-15)+10)
            tx,ty=fade(localx),fade(localy)
            lerp1=lerp(coorda,coordb,tx)
            lerp2=lerp(coordc,coordd,tx)
            fvalue=lerp(lerp1,lerp2,ty)
            heightmap[(currx,curry)]+=(fvalue*hmod)
    return heightmap

def wstringing(heightmap,tempmap,world_width,world_height):
    string=""
    for curry in range(world_height-5):
        for currx in range(world_width):
            if tempmap[(currx,curry)]>=-0.1:
                if heightmap[(currx,curry)]>=0:
                    if heightmap[(currx,curry)]>=0.1:
                        string+="DDACA"
                    else:
                        string+="CEAEA"
                else:
                    string+="BAAAA"
            else:
                if heightmap[(currx,curry)]>=(-0.1+(0.05*random.uniform(-1,1))):
                    if heightmap[(currx,curry)]>=0.1:
                        string+="EDAKA"
                    else:
                        string+="EAALA"
                else:
                    string+="BAAAA"
    return(string)