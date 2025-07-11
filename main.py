import pygame, sys, time, math, os, cyfunctions
import functions as fun

# python cysetup.py build_ext --inplace   (builds the cyfunctions file)

ww,wh=1854,1010
pygame.init
win = pygame.display.set_mode((ww,wh))
pygame.display.set_caption("Terra")
clock = pygame.time.Clock()
scale=5
cyfunctions.load_textures(cyfunctions.folder_texture_blocks,scale)

plx, ply = 60,60

pygame.mouse.set_visible(False)

while True:

    for event in pygame.event.get():
        if event.type == pygame.QUIT:
            pygame.quit()
            sys.exit()
    win.fill((0, 127, 127))
    
    blocktexturedims=(scale*cyfunctions.tilesize)
    cyfunctions.terrainproject(plx,ply,scale)
    





    msx,msy=pygame.mouse.get_pos()
    tileindx,tileindy=cyfunctions.tileind(plx,ply,msx,msy,scale)
    win.blit(pygame.transform.scale(pygame.image.load("resources/textures/entities/cursor.png").convert_alpha(), (5*scale,5*scale)), (msx,msy)) #Projects the cursor texture to the screen
    plx-=(1-(msx/(ww/2)))/5
    ply-=(1-(msy/(wh/2)))/5
    print(clock.get_fps())
    pygame.display.update()
    clock.tick(60)