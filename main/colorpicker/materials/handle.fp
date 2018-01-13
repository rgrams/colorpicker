varying mediump vec2 var_texcoord0;

uniform lowp sampler2D DIFFUSE_TEXTURE;
uniform lowp vec4 settings;
uniform lowp vec4 color_rgb;
uniform lowp vec4 color_hsv;

vec3 hsv_to_rgb(vec3 c) {
  vec4 K = vec4(1.0, 2.0/3.0, 1.0/3.0, 3.0);
  vec3 p = abs(fract(c.xxx + K.xyz) * 6.0 - K.www);
  return c.z * mix(K.xxx, clamp(p - K.xxx, 0.0, 1.0), c.y);
}

float rgb_to_val(vec3 rgb) { // A reasonably accurate perceptual value conversion
	return rgb.r*0.2 + rgb.g*0.7 + rgb.b*0.07;
}

void main()
{
	vec4 tex = texture2D(DIFFUSE_TEXTURE, var_texcoord0.xy);
	float texval = min(1.0, tex.r + tex.g + tex.b); // crude value of tex
	// invert hsv color, clamp value, and premultiply
	vec4 inv = vec4(mod(color_hsv.x+0.5, 1.0), color_hsv.y, min(1.0-rgb_to_val(color_rgb.rgb), 0.4), 1.0) * tex.a;
	inv.rgb = hsv_to_rgb(inv.rgb); // convert back to rgb

	gl_FragColor = mix(tex, inv, 1.0-texval);
}
