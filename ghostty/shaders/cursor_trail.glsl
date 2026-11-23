// Cursor trail for Ghostty 1.2+ (custom-shader).
// When the cursor jumps, a tapered streak runs from the old position and
// collapses into the new one. Short moves, such as typing, draw nothing.

const float DURATION = 0.18;      // seconds for the trail to collapse
const float MIN_JUMP_CELLS = 2.0; // ignore moves shorter than this many cell widths
const float OPACITY = 0.6;

float easeOutCubic(float t) { return 1.0 - pow(1.0 - t, 3.0); }

// Ghostty passes cursors as (left, top, width, height) in fragCoord pixels.
vec2 cursorCenter(vec4 c) { return vec2(c.x + c.z * 0.5, c.y - c.w * 0.5); }

// Signed distance from p to a segment a->b whose radius tapers from ra to rb.
float taperedSegment(vec2 p, vec2 a, vec2 b, float ra, float rb) {
    vec2 pa = p - a, ba = b - a;
    float h = clamp(dot(pa, ba) / dot(ba, ba), 0.0, 1.0);
    return length(pa - ba * h) - mix(ra, rb, h);
}

void mainImage(out vec4 fragColor, in vec2 fragCoord) {
    fragColor = texture(iChannel0, fragCoord / iResolution.xy);

    vec4 cur = iCurrentCursor;
    vec4 prev = iPreviousCursor;
    if (cur.z <= 0.0 || prev.z <= 0.0) return;

    vec2 head = cursorCenter(cur);
    vec2 origin = cursorCenter(prev);
    if (distance(head, origin) < cur.z * MIN_JUMP_CELLS) return;

    float t = clamp((iTime - iTimeCursorChange) / DURATION, 0.0, 1.0);
    if (t >= 1.0) return;

    vec2 tail = mix(origin, head, easeOutCubic(t));
    if (distance(head, tail) < 0.5) return;

    float headRadius = min(cur.z, cur.w) * 0.5;
    float d = taperedSegment(fragCoord, tail, head, headRadius * 0.15, headRadius);
    float coverage = 1.0 - smoothstep(-1.0, 1.0, d);

    // Leave the cursor cell itself to the terminal.
    vec2 inCursor = step(cur.xy - vec2(0.0, cur.w), fragCoord)
                  * step(fragCoord, cur.xy + vec2(cur.z, 0.0));
    coverage *= 1.0 - inCursor.x * inCursor.y;

    float alpha = coverage * OPACITY * (1.0 - t);
    fragColor.rgb = mix(fragColor.rgb, iCurrentCursorColor.rgb, alpha);
}
