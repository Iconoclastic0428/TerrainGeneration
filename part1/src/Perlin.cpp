#include <cstdint>
#include <fstream>
#include <iostream>
#include <vector>
#include "Perlin.hpp"

float Perlin::grad(int32_t hash, float x){
  int32_t h = hash & 0x0F;
  float grad = 1.0f + (h & 7);
  if((h & 8) != 0)
    grad = -grad;
  return (grad * x);
}

float Perlin::grad(int32_t hash, float x, float y){
  const int32_t h = hash & 0x3F;
  const float u = h < 4 ? x : y;
  const float v = h < 4 ? y : x;
  return ((h & 1) ? -u : u) + ((h & 2) ? -2.0f * v : 2.0f * v);
}

uint8_t Perlin::hash(int32_t i){
  return perm[static_cast<uint8_t>(i)];
}

float Perlin::noise(float x){
  float n0, n1;
  int32_t i0 = fastfloor(x);
  int32_t i1 = i0 + 1;
  float x0 = x - i0;
  float x1 = x0 - 1.0f;

  float t0 = 1.0f - x0*x0;
  t0 *= t0;
  n0 = t0 * t0 * grad(hash(i0), x0);
  float t1 = 1.0f - x1 * x1;
  t1 *= t1;
  n1 = t1 * t1 * grad(hash(i1), x1);
  return 0.395f * (n0 + n1);
}

float Perlin::noise(float x, float y){
  float n0, n1, n2;
  const float F2 = 0.366025403f;
  const float G2 = 0.211324865f;

  const float s = (x + y) * F2;
  const float xs = x + s;
  const float ys = y + s;
  const int32_t i = fastfloor(xs);
  const int32_t j = fastfloor(ys);

  const float t = static_cast<float> (i+j) * G2;
  const float X0 = i - t;
  const float Y0 = j - t;
  const float x0 = x - X0;
  const float y0 = y - Y0;

  int32_t i1, j1;
  if(x0 > y0){
    i1 = 1;
    j1 = 0;
  }
  else{
    i1 = 0;
    j1 = 1;
  }

  const float x1 = x0 - i1 + G2;
  const float y1 = y0 - j1 + G2;
  const float x2 = x0 - 1.0f + 2.0f * G2;
  const float y2 = y0 - 1.0f + 2.0f * G2;
  
  const int gi0 = hash(i + hash(j));
  const int gi1 = hash(i + i1 + hash(j + j1));
  const int gi2 = hash(i + 1 + hash(j + 1));

  float t0 = 0.5f - x0*x0 - y0*y0;
  if(t0 < 0.0f){
    n0 = 0.0f;
  }
  else{
    t0 *= t0;
    n0 = t0 * t0 * grad(gi0, x0, y0);
  }

  float t1 = 0.5f - x1 * x1 - y1 * y1;
  if(t1 < 0.0f){
    n1 = 0.0f;
  }
  else{
    t1 *= t1;
    n1 = t1 * t1 * grad(gi1, x1, y1);
  }
  
  float t2 = 0.5f - x2*x2 - y2*y2;
  if(t2 < 0.0f){
    n2 = 0.0f;
  }
  else{
    t2 *= t2;
    n2 = t2 * t2 * grad(gi2, x2, y2);
  }

  return 45.23065f * (n0 + n1 + n2);
}

float Perlin::fractal(size_t octaves, float x) {
  float output = 0.f;
  float denom = 0.f;
  float frequency = mFrequency;
  float amplitude = mAmplitude;

  for (size_t i = 0; i < octaves; ++i){
    output += (amplitude * noise(x * frequency));
    denom += amplitude;
    frequency *= mLacunarity;
    amplitude *= mPersistence;
  }

  return output / denom;
}

float Perlin::fractal(size_t octaves, float x, float y){
  float output = 0.f;
  float denom = 0.f;
  float frequency = mFrequency;
  float amplitude = mAmplitude;

  for(size_t i = 0; i < octaves; ++i){
    output += (amplitude * noise(x * frequency, y * frequency));
    denom += amplitude;
    frequency *= mLacunarity;
    amplitude *= mPersistence;
  }
  return output / denom;
}

void Perlin::output(){
  std::ofstream map("./terrain.ppm");
  std::vector<int> noiseTerrain;

  map << "P3" << std::endl;
  map << 512 << " " << 512 << std::endl;
  map << 255 << std::endl;
  
  for(int i = 0; i < 512; ++i){
    for(int j = 0; j < 512; ++j){
      float y = (i - 256 + 5.1f * 400.f);
      float x = (j - 256 + 5.9f * 400.f);
      float noi = fractal(7, x, y) + 0.05f;;
      int n = ((noi + 1) / 2) * 255;
      noiseTerrain.push_back(n);
      map << n << std::endl;
      map << n << std::endl;
      map << n << std::endl;
    }
  }

  map.close();

  map.open("./terrainMap.ppm");
  map << "P3" << std::endl;
  map << 512 << " " << 512 << std::endl;
  map << 255 << std::endl;

  for(auto& i : noiseTerrain){
    if(i <= 120){
      map << 194 << std::endl;
      map << 178 << std::endl;
      map << 128 << std::endl;
    }
    else if(i > 120 && i <= 130){
      map << 126 << std::endl;
      map << 200 << std::endl;
      map << 80 << std::endl;
    }
    else if(i > 130 && i <= 140){
      map << 115 << std::endl;
      map << 118 << std::endl;
      map << 83 << std::endl;
    }
    else{
      map << 255 << std::endl;
      map << 255 << std::endl;
      map << 255 << std::endl;
    }
  }
  map.close();

  map.open("./ocean.ppm");
  map << "P3" << std::endl;
  map << 512 << " " << 512 << std::endl;
  map << 255 << std::endl;

  for(int i = 0; i < 512; ++i){
    for(int j = 0; j < 512; ++j){
      map << 120 << std::endl;
      map << 120 << std::endl;
      map << 120 << std::endl;
    }
  }

  map.close();

  map.open("./oceanMap.ppm");
  map << "P3" << std::endl;
  map << 512 << " " << 512 << std::endl;
  map << 255 << std::endl;

  for(int i = 0; i < 512; ++i){
    for(int j = 0; j < 512; ++j){
      map << 0 << std::endl;
      map << 105 << std::endl;
      map << 148 << std::endl;
    }
  }
  map.close();
}

