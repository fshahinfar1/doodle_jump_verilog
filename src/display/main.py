import pygame
import struct
pygame.init()

from vcd.vcd import VCDReader

scr_w = 30
scr_h = 30
pixel_w = 10
screen_w = scr_w * pixel_w
screen_h = scr_h * pixel_w

white = (255, 255, 255)


screen = pygame.display.set_mode((screen_w, screen_h))
clock = pygame.time.Clock()

background = pygame.Surface(screen.get_size())
background.fill(white)
background = background.convert()




fpga_screen = [] 

def bitarr2int(bitarr):
    b = bitarr.tobytes()
    i = int.from_bytes(b, 'little', signed=False)
    return i


def new_screen_value(val, t):
    global fpga_screen
    fpga_screen = val

def fpga_2d_arr(fpga_screen):
    mat = [[None] * scr_w for i in range(scr_h)]
    pixel_len = 24
    for j in range(scr_h):
        for i in range(scr_w):
            start = ((i * scr_h) + j) * 24
            pixel = fpga_screen[start: start + 24]
            color  = bitarr2int(pixel[0:8]), bitarr2int(pixel[8:16]), bitarr2int(pixel[16:24])
            mat[j][i] = color
    return mat

def main_pygame(reader):

    mainloop = True
    while mainloop:
        # event
        for event in pygame.event.get():
            if event.type == pygame.QUIT:
                mainloop = False # pygame window closed by user
            elif event.type == pygame.KEYDOWN:
                if event.key == pygame.K_ESCAPE:
                    mainloop = False # user pressed ESC
        mat = fpga_2d_arr(fpga_screen)
        print('====')
        reader.next()
        # draw
        for r, row in enumerate(mat):
            for c, col in enumerate(row):
                color  = col
                x = c * pixel_w
                y = r * pixel_w
                pygame.draw.rect(background, color, (x, y, pixel_w, pixel_w))
        pygame.display.flip()
        screen.blit(background, (0,0))
        # ticks
        clock.tick(30)

def main():
    reader = VCDReader('./test.vcd')
    #for m_name in reader._modules:
    #    m = reader._modules[m_name]
    reader.register_on_signal('tbDoodle', 'screen', new_screen_value)
    reader.start_parsing()
    main_pygame(reader)


if __name__ == '__main__':
    main()
