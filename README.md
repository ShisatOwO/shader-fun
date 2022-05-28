# Shader-Fun
A little python/OpenGL program designed for messing around with fragment shaders. Shader-Fun supports both GLSL and Shadertoy code.

![Screenshot_20220528_165806](https://user-images.githubusercontent.com/63296309/170830879-24fc4211-a857-457d-9e9b-f185762b1138.png)


## Installation
### Prerequisites
 * A working Python >=3.9 and pip installation
 * A GPU that supports OpenGL 3.0

### Dependencies  
```
pip install pygame typer PyOpenGL
```

### That's it. 
You can verify that everything is working correctly by executing one of the examples:
```
python main.py run examples/morph.vs
```
If everything is working correctly, a window showing a ball morphing into a cube should appear. You can control the camera by clicking and dragging. 
