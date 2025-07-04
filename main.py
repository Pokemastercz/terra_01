import pygame, sys, time, math, os, cyfunctions
import functions as fun

# python cysetup.py build_ext --inplace   (builds the cyfunctions file)


#Varibles
rate=5
scale=5




pygame.init
win = pygame.display.set_mode(((scale*fun.world_width*fun.tilesize),(scale*fun.world_height*fun.tilesize)))
ww,wh=win.get_size()
pygame.display.set_caption("Mazeom")
clock = pygame.time.Clock()

fun.load_textures(fun.folder_texture_blocks,scale)

start,goal=fun.startgoal()
print(start,goal)
plx,ply=start
dir=3 # 1=left, 2=up, 3=right, 4=down
running="True"
pygame.mouse.set_visible(False)
dirstring=""
tick=0




while running != "False":

    for event in pygame.event.get():
        if event.type == pygame.QUIT:
            pygame.quit()
            sys.exit()
    win.fill((39,39,39))
    blocktexturedims=(scale*fun.tilesize)
    fun.terrainproject(scale,ww,wh)
    #print(plx,ply)
    if running == "True":
        plx,ply,dir,dirstring,tick,running=fun.algorithm(plx,ply,dir,dirstring,tick,scale,goal,running,ww,wh,start)
        print(dirstring,tick)
    else:
        tick,running,plx,ply=fun.secondary(plx,ply,dirstring,tick,scale,running,ww,wh)
    #Now let's do a purge of the dirstring >:]




    msx,msy=pygame.mouse.get_pos()
    win.blit(pygame.transform.scale(pygame.image.load("resources/textures/entities/cursor.png").convert_alpha(),(5*scale,5*scale)),(msx,msy))    
    #print(clock.get_fps())
    pygame.display.update()
    clock.tick(rate)