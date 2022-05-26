#version 330 core

in vec2 uv;

uniform float iTime;
uniform vec2 iResolution;
uniform vec2 iMouse;

out vec4 frag_color;


void main()
{
    // Time varying pixel color
    vec3 col = 0.5 + 0.5*cos(iTime+uv.xyx+vec3(0,2,4));

    // Output to screen
    frag_color = vec4(col,1.0);
}

