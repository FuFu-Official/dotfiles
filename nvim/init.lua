-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")

local function source_matugen()
  -- Update this with the location of your output file
  local matugen_path = os.getenv("HOME") .. "/.config/nvim/matugen.lua" -- dofile doesn't expand $HOME or ~

  local file, err = io.open(matugen_path, "r")
  -- If the matugen file does not exist (yet or at all), we must initialize a color scheme ourselves
  if err ~= nil then
    -- Some placeholder theme, this will be overwritten once matugen kicks in
    vim.cmd("colorscheme base16-catppuccin-mocha")

    -- Optionally print something to the user
    -- vim.print(
    --   "A matugen style file was not found, but that's okay! The colorscheme will dynamically change if matugen runs!"
    -- )
  else
    dofile(matugen_path)
    io.close(file)
  end
end

source_matugen()

-- Main entrypoint on matugen reloads
local function auxiliary_function()
  -- Load the matugen style file to get all the new colors
  source_matugen()

  -- Because reloading base16 overwrites lualine configuration, just source lualine here
  require("lualine").refresh()

  -- Refresh transparent.nvim
  vim.cmd("TransparentEnable")

  -- Any other options you wish to set upon matugen reloads can also go here!
  -- vim.api.nvim_set_hl(0, "Comment", { italic = true })
end

vim.api.nvim_create_autocmd("Signal", {
  pattern = "SIGUSR1",
  callback = auxiliary_function,
})
