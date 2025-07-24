import pygame,sys,time,math,os,cyfunctions,random,worldgen
import functions as fun

# python3 cysetup.py build_ext --inplace   (builds the cyfunctions file)
# python3 cysetupworldgen.py build_ext --inplace   (builds the worldgen file)

ww,wh=1854,1010
pygame.init
win=pygame.display.set_mode((ww,wh))
pygame.display.set_caption("Terra")
clock=pygame.time.Clock()
scale=10
cyfunctions.load_textures(cyfunctions.folder_texture_blocks,scale)

plx, ply = 60,60

pygame.mouse.set_visible(False)


stringwg=worldgen.generate_world(32,32,16)

while True:

    for event in pygame.event.get():
        if event.type==pygame.QUIT:
            pygame.quit()
            sys.exit()
    msx,msy=pygame.mouse.get_pos()
    plx,ply=cyfunctions.collisions(plx,ply,(((1-(msx/(ww/2)))/4)*-1),(((1-(msy/(wh/2)))/4)*-1),stringwg)
    win.fill((0,127,127))
    blocktexturedims=(scale*cyfunctions.tilesize)
    cyfunctions.terrainproject(plx,ply,scale,stringwg)
    





    
    tileindx,tileindy=cyfunctions.tileind(plx,ply,msx,msy,scale)
    win.blit(pygame.transform.scale(pygame.image.load("resources/textures/entities/cursor.png").convert_alpha(),(5*scale,5*scale)),(msx,msy)) #Projects the cursor texture to the screen
    print(clock.get_fps())
    pygame.display.update()
    clock.tick(600)