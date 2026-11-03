---@class RouteItem
---@field [string] fun(): Component


---@class Routes
---@field getAll fun(): RouteItem
---@field get fun(name:string): fun(): Component

local Routes = {}

---@return RouteItem
function Routes.getAll()
  return {
    ["/home"] = function()
      local HomeView = require('view.home')
      return HomeView()
    end,
    ["/detail"] = function ()
      local DetailView = require('view.detail')
      return DetailView()
    end
  }
end

---@param name string
---@return fun(): Component
function Routes.get(name)
  local routes = Routes.getAll()
  return routes[name]
end

function Routes._notFound()
  local NotFoundView = require('view.not_found')
  return NotFoundView
end

---@cast Routes Routes
return Routes

