-- FuFu Hyprland config, migrated to Lua for Hyprland 0.55+.
-- Keep hyprland.conf around for Hyprland 0.54 and older.

local colors = require("colors")

hl.config({
	xwayland = {
		force_zero_scaling = true,
	},
})

hl.monitor({ output = "DP-1", mode = "highres", position = "auto", scale = 1.2 })
hl.monitor({ output = "HDMI-A-1", mode = "highres", position = "auto", scale = 1.6 })

local terminal = "kitty"
local fileManager = "thunar"
local menu = "walker"
local browser = "zen"
local locker = "hyprlock"
local bar = "waybar"
local inputMethod = "fcitx5"

hl.on("hyprland.start", function()
	hl.exec_cmd("hyprpaper & hypridle")
	hl.exec_cmd("mako")
	hl.exec_cmd("/usr/lib64/libexec/hyprpolkitagent")
	hl.exec_cmd("dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")
	hl.exec_cmd("elephant & walker --gapplication-service")
	hl.exec_cmd(bar .. " & blueman-applet & nm-applet")
	hl.exec_cmd("hyprpm reload")
	hl.exec_cmd("snappy-switcher --daemon")
end)

hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")
hl.env("LIBVA_DRIVER_NAME", "nvidia")
hl.env("__GLX_VENDOR_LIBRARY_NAME", "nvidia")
hl.env("ELECTRON_OZONE_PLATFORM_HINT", "auto")
hl.env("NVD_BACKEND", "direct")

hl.permission({ binary = "/usr/(bin|local/bin)/hyprpm", type = "plugin", mode = "allow" })

hl.config({
	general = {
		gaps_in = 4,
		gaps_out = 6,
		border_size = 4,
		col = {
			active_border = colors.primary,
			inactive_border = colors.outline,
			nogroup_border_active = colors.tertiary,
			nogroup_border = colors.outline_variant,
		},
		resize_on_border = false,
		allow_tearing = false,
		layout = "dwindle",
	},

	decoration = {
		rounding = 10,
		rounding_power = 2,
		active_opacity = 1.0,
		inactive_opacity = 0.9,
		fullscreen_opacity = 1.0,
		shadow = {
			enabled = true,
			range = 4,
			render_power = 3,
			color = colors.shadow,
		},
		blur = {
			enabled = true,
			size = 3,
			passes = 1,
			vibrancy = 0.1696,
		},
	},

	animations = {
		enabled = true,
	},

	dwindle = {
		preserve_split = true,
	},

	master = {
		new_status = "master",
	},

	misc = {
		force_default_wallpaper = -1,
		disable_hyprland_logo = false,
	},

	cursor = {
		no_hardware_cursors = true,
		no_warps = true,
	},

	input = {
		kb_layout = "us",
		kb_variant = "",
		kb_model = "",
		kb_options = "",
		kb_rules = "",
		follow_mouse = 1,
		sensitivity = 0,
		touchpad = {
			natural_scroll = true,
		},
	},
})

hl.curve("fluentDecel", { type = "bezier", points = { { 0.05, 0.9 }, { 0.1, 1.05 } } })
hl.curve("easeOutExpo", { type = "bezier", points = { { 0.16, 1 }, { 0.3, 1 } } })
hl.curve("softBounce", { type = "bezier", points = { { 0.1, 1.1 }, { 0.1, 1.05 } } })
hl.curve("liner", { type = "bezier", points = { { 0, 0 }, { 1, 1 } } })

hl.animation({ leaf = "windowsIn", enabled = true, speed = 3, bezier = "fluentDecel", style = "popin 70%" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 3, bezier = "easeOutExpo", style = "popin 80%" })
hl.animation({ leaf = "windowsMove", enabled = true, speed = 3, bezier = "softBounce" })
hl.animation({ leaf = "layers", enabled = true, speed = 3, bezier = "fluentDecel", style = "fade" })
hl.animation({ leaf = "fadeIn", enabled = true, speed = 3, bezier = "easeOutExpo" })
hl.animation({ leaf = "fadeOut", enabled = true, speed = 3, bezier = "easeOutExpo" })
hl.animation({ leaf = "fadeSwitch", enabled = true, speed = 3, bezier = "easeOutExpo" })
hl.animation({ leaf = "fadeShadow", enabled = true, speed = 3, bezier = "easeOutExpo" })
hl.animation({ leaf = "fadeDim", enabled = true, speed = 3, bezier = "easeOutExpo" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 4, bezier = "fluentDecel", style = "slidefade 20%" })
hl.animation({ leaf = "specialWorkspace", enabled = true, speed = 4, bezier = "softBounce", style = "slidevert" })
hl.animation({ leaf = "borderangle", enabled = true, speed = 50, bezier = "liner", style = "loop" })

hl.workspace_rule({ workspace = "1", monitor = "eDP-1", default = true })
hl.workspace_rule({ workspace = "9", monitor = "HDMI-A-1", default = true })

hl.gesture({ fingers = 3, direction = "horizontal", action = "workspace" })

hl.device({
	name = "epic-mouse-v1",
	sensitivity = -0.5,
})

local mainMod = "SUPER"
local function exec(cmd)
	return hl.dsp.exec_cmd(cmd)
end

hl.bind(mainMod .. " + SUPER_L", exec("nc -U /run/user/1000/walker/walker.sock"), { release = true })
hl.bind(mainMod .. " + T", exec(terminal))
hl.bind(mainMod .. " + slash", exec("kitty --single-instance --class quickterminal"))
hl.bind(
	mainMod .. " + ALT + slash",
	exec("kitty --single-instance --class quickopencode /home/fufu/Dev/dotfiles/hypr/.scripts/quick-opencode.sh")
)
hl.bind(mainMod .. " + E", exec(fileManager))
hl.bind(mainMod .. " + W", exec(browser))
hl.bind(mainMod .. " + SHIFT + ALT + L", exec(locker))
hl.bind(mainMod .. " + B", exec("killall -USR1 waybar"))
hl.bind(mainMod .. " + SPACE", exec("pkill " .. inputMethod .. " || " .. inputMethod))
hl.bind(mainMod .. " + Q", hl.dsp.window.close())
hl.bind(mainMod .. " + V", hl.dsp.window.float())
hl.bind(
	mainMod .. " + ALT + V",
	exec(
		[=[hyprctl dispatch focuswindow $(if [[ $(hyprctl activewindow -j | jq ."floating") == "true" ]]; then echo "tiled"; else echo "floating"; fi;)]=]
	)
)
hl.bind(mainMod .. " + CTRL + ALT + P", hl.dsp.window.pseudo())

hl.bind("SUPER + G", hl.dsp.group.toggle())
hl.bind("SUPER + Tab", hl.dsp.group.next())
hl.bind("SUPER + SHIFT + Tab", hl.dsp.group.prev())
hl.bind(mainMod .. " + SHIFT + H", hl.dsp.window.move({ into_group = "l" }))
hl.bind(mainMod .. " + SHIFT + L", hl.dsp.window.move({ into_group = "r" }))
hl.bind(mainMod .. " + SHIFT + K", hl.dsp.window.move({ into_group = "u" }))
hl.bind(mainMod .. " + SHIFT + J", hl.dsp.window.move({ into_group = "d" }))

hl.bind(mainMod .. " + H", hl.dsp.focus({ direction = "l" }))
hl.bind(mainMod .. " + L", hl.dsp.focus({ direction = "r" }))
hl.bind(mainMod .. " + K", hl.dsp.focus({ direction = "u" }))
hl.bind(mainMod .. " + J", hl.dsp.focus({ direction = "d" }))

for i = 1, 10 do
	local key = tostring(i % 10)
	hl.bind(mainMod .. " + " .. key, hl.dsp.focus({ workspace = i }))
	hl.bind(mainMod .. " + ALT + " .. key, hl.dsp.window.move({ workspace = i }))
end

hl.bind(mainMod .. " + grave", hl.dsp.focus({ workspace = "empty" }))
hl.bind(mainMod .. " + bracketright", hl.dsp.focus({ workspace = "e+1" }), { repeating = true })
hl.bind(mainMod .. " + bracketleft", hl.dsp.focus({ workspace = "e-1" }), { repeating = true })
hl.bind(mainMod .. " + ALT + grave", hl.dsp.window.move({ workspace = "empty" }))
hl.bind(mainMod .. " + ALT + bracketright", hl.dsp.window.move({ workspace = "e+1" }), { repeating = true })
hl.bind(mainMod .. " + ALT + bracketleft", hl.dsp.window.move({ workspace = "e-1" }), { repeating = true })

hl.bind(mainMod .. " + SHIFT + H", hl.dsp.window.move({ direction = "l" }))
hl.bind(mainMod .. " + SHIFT + L", hl.dsp.window.move({ direction = "r" }))
hl.bind(mainMod .. " + SHIFT + K", hl.dsp.window.move({ direction = "u" }))
hl.bind(mainMod .. " + SHIFT + J", hl.dsp.window.move({ direction = "d" }))

hl.bind(mainMod .. " + S", hl.dsp.workspace.toggle_special("magic"))
hl.bind(mainMod .. " + ALT + S", hl.dsp.window.move({ workspace = "special:magic" }))
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }))
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })
hl.bind(mainMod .. " + semicolon", hl.dsp.layout("mfact -0.1"), { repeating = true })
hl.bind(mainMod .. " + apostrophe", hl.dsp.layout("mfact +0.1"), { repeating = true })

hl.bind(mainMod .. " + D", hl.dsp.window.fullscreen({ mode = "maximized" }))
hl.bind(mainMod .. " + F", hl.dsp.window.fullscreen({ mode = "fullscreen" }))

hl.bind(
	"XF86AudioRaiseVolume",
	exec("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"),
	{ locked = true, repeating = true }
)
hl.bind("XF86AudioLowerVolume", exec("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"), { locked = true, repeating = true })
hl.bind("CTRL + ALT + Up", exec("$HOME/.config/hypr/.scripts/vol.sh 1%+"), { locked = true, repeating = true })
hl.bind("CTRL + ALT + Down", exec("$HOME/.config/hypr/.scripts/vol.sh 1%-"), { locked = true, repeating = true })
hl.bind("XF86AudioMute", exec("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"), { locked = true, repeating = true })
hl.bind("XF86AudioMicMute", exec("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessUp", exec("brightnessctl -d intel_backlight set 5%+"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", exec("brightnessctl -d intel_backlight set 5%-"), { locked = true, repeating = true })
hl.bind("XF86AudioNext", exec("playerctl next"), { locked = true })
hl.bind("XF86AudioPause", exec("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay", exec("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev", exec("playerctl previous"), { locked = true })

hl.bind(mainMod .. " + ALT + A", exec([[grim -g "$(slurp)" - | wl-copy]]))
hl.bind("ALT + Tab", exec("snappy-switcher next"))
hl.bind("ALT + SHIFT + Tab", exec("snappy-switcher prev"))
hl.bind("SUPER + ALT + P", exec("$HOME/.config/hypr/.scripts/toggle_touchpad.sh"))
hl.bind("Caps_Lock", exec([[fish -c "check_caps"]]), { non_consuming = true })

hl.window_rule({ name = "suppress-maximize-events", match = { class = ".*" }, suppress_event = "maximize" })
hl.window_rule({
	name = "fix-xwayland-drags",
	match = { class = "^$", title = "^$", xwayland = true, float = true, fullscreen = false, pin = false },
	no_focus = true,
})
hl.window_rule({
	name = "move-hyprland-run",
	match = { class = "hyprland-run" },
	move = "20 monitor_h-120",
	float = true,
})
hl.window_rule({ name = "kitty-config", match = { class = "kitty" }, opacity = "0.8", no_blur = true })
hl.window_rule({
	name = "quickterminal-config",
	match = { class = "quickterminal" },
	opacity = "0.8",
	float = true,
	center = true,
	no_blur = true,
	size = { "monitor_w*0.55", "monitor_h*0.95" },
})
hl.window_rule({
	name = "quickopencode-config",
	match = { class = "quickopencode" },
	opacity = "0.8",
	float = true,
	center = true,
	no_blur = true,
	size = { "monitor_w*0.7", "monitor_h*0.8" },
})
hl.window_rule({ name = "zathura-config", match = { class = "org.pwmt.zathura" }, opacity = "0.9" })
hl.window_rule({
	name = "virt-manager",
	match = { class = "virt-manager", title = "win11 on QEMU/KVM" },
	pseudo = false,
})
hl.window_rule({
	name = "satty",
	match = { class = "com.gabm.satty|imv" },
	float = true,
	center = true,
	size = { "monitor_w*0.8", "monitor_h*0.8" },
})
hl.window_rule({
	name = "music-players",
	match = { class = "spotify|qqmusic|rmpc" },
	workspace = "special:music-players",
})
hl.bind(mainMod .. " + P", hl.dsp.workspace.toggle_special("music-players"))
hl.window_rule({
	name = "mihomo",
	match = { class = "mihomo-party" },
	float = true,
	center = true,
	size = { "monitor_w*0.8", "monitor_h*0.8" },
})

local function float_center_size(match, width, height)
	hl.window_rule({ match = match, float = true, center = true, size = { width, height } })
end

float_center_size({ class = "nmtui" }, "monitor_w*0.8", "monitor_h*0.8")
float_center_size({ class = "bluetui" }, "monitor_w*0.8", "monitor_h*0.8")
float_center_size({ class = "nm-connection-editor" }, "monitor_w*0.8", "monitor_h*0.8")
float_center_size({ class = "xdg-desktop-portal-gtk" }, "monitor_w*0.5", "monitor_h*0.75")
float_center_size({ title = "Open File" }, "monitor_w*0.5", "monitor_h*0.75")
float_center_size({ title = "Pick a File" }, "monitor_w*0.5", "monitor_h*0.75")
hl.window_rule({
	match = { class = "Thunar|thunar", title = [[Rename\s+"[^"]*"]] },
	float = true,
	stay_focused = true,
	center = true,
	size = { "monitor_w*0.3", "monitor_h*0.4" },
})

hl.window_rule({ match = { class = "^(wechat)$" }, border_size = 0, no_blur = true, no_shadow = true })
float_center_size({ title = "Weixin" }, "monitor_w*0.7", "monitor_h*0.8")
float_center_size({ class = "wechat", title = "Photos and Videos" }, "monitor_w*0.5", "monitor_h*0.7")
float_center_size({ class = "^$", title = [[WeChat|.+\..+]] }, "monitor_w*0.5", "monitor_h*0.95")
hl.window_rule({ match = { class = "wechat", title = "Save as…" }, float = true, center = true })
hl.window_rule({ match = { class = "wechat", title = "Save" }, float = true, center = true })
hl.window_rule({ match = { class = "wechat", title = "^.*的聊天记录$" }, float = true, center = true })
hl.window_rule({ match = { class = "wechat", title = "Search chat history" }, float = true, center = true })

float_center_size({ title = "QQ" }, "monitor_w*0.7", "monitor_h*0.8")
float_center_size({ title = "图片查看器", class = "QQ" }, "monitor_w*0.5", "monitor_h*0.7")
float_center_size({ title = "群文件", class = "QQ" }, "monitor_w*0.5", "monitor_h*0.7")
hl.window_rule({ match = { title = "视频播放器", class = "QQ" }, float = true, center = true })
hl.window_rule({ match = { class = "QQ", title = "^.*的聊天记录$" }, float = true, center = true })
float_center_size({ title = "Feishu" }, "monitor_w*0.7", "monitor_h*0.8")
hl.window_rule({ match = { title = "Steam", class = "^$" }, float = true, center = true })
float_center_size({ title = "Library", class = "zen-browser" }, "monitor_w*0.5", "monitor_h*0.7")
