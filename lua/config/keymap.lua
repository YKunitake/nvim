-- Gemini
local gemini = require('config.gemini')
vim.api.nvim_set_var('mfapleader', ' ')
vim.keymap.set('n', '<leader>ga', gemini.ask, { desc = 'Ask Gemini' })
vim.keymap.set('v', '<leader>ga', gemini.visual_action, { desc = 'Ask Gemini about selection' })
vim.keymap.set('n', '<leader>gc', gemini.chat, { desc = 'Chat with Gemini' })
vim.keymap.set('n', '<leader>gq', ":GeminiChatEnd<CR>", { desc = 'Quit Gemini Chat' })
return M
