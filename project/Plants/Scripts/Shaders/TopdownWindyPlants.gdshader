shader_type canvas_item;
render_mode blend_mix;

// Wind settings.
uniform vec2 wind = vec2(0, 0);

uniform float heightOffset : hint_range(0.0, 1.0);

void vertex() {
	vec4 pos = WORLD_MATRIX * vec4(0.0, 0.0, 0.0, 1.0);
	VERTEX.x += wind.x * max(0.0, (1.0-UV.y) - heightOffset);
	VERTEX.y += wind.y * max(0.0, (1.0-UV.y) - heightOffset);
}