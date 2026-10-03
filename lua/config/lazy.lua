local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local lazyrepo = "https://github.com/folke/lazy.nvim.git"
    local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
    if vim.v.shell_error ~= 0 then
        vim.api.nvim_echo({
        { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
        { out, "WarningMsg" },
        { "\nPress any key to exit..." },
        }, true, {})
        vim.fn.getchar()
        os.exit(1)
    end
end
vim.opt.rtp:prepend(lazypath)

vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Debian/Ubuntu install bundled parsers under lib/<triplet>/nvim, which lazy's rtp reset drops
local nvim_prefix = vim.fn.fnamemodify(vim.v.progpath, ":p:h:h")
local bundled_lib_paths = vim.fn.glob(nvim_prefix .. "/lib/*/nvim", false, true)

require("lazy").setup({
    spec = {
        { import = "plugins" },
    },
    checker = {enabled = true},
    performance = {
        rtp = {
            paths = bundled_lib_paths,
        },
    },
})
