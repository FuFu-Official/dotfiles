return {
  "neovim/nvim-lspconfig",
  config = function()
    local servers = { "pyright", "clangd", "lua_ls", "fish_lsp", "cmake", "hyprls" }

    for _, lsp in ipairs(servers) do
      vim.lsp.enable(lsp)
    end

    vim.lsp.config("lua_ls", {
      on_init = function(client)
        if client.workspace_folders then
          local path = client.workspace_folders[1].name
          if
            path ~= vim.fn.stdpath("config")
            and (vim.uv.fs_stat(path .. "/.luarc.json") or vim.uv.fs_stat(path .. "/.luarc.jsonc"))
          then
            return
          end
        end

        client.config.settings.Lua = vim.tbl_deep_extend("force", client.config.settings.Lua, {
          runtime = {
            -- Tell the language server which version of Lua you're using (most
            version = "LuaJIT",
            -- Tell the language server how to find Lua modules same way as Neovim
            path = {
              "lua/?.lua",
              "lua/?/init.lua",
            },
          },
          -- Make the server aware of Neovim runtime files
          workspace = {
            checkThirdParty = false,
            library = {
              vim.env.VIMRUNTIME,
            },
          },
        })
      end,
      settings = {
        Lua = {},
      },
    })

    -- vim.lsp.config("clangd", {
    --   cmd = {
    --     "clangd",
    --     "--path-mappings=/home/radar/workspace/rm.cv.radar2026=/home/fufu/workspace/rm.cv.radar2026",
    --   },
    -- })
  end,
}
