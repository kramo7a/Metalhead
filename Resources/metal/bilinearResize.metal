#include <metal_stdlib>
using namespace metal;

kernel void bilinearResize(texture2d<float, access::read> input [[texture(0)]],
                           texture2d<float, access::write> output [[texture(1)]],
                           uint2 outputPosition [[thread_position_in_grid]]) {
  float2 inputSize = float2(input.get_width(), input.get_height());
  float2 outputSize = float2(output.get_width(), output.get_height());
  
  float2 inputPosition = float2(outputPosition) * inputSize / outputSize;
  
  // top-left pixel of the four pixels in the input texture that surround the exact position
  float2 positionInt = floor(inputPosition);
  
  // Used as an interpolation factor.
  // Represents how far the exact position is from the top-left pixel, as a fraction of the distance between the pixels
  // In bilinear interpolation, the contribution of each of the four nearest pixels to the final color of the output pixel is weighted according to the distance from the exact position in the input texture to the center of each pixel.
  float2 positionFrac = inputPosition - positionInt;
  
  float4 topLeft = input.read(uint2(positionInt));
  float4 topRight = input.read(uint2(positionInt.x + 1, positionInt.y));
  float4 bottomLeft = input.read(uint2(positionInt.x, positionInt.y + 1));
  float4 bottomRight = input.read(uint2(positionInt.x + 1, positionInt.y + 1));
  
  // The closer a pixel is to the exact position, the more it contributes to the final color.
  float4 top = mix(topLeft, topRight, positionFrac.x);
  float4 bottom = mix(bottomLeft, bottomRight, positionFrac.x);
  
  // Interpolate vertically
  float4 pixel = mix(top, bottom, positionFrac.y);
  
  output.write(pixel, outputPosition);
}
