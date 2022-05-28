#version 330 core


// Render Settings
#define FOV 				1.0
#define MAX_RAY_STEPS		256
#define MAX_RAY_LENGTH		500.0
#define RAY_HIT_ACC			0.001
#define SHADOW_CLIPPING 	0.002
#define HIGHLIGHT_SHARPNESS 10.0
#define AMBIENT_LIGHT		0.05 


in vec2 uv;

uniform float iTime;
uniform vec2 iResolution;
uniform vec2 iMouse;

out vec4 frag_color;


#define PI 	3.14159
#define TAU	(2.0*PI)
#define PHI	(sqrt(5)*0.5+0.5)


struct Ray
{
  vec3 origin;
  vec3 direction;
};


struct Obj
{
  float distance;
  int material;
};


Obj merge_obj(Obj a, Obj b)
{
  if (a.distance < b.distance) return a;
  return b;
}


Obj subtract_obj(Obj a, Obj b)
{
  if (a.distance > -b.distance) return a;
  return b;
}


Obj mask_obj(Obj a, Obj b)
{
  if (a.distance > b.distance) return a;
  return b;
}


void map_obj(out Obj obj, vec3 ray_tip)
{
  float plane_dist = ray_tip.y + 1.0;
  int   plane_mat  = 1;
  Obj plane		   = Obj(plane_dist, plane_mat);

  ray_tip = mod(ray_tip, 4.0) - 2.0;

  float sphere_dist = length(ray_tip) - 1.0 + abs(0.5*sin(iTime));
  int sphere_mat	= 2;
  Obj sphere 		= Obj(sphere_dist, sphere_mat); 

  obj = merge_obj(plane, sphere);
}


vec3 get_normal(vec3 p)
{
  Obj obj1, obj2, obj3, obj4;
  
  vec2 h = vec2(RAY_HIT_ACC, 0.0);

  map_obj(obj1, p-h.xyy);
  map_obj(obj2, p-h.yxy);
  map_obj(obj3, p-h.yyx);
  map_obj(obj4, p);
 
  return normalize(vec3(obj4.distance) - vec3(obj1.distance, obj2.distance, obj3.distance));
}


vec3 get_material(Obj obj, Ray cam, vec3 ray_tip)
{
  vec3 mat;

  switch (obj.material)
  {
	case 1: mat = vec3(0.2 + 0.4*mod(floor(ray_tip.x) + floor(ray_tip.z), 2.0)); break;
	case 2: mat = vec3(0.5, 0.0, 0.0); break;
  }

  return mat;
}


vec2 rot(vec2 pos, float angle)
{
  return cos(angle)*pos + sin(angle)*vec2(pos.y, -pos.x);
}


Obj ray_march(Ray cam)
{
  Obj obj    = Obj(0.0, 0);
  float dist = 0.0;

  for (int i=0; i<MAX_RAY_STEPS; i++)
  {
	vec3 ray_tip = cam.origin + (dist * cam.direction);
	map_obj(obj, ray_tip);
	dist += obj.distance;
	
	if (abs(obj.distance) < RAY_HIT_ACC || dist > MAX_RAY_LENGTH) break;
  }

  obj.distance = dist;
  return obj;
}


vec3 calc_light(Obj obj, Ray cam, vec3 pos)
{
  vec3 ray_tip 			= cam.origin + obj.distance * cam.direction;
  vec3 light_direction 	= normalize(pos - ray_tip);
  vec3 surf_normal		= get_normal(ray_tip);
  vec3 reflections 		= reflect(-light_direction, surf_normal);
  vec3 highlight_color  = vec3(0.5);
  
  vec3 light     = get_material(obj, cam, ray_tip) * clamp(dot(light_direction, surf_normal), 0.0, 1.0);
  vec3 highlight = highlight_color * pow(clamp(dot(reflections, -cam.direction), 0.0, 1.0), HIGHLIGHT_SHARPNESS);
  vec3 ambient   = get_material(obj, cam, ray_tip)*AMBIENT_LIGHT; 

  float dist = ray_march(Ray(ray_tip + surf_normal*SHADOW_CLIPPING, normalize(pos))).distance;
  
  return (dist >= length(pos-ray_tip) || obj.material == 2) ? light+highlight*0.7+ambient : ambient;
}


Ray get_cam(vec3 pos, vec3 target, vec2 uv, float fov)
{
  vec2 mouse	= iMouse/iResolution;
  
  pos.yz = rot(pos.yz, mouse.y * PI * 0.5 -0.5);
  pos.xz = rot(pos.xz, (mouse.x+(iTime*0.05) * TAU));

  vec3 forward = normalize(vec3(target-pos));
  vec3 right   = normalize(cross(forward, vec3(0.0, 1.0, 0.0)));
  vec3 up      = -cross(forward, right);

  mat3 dir = mat3(right, up, forward);
  return Ray(pos, dir*normalize(vec3(uv, fov)));
}


void main()
{
	// Centering the uvs and fitting them to the aspect ratio
	vec2 uv = (uv-0.5);
	uv.x 	= uv.x * (iResolution.x/iResolution.y);

	// Creating a camera 
	// (a ray pointing from some point to the currently rendered pixel)
	Ray cam = get_cam(vec3(3.0, 2.0, -4.0), vec3(0.0, 0.1, 0.0), uv, FOV);
	
	Obj obj 		= ray_march(cam);
	vec3 col 		= vec3(0.0);
	vec3 sky_color 	= vec3(0.5, 0.8, 0.9);
	
	if (obj.distance < MAX_RAY_LENGTH)
	{
	  col += calc_light(obj, cam, vec3(20.0, 40.0, -30.0));
	  col = mix(col, sky_color, 1.0 - exp(-0.0008 * pow(obj.distance, 2)));
	}
	else
	{
	  col += sky_color - max(0.95 * cam.direction.y, 0.0);
	}

    // Output to screen
	col = pow(col, vec3(0.4545)),
    frag_color = vec4(col,1.0);
}

