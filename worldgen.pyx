import functions as fun
import pygame, sys, time ,math,random, os, cyfunctions
#import saves.world_0.strings.string as string
import saves.world_0.strings.string as stringfile

def generate_world(world_width,world_height,chunksize):
    heightmap=worldgen(world_width,world_height+10,chunksize,0)
    heightmap=worldgens(world_width,world_height+10,(chunksize/2),heightmap,0.1)
    tempmap=worldgen(world_width,world_height+10,world_height,0.03)
    stringwg=wstringing(heightmap,tempmap,world_width,world_height+10)
    return(stringwg)

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