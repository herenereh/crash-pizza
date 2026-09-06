shader_type spatial;
render_mode unshaded, cull_disabled;

uniform sampler2D portal_texture : source_color, filter_nearest;

void fragment() {
	ALBEDO = texture(portal_texture, SCREEN_UV).rgb;
}
