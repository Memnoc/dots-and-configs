// Cursor landing pulse for Ghostty 1.2+ (custom-shader).
// When the cursor jumps, a soft halo briefly brightens around where it lands
// and fades back. Nothing travels; short moves, such as typing, draw nothing.

const float DURATION = 0.25;      // seconds for the pulse to fade
const float MIN_JUMP_CELLS = 2.0; // ignore moves shorter than this many cell widths
const float RADIUS = 6.0;         // pixels for the halo to fall to ~37%
const float STRENGTH = 0.25;      // extra blend at the cursor edge when it lands

// Signed distance from p to a box of half-size b centred on the origin.
float sdBox(vec2 p, vec2 b) {
    vec2 d = abs(p) - b;
    return length(max(d, 0.0)) + min(max(d.x, d.y), 0.0);
}

// Ghostty passes cursors as (left, top, width, height) in fragCoord pixels.
vec2 cursorCenter(vec4 c) { return vec2(c.x + c.z * 0.5, c.y - c.w * 0.5); }

void mainImage(out vec4 fragColor, in vec2 fragCoord) {
    fragColor = texture(iChannel0, fragCoord / iResolution.xy);

    vec4 cur = iCurrentCursor;
    vec4 prev = iPreviousCursor;
    if (cur.z <= 0.0 || prev.z <= 0.0) return;

    vec2 center = cursorCenter(cur);
    if (distance(center, cursorCenter(prev)) < cur.z * MIN_JUMP_CELLS) return;

    float t = clamp((iTime - iTimeCursorChange) / DURATION, 0.0, 1.0);
    if (t >= 1.0) return;

    float d = sdBox(fragCoord - center, cur.zw * 0.5);
    if (d <= 0.0) return; // leave the cursor cell to the terminal

    float fade = (1.0 - t) * (1.0 - t);
    float alpha = exp(-d / RADIUS) * STRENGTH * fade;
    fragColor.rgb = mix(fragColor.rgb, iCurrentCursorColor.rgb, alpha);
}
