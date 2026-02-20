local colors = require("colors")

-- Equivalent to the --bar domain
sbar.bar({
	topmost = "window",
	height = 40, -- fixme: different height on different monitors how? retrieve current monitor height then do it as a percentage instead?
	color = colors.with_alpha(colors.bg2, 0.35),
	padding_right = 5,
	padding_left = 5,
	blur_radius = 30,
	shadow = false,
	y_offset = 0,
	margin = 0,
	corner_radius = 5,
	background_color = colors.with_alpha(colors.bar.bg, 0.80),
})
