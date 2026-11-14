-- Framework 13 panel, right of the PG42UQ
local function laptopPanel(disabled)
	hl.monitor({
		output = "eDP-1",
		disabled = disabled,
		mode = "2880x1920@120",
		position = "auto-right",
		scale = 1.5,
		vrr = 2,
		supports_hdr = true,
		bitdepth = 10,
		supports_wide_color = true,
	})
end

-- Match the lid on (re)load, e.g. after home-manager switch with the lid shut
local function lidClosed()
	local f = io.open("/proc/acpi/button/lid/LID0/state")
	if not f then
		return false
	end
	local state = f:read("*a")
	f:close()
	return state:find("closed") ~= nil
end
laptopPanel(lidClosed())

-- Lid closed: panel off (logind decides whether to suspend)
hl.bind("switch:on:Lid Switch", function()
	laptopPanel(true)
end, { locked = true })
hl.bind("switch:off:Lid Switch", function()
	laptopPanel(false)
end, { locked = true })
