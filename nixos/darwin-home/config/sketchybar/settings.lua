return {
  paddings = 3,
  group_paddings = 5,

  icons = "sf-symbols", -- alternatively available: NerdFont

  -- This is a font configuration for SF Pro and SF Mono (installed manually)
  -- font = require("helpers.default_font"),

  -- Alternatively, this is a font config for JetBrainsMono Nerd Font
  font = {
    text = "Monaspace Neon Var", -- Used for text
    numbers = "Monaspace Neon Var", -- Used for numbers
    space_numbers = "Maple Mono NF",
    style_map = {
      ["Regular"] = "Regular",
      ["Semibold"] = "Medium",
      ["Bold"] = "SemiBold",
      ["Heavy"] = "Bold",
      ["Black"] = "ExtraBold",
    },
  },
}
