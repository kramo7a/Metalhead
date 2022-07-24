#include <metal_stdlib>
using namespace metal;

kernel void HT_HoughSpaceDrawer(constant uint* accumulator [[ buffer(0) ]],
                                constant uint &threshold [[ buffer(1) ]],
                                texture2d<float, access::write> outputTexture [[ texture (0) ]],
                                uint3 gid [[ thread_position_in_grid ]],
                                uint3 tgs [[ threads_per_threadgroup ]]) {
  const uint maxAngleIndex = tgs.z;
  
  const int index = gid.x * maxAngleIndex + gid.y;
  const uint parametersValue = accumulator[index];
  
  if(parametersValue > threshold) {
    outputTexture.write(1, gid.xy);
  }
}
