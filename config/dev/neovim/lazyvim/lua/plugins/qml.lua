return {
  {
    "Leon-Degel-Koehn/qmlformat.nvim",
    event = "VeryLazy",
    ft = { "qml" },
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        qmlls = {
          keys = {
            {
              "<localleader>f",
              function()
                require("qmlformat").preview_qmlformat_changes()
              end,
              desc = "Qml Format",
            },
          },
        },
      },
    },
  },
}
