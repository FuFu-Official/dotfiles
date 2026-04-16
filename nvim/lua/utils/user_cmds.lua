vim.api.nvim_create_user_command("VimChroot", function(opts)
  local path = opts.args

  if path == "" then
    path = vim.fn.expand("%:p:h")
  end

  if vim.fn.isdirectory(path) == 1 then
    vim.api.nvim_set_current_dir(path)
    vim.g.root_spec = { "cwd" }

    vim.notify("🚀 Root switch to: " .. path, vim.log.levels.INFO)
  else
    vim.notify("❌ ERROR: Not a valid directory -> " .. path, vim.log.levels.ERROR)
  end
end, {
  nargs = "?",
  complete = "dir",
  desc = "chroot to a specified path",
})
