return {
	"snacks.nvim",
	opts = {
		dashboard = {
			formats = {
				key = function(item)
					return { { "[", hl = "special" }, { item.key, hl = "key" }, { "]", hl = "special" } }
				end,
			},
			-- dashboard configuration
			sections = {
				{
					section = "terminal",
					cmd = "~/dev/img2ascii_c/build/img2ascii --braille --height=130 --width=100 /home/ibarahime/dev/art_daemon/album_art/current.jpg",
					height = 25,
					padding = 1,
					ttl = 0,
					random = 100,
				},
				{ pane = 2, icon = " ", title = "recent", section = "recent_files", indent = 2, padding = 1 },
				{ pane = 2, icon = " ", title = "projs", section = "projects", indent = 2, padding = 1 },
				{
					pane = 2,
					icon = " ",
					title = "git",
					section = "terminal",
					enabled = function()
						return Snacks.git.get_root() ~= nil
					end,
					cmd = "git status --short --branch --renames",
					height = 5,
					padding = 1,
					ttl = 5 * 60,
					indent = 3,
				},
				{
					icon = " ",
					title = "keymap",
					section = "keys",
					indent = 2,
					padding = 1,
					pane = 2,
					enabled = function()
						return Snacks.git.get_root() == nil
					end,
				},
				function()
					local artist = ""
					local title = ""

					local f = io.open("/home/ibarahime/dev/art_daemon/output.txt", "r")
					if f then
						local contents = f:read("*a")
						f:close()

						local lines = {}
						for line in contents:gmatch("[^\r\n]+") do
							table.insert(lines, line)
						end

						artist = lines[1] or ""
						title = lines[2] or ""
					end

					return {
						pane = 2,
						align = "center",
						text = {
							{ artist .. " - ", hl = "special" },
							{ title, hl = "footer" },
						},
						ttl = 0,
					}
				end,
			},
		},
	},
}
