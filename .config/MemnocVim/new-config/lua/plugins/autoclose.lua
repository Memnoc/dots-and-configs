return {
   {
      "m4xshen/autoclose.nvim",
      opts = {
         keys = {
            ["<CR>"] = nil
         },
         options = {
            disabled_filetypes = { "text", "markdown" },
            disable_when_touch = true,
         },
      },
   },
   "windwp/nvim-ts-autotag",
}
