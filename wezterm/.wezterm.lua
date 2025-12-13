-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This will hold the configuration.
local config = wezterm.config_builder()

-- This is where you actually apply your config choices.

-- For example, changing the initial geometry for new windows:
-- config.initial_cols = 120
-- config.initial_rows = 28

-- or, changing the font size and color scheme
config.font = wezterm.font 'Monego'
config.font_size = 12

-- if not can't start
config.enable_wayland = false

-- default tab bar is ugly
config.use_fancy_tab_bar = false

-- color scheme
config.color_scheme = 'One Half Black (Gogh)'

-- fullscreen on startup
local mux = wezterm.mux
wezterm.on('gui-startup', function(window)
  local tab, pane, window = mux.spawn_window(cmd or {})
  local gui_window = window:gui_window();
  gui_window:perform_action(wezterm.action.ToggleFullScreen, pane)
end)

wezterm.on('format-tab-title', function(tab, tabs, panes, config, hover, max_width)
    local pane = tab.active_pane
    local title = tab.tab_title

    if not title or #title == 0 then
        local process_name = pane.foreground_process_name

        if process_name then
            process_name = process_name:match("([^/\\]+)$") or process_name

            local is_shell = process_name:match("bash") or process_name:match("zsh") or process_name:match("fish") or
                                 process_name:match("sh$")

            if is_shell then
                local cwd_uri = pane.current_working_dir
                if cwd_uri then
                    local cwd = cwd_uri.file_path or tostring(cwd_uri)
                    title = cwd:match("([^/]+)/?$") or cwd
                else
                    title = process_name
                end
            else
                title = process_name
            end
        else
            title = "Tab"
        end
    end

    local index = tab.tab_index + 1

    return {{
        Text = ' ' .. index .. ': ' .. title .. ' '
    }}
end)

-- Finally, return the configuration to wezterm:
return config
