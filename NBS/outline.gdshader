shader_type canvas_item;

uniform vec4 outlinecolor : source_color;

uniform bool outline;

void fragment()
{
	float sizex = 1.0/float(textureSize(TEXTURE, 0).x);
	float sizey = 1.0/float(textureSize(TEXTURE, 0).y);
	vec4 spriteColor = texture(TEXTURE, UV);
	float alpha = -4.0 * spriteColor.a;
	alpha += texture(TEXTURE, UV + vec2(sizex, 0)).a;
	alpha += texture(TEXTURE, UV + vec2(-sizex, 0)).a;
	alpha += texture(TEXTURE, UV + vec2(0, sizey)).a;
	alpha += texture(TEXTURE, UV + vec2(0, -sizey)).a;
	vec4 finalColor = mix(spriteColor, outlinecolor, clamp(alpha, 0.0, 1));
	if (outline) {
		COLOR = vec4(finalColor.rgb, clamp(abs(alpha) + spriteColor.a, 0.0, 1.0));
	}
}
