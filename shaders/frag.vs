#version 330 core


// General Settings
#define FIREWORK_SIZE 			0.7
#define EXPLOSIONS 				5.0
#define EXPLOSION_INTENSITY 	0.0001
#define EXPLOSION_SIZE  		0.4
#define PARTICLE_AMOUNT 		100
#define PARTICLE_LIGHT			0.0007
#define PARTICLE_SPARKLING		50
#define PARTICLE_FADEOUT		0.8
#define COLOR_BIAS				vec3(0.34, 0.54, 0.43)
#define COLOR_SPEED				3
#define WHITE_AMOUNT			0.1



in vec2 uv;

uniform float iTime;
uniform vec2 iResolution;
uniform vec2 iMouse;

out vec4 frag_color;


// Constants, do not change
#define PI 3.14159


// used to generate seemingly random vec2s based on float seed;
vec2 hash(float seed)
{
  float a = fract(sin(seed*255.7)*623.1) * 2*PI;
  float b = fract(sin((seed+a)*715.3)*346.8);
  return vec2(sin(a), cos(a))*b;
}


float gen_lights(int amount, float animator, vec2 uv, float seed)
{
  float lights = 0.0;
  
  for (int i=0; i<amount; i++)
  {
	float intensity = mix(PARTICLE_LIGHT, EXPLOSION_INTENSITY, smoothstep(0.1, 0.0, animator));
	intensity *= sin(animator*PARTICLE_SPARKLING+i) * 0.5 + 0.5;
	intensity *= smoothstep(1.0, PARTICLE_FADEOUT, animator);
	lights += intensity/length(uv-(hash(1+i+seed*PARTICLE_AMOUNT)*EXPLOSION_SIZE)*animator);	
  }

  return lights;
}


void main()
{
  // Adjusting uv coordinates to fit non square aspect ratios
  vec2 uv = (uv -0.5);
  uv.x *= iResolution.x/iResolution.y;

  // Empty color vector. The entire scene will just be added ontop of this.
  vec3 col = vec3(0);

  //col += gen_lights(PARTICLE_AMOUNT, t, uv, floor(iTime)) * color;
  
  for (float i=0.0; i<EXPLOSIONS; i++)
  {
	float t = iTime+i/EXPLOSIONS;
	vec3 color  = sin(COLOR_SPEED*COLOR_BIAS * floor(t+i)) * WHITE_AMOUNT + (1-WHITE_AMOUNT);
	vec2 offset = hash(i+1.0+floor(iTime))*FIREWORK_SIZE;
	col += gen_lights(PARTICLE_AMOUNT, fract(t), uv-offset, floor(t+i)) * color;
  }

  // OUtputing pixel color
  frag_color = vec4(col, 1.0);
  frag_color.rgb = pow(frag_color.rgb, vec3(1.0/0.55));
}

