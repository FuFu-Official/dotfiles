local cn_mode_augroup_name = "fcitx5_cn_writing"
local always_english_augroup_name = "fcitx5_always_english"

local function run(cmd)
  vim.fn.system(cmd)
end

local function ensure_fcitx5_running()
  run("fcitx5-remote --check >/dev/null 2>&1")
  if vim.v.shell_error == 0 then
    run("bash -lc 'fcitx5 -r >/dev/null 2>&1 & disown'")
  end
end

local function to_english()
  run("fcitx5-remote -c")
end

local function to_chinese()
  run("fcitx5-remote -o")
end

local function setup_always_english_guard()
  local group = vim.api.nvim_create_augroup(always_english_augroup_name, { clear = true })
  vim.api.nvim_create_autocmd({ "InsertLeave", "CmdlineEnter", "FocusLost", "VimLeavePre" }, {
    group = group,
    callback = to_english,
  })
end

local function enable_cn_writing_mode()
  ensure_fcitx5_running()

  local group = vim.api.nvim_create_augroup(cn_mode_augroup_name, { clear = true })
  vim.api.nvim_create_autocmd("InsertEnter", {
    group = group,
    callback = to_chinese,
  })
  vim.api.nvim_create_autocmd({ "InsertLeave", "CmdlineEnter", "FocusLost" }, {
    group = group,
    callback = to_english,
  })

  to_english()
  vim.notify("Fcitx5 Chinese writing mode enabled", vim.log.levels.INFO)
end

local function disable_cn_writing_mode()
  pcall(vim.api.nvim_del_augroup_by_name, cn_mode_augroup_name)
  to_english()
  vim.notify("Fcitx5 Chinese writing mode disabled", vim.log.levels.INFO)
end

local function toggle_cn_writing_mode()
  if vim.fn.exists("#" .. cn_mode_augroup_name) == 1 then
    disable_cn_writing_mode()
    return
  end
  enable_cn_writing_mode()
end

setup_always_english_guard()

vim.api.nvim_create_user_command("Fcitx5CnModeEnable", enable_cn_writing_mode, {
  desc = "Enable Chinese writing mode with fcitx5",
})

vim.api.nvim_create_user_command("Fcitx5CnModeDisable", disable_cn_writing_mode, {
  desc = "Disable Chinese writing mode with fcitx5",
})

vim.api.nvim_create_user_command("Fcitx5CnModeToggle", toggle_cn_writing_mode, {
  desc = "Toggle Chinese writing mode with fcitx5",
})
