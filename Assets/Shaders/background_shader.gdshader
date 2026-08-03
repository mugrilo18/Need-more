shader_type canvas_item;

uniform float scroll_speed : hint_range(0.0, 2.0) = 0.05;
uniform float angle_degrees : hint_range(0.0, 360.0, 1.0) = 45.0;
uniform float repeat_x : hint_range(1.0, 20.0, 1.0) = 1.0;
uniform float repeat_y : hint_range(1.0, 20.0, 1.0) = 1.0;
uniform vec4 tint : source_color = vec4(1.0);

void fragment() {
	float angle_rad = radians(angle_degrees);
	vec2 direction = vec2(cos(angle_rad), sin(angle_rad));
	vec2 offset_uv = UV - (TIME * scroll_speed * direction);
	
	//tile
	vec2 scaled_uv = vec2(fract(offset_uv.x * repeat_x), fract(offset_uv.y * repeat_y));
	vec2 texelSize = vec2(1.0) / vec2(textureSize(TEXTURE, 0));
	vec2 snappedUV = round(scaled_uv / texelSize) * texelSize;
	
	COLOR = texture(TEXTURE, snappedUV) * tint;
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
