import OpenGL.GL.shaders

from OpenGL.GL import *


def load_shaderfile(file: str) -> bytes:
    src = ""

    with open(file) as f:
        src = f.read()

    return str.encode(src)


def compile_shader(*args, **kwargs):
    try:
        return OpenGL.GL.shaders.compileShader(*args, **kwargs)
    except OpenGL.GL.shaders.ShaderCompilationError as err:
        print(err)
        return None

def create_program(vert_file: str, frag_file: str) -> int|None:
    vert = load_shaderfile(vert_file)
    frag = load_shaderfile(frag_file)

    vert = compile_shader(vert, GL_VERTEX_SHADER)
    frag = compile_shader(frag, GL_FRAGMENT_SHADER)

    if vert is None or frag is None:
        return None


    return OpenGL.GL.shaders.compileProgram(vert, frag)

