local UI = require("components.basic");

local value = 0

local function HomeView()
  return UI.Multi({
    direction = "vertical",
    crossAlignment = "center",
    alignment = "center",
    spacing = 16,
    children = {
      UI.Text({
        value = "Home Screen",
        style = {
          fontSize = 24,
          fontWeight = 600
        }
      }),
      UI.Clickable({
        onClick = function()
          Navigator.pushNamed("/detail")
        end,
        child = UI.Text({
          value = "Open Detail"
        }),
      }),
      UI.Text({
        value = "set the counter below",
      }),
      UI.Text({
        value = tostring(value),
        style = {
          fontSize = 28,
          fontWeight = 800
        }
      }),
      UI.Clickable({
        onClick = function()
          value = value + 1
          Flutter.rebuild();
        end,
        child = UI.Text({
          value = "increase"
        }),
      })
    }
  })
end

return HomeView
