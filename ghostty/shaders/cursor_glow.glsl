// Cursor glow for Ghostty 1.2+ (custom-shader).
// A soft halo in the cursor colour fades out around the cursor cell.

const float RADIUS = 5.0;    // pixels for the glow to fall to ~37%
const float STRENGTH = 0.1;  // blend at the cursor edge

// Signed distance from p to a box of half-size b centred on the origin.
float sdBox(vec2 p, vec2 b) {
    vec2 d = abs(p) - b;
    return length(max(d, 0.0)) + min(max(d.x, d.y), 0.0);
}

void mainImage(out vec4 fragColor, in vec2 fragCoord) {
    fragColor = texture(iChannel0, fragCoord / iResolution.xy);

    // Ghostty passes cursors as (left, top, width, height) in fragCoord pixels.
    vec4 cur = iCurrentCursor;
    if (cur.z <= 0.0) return;

    vec2 center = vec2(cur.x + cur.z * 0.5, cur.y - cur.w * 0.5);
    float d = sdBox(fragCoord - center, cur.zw * 0.5);
    if (d <= 0.0) return; // leave the cursor cell to the terminal

    float glow = exp(-d / RADIUS) * STRENGTH;
    fragColor.rgb = mix(fragColor.rgb, iCurrentCursorColor.rgb, glow);
}
