local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable",
		lazypath,
	})
end

vim.g.mapleader = " "
vim.g.netrw_localcopydircmd = "cp -r" -- this solves the problem on my setup
-- vim.g.netrw_keepdir = 0 -- https://stackoverflow.com/questions/31811335/copying-files-with-vims-netrw-on-mac-os-x-is-broken
vim.opt.guicursor = "a:block"
vim.opt.nu = true
vim.opt.relativenumber = true
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.wrap = false
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.nvim/undodir"
vim.opt.undofile = true
vim.opt.hlsearch = true
vim.opt.incsearch = true
vim.opt.termguicolors = true
vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.isfname:append("@-@")
vim.opt.updatetime = 50
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.inccommand = "split"

vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "q", "")
vim.keymap.set("x", "p", "P")
vim.keymap.set({ "n", "v" }, "<leader>d", '"_d')
vim.opt.clipboard:prepend({ "unnamed", "unnamedplus" })

vim.opt.rtp:prepend(lazypath)
require("lazy").setup({
	"folke/which-key.nvim",
	{ "folke/neoconf.nvim", cmd = "Neoconf" },
	"folke/neodev.nvim",

	{
		"rose-pine/neovim",
		name = "rose-pine",
		priority = 1000,
		config = function()
			vim.cmd("colorscheme rose-pine")
		end,
	},

	"xiyaowong/transparent.nvim",

	"smithbm2316/centerpad.nvim", -- pane centering

	"lewis6991/gitsigns.nvim",
	"nvim-treesitter/nvim-treesitter",
	"nvim-treesitter/nvim-treesitter-context",
	"tpope/vim-fugitive",
	"tpope/vim-commentary",
	"mbbill/undotree",
	"ThePrimeagen/harpoon",
	"hrsh7th/cmp-nvim-lsp",
	"hrsh7th/cmp-buffer",
	"hrsh7th/cmp-path",
	"hrsh7th/cmp-cmdline",
	"hrsh7th/nvim-cmp",
	"L3MON4D3/LuaSnip",
	"saadparwaiz1/cmp_luasnip",
	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			require("lualine").setup()
		end,
	},
	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		init = function()
			vim.o.timeout = true
			vim.o.timeoutlen = 300
		end,
		opts = {},
	},
	{
		"stevearc/conform.nvim",
		event = { "BufWritePre" },
		cmd = { "ConformInfo" },
		keys = {
			{
				"<leader>fm",
				function()
					require("conform").format({ async = true, lsp_fallback = true })
				end,
				mode = "",
				desc = "Format buffer",
			},
		},
		opts = {
			formatters_by_ft = {
				lua = { "stylua" },
				c = { "clang-format" },
				go = { "goimports", "gofumpt" },
				python = { "isort", "black" },
				javascript = { { "prettierd", "prettier" } },
				javascriptreact = { { "prettierd", "prettier" } },
				typescript = { { "prettierd", "prettier" } },
				typescriptreact = { { "prettierd", "prettier" } },
				html = { { "prettierd", "prettier" } },
				css = { { "prettierd", "prettier" } },
				markdown = { { "prettierd", "prettier" } },
				json = { { "prettierd", "prettier" } },
				yaml = { { "prettierd", "prettier" } },
			},
			format_on_save = function(bufnr)
				if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
					return
				end
				return { timeout_ms = 500, lsp_fallback = true }
			end,
			formatters = {
				shfmt = {
					prepend_args = { "-i", "2" },
				},
			},
		},
		init = function()
			vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
		end,
	},
	{
		"nvim-telescope/telescope.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
	},
	{
		"folke/trouble.nvim",
		config = function()
			require("trouble").setup({
				icons = false,
			})
		end,
	},
	{
		"williamboman/mason-lspconfig.nvim",
		dependencies = {
			"williamboman/mason.nvim",
			"neovim/nvim-lspconfig",
			"j-hui/fidget.nvim",
			"simrat39/rust-tools.nvim",
		},
		config = function()
			require("mason").setup({})
			require("mason-lspconfig").setup({
				ensure_installed = {
					"lua_ls",
					"rust_analyzer",
					"tsserver",
					"prismals",
					"clangd",
					"cssls",
					"tailwindcss",
					"sqlls",
					"pylsp",
					"html",
					"eslint",
					"volar",
				},
			})
			require("mason-lspconfig").setup_handlers({
				function(server_name)
					require("lspconfig")[server_name].setup({})
				end,
				["rust_analyzer"] = function()
					require("rust-tools").setup({})
				end,
				["lua_ls"] = function()
					require("lspconfig").lua_ls.setup({
						settings = {
							Lua = {
								diagnostic = {
									globals = { "vim" },
								},
							},
						},
					})
				end,
				["tsserver"] = function()
					require("lspconfig").tsserver.setup({})
				end,
				["clangd"] = function()
					require("lspconfig").clangd.setup({})
				end,
				["eslint"] = function()
					require("lspconfig").eslint.setup({})
				end,
				["cssls"] = function()
					require("lspconfig").cssls.setup({})
				end,
				["html"] = function()
					require("lspconfig").html.setup({})
				end,
				["gopls"] = function()
					require("lspconfig").gopls.setup({})
				end,
				["prismals"] = function()
					require("lspconfig").prismals.setup({})
				end,
				["pylsp"] = function()
					require("lspconfig").pylsp.setup({})
				end,
				["tailwindcss"] = function()
					require("lspconfig").tailwindcss.setup({})
				end,
				["sqlls"] = function()
					require("lspconfig").sqlls.setup({})
				end,
				["volar"] = function()
					require("lspconfig").volar.setup({})
				end,
			})
			require("fidget").setup({})
		end,
	},
})

vim.keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle)

require("gitsigns").setup({
	signs = {
		add = { text = "│" },
		change = { text = "│" },
	},
})

local mark = require("harpoon.mark")
local ui = require("harpoon.ui")
vim.keymap.set("n", "<leader>a", mark.add_file)
vim.keymap.set("n", "<C-e>", ui.toggle_quick_menu)
vim.keymap.set("n", "<C-j>", function()
	ui.nav_file(1)
end)
vim.keymap.set("n", "<C-k>", function()
	ui.nav_file(2)
end)
vim.keymap.set("n", "<C-l>", function()
	ui.nav_file(3)
end)
vim.keymap.set("n", "<C-h>", function()
	ui.nav_file(4)
end)

vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("MikalsqweLspAttachGroup", {}),
	callback = function(e)
		local opts = { buffer = e.buf }
		vim.keymap.set("n", "<leader>dn", vim.diagnostic.goto_next, opts)
		vim.keymap.set("n", "<leader>dp", vim.diagnostic.goto_prev, opts)
		vim.keymap.set("n", "<leader>dd", vim.diagnostic.open_float, opts)
		vim.keymap.set("n", "<C-s>", vim.lsp.buf.signature_help, opts)
		vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
		vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)

		vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
		vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
		vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
		vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
		vim.keymap.set("n", "<space>wa", vim.lsp.buf.add_workspace_folder, opts)
		vim.keymap.set("n", "<space>wr", vim.lsp.buf.remove_workspace_folder, opts)
		vim.keymap.set("n", "<space>wl", function()
			print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
		end, opts)
		vim.keymap.set("n", "<space>D", vim.lsp.buf.type_definition, opts)
		vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
	end,
})

local cmp = require("cmp")
cmp.setup({
	snippet = {
		expand = function(args)
			require("luasnip").lsp_expand(args.body)
		end,
	},
	window = {
		completion = cmp.config.window.bordered(),
		documentation = cmp.config.window.bordered(),
	},
	mapping = cmp.mapping.preset.insert({
		["<C-p>"] = cmp.mapping.select_prev_item(),
		["<C-n>"] = cmp.mapping.select_next_item(),
		["<C-d>"] = cmp.mapping.scroll_docs(-4),
		["<C-u>"] = cmp.mapping.scroll_docs(4),
		["<C-space>"] = cmp.mapping.complete(),
		["<C-e>"] = cmp.mapping.abort(),
		["<Tab>"] = cmp.mapping.confirm({ select = true }),
	}),
	sources = cmp.config.sources({
		{ name = "nvim_lsp" },
		{ name = "luasnip" },
		{ name = "path" },
		{ name = "buffer", keyword_length = 5 },
	}, {
		{ name = "buffer" },
	}),
	vim.diagnostic.config({
		virtual_text = true,
	}),
})

local builtin = require("telescope.builtin")
vim.keymap.set("n", "<C-p>", builtin.find_files, {})
vim.keymap.set("n", "<C-f>", builtin.live_grep, {})
vim.keymap.set("n", "<leader>fb", builtin.buffers, {})
vim.keymap.set("n", "<leader>fh", builtin.help_tags, {})

require("nvim-treesitter.configs").setup({
	ensure_installed = {
		"vimdoc",
		"javascript",
		"typescript",
		"c",
		"lua",
		"rust",
		"go",
	},
	sync_install = false,
	auto_install = true,
	highlight = {
		enable = true,
		additional_vim_regex_highlighting = false,
	},
})

vim.keymap.set("n", "<leader>gs", vim.cmd.Git)
local Mikalsqwe_Fugitive = vim.api.nvim_create_augroup("Mikalsqwe_Fugitive", {})
local autocmd = vim.api.nvim_create_autocmd
autocmd("BufWinEnter", {
	group = Mikalsqwe_Fugitive,
	pattern = "*",
	callback = function()
		if vim.bo.ft ~= "fugitive" then
			return
		end
		local bufnr = vim.api.nvim_get_current_buf()
		local opts = { buffer = bufnr, remap = false }
		vim.keymap.set("n", "<leader>p", function()
			vim.cmd.Git("push")
		end, opts)
		vim.keymap.set("n", "<leader>P", function()
			vim.cmd.Git({ "pull", "--rebase" })
		end, opts)
		vim.keymap.set("n", "<leader>t", ":Git push -u origin ", opts)
	end,
})
vim.keymap.set("n", "gh", "<cmd>diffget //2<CR>") -- left diff
vim.keymap.set("n", "gl", "<cmd>diffget //3<CR>") -- right diff

require("transparent").setup({ -- Optional, you don't have to run setup.
	groups = { -- table: default groups
		"Normal",
		"NormalNC",
		"Comment",
		"Constant",
		"Special",
		"Identifier",
		"Statement",
		"PreProc",
		"Type",
		"Underlined",
		"Todo",
		"String",
		"Function",
		"Conditional",
		"Repeat",
		"Operator",
		"Structure",
		"LineNr",
		"NonText",
		"SignColumn",
		"CursorLine",
		"CursorLineNr",
		"StatusLine",
		"StatusLineNC",
		"EndOfBuffer",
	},
	extra_groups = {}, -- table: additional groups that should be cleared
	exclude_groups = {}, -- table: groups you don't want to clear
})
