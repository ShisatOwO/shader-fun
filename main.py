#!/usr/bin/env python

import os
import sys
import typer
import shutil

from typing import Optional

from py_shaderfun.app import App
from py_shaderfun.mesh import Mesh
from gl_util import *


#SHADERFUN_FOLDER = "/opt/shaderfun/"
SHADERFUN_FOLDER = "shaderfun/"



class ShaderViewer(App):
    def __init__(self, file: str, *args, **kwargs) -> None:
        self._file = file
        super().__init__(*args, **kwargs)

    def _init(self) -> None:
        self.prog_id = create_program(os.path.join(SHADERFUN_FOLDER, "shaders/vert.vs"), self._file)
        
        if self.prog_id is None:
            self.should_terminate = True
        else:
            print("Shaders compiled successfully")
            self.plane = Mesh(self.prog_id)
        

    def _display(self) -> None:
        glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT)
        glUseProgram(self.prog_id)
        
        res_id = glGetUniformLocation(self.prog_id, "iResolution")
        glUniform2f(res_id, self.window_w, self.window_h)
        self.plane.draw()


def main(*args, **kwargs) -> int:
    typer_ = typer.Typer()

    @typer_.command()
    def run(file: str, shadertoy: bool=False, width: Optional[int]=typer.Option(800), height: Optional[int]=typer.Option(600), fps: Optional[int]=typer.Option(60)):
        if not os.path.exists(file) or not os.path.isfile(file):
            print(f"[ERROR]: File not found \"{file}\"")
            return

        if shadertoy:
            header = os.path.join(SHADERFUN_FOLDER, "shaders/frag_header.vs")
            temp = os.path.join(SHADERFUN_FOLDER, "temp/frag.vs")
            print(header, temp)
            
            if os.path.exists(temp):
                os.remove(temp)

            shutil.copyfile(header, temp)
            with open(temp, "a+") as shader_header:
                with open(file, "r") as shader_content:
                    shader_header.write(shader_content.read())

            file = temp
            
        app = ShaderViewer(file, window_w=width, window_h=height, target_fps=fps)
        app.loop()

    @typer_.command()
    def new(name: str, shadertoy: bool=False):
        file = os.path.join(os.getcwd(), name+".vs")

        if os.path.exists(file):
            print(f"[ERROR]: \"{file}\" already exists")
            return

        if shadertoy:
            preset = os.path.join(SHADERFUN_FOLDER, "shaders/shadertoy.vs")
        else:
            preset = os.path.join(SHADERFUN_FOLDER, "shaders/glsl.vs")

        shutil.copy(preset, file)


    typer_()


if __name__ == "__main__":
    main()

