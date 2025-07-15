import pygame,sys,time,math,os,cyfunctions,random
import functions as fun

# python cysetup.py build_ext --inplace   (builds the cyfunctions file)

ww,wh=1854,1010
pygame.init
win=pygame.display.set_mode((ww,wh))
pygame.display.set_caption("Terra")
clock=pygame.time.Clock()
scale=1
cyfunctions.load_textures(cyfunctions.folder_texture_blocks,scale)

plx, ply = 60,60

pygame.mouse.set_visible(False)

heightmap=cyfunctions.worldgen(cyfunctions.world_width,cyfunctions.world_height+10,cyfunctions.chunksize,0)
heightmap=cyfunctions.worldgens(cyfunctions.world_width,cyfunctions.world_height+10,(cyfunctions.chunksize/2),heightmap,0.1)
tempmap=cyfunctions.worldgen(cyfunctions.world_width,cyfunctions.world_height+10,cyfunctions.world_height,0.03)
stringwg=cyfunctions.wstringing(heightmap,tempmap,cyfunctions.world_width,cyfunctions.world_height+10)

while True:

    for event in pygame.event.get():
        if event.type==pygame.QUIT:
            pygame.quit()
            sys.exit()
    win.fill((0,127,127))
    blocktexturedims=(scale*cyfunctions.tilesize)
    cyfunctions.terrainproject(plx,ply,scale,stringwg)
    





    msx,msy=pygame.mouse.get_pos()
    tileindx,tileindy=cyfunctions.tileind(plx,ply,msx,msy,scale)
    win.blit(pygame.transform.scale(pygame.image.load("resources/textures/entities/cursor.png").convert_alpha(),(5*scale,5*scale)),(msx,msy)) #Projects the cursor texture to the screen
    plx-=(1-(msx/(ww/2)))/4
    ply-=(1-(msy/(wh/2)))/4
    print(clock.get_fps())
    pygame.display.update()
    clock.tick(60)