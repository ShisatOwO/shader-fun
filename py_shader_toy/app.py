import os
import pygame as pg

from pygame.locals import *
from abc import ABC, abstractmethod


class App:
    def _display(self) -> None:
        ...

    def _init(self) -> None:
        ...


    def __init__(self, name: str="Shader Viewer", window_x: int|None=None, window_y: int|None=None, window_w: int=800, window_h: int=600, target_fps: int=60) -> None:
        self.window_w         = window_w
        self.window_h         = window_h
        self.prog_id          = None
        self.should_terminate = False
        self.target_fps       = target_fps

        if window_x is not None and window_y is not None:
            os.environ["SDL_VIDEO_WINDOW_POS"] = f"{window_x}, {window_y}"

        pg.init()
        pg.display.set_caption(name)
        
        self.screen = pg.display.set_mode((window_w, window_h), pg.DOUBLEBUF | pg.OPENGL)
        self.clock  = pg.time.Clock()

        pg.display.gl_set_attribute(pg.GL_MULTISAMPLEBUFFERS, 1)
        pg.display.gl_set_attribute(pg.GL_MULTISAMPLESAMPLES, 4)
        pg.display.gl_set_attribute(pg.GL_CONTEXT_PROFILE_MASK, pg.GL_CONTEXT_PROFILE_CORE)
        pg.display.gl_set_attribute(pg.GL_DEPTH_SIZE, 32)
        

    def loop(self):
        self._init()

        while not self.should_terminate:
            for e in pg.event.get():
                if e.type == pg.QUIT:
                    self.should_terminate = True
            
            #self.screen.fill((0,0,0))
            self._display()
            pg.display.flip()
            self.clock.tick(self.target_fps)

        pg.quit()

