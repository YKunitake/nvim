local ts = require('nvim-treesitter')

local ENSURE_INSTALLED = { "c", "lua", "vim", "vimdoc", "query", "markdown", "markdown_inline" }
local IGNORE_INSTALL = { javascript = true}
local MAX_FILESIZE = 100 * 1024

ts.install(ENSURE_INSTALLED)

local available_langs
local function is_available(lang)
    available_langs = available_langs or ts.get_available()
    return vim.list_contains(available_langs, lang)
end

local function is_large_file(buf)
    local ok, stats = pcall(vim.uv.fs_stat, vim.api.nvim_buf_get_name(buf))
    return ok and stats ~= nil and stats.size > MAX_FILESIZE
end

local function start_highlight(buf, lang)
    if not vim.api.nvim_buf_is_valid(buf) or is_large_file(buf) then
        return
    end
    pcall(vim.treesitter.start, buf, lang)
end

vim.api.nvim_create_autocmd('FileType', {
    group = vim.api.nvim_create_augroup('user_treesitter', { clear = true }),
    callback = function(args)
        local buf = args.buf
	local lang = vim.treesitter.language.get_lang(args.match)
	if not lang or IGNORE_INSTALL[lang] then
	    return
	end

	if vim.list_contains(ts.get_installed('parsers'), lang) then
	    start_highlight(buf, lang)
	elseif is_available(lang) then
	    ts.install({ lang }):await(function(err)
	        if err then
		    return
		end
		vim.schedule(function() start_highlight(buf, lang) end)
	    end)
	end
    end,
})

local function open_nvim_tree()
    require("nvim-tree.api").tree.open()
end

--vim.api.nvim_create_autocmd({ "VimEnter" }, { callback = open_nvim_tree })
