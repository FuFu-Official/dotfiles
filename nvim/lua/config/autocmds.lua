-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")
--
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

local function open_screensaver(on_close)
  vim.cmd("tabnew")

  local tab = vim.api.nvim_get_current_tabpage()
  local bufs = {}
  local jobs = {}
  local closed = false

  local function setup_term_win(win)
    vim.wo[win].number = false
    vim.wo[win].relativenumber = false
    vim.wo[win].cursorline = false
    vim.wo[win].cursorcolumn = false
    vim.wo[win].signcolumn = "no"
    vim.wo[win].foldcolumn = "0"
    vim.wo[win].statusline = " "
  end

  local close_all -- forward declare

  local function open_term(cmd)
    vim.cmd("enew")
    local buf = vim.api.nvim_get_current_buf()
    vim.bo[buf].bufhidden = "wipe"
    vim.bo[buf].swapfile = false
    vim.bo[buf].buflisted = false

    local job = vim.fn.termopen(cmd)
    table.insert(bufs, buf)
    table.insert(jobs, job)

    setup_term_win(vim.api.nvim_get_current_win())
    vim.keymap.set({ "n", "t" }, "q", function()
      close_all()
    end, { buffer = buf, silent = true })
    vim.keymap.set({ "n", "t" }, "<Esc>", function()
      close_all()
    end, { buffer = buf, silent = true })
    vim.cmd("startinsert")
  end

  open_term("tty-clock -c -C 4 -B -s")

  vim.cmd("belowright split")
  vim.cmd("resize 25")

  local sink_inputs = vim.fn.system("pactl list sink-inputs short 2>/dev/null")
  if vim.trim(sink_inputs) ~= "" then
    open_term("cava")
  else
    open_term("cmatrix -b -s")
  end

  close_all = function()
    if closed then
      return
    end
    closed = true

    for _, job in ipairs(jobs) do
      pcall(vim.fn.jobstop, job)
    end

    for _, buf in ipairs(bufs) do
      if vim.api.nvim_buf_is_valid(buf) then
        pcall(vim.api.nvim_buf_delete, buf, { force = true })
      end
    end

    if vim.api.nvim_tabpage_is_valid(tab) then
      pcall(vim.cmd, "tabclose")
    end

    if on_close then
      on_close()
    end
  end
end

vim.api.nvim_create_user_command("ScreenLocker", function()
  open_screensaver()
end, {})

-- idle screensaver daemon
local IDLE_TIMEOUT = 60 -- seconds
local idle_timer = vim.uv.new_timer()
local screensaver_active = false

local function reset_idle()
  if screensaver_active then
    return
  end
  idle_timer:stop()
  idle_timer:start(
    IDLE_TIMEOUT * 1000,
    0,
    vim.schedule_wrap(function()
      if not screensaver_active then
        screensaver_active = true
        open_screensaver(function()
          screensaver_active = false
          reset_idle()
        end)
      end
    end)
  )
end

local idle_events =
  { "CursorMoved", "CursorMovedI", "TextChanged", "TextChangedI", "BufEnter", "WinEnter", "FocusGained", "InsertEnter" }
vim.api.nvim_create_autocmd(idle_events, {
  group = vim.api.nvim_create_augroup("screensaver_idle", { clear = true }),
  callback = reset_idle,
})

reset_idle()

vim.api.nvim_create_user_command("ScreenLockerEnable", function()
  reset_idle()
  vim.notify("🖥️ Screensaver daemon enabled (" .. IDLE_TIMEOUT .. "s)", vim.log.levels.INFO)
end, {})

vim.api.nvim_create_user_command("ScreenLockerDisable", function()
  idle_timer:stop()
  vim.notify("🖥️ Screensaver daemon disabled", vim.log.levels.INFO)
end, {})
