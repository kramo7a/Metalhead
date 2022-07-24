#include <metal_stdlib>
using namespace metal;


kernel void averageSumDownscale(texture2d<half, access::read> inputTexture [[ texture(0) ]],
                                texture2d<half, access::write> outputTexture [[ texture(1) ]],
                                uint2 gid [[ thread_position_in_grid ]]) {
  uint downscaleFactor = int(inputTexture.get_width() / outputTexture.get_width());
  
  float total = 0.0;
  int count = 0;
  
  for (uint y = gid.y * downscaleFactor; y < (gid.y + 1) * downscaleFactor; y++) {
    for (uint x = gid.x * downscaleFactor; x < (gid.x + 1) * downscaleFactor; x++) {
      const float sample = inputTexture.read(uint2(x, y)).r;
      
      total += sample;
      count++;
    }
  }
  
  const float average = total / count;
  
  outputTexture.write(half4(average), gid);
}
