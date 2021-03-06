// ====================================================
#version 330 core

// ======================= uniform ====================
// Our light sources
uniform vec3 lightColor;
uniform vec3 lightPos;
uniform float ambientIntensity;
// Used for our specular highlights
uniform mat4 view;
// If we have texture coordinates, they are stored in this sampler.
uniform sampler2D u_DiffuseMap;
uniform vec3 viewPos; 

// ======================= IN =========================
in vec3 myNormal; // Import our normal data
in vec2 v_texCoord; // Import our texture coordinates from vertex shader
in vec3 FragPos; // Import the fragment position
in vec3 Position;

// ======================= out ========================
// The final output color of each 'fragment' from our fragment shader.
out vec4 FragColor;

// ======================= Globals ====================
// We will have another constant for specular strength
float specularStrength = 0.5f;
const ivec3 off = ivec3(-1, 0, 1);
const vec2 size = vec2(2.0, 0.0);

vec3 fog(vec3 pos, vec3 color){
  float dis = sqrt(pow(pos.x - viewPos.x, 2) + pow(pos.y - viewPos.y, 2) + pow(pos.z - viewPos.z, 2));
  if(dis > 500)
    return vec3(0.529, 0.808, 0.91257);
  if(dis < 50)
    return color;
  return (dis / 500) * vec3(0.529, 0.808, 0.92157) + (1 - dis / 500) * color;
}

void main()
{
    // Store our final texture color
    vec3 diffuseColor;
    diffuseColor = texture(u_DiffuseMap, v_texCoord).rgb;

    // (1) Compute ambient light
    vec3 ambient = ambientIntensity * lightColor;

    vec4 tex = texture(u_DiffuseMap, v_texCoord);
    float s11 = tex.x;
    float s01 = textureOffset(u_DiffuseMap, v_texCoord, off.xy).x;
    float s21 = textureOffset(u_DiffuseMap, v_texCoord, off.zy).x;
    float s10 = textureOffset(u_DiffuseMap, v_texCoord, off.yx).x;
    float s12 = textureOffset(u_DiffuseMap, v_texCoord, off.yz).x;

    vec3 va = normalize(vec3(size.xy, s21-s01));
    vec3 vb = normalize(vec3(size.yx, s12-s10));
    vec4 bump = vec4(cross(va, vb), s11);
    vec3 normal = bump.xyz;

    // (2) Compute diffuse light

    // Compute the normal direction
    vec3 norm = normalize(normal);
    // From our lights position and the fragment, we can get
    // a vector indicating direction
    // Note it is always good to 'normalize' values.
    vec3 lightDir = normalize(lightPos - FragPos);
    // Now we can compute the diffuse light impact
    float diffImpact = max(dot(norm, lightDir), 0.0);
    vec3 diffuseLight = diffImpact * lightColor;

    // (3) Compute Specular lighting
    vec3 viewPos = vec3(0.0,0.0,0.0);
    vec3 viewDir = normalize(viewPos - FragPos);
    vec3 reflectDir = reflect(-lightDir, norm);

    float spec = pow(max(dot(viewDir, reflectDir), 0.0), 32);
    vec3 specular = specularStrength * spec * lightColor;

    // Our final color is now based on the texture.
    // That is set by the diffuseColor
    vec3 Lighting = diffuseLight + ambient + specular;

    if(Position.y < 125 && diffuseColor.r > 0 && Position.y >= 110)
      diffuseColor = vec3(0.812, 0.682, 0.4588);
    else if(Position.y > 125 && Position.y <= 140){
      diffuseColor = vec3(0.812, 0.682, 0.4588) * (140 - Position.y) / 15 + vec3(0.494, 0.7843, 0.3137) * (1 - (140 - Position.y) / 15);
    }
    else if(Position.y > 140 && Position.y <= 170)
      diffuseColor = vec3(0.494, 0.7843, 0.3137) * (170 - Position.y) / 30 + vec3(0.804, 0.894, 0.627) * (1 - (170 - Position.y) / 30);
    else if(Position.y > 170 && Position.y <= 250)
      diffuseColor = vec3(0.804, 0.894, 0.627) * (250 - Position.y) / 80 + vec3(0.353, 0.302, 0.255) * (1 - (250 - Position.y) / 80);
    else if(Position.y > 150)
      diffuseColor = vec3(0.353, 0.302, 0.255);

    // Final color + "how dark or light to make fragment"
    if(gl_FrontFacing){
        FragColor = vec4(diffuseColor * Lighting,1.0);
    }else{
        // Additionally color the back side the same color
         FragColor = vec4(diffuseColor * Lighting,1.0);
    }

    FragColor = vec4(fog(Position, vec3(FragColor)), 1.0);
}
// ==================================================================
