shader_type canvas_item;

uniform vec2 top_left = vec2(20, 20);
uniform vec2 bottom_right = vec2(460, 250);
uniform float rounded = 14.0;
uniform vec2 offset = vec2(0.0, 0.0);

varying vec2 position;


void vertex() {
    position = (MODEL_MATRIX * vec4(VERTEX, 0.0, 1.0)).xy;
}


void fragment() {
    vec2 pos = position - offset;

    if (pos.x >= top_left.x - rounded && pos.x <= bottom_right.x + rounded
        && pos.y >= top_left.y && pos.y <= bottom_right.y) {
        discard;
    }

    if (pos.x >= top_left.x && pos.x <= bottom_right.x
        && pos.y >= top_left.y - rounded && pos.y <= bottom_right.y + rounded) {
        discard;
    }

    if (distance(pos, top_left) <= rounded
        || distance(pos, vec2(bottom_right.x, top_left.y)) <= rounded
        || distance(pos, vec2(top_left.x, bottom_right.y)) <= rounded
        || distance(pos, bottom_right) <= rounded) {
        discard;
    }
}
