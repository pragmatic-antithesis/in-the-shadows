shader_type canvas_item;

uniform vec4 base_color: source_color = vec4(0.0, 0.0, 0.0, 0.7);
uniform float aspect_ratio = 0.5;
uniform float radius = 0.2;
uniform vec2 u_mouse = vec2(0.45, 0.44);

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	vec2 scaledUV = vec2(UV.x, UV.y * aspect_ratio);
	vec2 scaledMouse = vec2(u_mouse.x, u_mouse.y * aspect_ratio);

    float d = distance(scaledUV, scaledMouse);
    COLOR = (d < radius) ? vec4(0.0, 1.0, 0.0, 1.0) : vec4(1.0);
}
//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
