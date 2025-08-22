return {
    {
        'vim-denops/denops.vim',
    },
    {
        'vim-denops/denops-helloworld.vim',
        config = function()
            vim.g.denops_deno = "/home/yukihito/.deno/bin/deno"
        end,
    },
}
