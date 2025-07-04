import pygame, sys, time, math, os, cyfunctions
import functions as fun

# python cysetup.py build_ext --inplace   (builds the cyfunctions file)


#Varibles
rate=10
scale=5




pygame.init
win = pygame.display.set_mode(((scale*cyfunctions.world_width*cyfunctions.tilesize),(scale*cyfunctions.world_height*cyfunctions.tilesize)))
ww,wh=win.get_size()
pygame.display.set_caption("Mazeom")
clock = pygame.time.Clock()

cyfunctions.load_textures(cyfunctions.folder_texture_blocks,scale)

start,goal=cyfunctions.startgoal()
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
    blocktexturedims=(scale*cyfunctions.tilesize)
    cyfunctions.terrainproject(scale,ww,wh)
    #print(plx,ply)
    if running == "True":
        plx,ply,dir,dirstring,tick,running=cyfunctions.algorithm(plx,ply,dir,dirstring,tick,scale,goal,running,ww,wh)
        print(dirstring)
    #Now let's do a purge of the dirstring >:]




    msx,msy=pygame.mouse.get_pos()
    win.blit(pygame.transform.scale(pygame.image.load("resources/textures/entities/cursor.png").convert_alpha(),(5*scale,5*scale)),(msx,msy))    
    #print(clock.get_fps())
    pygame.display.update()
    clock.tick(rate)