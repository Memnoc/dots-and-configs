// Light vignette for Ghostty (custom-shader).
// Darkens the outer edges slightly; the middle of the window is untouched.

const float STRENGTH = 0.18; // darkening at the corners
const float START = 0.55;    // distance from centre where darkening begins (1 = corner)

void mainImage(out vec4 fragColor, in vec2 fragCoord) {
    vec2 uv = fragCoord / iResolution.xy;
    fragColor = texture(iChannel0, uv);

    float dist = length((uv - 0.5) * 2.0) / sqrt(2.0);
    fragColor.rgb *= 1.0 - smoothstep(START, 1.0, dist) * STRENGTH;
}
