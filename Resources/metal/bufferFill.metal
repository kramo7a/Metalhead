#include <metal_stdlib>
using namespace metal;

kernel void bufferFill(texture2d<float, access::read> inputTexture [[ texture (0) ]],
                       texture2d<float, access::read_write> outputTexture [[ texture (1) ]],
                       device uint* buffer [[ buffer(0) ]],
                       constant uint &value [[ buffer(1) ]],
                       uint3 gid [[ thread_position_in_grid ]]) {
  float4 asd = inputTexture.read(uint2(0, 0)) + outputTexture.read(uint2(0, 0));
  if (asd.x > 0) {
    buffer[gid.x] = value;
  }
}

