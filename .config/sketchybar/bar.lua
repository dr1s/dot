local colors = require("colors")

-- Equivalent to the --bar domain
sbar.bar({
  topmost = "window",
  height = 32,
  color = colors.bar.bg,
  padding_right = 7,
  padding_left = 7,
})
