-- Catppuccin Mocha theme with a pure black bar background

return {
  black = 0xff1e1e2e,
  white = 0xffcdd6f4,
  red = 0xfff38ba8,
  green = 0xffa6e3a1,
  blue = 0xff89b4fa,
  yellow = 0xfff9e2af,
  orange = 0xfffab387,
  magenta = 0xffcba6f7,
  grey = 0xff7f849c,
  transparent = 0x00000000,

  bar = {
    bg = 0xff000000,
    border = 0xff181825,
  },
  popup = {
    bg = 0xc0313244,
    border = 0xff45475a
  },

  bg1 = 0xff313244,
  bg2 = 0xff45475a,

  -- Utility function to apply an alpha channel to a hex color.
  -- The alpha value should be a float between 0.0 (transparent) and 1.0 (opaque).
  with_alpha = function(color, alpha)
    if alpha > 1.0 or alpha < 0.0 then return color end
    return (color & 0x00ffffff) | (math.floor(alpha * 255.0) << 24)
  end,
}
