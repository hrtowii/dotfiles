#define BLACK_BLEND_THRESHOLD 1.0

float hash21(vec2 p) {
    p = fract(p * vec2(233.34, 851.73));
    p += dot(p, p + 23.45);
    return fract(p.x * p.y);
}

float rayStrength(vec2 raySource, vec2 rayRefDirection, vec2 coord, float seedA, float seedB, float speed)
{
    vec2 sourceToCoord = coord - raySource;
    float cosAngle = dot(normalize(sourceToCoord), rayRefDirection);
    
    // Add subtle dithering based on screen coordinates
    float dither = hash21(coord) * 0.015 - 0.0075;
    
    float ray = clamp(
        (0.45 + 0.15 * sin(cosAngle * seedA + iTime * speed)) +
        (0.3 + 0.2 * cos(-cosAngle * seedB + iTime * speed)) + dither,
        0.0, 1.0);
        
    // Smoothstep the distance falloff
    float distFade = smoothstep(0.0, iResolution.x, iResolution.x - length(sourceToCoord));
    return ray * mix(0.5, 1.0, distFade);
}
float lum(vec4 c) {
  return 0.299 * c.r + 0.587 * c.g + 0.114 * c.b;
}

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    vec2 uv = fragCoord.xy / iResolution.xy;
    uv.y = 1.0 - uv.y;
    vec2 coord = vec2(fragCoord.x, iResolution.y - fragCoord.y);
    
    // Sample terminal color FIRST (before calculating rays)
    vec2 termUV = fragCoord.xy / iResolution.xy;
    vec4 terminalColor = texture(iChannel0, termUV);
    float luminance = lum(terminalColor);
    
    // Only apply rays to dark pixels (background)
    // Rose Pine bg is ~0.08-0.12, text is 0.4+
    if (luminance > 0.2) {
        fragColor = terminalColor;
        return;
    }
    // Set the parameters of the sun rays
    vec2 rayPos1 = vec2(iResolution.x * 0.7, iResolution.y * 1.1);
    vec2 rayRefDir1 = normalize(vec2(1.0, 0.116));
    float raySeedA1 = 36.2214;
    float raySeedB1 = 21.11349;
    float raySpeed1 = 1.1;
    
    vec2 rayPos2 = vec2(iResolution.x * 0.8, iResolution.y * 1.2);
    vec2 rayRefDir2 = normalize(vec2(1.0, -0.241));
    const float raySeedA2 = 22.39910;
    const float raySeedB2 = 18.0234;
    const float raySpeed2 = 0.9;
    
    // Calculate ray STRENGTHS (0.0 to 1.0)
    float strength1 = rayStrength(rayPos1, rayRefDir1, coord, raySeedA1, raySeedB1, raySpeed1);
    float strength2 = rayStrength(rayPos2, rayRefDir2, coord, raySeedA2, raySeedB2, raySpeed2);
    
    // Combine strengths (this is how visible the rays are)
    float totalStrength = strength1 * 0.5 + strength2 * 0.4;
    
    // If there's no ray here, just use terminal color (early exit for performance)
    if (totalStrength < 0.001) {
        fragColor = terminalColor;
        return;
    }
    
    // Calculate ray COLOR (white base × strength × blue-green colorization)
    vec4 col = vec4(1.0, 1.0, 1.0, 0.0) * totalStrength;
    
    // Attenuate brightness towards the bottom, simulating light-loss due to depth.
    // Give the whole thing a blue-green tinge as well.
    float brightness = 1.0 - (coord.y / iResolution.y);
    col.r *= 0.05 + (brightness * 0.8);
    col.g *= 0.15 + (brightness * 0.6);
    col.b *= 0.3 + (brightness * 0.5);
    
    // BLEND: Add rays on top of terminal color
    // Use ray strength as the mix factor (so dark areas have no rays)
    // 0.3 is a global opacity control for the entire effect
    vec3 blendedColor = mix(terminalColor.rgb, col.rgb, totalStrength * 0.4);
    
    fragColor = vec4(blendedColor, terminalColor.a);
}
