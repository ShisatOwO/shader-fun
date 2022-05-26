import pygame as pg
import numpy as np

from OpenGL.GL import *


class Mesh:
    def __init__(self, prog_id: int) -> None:
        self.verts = [
            [-1, -1, 0],
            [-1,  1, 0],
            [ 1, -1, 0],
            [ 1, -1, 0],
            [-1,  1, 0],
            [ 1,  1, 0],
        ]

        self.uvs = [
            [0, 0],
            [0, 1],
            [1, 0],
            [1, 0],
            [0, 1],
            [1, 1],
        ]
        
        self.vert_count = len(self.verts)
        self.prog_id = prog_id
        self.vao_ref = glGenVertexArrays(1)

        glBindVertexArray(self.vao_ref)
        
        pos_ref  = glGenBuffers(1)
        pos_data = np.array(self.verts, np.float32)
        pos_id   = glGetAttribLocation(self.prog_id, "position")
        
        glBindBuffer(GL_ARRAY_BUFFER, pos_ref)
        glVertexAttribPointer(pos_id, 3, GL_FLOAT, False, 0, None)
        glEnableVertexAttribArray(pos_id)
        glBindBuffer(GL_ARRAY_BUFFER, pos_ref)
        glBufferData(GL_ARRAY_BUFFER, pos_data.ravel(), GL_STATIC_DRAW)
        
        uv_ref  = glGenBuffers(1)
        uv_data = np.array(self.uvs, np.float32)
        uv_id   = glGetAttribLocation(self.prog_id, "vertex_uv")

        glBindBuffer(GL_ARRAY_BUFFER, uv_ref)
        glVertexAttribPointer(uv_id, 2, GL_FLOAT, False, 0, None)
        glEnableVertexAttribArray(uv_id)
        glBindBuffer(GL_ARRAY_BUFFER, uv_ref)
        glBufferData(GL_ARRAY_BUFFER, uv_data.ravel(), GL_STATIC_DRAW)

    def draw(self) -> None:
        timer_id = glGetUniformLocation(self.prog_id, "iTime")
        glUniform1f(timer_id, pg.time.get_ticks()*0.001)
        
        mouse_pos = pg.mouse.get_pos()
        mouse_id = glGetUniformLocation(self.prog_id, "iMouse")
        glUniform2f(mouse_id, mouse_pos[0], mouse_pos[1])

        glBindVertexArray(self.vao_ref)
        glDrawArrays(GL_TRIANGLES, 0, self.vert_count)
