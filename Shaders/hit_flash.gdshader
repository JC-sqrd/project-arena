shader_type canvas_item;

uniform float hit_opacity = 0;
uniform vec4 modulate : source_color = vec4(1.0,1.0,1.0,1.0);

void fragment() {
	vec4 texture_color = texture(TEXTURE, UV);
	vec3 modulated_color = texture_color.rgb * modulate.rgb * (1.0 - hit_opacity) + vec3(1.0, 1.0, 1.0) * hit_opacity;
	COLOR = vec4(modulated_color, texture_color.a * modulate.a);

	//COLOR.rgb = (texture(TEXTURE, UV).rgb * (1.0 - hit_opacity) + vec3(1,1,1) * hit_opacity);
	//COLOR.a = texture(TEXTURE, UV).a;
}
