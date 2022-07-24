#include <metal_stdlib>
using namespace metal;

kernel void grayscale(texture2d<float, access::read> inputTexture [[ texture (0) ]],
                      texture2d<float, access::write> outputTexture [[ texture (1) ]],
                      constant float3 &weights [[ buffer(0) ]],
                      uint2 pixel_index [[ thread_position_in_grid ]]) {
  const float3 inColor = inputTexture.read(pixel_index).rgb;
  float grayColor = dot(inColor, weights);
    
  outputTexture.write(float4(grayColor, grayColor, grayColor, 1), pixel_index);
}
