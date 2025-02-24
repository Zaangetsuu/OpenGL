#version 330 core

struct Material {
    sampler2D diffuse; // Ambient and diffuse are almost always the same
    sampler2D specular;
    float shininess;
}; 

struct Light {
	vec3 position;
    vec3 ambient;
    vec3 diffuse;
    vec3 specular;
	float constant;
	float linear;
	float quadratic;
};

out vec4 FragColor; 

in vec3 FragPos;
in vec3 Normal;
in vec2 TexCoords;

uniform vec3 viewPos;
uniform Light light;
uniform Material material;

// Phong lighting model
void main()
{
	// Ambiant
	vec3 ambient = light.ambient * texture(material.diffuse, TexCoords).rgb;

	// Diffuse
	vec3 norm = normalize(Normal);
	vec3 lightDir = normalize(light.position - FragPos);

	float diff = max(dot(norm, lightDir), 0.0);
	vec3 diffuse = light.diffuse * diff * texture(material.diffuse, TexCoords).rgb;

	// Specular
	vec3 viewDir = normalize(viewPos - FragPos);
	vec3 reflectDir = reflect(-lightDir, norm);
	
	float spec = pow(max(dot(viewDir, reflectDir), 0.0), material.shininess);
	vec3 specular = light.specular * spec * texture(material.specular, TexCoords).rgb;

	float distance = length(light.position - FragPos);
	float attenuation = 1.0 / (light.constant + light.linear * distance + light.quadratic * pow(distance, 2));

	ambient *= attenuation;
	diffuse *= attenuation;
	specular *= attenuation;

    FragColor = vec4(ambient + diffuse + specular, 1.0f);
}