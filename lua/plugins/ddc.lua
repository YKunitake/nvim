return {
    'Shougo/ddc.vim',
    dependencies = {
        'vim-denops/denops.vim',
        'Shougo/ddc-ui-native',
        'Shougo/ddc-source-around',
        'Shougo/ddc-source-lsp',
        'uga-rosa/ddc-source-lsp-setup',
        'tani/ddc-fuzzy',
        'Shougo/ddc-filter-matcher_head',
        'Shougo/ddc-filter-sorter_rank',
    },
    config = function()
        vim.fn["ddc#custom#patch_global"]('ui', 'native')
        vim.fn["ddc#custom#patch_global"]('sources', {'lsp', 'around'})
        vim.fn["ddc#custom#patch_global"]('sourceOptions', {
            ['lsp'] = {
                mark = "[LSP]",
                forceCompletionPattern = "\\.\\w*|:\\w*|->\\w*",
            },
            _ = {
                matchers = {'matcher_fuzzy'},
                sorters = {'sorter_rank'},
                ignoreCase = true,
                minAutoCompleteLength = 2,
                mark = '[A]',
            },
        })
        vim.fn["ddc#custom#patch_global"]{"sourceParams",{
            lsp = {
                snippetEngine = vim.fn["denops#callback#register"](function(body)
                    vim.fn["vsnip#anonymous"](body)
                end),
                enableResolveItem = true,
                enableAdditionalTextEdit = true,
            }
        }}
        vim.fn["ddc#enable"]()
    end,
}
