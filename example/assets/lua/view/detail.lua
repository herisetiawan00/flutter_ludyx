local UI = require("components.basic")

local function DetailView()
  return UI.Multi({
    direction = "vertical",
    crossAlignment = "center",
    alignment = "center",
    spacing = 16,
    children = {
      UI.Text({
        value = "Detail Screen",
        style = {
          fontSize = 24,
          fontWeight = 600
        }
      }),
      UI.Clickable({
        onClick = function()
          Navigator.pop()
        end,
        child = UI.Text({
          value = "Back"
        }),
      })
    }
  })
end

return DetailView
