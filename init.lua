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
vim.opt.rtp:prepend(lazypath)

vim.g.mapleader = " "
vim.g.netrw_localcopydircmd = "cp -r"
-- vim.g.netrw_keepdir = 0
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

vim.filetype.add({
	extension = {
		templ = "templ",
	},
})

-- vim.api.nvim_create_autocmd("BufEnter", {
-- 	pattern = "*.templ",
-- 	callback = function()
-- 		vim.cmd("TSBufEnable highlight")
-- 	end,
-- })

require("lazy").setup({
	"folke/which-key.nvim",
	{ "folke/neoconf.nvim", cmd = "Neoconf" },
	"folke/neodev.nvim",
	"folke/zen-mode.nvim",

	{
		"rebelot/kanagawa.nvim",
		priority = 1000,
		config = function()
			require("kanagawa").setup({
				overrides = function(colors)
					local theme = colors.theme
					return {
						TelescopeSelection = { bg = theme.ui.bg_search },
					}
				end,
			})
			require("kanagawa").load("dragon")
			-- require("kanagawa").load("wave")
		end,
	},

	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			require("lualine").setup({
				options = {
					theme = "kanagawa",
				},
			})
		end,
	},

	{
		"barrett-ruth/live-server.nvim",
		build = "npm install -g live-server",
		cmd = { "LiveServerStart", "LiveServerStop" },
		config = function()
			require("live-server").setup({})
		end,
	},

	"xiyaowong/transparent.nvim",

	"lewis6991/gitsigns.nvim",

	{
		"nvim-treesitter/nvim-treesitter",
		-- dependencies = {
		-- 	"vrischmann/tree-sitter-templ",
		-- },
		build = ":TSUpdate",
		config = function()
			require("nvim-treesitter.configs").setup({
				ensure_installed = {
					"vimdoc",
					"javascript",
					"typescript",
					"c",
					"lua",
					"rust",
					"jsdoc",
					"bash",
					"templ",
				},
				sync_install = false,
				auto_install = true,
				indent = {
					enable = true,
				},
				highlight = {
					enable = true,
					additional_vim_regex_highlighting = { "markdown" },
				},
			})

			local treesitter_parser_config = require("nvim-treesitter.parsers").get_parser_configs()
			treesitter_parser_config.templ = {
				install_info = {
					url = "https://github.com/vrischmann/tree-sitter-templ.git",
					files = { "src/parser.c", "src/scanner.c" },
					branch = "master",
				},
			}

			vim.treesitter.language.register("templ", "templ")
		end,
	},
	-- "nvim-treesitter/nvim-treesitter-context",
	"tpope/vim-fugitive",
	"tpope/vim-commentary",
	"mbbill/undotree",
	{
		"ThePrimeagen/harpoon",
		branch = "harpoon2",
		dependencies = { "nvim-lua/plenary.nvim" },
	},
	"hrsh7th/cmp-nvim-lsp",
	"hrsh7th/cmp-buffer",
	"hrsh7th/cmp-path",
	"hrsh7th/cmp-cmdline",
	"hrsh7th/nvim-cmp",
	{
		"L3MON4D3/LuaSnip",
		-- follow latest release.
		version = "v2.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
		-- install jsregexp (optional!).
		build = "make install_jsregexp",
	},
	"saadparwaiz1/cmp_luasnip",
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
			-- format_on_save = function(bufnr)
			-- 	if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
			-- 		return
			-- 	end
			-- 	return { timeout_ms = 500, lsp_fallback = true }
			-- end,
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
			local lspconfig = require("lspconfig")
			local lsp_capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

			require("mason").setup({})
			require("mason-lspconfig").setup({
				ensure_installed = {
					-- "dockerls",
					-- "docker_compose_language_service",

					"lua_ls",
					"rust_analyzer",
					"prismals",
					"clangd",
					"tailwindcss",
					"sqlls",
					"pyright",
					"html",
					"eslint",
					"volar",
					"denols",

					"gopls",
					"cmake",
					"cssls",
					"tsserver",
					-- "templ",
				},
				handlers = {
					function(server)
						lspconfig[server].setup({
							capabilities = lsp_capabilities,
						})
					end,
					["lua_ls"] = function()
						lspconfig["lua_ls"].setup({
							capabilities = lsp_capabilities,
							settings = {
								Lua = {
									diagnostic = {
										globals = { "vim" },
									},
								},
							},
						})
					end,
					["html"] = function()
						lspconfig["html"].setup({
							capabilities = lsp_capabilities,
							filetypes = { "html", "templ" },
						})
					end,
					["tailwindcss"] = function()
						lspconfig["tailwindcss"].setup({
							capabilities = lsp_capabilities,
							filetypes = {
								"templ",
								"astro",
								"javascript",
								"typescript",
								"react",
								"javascriptreact",
								"typescriptreact",
							},
							init_options = { userLanguages = { templ = "html" } },
						})
					end,
					["tsserver"] = function()
						lspconfig["tsserver"].setup({
							capabilities = lsp_capabilities,
							root_dir = lspconfig.util.root_pattern("package.json"),
							single_file_support = false,
						})
					end,
					["denols"] = function()
						lspconfig["denols"].setup({
							capabilities = lsp_capabilities,
							root_dir = lspconfig.util.root_pattern("deno.json", "deno.jsonc"),
						})
					end,
					["pyright"] = function()
						lspconfig["pyright"].setup({
							capabilities = lsp_capabilities,
							filetypes = { "python" },
						})
					end,
				},
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

vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("MikalsqweLspAttachGroup", {}),
	callback = function(e)
		local opts = { buffer = e.buf }
		vim.keymap.set("n", "<leader>dn", vim.diagnostic.goto_next, opts)
		vim.keymap.set("n", "<leader>dp", vim.diagnostic.goto_prev, opts)
		vim.keymap.set("n", "<leader>dd", vim.diagnostic.open_float, opts)
		vim.keymap.set({ "n", "i" }, "<C-s>", vim.lsp.buf.signature_help, opts)
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

local harpoon = require("harpoon")

-- REQUIRED
harpoon:setup()
-- REQUIRED

vim.keymap.set("n", "<leader>a", function()
	harpoon:list():add()
end)
vim.keymap.set("n", "<C-e>", function()
	harpoon.ui:toggle_quick_menu(harpoon:list())
end)

vim.keymap.set("n", "<C-j>", function()
	harpoon:list():select(1)
end)
vim.keymap.set("n", "<C-k>", function()
	harpoon:list():select(2)
end)
vim.keymap.set("n", "<C-l>", function()
	harpoon:list():select(3)
end)
vim.keymap.set("n", "<C-h>", function()
	harpoon:list():select(4)
end)

-- Toggle previous & next buffers stored within Harpoon list
vim.keymap.set("n", "<C-S-P>", function()
	harpoon:list():prev()
end)
vim.keymap.set("n", "<C-S-N>", function()
	harpoon:list():next()
end)
