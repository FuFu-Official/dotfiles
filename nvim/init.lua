-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")
require("utils.init")
require("matugen.init")

vim.cmd([[packadd nvim.undotree]])
