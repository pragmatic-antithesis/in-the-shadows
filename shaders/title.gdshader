shader_type canvas_item;

uniform float steepness = 10.0;
uniform vec2 mouse_pos = vec2(0.5, 0.5);
uniform float gradient_radius = 1.0;
uniform float aspect_ratio = 0.5;

float rationalBump(float x, float k) {
    return 1.0/(1.0+k*x*x);
}

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	vec2 scaledUV = vec2(UV.x, UV.y * aspect_ratio);
	vec2 scaledMouse = vec2(mouse_pos.x, mouse_pos.y * aspect_ratio);
    float distance = length(scaledUV - scaledMouse) / gradient_radius;
	float gradient = rationalBump(distance, steepness);
	vec3 new_color = vec3(gradient);
	COLOR = vec4(new_color, 1.0);
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
