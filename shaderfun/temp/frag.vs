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


void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    // Normalized pixel coordinates (from 0 to 1)
    vec2 uv = fragCoord/iResolution.xy;

    // Time varying pixel color
    vec3 col = 0.5 + 0.5*cos(iTime+uv.xyx+vec3(0,2,4));

    // Output to screen
    fragColor = vec4(col,1.0);
}
