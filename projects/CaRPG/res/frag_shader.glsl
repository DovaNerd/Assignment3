#version 420

layout(location = 0) in vec3 inPos;
layout(location = 1) in vec2 UV;
layout(location = 2) in vec3 inNormal;
layout(location = 3) in vec3 inColor;
//LECTURE 7


uniform sampler2D textureSampler;

uniform layout(binding = 20) sampler2D rampTex;

uniform vec3  u_AmbientCol;
uniform float u_AmbientStrength;
uniform float u_SpecularStrength;
uniform float u_DiffuseStrength;

uniform int u_CarEmissive;
uniform int u_ToonShade;

uniform int u_RampingSpec;
uniform int u_RampingDiff;


uniform vec3  u_LightPos;
uniform vec3  u_LightCol;

uniform vec3  u_CamPos;

uniform vec3 playerPos;
uniform vec3 enemyPos;

const int bands = 5;
const float scaleFactor = 1.0 / bands;

out vec4 frag_color;

float random(vec2 r) //random function
{
  vec2 consts = vec2(
    23.14069263277926, // e^pi (Gelfond's constant)
    2.665144142690225 // 2^sqrt(2) (Gelfond�Schneider constant)
  );
return fract( cos( dot(r,consts) ) * 12345.6789 );
}

uniform float amount;

uniform bool u_film;


void main() {
	float distPlay= max(2.0,distance(playerPos,inPos));
	float distEnemy =max(2.0,distance(enemyPos,inPos));

	if(distPlay>200.f)
		discard;

	
	vec3 textureColor = texture(textureSampler, UV).xyz;


	vec3 lightColor = vec3(1.0, 1.0, 1.0);

	float ambientStrength = u_AmbientStrength;
	vec3 ambient = ambientStrength * lightColor * textureColor;//inColor;
	
	// Diffuse
	vec3 N = normalize(inNormal);
	vec3 lightDir = normalize(u_LightPos - inPos);
	
	float dif =u_RampingDiff==1?texture(rampTex,vec2(max(dot(N, lightDir), 0.0),0.5)).r: max(dot(N, lightDir), 0.0);
	float diffuseStrength=u_DiffuseStrength;
	vec3 diffuse = dif * textureColor*diffuseStrength;//inColor;// add diffuse intensity

	//Attenuation
	float dist = length(u_LightPos - inPos);
	diffuse = diffuse / dist; // (dist*dist)
	
	// Specular
	vec3 camPos = u_CamPos;//Pass this as a uniform from your C++ code
	float specularStrength = u_SpecularStrength; // this can be a uniform
	vec3 camDir = normalize(u_CamPos - inPos);
	vec3 reflectDir = reflect(-lightDir, N);
	float spec = u_RampingSpec==1?texture(rampTex,vec2(pow(max(dot(camDir, reflectDir), 0.0), 4),0.5)).r:pow(max(dot(camDir, reflectDir), 0.0), 4); // Shininess coefficient (can be a uniform)
	vec3 specular = specularStrength * spec* lightColor; // Can also use a specular color

	vec2 UVrandom = UV;								//noise
	UVrandom.y = random(vec2(UVrandom.y,amount));
	textureColor.rgb += random(UVrandom) * 0.15;

	
	vec3 result = u_ToonShade==1?scaleFactor * floor(bands * (ambient + diffuse + specular)) : (ambient + diffuse + specular);
	
	if (u_film == false)
	{
	 	frag_color = u_CarEmissive==1?(texture(textureSampler, UV)/(distPlay/10) *vec4(result,1.0)+vec4(1/distPlay,0.0f,1/distEnemy,0.0f)):(texture(textureSampler, UV)*vec4(result,1.0));
	}
	if (u_film == true)
	{
		frag_color = vec4 (textureColor, 1.0); // this lines makes noise
	}
}
