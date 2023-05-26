local opts = { noremap=true, silent=true }
vim.keymap.set("n", "<Leader>e", vim.diagnostic.open_float, opts)
vim.keymap.set("n", "<Leader>a", vim.lsp.buf.code_action, opts)

vim.keymap.set('n', '<space>d', vim.diagnostic.open_float)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next)

local function on_attach()
   vim.keymap.set("n", "K", vim.lsp.buf.hover, { buffer = 0 })
   vim.keymap.set("n", "gd", vim.lsp.buf.definition, { buffer = 0 })
   vim.keymap.set("n", "<Leader>rn", vim.lsp.buf.rename, { buffer = 0 })
   vim.keymap.set("n", "gs", "<cmd>lua vim.lsp.buf.signature_help()<cr>", { buffer = 0 })
end

local languages = { "clangd", "tsserver", "html", "cssls", "pyright", "texlab" }

return {
   {
      "neovim/nvim-lspconfig",
      dependencies = { "hrsh7th/cmp-nvim-lsp" },
      config = function()
         local capabilities = require('cmp_nvim_lsp').default_capabilities()
         require("lspconfig").lua_ls.setup({
            on_attach = on_attach,
            capabilities = capabilities,
            settings = {
               Lua = {
                  diagnostics = {
                     globals = {"vim"},
                  },
               },
            },
         })

         require("lspconfig").tailwindcss.setup({
            on_attach = function()
               require("tailwindcss-colors").buf_attach(0)
            end
         })

         for _, language in pairs(languages) do
            require("lspconfig")[language].setup({
               on_attach = on_attach,
               capabilities = capabilities,
            })
         end

         vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
            vim.lsp.diagnostic.on_publish_diagnostics, {
               virtual_text = false
            }
         )
      end
   },
   {
      "williamboman/mason.nvim",
      opts = {}
   },
   {
      "williamboman/mason-lspconfig.nvim",
      opts = {
         ensure_installed = { "lua_ls", "clangd", "tsserver", "html", "cssls",
            "tailwindcss", "pyright", }
      }
   }
}
