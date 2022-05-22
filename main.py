from py_shader_toy.app import App
from py_shader_toy.mesh import Mesh
from gl_util import *


class ShaderViewer(App):
    def __init__(self, *args, **kwargs) -> None:
        super().__init__(*args, **kwargs)

    def _init(self) -> None:
        self.prog_id = create_program("shaders/vert.vs", "shaders/frag.vs")
        
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


if __name__ == "__main__":
    app = ShaderViewer(target_fps=75, window_w=1200, window_h=675)
    app.loop()

