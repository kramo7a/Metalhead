#include <metal_stdlib>
using namespace metal;

kernel void convolve(texture2d<float, access::read> inputTexture [[ texture (0) ]],
                     texture2d<float, access::write> outputTexture [[ texture (1) ]],
                     texture2d<float, access::read> kernelMatrixTexture [[texture(2)]],
                     uint2 gid [[thread_position_in_grid]],
                     constant float& threshold [[ buffer(0) ]]
                     ) {
  int kernelMatrixSize = kernelMatrixTexture.get_width();
  int kernelMatrixRadius = kernelMatrixSize / 2;
  
  float3 accumulativeValue = 0;
  for (int j = 0; j < kernelMatrixSize; j++)
  {
    for (int i = 0; i < kernelMatrixSize; i++)
    {
      uint2 textureIndex(gid.x + (i - kernelMatrixRadius), gid.y + (j - kernelMatrixRadius));
      uint2 kernelIdnex(i, j);
      float3 value = inputTexture.read(textureIndex).rgb;
      float weight = kernelMatrixTexture.read(kernelIdnex).r;
      accumulativeValue += weight * value;
    }
  }
  
  float4 result = float4(accumulativeValue.rgb, 1);
  if (dot(result.rgb, 1.0) > threshold) {
    outputTexture.write(result, gid);
  }
}
