#include <metal_stdlib>
using namespace metal;

kernel void brightness(texture2d<float, access::read> inputTexture [[ texture (0) ]],
                       texture2d<float, access::write> outputTexture [[ texture (1) ]],
                       constant float &brightnessFactor [[ buffer(0) ]],
                       uint2 pixel_index [[ thread_position_in_grid ]]) {
  const float4 inputPixelValue = inputTexture.read(pixel_index);
  outputTexture.write(inputPixelValue * brightnessFactor, pixel_index);
}
