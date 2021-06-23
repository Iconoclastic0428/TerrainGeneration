// ==================================================================
#version 330 core
// Read in our attributes stored from our vertex buffer object
// We explicitly state which is the vertex information
// (The first 3 floats are positional data, we are putting in our vector)
layout(location=0)in vec3 position; 
layout(location=1)in vec3 normals; // Our second attribute - normals.
layout(location=2)in vec2 texCoord; // Our third attribute - texture coordinates.
layout(location=3)in vec3 tangents; // Our third attribute - texture coordinates.
layout(location=4)in vec3 bitangents; // Our third attribute - texture coordinates.

// If we are applying our camera, then we need to add some uniforms.
// Note that the syntax nicely matches glm's mat4!
uniform mat4 model; // Object space
uniform mat4 view; // Object space
uniform mat4 projection; // Object space
uniform float theta;

// Export our normal data, and read it into our frag shader
out vec3 myNormal;
// Export our Fragment Position computed in world space
out vec3 FragPos;
// If we have texture coordinates we can now use this as well
out vec2 v_texCoord;

float CalculateWavePosition(float q, float a, float w, vec3 dir, vec3 meshVert, float ph, float t){
  float qa = q * a;
  float th = dot(w * dir.xz, meshVert.xz) + ph * t;
  float cosTh = cos(th);
  float sinTh = sin(th);
  float x = qa * dir.x * cosTh;
  float z = qa * dir.z * cosTh;
  float y = a * sinTh;
  return y;
}

vec3 CalculateNormalPosition(float q, float a, float w, vec3 dir, vec3 waveVert, float ph, float t){
  float wa = w * a;
  float th = dot(w * dir, waveVert) + ph * t;
  float cosTh = cos(th);
  float sinTh = sin(th);
  float x = dir.x * wa * cosTh;
  float z = dir.z * wa * cosTh;
  float y = q * wa * cosTh;

  return vec3(x, y, z);
}

float water(float x, float y, float z, float theta){
   return sin(sqrt(pow(x, 2) + pow(y, 2)) + theta) + sin(pow(x, 2) + theta) + sin(pow(z, 2) + theta);
}

void main()
{

    gl_Position = projection * view * model * vec4(position, 1.0f);
    myNormal = normals;
    if(position.y == 120){ 
    float l0 = 31.25, a0 = 0.16, s0 = 2.56;
    vec3 dir0 = vec3(0.58, 0.0, 0.42);
    float w0 = 2.0 / l0, ph0 = s0 * w0, q0 = 1.28;
    float l1 = 25.0, a1 = 0.22, s1 = 5.12;
    vec3 dir1 = vec3(0.31, 0.0, 0.69);
    float w1 = 2.0 / l1, ph1 = s1 * w1, q1 = 2.56;
    float l2 = 25.6, a2 = 0.22, s2 = 1.28;
    vec3 dir2 = vec3(0.33, 0.0, 0.67);
    float w2 = 2.0 / l2, ph2 = s2 * w2, q2 = 2.56;
    float l3 = 52.5, a3 = 0.34, s3 = 0.64;
    vec3 dir3 = vec3(0.26, 0.0, 0.67);
    float w3 = 2.0 / l3, ph3 = s3 * w3, q3 = 5.12;
    float l4 = 25.6, a4 = 0.34, s4 = 0.64;
    vec3 dir4 = vec3(0.3, 0.0, -0.7);
    float w4 = 2.0 / l4, ph4 = s4 * w4, q4 = 5.12;
    float l5 = 42.5, a5 = 0.46, s5 = 5.12;
    vec3 dir5 = vec3(0.4, 0.0, -0.6);
    float w5 = 2.0 / l5, ph5 = s5 * w5, q5 = 2.56;
    float l6 = 25.0, a6 = 0.22, s6 = 1.28;
    vec3 dir6 = vec3(0.1, 0.0, -0.9);
    float w6 = 2.0 / l6, ph6 = s6 * w6, q6 = 2.56;
    float l7 = 31.25, a7 = 0.16, s7 = 0.64;
    vec3 dir7 = vec3(0.43, 0.0, -0.57);
    float w7 = 2.0 / l7, ph7 = s7 * w7, q7 = 1.28;

    vec3 worldVertex = vec3(position.x, 0.0, position.z);

    float pos0 = CalculateWavePosition(q0, a0, w0, dir0, worldVertex, ph0, theta);
    float pos1 = CalculateWavePosition(q1, a1, w1, dir1, worldVertex, ph1, theta);
    float pos2 = CalculateWavePosition(q1, a2, w2, dir2, worldVertex, ph2, theta);
    float pos3 = CalculateWavePosition(q1, a3, w3, dir3, worldVertex, ph3, theta);
    float pos4 = CalculateWavePosition(q1, a4, w4, dir4, worldVertex, ph4, theta);
    float pos5 = CalculateWavePosition(q1, a5, w5, dir5, worldVertex, ph5, theta);
    float pos6 = CalculateWavePosition(q6, a6, w6, dir6, worldVertex, ph6, theta);
    float pos7 = CalculateWavePosition(q7, a7, w7, dir7, worldVertex, ph7, theta);

    float pos = pos0 + pos1 + pos2 + pos3 + pos4 + pos5 + pos6 + pos7;
    gl_Position.y += 2 * pos;
    gl_Position.y += water(position.x, position.y, position.z, theta);
    

    vec3 nor0 = CalculateNormalPosition(q0, a0, w0, dir0, gl_Position.xyz, ph0, theta); 
    vec3 nor1 = CalculateNormalPosition(q1, a1, w1, dir1, gl_Position.xyz, ph1, theta); 
    vec3 nor2 = CalculateNormalPosition(q2, a2, w2, dir2, gl_Position.xyz, ph2, theta); 
    vec3 nor3 = CalculateNormalPosition(q3, a3, w3, dir3, gl_Position.xyz, ph3, theta); 
    vec3 nor4 = CalculateNormalPosition(q4, a4, w4, dir4, gl_Position.xyz, ph4, theta); 
    vec3 nor5 = CalculateNormalPosition(q5, a5, w5, dir5, gl_Position.xyz, ph5, theta); 
    vec3 nor6 = CalculateNormalPosition(q6, a6, w6, dir6, gl_Position.xyz, ph6, theta); 
    vec3 nor7 = CalculateNormalPosition(q7, a7, w7, dir7, gl_Position.xyz, ph7, theta); 

    vec3 norm = nor0 + nor1 + nor2 + nor3 + nor4 + nor5 + nor6 + nor7;
    norm = vec3(0.0, 1.0, 0.0) - norm;
    
    myNormal = norm;
    }
    // Transform normal into world space
    FragPos = vec3(model* vec4(position,1.0f));

    // Store the texture coordinates which we will output to
    // the next stage in the graphics pipeline.
    v_texCoord = texCoord;
}
// ==================================================================
