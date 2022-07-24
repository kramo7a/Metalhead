#include <metal_stdlib>
using namespace metal;

kernel void pipe(texture2d<float, access::read> inputTexture [[ texture (0) ]],
                 texture2d<float, access::write> outputTexture [[ texture (1) ]],
                 uint2 grid_index [[thread_position_in_grid]]) {
  outputTexture.write(inputTexture.read(grid_index), grid_index);
}
