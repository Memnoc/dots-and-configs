// Cursor ripple for Ghostty 1.2+ (custom-shader).
// When the cursor jumps, a thin ring in the cursor colour spreads out from
// where it lands and fades. Short moves, such as typing, draw nothing.

const float DURATION = 0.35;      // seconds for the ring to expand and fade
const float MIN_JUMP_CELLS = 2.0; // ignore moves shorter than this many cell widths
const float MAX_RADIUS = 2.5;     // final ring radius, in cursor heights
const float THICKNESS = 1.5;      // ring half-width in pixels
const float OPACITY = 0.5;

float easeOutCubic(float t) { return 1.0 - pow(1.0 - t, 3.0); }

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

    // Leave the cursor cell itself to the terminal.
    vec2 inCursor = step(cur.xy - vec2(0.0, cur.w), fragCoord)
                  * step(fragCoord, cur.xy + vec2(cur.z, 0.0));
    if (inCursor.x * inCursor.y > 0.0) return;

    float radius = easeOutCubic(t) * MAX_RADIUS * cur.w;
    float d = abs(distance(fragCoord, center) - radius);
    float ring = 1.0 - smoothstep(THICKNESS - 1.0, THICKNESS + 1.0, d);

    float alpha = ring * OPACITY * (1.0 - t);
    fragColor.rgb = mix(fragColor.rgb, iCurrentCursorColor.rgb, alpha);
}
