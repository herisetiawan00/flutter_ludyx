local UI = require("components")

local function DetailView()
  return UI.MultiWidget({
    direction = "vertical",
    crossAlignment = "center",
    alignment = "center",
    spacing = 16,
    children = {
      UI.TextWidget({
        value = "Detail Screen",
        style = {
          fontSize = 24,
          fontWeight = 600
        }
      }),
      UI.ClickableWidget({
        onClick = function()
          Navigator.pop()
        end,
        child = UI.TextWidget({
          value = "Back"
        }),
      })
    }
  })
end

return DetailView
