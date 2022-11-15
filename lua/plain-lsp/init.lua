-- init.lua

local autocmd = {}

local on_attach = function(client, config, handler)
    local buffer = vim.api.nvim_get_current_buf()

    handler(buffer)

    vim.lsp.buf_attach_client(buffer, client.id)
end

local on_init = function(client, config, handler)
    local description = string.format("Attach LSP: %s", client.name)
    local callback = function()
        on_attach(client, config, handler)
    end

    local command = {
        callback  = callback,
        desc      = description,
        pattern   = config.filetypes,
    }

    if vim.v.vim_did_enter == 1 then
        local supported = vim.tbl_contains(config.filetypes, vim.bo.filetype)

        if supported then
            callback()
        end
    end

    autocmd[client.id] = vim.api.nvim_create_autocmd("FileType", command)
end

local on_exit = function(code, signal, clientid)
    vim.api.nvim_del_autocmd(autocmd[clientid])
end

local M = {}

M.execute = function(name, handler)
    local path = string.format("plain-lsp.config.%s", name)
    local config = require(path)

    if not config then
        return
    end

    config.parameters.on_exit = vim.schedule_wrap(on_exit)
    config.parameters.on_init = function(client, _)
        on_init(client, config, handler)
    end

    vim.lsp.start_client(config.parameters)
end

return M
