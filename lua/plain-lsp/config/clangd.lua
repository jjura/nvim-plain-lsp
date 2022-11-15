-- clangd.lua

local filetypes = { "c", "cpp" }

local parameters = {
    cmd          = { "clangd" },
    name         = "clangd",
    root_dir     = vim.fn.getcwd(),
    capabilities = vim.lsp.protocol.make_client_capabilities(),
}

local config   = {
    filetypes  = filetypes,
    parameters = parameters,
}

return config
