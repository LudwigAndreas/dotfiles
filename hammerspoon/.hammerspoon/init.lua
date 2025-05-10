
hs.window.animationDuration = 0

local hotkeys = {
  {"1", "Google Chrome"},
  {"2", "Ghostty"},
  {"3", "Obsidian"},
  {"4", "Telegram"},
}

for _, mapping in ipairs(hotkeys) do
  local key = mapping[1]
  local appName = mapping[2]

  hs.hotkey.bind({"alt"}, key, function()
    local app = hs.application.get(appName)
    if app then
      app:activate()
    else
      hs.application.launchOrFocus(appName)
    end
  end)
end

