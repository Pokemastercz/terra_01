# game_logic.pyx
import functions as fun
import pygame, sys, time ,math, os, cyfunctions
#import saves.world_0.strings.string as string
import saves.world_0.strings.string as stringfile

folder_texture_blocks = "resources/textures/blocks"
textures_blocks = {}

tilesize = 8

win = pygame.display.set_mode((0, 0))

world_width = 15
world_height = 15

start=(1,1)
goal=(13,13)
#LAND OF THE FREE MIND

def load_textures(folder,scale):
    for filename in os.listdir(folder):
        if filename.endswith(".png")or filename.endswith(".jpg"):
            texture_path = os.path.join(folder, filename)
            texture_name = os.path.splitext(filename)[0]  
            texture = pygame.image.load(texture_path).convert_alpha()
            textures_blocks[texture_name] = pygame.transform.scale(texture, ((tilesize*scale),(tilesize*scale)))


def projector(texture,ww,wh,xpos,ypos,scale):
    xposp=((ww/2)+(xpos*scale))
    yposp=((wh/2)+(ypos*scale))
    win.blit(textures_blocks[texture],(xposp,yposp))

def terrainproject(scale,ww,wh):
    string = stringfile.string
    for curry in range(world_height):
        for currx in range(world_width):
            tileposx=((0-(tilesize*(world_width/2)))+(currx*tilesize))
            tileposy=((0-(tilesize*(world_height/2)))+(curry*tilesize))
            tilestring = tilestringcalculate(currx,curry,string)
            if tilestring in textures_blocks:
                projector(tilestring,ww,wh,tileposx,tileposy,scale)
            else:
                projector("missing",ww,wh,tileposx,tileposy,scale)

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

def startgoal():
    for currx in range(world_width):
        for curry in range(world_height):
            currtile=((world_width*(curry+1))+currx)
            if stringfile.string[currtile]=="C":
                start=(currx,curry)
            if stringfile.string[currtile]=="D":
                goal=(currx,curry)
    return(start, goal)

def dirctrl(dir):
    if dir>4:
        dir=1
    if dir<1:
        dir=4
    return(dir)

def algorithm(plx,ply,dir,dirstring,tick,scale,goal,running,ww,wh):
    currtile=((world_width*(ply+1))+plx)
    plcind=[(-1,0),(0,-1),(1,0),(0,1)]  # left, up, right, down
    indices=[((currtile-1)),((currtile-world_width)),((currtile+1)),((currtile+world_width))]
    if plx==goal[0] and ply==goal[1]:
        print("Goal Reached!")
        dirstring+="5"
        tick+=1
        running="SecondaryActive"
        return(plx,ply,dir,dirstring,tick,running)
    
    dir+=1
    dir=dirctrl(dir)
    if stringfile.string[indices[dir-1]]=="B":
        dir-=1
        dir=dirctrl(dir)
        if stringfile.string[indices[dir-1]]=="B":
            dir-=1
            dir=dirctrl(dir)
        else:
            plx+=plcind[dir-1][0]
            ply+=plcind[dir-1][1]
            print("Moved to:", (plx, ply), "Direction:", dir)
            dirstring+=str(dir)
            tick+=1
    else:
        plx+=plcind[dir-1][0]
        ply+=plcind[dir-1][1]
        print("Moved to:", (plx, ply), "Direction:", dir)
        dirstring+=str(dir)
        tick+=1

    dir=dirctrl(dir)
    tileposx=((0-(tilesize*(world_width/2)))+(plx*tilesize))
    tileposy=((0-(tilesize*(world_height/2)))+(ply*tilesize))
    projector(("pl"+str(dir)),ww,wh,tileposx,tileposy,scale)
    return(plx,ply,dir,dirstring,tick,running)