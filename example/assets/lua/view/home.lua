local UI = require("components");

local value = 0

local function HomeView()
  return UI.MultiWidget({
    direction = "vertical",
    crossAlignment = "center",
    alignment = "center",
    spacing = 16,
    children = {
      UI.TextWidget({
        value = "Home Screen",
        style = {
          fontSize = 24,
          fontWeight = 600
        }
      }),
      UI.ClickableWidget({
        onClick = function()
          Navigator.pushNamed("/detail")
        end,
        child = UI.TextWidget({
          value = "Open Detail"
        }),
      }),
      UI.TextWidget({
        value = "set the counter below",
      }),
      UI.TextWidget({
        value = tostring(value),
        style = {
          fontSize = 28,
          fontWeight = 800
        }
      }),
      UI.ClickableWidget({
        onClick = function()
          value = value + 1
          Flutter.rebuild();
        end,
        child = UI.TextWidget({
          value = "increase"
        }),
      })
    }
  })
end

return HomeView
