local colors = require("colors")
local icons = require("icons")
local settings = require("settings")
local app_icons = require("helpers.app_icons")

local spaces = {}

local workspaces = get_workspaces()
local current_workspace = get_current_workspace()

for _, workspace in ipairs(workspaces) do
  local selected = workspace == current_workspace
  local space = sbar.add("item", "space." .. workspace, {
    icon = {
      font = { family = settings.font.numbers },
      string = workspace,
      padding_left = 15,
      padding_right = 8,
      color = colors.white,
      highlight_color = colors.red,
      highlight = selected,
    },
    label = {
      padding_right = 20,
      color = colors.grey,
      highlight_color = colors.white,
      font = "sketchybar-app-font:Regular:16.0",
      y_offset = -1,
      highlight = selected,
    },
    padding_right = 1,
    padding_left = 1,
    background = {
      color = colors.bg1,
      border_width = 1,
      height = 26,
      border_color = selected and colors.red or colors.black,
    },
    popup = { background = { border_width = 5, border_color = colors.black } }
  })

  spaces[workspace] = space

  -- Single item bracket for space items to achieve double border on highlight
  local space_bracket = sbar.add("bracket", { space.name }, {
    background = {
      color = colors.transparent,
      border_color = selected and colors.grey or colors.bg2,
      height = 28,
      border_width = 2
    }
  })

  -- Padding space
  sbar.add("item", "space.padding." .. workspace, {
    script = "",
    width = settings.group_paddings,
  })

  local space_popup = sbar.add("item", {
    position = "popup." .. space.name,
    padding_left = 5,
    padding_right = 0,
    background = {
      drawing = true,
      image = {
        corner_radius = 4,
        scale = 0.2
      }
    }
  })

  -- Initialize app icons for the workspace
  sbar.exec("aerospace list-windows --workspace " .. workspace .. " --format '%{app-name}' --json", function(result)
    local icon_line = ""
    local no_app = true
    if result and #result > 0 then
      for _, app_data in ipairs(result) do
        no_app = false
        local app_name = app_data["app-name"]
        local lookup = app_icons[app_name]
        local icon = ((lookup == nil) and app_icons["Default"] or lookup)
        icon_line = icon_line .. icon
      end
    end

    if no_app then
      icon_line = " —"
    end

    space:set({ label = icon_line })
  end)

  space:subscribe("aerospace_workspace_change", function(env)
    local is_selected = env.FOCUSED_WORKSPACE == workspace
    space:set({
      icon = { highlight = is_selected },
      label = { highlight = is_selected },
      background = { border_color = is_selected and colors.red or colors.black }
    })
    space_bracket:set({
      background = { border_color = is_selected and colors.grey or colors.bg2 }
    })
  end)

  space:subscribe("mouse.clicked", function(env)
    if env.BUTTON == "other" then
      space_popup:set({ background = { image = "space." .. workspace } })
      space:set({ popup = { drawing = "toggle" } })
    else
      sbar.exec("aerospace workspace " .. workspace)
    end
  end)

  space:subscribe("mouse.exited", function(_)
    space:set({ popup = { drawing = false } })
  end)
end

local space_window_observer = sbar.add("item", {
  drawing = false,
  updates = true,
})

local spaces_indicator = sbar.add("item", {
  padding_left = -3,
  padding_right = 0,
  icon = {
    padding_left = 8,
    padding_right = 9,
    color = colors.grey,
    string = icons.switch.on,
  },
  label = {
    width = 0,
    padding_left = 0,
    padding_right = 8,
    string = "Spaces",
    color = colors.bg1,
  },
  background = {
    color = colors.with_alpha(colors.grey, 0.0),
    border_color = colors.with_alpha(colors.bg1, 0.0),
  }
})

space_window_observer:subscribe("space_windows_change", function(_)
  for _, workspace in ipairs(workspaces) do
    sbar.exec("aerospace list-windows --workspace " .. workspace .. " --format '%{app-name}' --json", function(result)
      local icon_line = ""
      local no_app = true
      if result and #result > 0 then
        for _, app_data in ipairs(result) do
          no_app = false
          local app_name = app_data["app-name"]
          local lookup = app_icons[app_name]
          local icon = ((lookup == nil) and app_icons["Default"] or lookup)
          icon_line = icon_line .. icon
        end
      end

      if no_app then
        icon_line = " —"
      end

      sbar.animate("tanh", 10, function()
        if spaces[workspace] then
          spaces[workspace]:set({ label = icon_line })
        end
      end)
    end)
  end
end)

space_window_observer:subscribe("aerospace_focus_change", function(_)
  for _, workspace in ipairs(workspaces) do
    sbar.exec("aerospace list-windows --workspace " .. workspace .. " --format '%{app-name}' --json", function(result)
      local icon_line = ""
      local no_app = true
      if result and #result > 0 then
        for _, app_data in ipairs(result) do
          no_app = false
          local app_name = app_data["app-name"]
          local lookup = app_icons[app_name]
          local icon = ((lookup == nil) and app_icons["Default"] or lookup)
          icon_line = icon_line .. icon
        end
      end

      if no_app then
        icon_line = " —"
      end

      sbar.animate("tanh", 10, function()
        if spaces[workspace] then
          spaces[workspace]:set({ label = icon_line })
        end
      end)
    end)
  end
end)

spaces_indicator:subscribe("swap_menus_and_spaces", function(_)
  local currently_on = spaces_indicator:query().icon.value == icons.switch.on
  spaces_indicator:set({
    icon = currently_on and icons.switch.off or icons.switch.on
  })
end)

spaces_indicator:subscribe("mouse.entered", function(_)
  sbar.animate("tanh", 30, function()
    spaces_indicator:set({
      background = {
        color = { alpha = 1.0 },
        border_color = { alpha = 1.0 },
      },
      icon = { color = colors.bg1 },
      label = { width = "dynamic" }
    })
  end)
end)

spaces_indicator:subscribe("mouse.exited", function(_)
  sbar.animate("tanh", 30, function()
    spaces_indicator:set({
      background = {
        color = { alpha = 0.0 },
        border_color = { alpha = 0.0 },
      },
      icon = { color = colors.grey },
      label = { width = 0, }
    })
  end)
end)

spaces_indicator:subscribe("mouse.clicked", function(_)
  sbar.trigger("swap_menus_and_spaces")
end)
