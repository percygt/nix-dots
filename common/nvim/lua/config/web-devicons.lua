require("nvim-web-devicons").setup({
	default = true,
	strict = true,
	override = {
		astro = { icon = "󱓞", color = "#FF4900", name = "Astro" },

		["*.astro"] = { icon = "󱓞", color = "#FF4900", name = "Astro" },

		deb = { icon = "", name = "Deb" },
		lock = { icon = "󰌾", name = "Lock" },
		mp3 = { icon = "󰎆", name = "Mp3" },
		mp4 = { icon = "", name = "Mp4" },
		out = { icon = "", name = "Out" },
		["robots.txt"] = { icon = "󰚩", name = "Robots" },
		ttf = { icon = "", name = "TrueTypeFont" },
		rpm = { icon = "", name = "Rpm" },
		woff = { icon = "", name = "WebOpenFontFormat" },
		woff2 = { icon = "", name = "WebOpenFontFormat2" },
		xz = { icon = "", name = "Xz" },
		zip = { icon = "", name = "Zip" },

		override_by_extension = {
			[".astro"] = { icon = "󱓞", color = "#FF4900", name = "Astro" },
		},
	},
})
