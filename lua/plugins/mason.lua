return {
    {
        'mason-org/mason.nvim',
    },
    {
        'mason-org/mason-lspconfig.nvim',
        dependencies = {
            {'mason-org/mason.nvim', config = mason},
            'neovim/nvim-lspconfig',
            'Shougo/ddc-source-lsp',
            'uga-rosa/ddc-source-lsp-setup',
        },
        config = mason_lsconfig,
    },
}
