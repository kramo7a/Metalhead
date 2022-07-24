#include <metal_stdlib>
using namespace metal;

kernel void colorInverse(texture2d<float, access::read> inputTexture [[ texture (0) ]],
                         texture2d<float, access::write> outputTexture [[ texture (1) ]],
                         uint2 pixel_index [[thread_position_in_grid]]) {
  const float4 pixel_value = inputTexture.read(pixel_index);
  outputTexture.write(1 - pixel_value, pixel_index);
}
