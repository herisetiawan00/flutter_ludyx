local Routes = require('routes')

function GetView(name)
  local route = Routes.get(name)
  return route()
end

---@class NavigatorStatic
---@field pushNamed fun(routeName: string, arguments?: any): nil
---@field pop fun(result?: any): nil

---@type NavigatorStatic
Navigator = Navigator or {}

---@class Flutter
---@field rebuild fun(): nil
Flutter = Flutter or {}

