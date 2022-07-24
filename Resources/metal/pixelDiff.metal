#include <metal_stdlib>
using namespace metal;


kernel void pixelDiff(texture2d<float, access::read> inputTexture [[ texture (0) ]],
                      texture2d<float, access::write> outputTexture [[ texture (1) ]],
                      texture2d<float, access::read> subtrahendTexture [[ texture (2) ]],
                      uint2 grid_index [[thread_position_in_grid]]) {
  outputTexture.write(inputTexture.read(grid_index) - subtrahendTexture.read(grid_index), grid_index);
}


kernel void pixelSum(texture2d<float, access::read> inputTexture [[ texture (0) ]],
                     texture2d<float, access::write> outputTexture [[ texture (1) ]],
                     texture2d<float, access::read> summandTexture [[ texture (2) ]],
                     uint2 grid_index [[thread_position_in_grid]]) {
  outputTexture.write(inputTexture.read(grid_index) + summandTexture.read(grid_index), grid_index);
}
