import pygame,sys,time,math,os,cyfunctions,random,worldgen
import functions as fun

# python3 cysetup.py build_ext --inplace   (builds the cyfunctions file)
# python3 cysetupworldgen.py build_ext --inplace   (builds the worldgen file)

pygame.init()
try:
    win=pygame.display.set_mode((300,200),pygame.SCALED|pygame.RESIZABLE)
    pyscaled=True
except pygame.error:
    win=pygame.display.set_mode((300,200),pygame.RESIZABLE)
    pyscaled=False
eldersize=(300,200)
ww,wh=win.get_size()
pygame.display.set_caption("Terra")
clock=pygame.time.Clock()
scale=1
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

    #for faulty .SCALED:
    if pyscaled:
        scale=1
    else:
        scale=math.floor(win.get_size()[1]//200)
    if not eldersize == win.get_size():
        ww,wh=win.get_size()
        cyfunctions.load_textures(cyfunctions.folder_texture_blocks,scale)
        eldersize=(ww,wh)



    plx,ply=cyfunctions.collisions(plx,ply,(((1-(msx/(ww/2)))/4)*-1),(((1-(msy/(wh/2)))/4)*-1),stringwg)
    win.fill((0,127,127))
    blocktexturedims=(scale*cyfunctions.tilesize)
    cyfunctions.terrainproject(plx,ply,scale,stringwg,win,ww,wh)
    





    
    tileindx,tileindy=cyfunctions.tileind(plx,ply,msx,msy,scale,win,ww,wh)
    win.blit(pygame.transform.scale(pygame.image.load("resources/textures/entities/cursor.png").convert_alpha(),(5*scale,5*scale)),(msx,msy)) #Projects the cursor texture to the screen
    print(clock.get_fps())
    pygame.display.update()
    clock.tick(600)