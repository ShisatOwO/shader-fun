//////////////////////////////////////////////////
// Whacky header to make Shadertoy shaders work //
//////////////////////////////////////////////////
//Mark version                               	//
#version 330 core                           	//
												//
//Add uniforms and in/out                   	//
in vec2 uv;                                 	//
												//
uniform float iTime;                        	//
uniform vec2 iResolution;                   	//
uniform vec2 iMouse;                        	//
												//
out vec4 frag_color;                         	//
												//    													
//Execute mainImage                         	//
void mainImage(out vec4, in vec2);	            //
void main()										//
{												//
  mainImage(frag_color, uv.xy*iResolution.xy);  //
}												//
//////////////////////////////////////////////////


/////////////////////////////////
//Append Shadertoy shader below//
/////////////////////////////////


