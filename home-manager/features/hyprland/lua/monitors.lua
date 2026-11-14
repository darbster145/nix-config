-- Asus PG42UQ, matched by description so it works on any port/host.
hl.monitor({
	output = "desc:ASUSTek COMPUTER INC PG42UQ",
	mode = "3840x2160@138",
	position = "0x0",
	scale = 1,
	vrr = 2,
	supports_hdr = true,
	bitdepth = 10,
	supports_wide_color = true,
})

-- Fallback for anything else that gets plugged in.
hl.monitor({
	output = "",
	mode = "preferred",
	position = "auto",
	scale = "auto",
})
