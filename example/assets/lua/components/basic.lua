---@class Component
---@field component string

---@class TextStyle
---@field fontSize? number
---@field fontFamily? string
---@field fontWeight? integer
---@field fontStyle? "normal" | "italic"
---@field color? string
---@field backgroundColor? string

---@class TextProps
---@field value string
---@field style? TextStyle

---@class Text: Component, TextProps
---@field component "text"

---@param props TextProps
---@return Text
local function Text(props)
  ---@cast props Text
  props.component = "text"
  return props
end

---@class ClickableProps
---@field child Component
---@field onClick fun(): nil

---@class Clickable: Component, ClickableProps
---@field component string

---@param props ClickableProps
---@return Clickable
local function Clickable(props)
  ---@cast props Clickable
  props.component = "clickable"
  return props
end

---@class MultiProps
---@field children Component[]
---@field direction "horizontal" | "vertical"
---@field spacing? number
---@field alignment? "start" | "end" | "center" | "space_between" | "space_around" | "space_evenly"
---@field crossAlignment? "start" | "end" | "center" | "stretch" | "baseline"

---@class Multi: Component, MultiProps
---@field component "multi"

---@param props MultiProps
---@return Multi
local function Multi(props)
  ---@cast props Multi
  props.component = "multi"
  return props
end

local UI = {
  Text = Text,
  Clickable = Clickable,
  Multi = Multi,
}

return UI
