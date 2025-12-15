precision mediump float;

varying vec2 v_texcoord;
uniform sampler2D tex;

const float blurSize = 8.0;

void main() {
    vec2 texelSize = 1.0 / vec2(textureSize(tex, 0));
    vec4 color = vec4(0.0);
    float totalWeight = 0.0;

    for (float x = -blurSize; x <= blurSize; x += 1.0) {
        float weight = exp(- (x * x) / (2.0 * blurSize * blurSize));
        color += texture2D(tex, v_texcoord + vec2(x * texelSize.x, 0.0)) * weight;
        totalWeight += weight;
    }
    color /= totalWeight;

    vec4 blurred = vec4(0.0);
    totalWeight = 0.0;
    for (float y = -blurSize; y <= blurSize; y += 1.0) {
        float weight = exp(- (y * y) / (2.0 * blurSize * blurSize));
        blurred += texture2D(tex, v_texcoord + vec2(0.0, y * texelSize.y)) * weight;
        totalWeight += weight;
    }
    blurred /= totalWeight;

    gl_FragColor = mix(color, blurred, 0.5);
}
