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
require('gitsigns').setup()

vim.lsp.config['rust-analyzer'] = {
  cmd = { "rust-analyzer" },
  filetypes = { "rust" },
  settings = {
    ["rust-analyzer"] = {
      check = {
        command = "clippy"
      }
    }
  }
}

vim.lsp.config['luals'] = {
  cmd = { "lua-language-server" },
  root_markers = { ".luarc.json" },
  filetypes = { "lua" },
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
}

vim.lsp.config["nil_ls"] = {}
vim.lsp.config["tinymist"] = {}
vim.lsp.config["svelte"] = {}
vim.lsp.config["pyright"] = {
  cmd = { "pyright-langserver", "--stdio" },
  filetypes = { "python" },
  settings = {
    python = {
      analysis = {
        autoSearchPaths = true,
        diagnosticMode = "openFilesOnly",
        useLibraryCodeForTypes = true
      }
    }
  }
}
vim.lsp.config["ts_ls"] = {}
vim.lsp.config["jdtls"] = {}
vim.lsp.config["marksman"] = {}
vim.lsp.config["zls"] = {}
vim.lsp.config["gopls"] = {
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
}

vim.lsp.enable({'luals', 'rust-analyzer', 'zls', 'pyright', 'gopls'})

vim.api.nvim_create_autocmd("LspAttach", {
  callback = function (ev)
    local client = vim.lsp.get_client_by_id(ev.data.client_id)

    vim.cmd([[set completeopt+=menuone,noselect,popup]])

    vim.keymap.set('i', '<c-space>', function()
      vim.lsp.completion.get()
    end)

    if client:supports_method('textDocument/completion') then
      vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = true })
    end
  end
})

vim.keymap.set("n", "<leader>bf", function()
  require('conform').format({ async = true, lsp_format = "fallback" })
end)

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
