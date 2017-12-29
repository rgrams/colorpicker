varying mediump vec2 var_texcoord0;

uniform lowp sampler2D DIFFUSE_TEXTURE;
uniform lowp vec4 settings;
uniform lowp vec4 color_rgb;
uniform lowp vec4 color_hsv;

vec3 rgb_to_hsv(vec3 rgb) {
	vec3 hsv = vec3(0.0, 0.0, 0.0);
	float mx = max(max(rgb.x, rgb.y), rgb.z);
	float mn = min(min(rgb.x, rgb.y), rgb.z);
	float diff = mx-mn;
	// Hue
	if(mx == mn) { hsv.x = 0; }
	else if(mx == rgb.x) { hsv.x = mod((60 * ((rgb.y-rgb.z)/diff) + 360), 360); }
	else if(mx == rgb.y) { hsv.x = mod((60 * ((rgb.z-rgb.x)/diff) + 360), 360); }
	else if(mx == rgb.z) { hsv.x = mod((60 * ((rgb.x-rgb.y)/diff) + 360), 360); }
	// Saturation
	if(mx == 0) { hsv.y = 0; }
	else { hsv.y = diff/mx; }
	// Value
	hsv.z = mx;

	return hsv;
}

vec3 hsv_to_rgb(vec3 hsv) { // doesn't work
	vec3 rgb = vec3(hsv);
	float hi = floor(hsv.x*6);
	float f = hsv.x*6 - hi;
    float p = hsv.z * (1.0 - hsv.y);
    float q = hsv.z * (1.0 - f * hsv.y);
    float t = hsv.z * (1.0 - (1.0 - f) * hsv.y);
    if(hi == 0) { rgb.x, rgb.y, rgb.z = hsv.z, t, p; }
    else if(hi == 1) { rgb.x, rgb.y, rgb.z = q, hsv.z, p; }
    else if(hi == 2) { rgb.x, rgb.y, rgb.z = p, hsv.z, t; }
    else if(hi == 3) { rgb.x, rgb.y, rgb.z = p, q, hsv.z; }
    else if(hi == 4) { rgb.x, rgb.y, rgb.z = t, p, hsv.z; }
    else if(hi == 5) { rgb.x, rgb.y, rgb.z = hsv.z, p, q; }
    return rgb;
}

vec3 hsv2rgb(vec3 c) { // works
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
	if (settings.b == 1) {
		if (settings.a == 0) { color.rgba = color_hsv; }
		else { color.rgba = color_rgb; }
	}

	// change values of selected axes
	// x-axis
	if (settings.x == 1) { color.r = var_texcoord0.x; }
	else if (settings.x == 2) { color.g = var_texcoord0.x; }
	else if (settings.x == 3) { color.b = var_texcoord0.x; }
	else if (settings.x == 4) { color.a = var_texcoord0.x; }
	// y-axis
	if (settings.y == 1) { color.r = var_texcoord0.y; }
	else if (settings.y == 2) { color.g = var_texcoord0.y; }
	else if (settings.y == 3) { color.b = var_texcoord0.y; }
	else if (settings.y == 4) { color.a = var_texcoord0.y; }

	// If not using rgb mode, convert color from hsv to rgb
	if (settings.a == 0) { color.rgb = hsv2rgb(color.rgb); }
	color.rgb *= color.a; // Pre-multiply

	gl_FragColor = color;
}
