shader_type canvas_item;

uniform vec4 base_color: source_color = vec4(0.0, 0.0, 0.0, 0.85);
uniform float aspect_ratio = 0.5;
uniform float radius = 0.1;
uniform float strength = 0.5;
uniform float radius_dist = 0.1;
uniform vec2 u_mouse = vec2(0.45, 0.44);
uniform bool disable_darkening = false;

uniform vec2 rect_center = vec2(0.5, 0.5);
uniform vec2 rect_size   = vec2(0.085, 0.18);

uniform float edge_softness = 0.05;
uniform float edge_sharpness = 0.015;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	if (disable_darkening) {
		COLOR = vec4(base_color.rgb, 0.0);
	} else {
		vec2 scaledUV = vec2(UV.x, UV.y * aspect_ratio);
		vec2 scaledMouse = vec2(u_mouse.x, u_mouse.y * aspect_ratio);

		float d = distance(scaledUV, scaledMouse);
		float fade = smoothstep(radius, radius * radius_dist, d);

		float alpha_circle = (d < radius) ? base_color.a - fade * strength : base_color.a;

		vec2 rec_distance = abs(UV - rect_center) - rect_size;
		float outsideDist = length(max(rec_distance, 0.0));
		float rect_mask = smoothstep(edge_sharpness, edge_softness, outsideDist);

		float alpha_rect = base_color.a * rect_mask;

		float alpha = alpha_circle * rect_mask;

		COLOR = vec4(base_color.rgb, alpha);
	}
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
