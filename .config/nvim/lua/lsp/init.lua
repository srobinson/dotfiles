local lsp_installer = require "nvim-lsp-installer"

-- Include the servers you want to have installed by default below
local servers = {
  "ansiblels",
  "bashls",
  "cssls",
  "cssmodules_ls",
  "dotls",
  "eslint",
  "graphql",
  "html",
  "pylsp",
  "pyright",
  "rust_analyzer",
  "solidity_ls",
  "sorbet",
  "sqlls",
  "sqls",
  "stylelint_lsp",
  "sumneko_lua",
  "taplo",
  "terraformls",
  "tflint",
  "tsserver",
  "vimls",
  "vuels",
  "yamlls",
}

for _, name in pairs(servers) do
  local server_is_found, server = lsp_installer.get_server(name)
  if server_is_found and not server:is_installed() then
    print("Installing " .. name)
    server:install()
  end
end

--

local function on_attach(client, bufnr)
  -- Set up buffer-local keymaps (vim.api.nvim_buf_set_keymap()), etc.
end

lsp_installer.on_server_ready(function(server)
  -- Specify the default options which we'll use to setup all servers
  local opts = {
    on_attach = on_attach,
  }

  server:setup(opts)
end)

