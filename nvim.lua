vim.g.mapleader = " "

vim.opt.cmdheight = 0
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.wrap = false

vim.opt.splitright = true
vim.opt.splitbelow = true

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.hlsearch = true -- highlight all matches
vim.opt.cursorline = true

vim.opt.smartcase = true
vim.opt.scrolloff = 8

vim.g.zig_fmt_parse_errors = 0

vim.bo.softtabstop = 4

vim.opt.termguicolors = true
vim.opt.background = "light"
vim.cmd("colorscheme modus")

vim.cmd("autocmd FileType go setlocal noexpandtab tabstop=4 shiftwidth=4")

require('lint').linters_by_ft = ({
  markdown = {'vale'},
  python = {'flake8'},
  rust = {'clippy'},
  sh = {'shellcheck'},
})

vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost", "InsertLeave" }, {
  callback = function()
    require("lint").try_lint()
  end,
})

local prettier_cfg = {"prettierd", "prettier", stop_after_first = true}

require("conform").setup({
  formatters_by_ft = {
    lua = {"stylua"},
    python = {"isort", "black"},
    rust = {"rustfmt", lsp_format = "fallback"},
    go = {"gofmt"},
    javascript = prettier_cfg,
    typescript = prettier_cfg,
    javascriptreact = prettier_cfg,
    typescriptreact = prettier_cfg,
    svelte = prettier_cfg,
    css = prettier_cfg,
    html = prettier_cfg,
    json = prettier_cfg,
    yaml = prettier_cfg,
    markdown = prettier_cfg,
    graphql = prettier_cfg,
  },
})

require("ibl").setup()
require("mini.ai").setup()
require("mini.pairs").setup()
require("mini.trailspace").setup()
require("mini.statusline").setup()
-- require("supermaven-nvim").setup({
--   log_level = "off",
-- })
require('gitsigns').setup()

local lspconfig = require("lspconfig")
local default_capabilities = require("cmp_nvim_lsp").default_capabilities()

lspconfig["elixirls"].setup({
  capabilities = default_capabilities,
  cmd = { "elixir-ls" }
})
lspconfig["nil_ls"].setup({ capabilities = default_capabilities })
lspconfig["svelte"].setup({ capabilities = default_capabilities })
lspconfig["pyright"].setup({ capabilities = default_capabilities })
lspconfig["ts_ls"].setup({ capabilities = default_capabilities })
lspconfig["jdtls"].setup({ capabilities = default_capabilities })
lspconfig["marksman"].setup({ capabilities = default_capabilities })
lspconfig["zls"].setup({ capabilities = default_capabilities })
lspconfig["rust_analyzer"].setup({
  capabilities = default_capabilities,
  settings = {
    ["rust-analyzer"] = {
      check = {
        command = "clippy"
      }
    }
  }
})

lspconfig["lua_ls"].setup({
  capabilities = default_capabilities,
  settings = {
    Lua = {
      workspace = {
        checkThirdParty = false,
        library = { vim.env.VIMRUNTIME }
      },
      completion = {
        callSnippet = "Replace",
      },
      diagnostics = {
        globals = { "vim" }
      }
    },
  },
})

lspconfig["gopls"].setup({
  capabilities = default_capabilities,
  settings = {
    gopls = {
      gofumpt = true,
      codelenses = {
        gc_details = false,
        generate = true,
        regenerate_cgo = true,
        run_govulncheck = true,
        test = true,
        tidy = true,
        upgrade_dependency = true,
        vendor = true,
      },
      hints = {
        assignVariableTypes = true,
        compositeLiteralFields = true,
        compositeLiteralTypes = true,
        constantValues = true,
        functionTypeParameters = true,
        parameterNames = true,
        rangeVariableTypes = true,
      },
      analyses = {
        nilness = true,
        unusedparams = true,
        unusedwrite = true,
        useany = true,
      },
      usePlaceholders = true,
      completeUnimported = true,
      staticcheck = true,
      directoryFilters = { "-.git", "-.vscode", "-.idea", "-.vscode-test", "-node_modules" },
      semanticTokens = true,
    },
  }
})

vim.keymap.set("n", "<space>e", vim.diagnostic.open_float)
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev)
vim.keymap.set("n", "]d", vim.diagnostic.goto_next)
vim.keymap.set("n", "<space>q", vim.diagnostic.setloclist)

vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("UserLspConfig", {}),
  callback = function(ev)
    -- Enable completion triggered by <c-x><c-o>
    vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"

    -- Buffer local mappings.
    -- See `:help vim.lsp.*` for documentation on any of the below functions
    local opts = { buffer = ev.buf }
    vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
    vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
    vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
    vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, opts)
    vim.keymap.set("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, opts)
    vim.keymap.set("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, opts)
    vim.keymap.set("n", "<leader>wl", function()
      print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, opts)
    vim.keymap.set("n", "<leader>D", vim.lsp.buf.type_definition, opts)
    vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
    vim.keymap.set({ "n", "v" }, "<space>ca", vim.lsp.buf.code_action, opts)
    vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
    vim.keymap.set("n", "<leader>bf", function()
      -- vim.lsp.buf.format { async = true }
      require('conform').format({ async = true, lsp_format = "fallback" })
    end, opts)
  end,
})

local cmp = require("cmp")
cmp.setup({
  snippet = {
    expand = function(args)
      require("luasnip").lsp_expand(args.body)
    end,
  },
  completion = {
    completeopt = "menu,menuone,noinsert",
  },
  mapping = cmp.mapping.preset.insert({
    ["<C-b>"] = cmp.mapping.scroll_docs(-4),
    ["<C-f>"] = cmp.mapping.scroll_docs(4),
    ["<C-Space>"] = cmp.mapping.complete(),
    ["<C-e>"] = cmp.mapping.abort(),
    -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
    ["<CR>"] = cmp.mapping.confirm({ select = true }),
  }),
  sources = cmp.config.sources({
    { name = "nvim_lsp" },
    { name = "luasnip" },
    { name = "buffer" },
  }, {})
})

require("nvim-treesitter.configs").setup({
  sync_install = false,
  highlight = { enable = true },
  indent = { enable = true },
})

require('treesitter-context').setup({
  max_lines = 10,
})

local builtin = require("telescope.builtin")
vim.keymap.set("n", "<leader><leader>", builtin.find_files, {})
vim.keymap.set("n", "<leader>g", builtin.live_grep, {})

vim.keymap.set("t", "<esc><esc>", "<c-\\><c-n>", { desc = "exit terminal!!!" })

vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "move down half a page, then center" })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "move up half a page, then center" })
vim.keymap.set("n", "<leader>fb", builtin.buffers, {})
