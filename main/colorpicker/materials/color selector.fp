varying mediump vec2 var_texcoord0;

uniform lowp sampler2D DIFFUSE_TEXTURE;
uniform lowp vec4 settings;
uniform lowp vec4 color_rgb;
uniform lowp vec4 color_hsv;

vec3 rgb_to_hsv(vec3 rgb) { // not actually used
	vec3 hsv = vec3(0.0, 0.0, 0.0);
	float mx = max(max(rgb.x, rgb.y), rgb.z);
	float mn = min(min(rgb.x, rgb.y), rgb.z);
	float diff = mx-mn;
	// Hue
	if(mx == mn) { hsv.x = 0.0; }
	else if(mx == rgb.x) { hsv.x = (rgb.y-rgb.z)/diff; }
	else if(mx == rgb.y) { hsv.x = 2.0 + (rgb.z-rgb.x)/diff; }
	else if(mx == rgb.z) { hsv.x = 4.0 + (rgb.x-rgb.y)/diff; }
	hsv.x = mod(hsv.x/6.0, 1.0);
	// Saturation
	if(mx == 0.0) { hsv.y = 0.0; }
	else { hsv.y = diff/mx; }
	// Value
	hsv.z = mx;

	return hsv;
}

vec3 hsv2rgb(vec3 c) {
  vec4 K = vec4(1.0, 2.0/3.0, 1.0/3.0, 3.0);
  vec3 p = abs(fract(c.xxx + K.xyz) * 6.0 - K.www);
  return c.z * mix(K.xxx, clamp(p - K.xxx, 0.0, 1.0), c.y);
}

/* vec4 settings = {
	x = 0, 1, 2, 3, 4: color axis of image X axis,
	y = 0, 1, 2, 3, 4: color axis of image Y axis,
		0 = none,
		1 = x, (red or hue)
		2 = y, (green or saturation)
		3 = z, (blue or value)
		4 = w, (alpha)
	z = 0 or 1: unchanging or changing mode (changing = grabs all other axes from current color)
	w = 0 or 1: hsb or rgb mode
}
*/

void main()
{
	vec4 color = vec4(1.0);
	// to start, set our color to the current color for our mode (hsv or rgb)
	if (settings.z == 1.0) {
		if (settings.w == 0.0) { color.rgba = color_hsv; }
		else { color.rgba = color_rgb; }
	}

	// change values of selected axes
	// x-axis
	if (settings.x == 1.0) { color.r = var_texcoord0.x; }
	else if (settings.x == 2.0) { color.g = var_texcoord0.x; }
	else if (settings.x == 3.0) { color.b = var_texcoord0.x; }
	else if (settings.x == 4.0) { color.a = var_texcoord0.x; }
	// y-axis
	if (settings.y == 1.0) { color.r = var_texcoord0.y; }
	else if (settings.y == 2.0) { color.g = var_texcoord0.y; }
	else if (settings.y == 3.0) { color.b = var_texcoord0.y; }
	else if (settings.y == 4.0) { color.a = var_texcoord0.y; }

	// If not using rgb mode, convert color from hsv to rgb
	if (settings.w == 0.0) { color.rgb = hsv2rgb(color.rgb); }
	color.rgb *= color.a; // Pre-multiply

	gl_FragColor = color;
}
