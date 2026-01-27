return {
	"vyfor/cord.nvim",
	build = ":Cord update",
	config = function()
		require("cord").setup({
			enabled = true,
			debug = false,
			log_level = vim.log.levels.OFF,
			display = {
				theme = "catppuccin",
				flavor = "dark",
			},
			variables = true,
			text = {
				editing = "banging rocks with ${filename}",
				file_browser = "save me pls ${tooltip}",
			},
			buttons = {
				{
					label = function(opts)
						if opts.repo_url and opts.repo_url:match("^https://github.com/") then
							return "repo"
						end
						return "guthib profile"
					end,
					url = function(opts)
						if opts.repo_url and opts.repo_url:match("^https://github.com/") then
							return opts.repo_url
						end
						return "https://github.com/hrtowii"
					end,
				},
				--{
				--    label = "Countdown to leave Windows 10",
				--    url = "https://monaie.ca/windows10-eos",
				--},
			},
			hooks = {
				workspace_change = function(opts)
					opts.manager:queue_update(true)
				end,
			},
		})
	end,
}
