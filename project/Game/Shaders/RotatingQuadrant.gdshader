shader_type canvas_item;

uniform vec4 first_color : hint_color;
uniform vec4 second_color : hint_color;

uniform float angle_radians = 1.57079632679;
uniform float tmp1 = 0.0;
uniform float tmp2 = 0.0;

const float PI = 3.14159265358979323846;

vec2 calculateVectorFromAngle(float targetAngle) {
	return vec2(cos(targetAngle), sin(targetAngle));
}

bool getEqualOrLessThanBoundary(float x, float y, vec2 boundary) {
	return (x - 0.5) <= (y - 0.5);
	//return pow(((x - 0.5) * boundary.x), (exp(tmp1)))  <= (y - 0.5) * boundary.y;
}

bool getGreaterThanBoundary(float x, float y, vec2 boundary) {
	return (x - 0.5) > (y - 0.5);
	//return pow(((x - 0.5) * boundary.x), (exp(tmp1))) > (y - 0.5) * boundary.y ;
}

// Other Cool Equations:
// pow(((x - 0.5) * boundary.x), (exp(tmp1))) > (y - 0.5) * boundary.y

void fragment() {
	vec2 line_1 = calculateVectorFromAngle(angle_radians);
	vec2 line_2 = calculateVectorFromAngle(angle_radians + PI/2.0);
	
	if (getEqualOrLessThanBoundary(UV.x, UV.y, line_1) && 
		getEqualOrLessThanBoundary(UV.x, UV.y, line_2)) {
		COLOR = first_color;
	} else if (getGreaterThanBoundary(UV.x, UV.y, line_1) &&
		getGreaterThanBoundary(UV.x, UV.y, line_2)) {
		COLOR = first_color;
	} else if (getEqualOrLessThanBoundary(UV.x, UV.y, line_1) &&
		getGreaterThanBoundary(UV.x, UV.y, line_2)) {
		COLOR = second_color;
	} else if (getGreaterThanBoundary(UV.x, UV.y, line_1) &&
		getEqualOrLessThanBoundary(UV.x, UV.y, line_2)) {
		COLOR = second_color;
	}
}
