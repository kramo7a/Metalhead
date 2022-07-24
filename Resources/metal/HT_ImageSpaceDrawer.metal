#include <metal_stdlib>
using namespace metal;

kernel void HT_ImageSpaceDrawer(constant uint* accumulator [[ buffer(0) ]],
                                constant float &rhoMax [[ buffer(1) ]],
                                constant uint &rhoCompressionFactor [[ buffer(2) ]],
                                constant uint &threshold [[ buffer(3) ]],
                                texture2d<float, access::write> outputTexture [[ texture (0) ]],
                                uint3 gid [[ thread_position_in_grid ]],
                                uint3 tgs [[ threads_per_threadgroup ]]) {
  const uint thetaIndex = gid.z;
  const uint maxAngleIndex = tgs.z;
  
  const float theta = M_PI_F * thetaIndex / maxAngleIndex;
  const float rho = (float(gid.x) * cos(theta) + float(gid.y) * sin(theta)) / rhoCompressionFactor + rhoMax;
  
  const int index = int(round(rho)) * maxAngleIndex + thetaIndex;
  const uint parametersValue = accumulator[index];
  
  if(parametersValue > threshold) {
    outputTexture.write(float4(0,1,0,1), gid.xy);
  }
}
