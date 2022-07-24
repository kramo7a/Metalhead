#include <metal_stdlib>
using namespace metal;

struct HoughTransformParams {
  float brightnessThreshold;
  int rhoMax;
};

kernel void houghTransform(texture2d<float, access::read> inputTexture [[ texture (0) ]],
                           device atomic_uint* accumulator [[ buffer(0) ]],
                           constant float &rhoMax [[buffer(1)]],
                           uint3 gid [[ thread_position_in_grid ]],
                           uint3 tgs [[ threads_per_threadgroup ]]) {

  if (inputTexture.read(gid.xy).r < 0.1) { return; }

  float maxAngleIndex = tgs.z;
  float theta = M_PI_F * gid.z / maxAngleIndex;
  float rho = float(gid.x) * cos(theta) + float(gid.y) * sin(theta) + rhoMax;
  uint index = round(rho) * maxAngleIndex + gid.z;

  atomic_fetch_add_explicit(accumulator + index, 1, memory_order_relaxed);
}
