return {
  {
    "towolf/vim-helm",
    ft = { "helm" },
  },

  {
    "cappyzawa/trim.nvim",
    event = "VeryLazy",
    opts = {},
  },

  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        terraform = { "terraform_fmt" },
        yaml = { "prettier" },
        sh = { "shfmt" },
      },
    },
  },
}
