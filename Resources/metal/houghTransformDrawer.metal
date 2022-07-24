#include <metal_stdlib>
using namespace metal;

struct LineParameters {
  int rho;
  int theta;
};

kernel void houghTransformDrawer(device LineParameters* linesParameters [[ buffer(0) ]],
                                 constant uint &arrayLength [[buffer(1)]],
                                 constant uint &maxAngleIndex [[buffer(2)]],
                                 constant float &rhoDiffThreshold [[buffer(3)]],
                                 constant float &rhoMax [[buffer(4)]],
                                 constant uint &rhoCompressionFactor [[buffer(5)]],
                                 texture2d<float, access::write> outputTexture [[ texture (1) ]],
                                 uint2 gid [[ thread_position_in_grid ]]) {
  for(uint i = 0; i < arrayLength; i++) {
    auto const p = linesParameters[i];
    const float theta = M_PI_F * p.theta / maxAngleIndex;
    const float rho = float(gid.x) * cos(theta) + float(gid.y) * sin(theta);
    const float rhoDiff = rho / rhoCompressionFactor - (float(p.rho) - rhoMax);
    if(abs(rhoDiff) < rhoDiffThreshold) {
      outputTexture.write(1, gid);
    }
  }
}
