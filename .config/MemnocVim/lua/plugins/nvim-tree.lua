return {
  'nvim-tree/nvim-tree.lua',
  version = '*',
  keys = {
    { "<leader>ft", "<cmd>NvimTreeOpen<cr>",  desc = "Nvim Tree Open" },
    { "<leader>fc", "<cmd>NvimTreeClose<cr>", desc = "Nvim Tree Close" },
  },
  dependencies = {
    'nvim-tree/nvim-web-devicons',
  },
  config = function()
    require('nvim-tree').setup {}
  end,
}
