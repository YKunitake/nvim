local M = {}

-- 状態を管理するテーブル
local state = {
    q_buf = nil, -- 質問バッファ番号
    a_buf = nil, -- 回答バッファ番号
    log_dir = vim.fn.stdpath("cache") .. "/gemini_chat",
    q_log = nil,
    a_log = nil,
    job_id = nil,
}

-- ログディレクトリを確保
vim.fn.mkdir(state.log_dir, "p")
state.q_log = state.log_dir .. "/questions.md"
state.a_log = state.log_dir .. "/answers.md"


-- バッファの先頭にテキストを挿入するヘルパー
local function prepend_to_buf(bufnr, lines, save)
    if not bufnr or not vim.api.nvim_buf_is_valid(bufnr) then return end

    local was_readonly = vim.bo[bufnr].readonly
    local was_modifiable = vim.bo[bufnr].modifiable

    vim.bo[bufnr].readonly = false
    vim.bo[bufnr].modifiable = true

    vim.api.nvim_buf_set_lines(bufnr, 0, 0, false, lines)

    vim.bo[bufnr].readonly = was_readonly
    vim.bo[bufnr].modifiable = was_modifiable

    if save then
        -- 対応するウィンドウを探して保存
        local wins = vim.fn.win_findbuf(bufnr)
        if #wins > 0 then
            vim.api.nvim_win_call(wins[1], function()
                vim.cmd("noautocmd w!")
            end)
        else
            -- ウィンドウが見つからない場合でもバッファ名で保存を試みる
            vim.cmd("noautocmd bufdo if bufname('%') == '" .. vim.api.nvim_buf_get_name(bufnr) .. "' | w! | endif")
        end
    end
end

-- 質問を送信する内部関数
function M._send_question()
    if not state.q_buf or not state.a_buf then
        vim.notify("Chat session not active. Run :GeminiChat to start.", vim.log.levels.ERROR)
        return
    end
    if state.job_id then
        vim.notify("A request is already in progress. Please wait.", vim.log.levels.WARN)
        return
    end

    -- 質問バッファから最新の質問を取得 (先頭から)
    local q_lines = vim.api.nvim_buf_get_lines(state.q_buf, 0, -1, false)
    local first_separator = -1
    for i = 1, #q_lines do
        if string.match(q_lines[i], "^---") then
            first_separator = i
            break
        end
    end

    local prompt_lines = {}
    local end_line = (first_separator == -1) and #q_lines or (first_separator - 1)
    for i = 1, end_line do
        table.insert(prompt_lines, q_lines[i])
    end
    local prompt = table.concat(prompt_lines, "\n"):gsub("^%s*(.-)%s*$", "%1")


    -- Prepare the full conversation history
    local history_q = vim.fn.readfile(state.q_log)
    local history_a = vim.fn.readfile(state.a_log)
    local full_history = "## Questions\n\n" .. table.concat(history_q, "\n") .. "\n\n## Answers\n\n" .. table.concat(history_a, "\n")
    local final_prompt_with_history = "Based on the following conversation history, please answer the new question.\n\n" .. full_history .. "\n\n## New Question\n\n" .. prompt

    local timestamp = os.date("%Y-%m-%d %H:%M:%S")

    -- ユーザーが入力した質問をクリア
    vim.api.nvim_buf_set_lines(state.q_buf, 0, end_line, false, {})

    -- タイムスタンプ付きで質問を再挿入
    prepend_to_buf(state.q_buf, { "", "---", timestamp, prompt }, true)

    -- 回答バッファに応答待機メッセージを表示
    prepend_to_buf(state.a_buf, { "---", timestamp, "⏳ Thinking...", "" }, true)


    local stdout_data = {}
    local stderr_data = {}
    state.job_id = vim.fn.jobstart({"gemini", "--model", "gemini-2.5-flash"}, {
        on_stdout = function(_, data)
            if data then vim.list_extend(stdout_data, data) end
        end,
        on_stderr = function(_, data)
            if data then vim.list_extend(stderr_data, data) end
        end,
        on_exit = function(_, code)
            vim.schedule(function()
                -- "Thinking..."ブロックを削除
                vim.api.nvim_buf_set_lines(state.a_buf, 0, 4, false, {}) -- Remove the 4 lines of the "Thinking..." block

                if code ~= 0 then
                    local err_msg = table.concat(stderr_data, "\n")
                    if err_msg ~= "" then
                        vim.notify("Gemini Error (code: " .. code .. "):\n" .. err_msg, vim.log.levels.ERROR)
                        prepend_to_buf(state.a_buf, { "---", timestamp, "Error: " .. err_msg, "" }, true)
                    else
                        vim.notify("Gemini process failed with code: " .. code, vim.log.levels.ERROR)
                        prepend_to_buf(state.a_buf, { "---", timestamp, "Error: Process failed with code " .. code, "" }, true)
                    end
                else
                    -- Join all stdout chunks and then split into proper lines
                    local full_answer = table.concat(stdout_data, "")
                    local answer_lines = vim.split(full_answer, "\n")

                    -- Create a single table with all lines for nvim_buf_set_lines
                    local lines_to_insert = { "---", timestamp }
                    vim.list_extend(lines_to_insert, answer_lines)
                    table.insert(lines_to_insert, "")
                    prepend_to_buf(state.a_buf, lines_to_insert, true)
                end

                state.job_id = nil

                -- ユーザーが次の質問をしやすいようにフォーカスを移動
                local q_wins = vim.fn.win_findbuf(state.q_buf)
                if #q_wins > 0 then
                    vim.api.nvim_set_current_win(q_wins[1])
                    vim.cmd("normal! gg")
                    vim.cmd("startinsert")
                end
            end)
        end,
    })
    -- Send the prompt to stdin and close it
    vim.fn.chansend(state.job_id, final_prompt_with_history)
    vim.fn.chanclose(state.job_id, "stdin")
end

-- チャットセッションを開始するメイン関数
function M.chat()
    -- 左側に質問ウィンドウ
    vim.cmd("vnew " .. state.q_log)
    state.q_buf = vim.api.nvim_get_current_buf()
    vim.cmd("setlocal filetype=markdown wrap")
    vim.cmd("setlocal scrollbind")
    vim.api.nvim_buf_set_keymap(
        state.q_buf,
        "n",
        "<CR>",
        "<Cmd>lua require('config.gemini')._send_question()<CR>",
        { noremap = true, silent = true, desc = "Send question to Gemini" }
    )
    if #vim.api.nvim_buf_get_lines(state.q_buf, 0, -1, false) <= 1 then
      prepend_to_buf(state.q_buf, { "", "---", os.date("%Y-%m-%d %H:%M:%S"), "Type your question here and press <Enter> in normal mode to send." })
    end
    vim.cmd("normal! gg")

    -- 右側に回答ウィンドウ
    vim.cmd("wincmd l")
    vim.cmd("edit " .. state.a_log)
    state.a_buf = vim.api.nvim_get_current_buf()
    vim.cmd("setlocal filetype=markdown wrap")
    vim.cmd("setlocal scrollbind readonly")

    -- フォーカスを質問ウィンドウに戻す
    vim.cmd("wincmd p")
    vim.cmd("startinsert")

    vim.notify("Gemini chat session started.", vim.log.levels.INFO)
end

function M.end_chat()
    if state.q_buf and vim.api.nvim_buf_is_valid(state.q_buf) then
        vim.cmd("bdelete! " .. state.q_buf)
        state.q_buf = nil
    end
    if state.a_buf and vim.api.nvim_buf_is_valid(state.a_buf) then
        vim.cmd("bdelete! " .. state.a_buf)
        state.a_buf = nil
    end
    vim.notify("Gemini chat session ended.", vim.log.levels.INFO)
end

-- 既存の関数も残しておく
local function get_visual_selection()
    local _, start_row, start_col, _ = unpack(vim.fn.getpos("'<"))
    local _, end_row, end_col, _ = unpack(vim.fn.getpos("'>"))
    local lines = vim.api.nvim_buf_get_lines(0, start_row - 1, end_row, false)
    if #lines == 0 then
        return ""
    end
    if #lines == 1 then
        return string.sub(lines[1], start_col, end_col)
    end
    lines[#lines] = string.sub(lines[#lines], 1, end_col)
    lines[1] = string.sub(lines[1], start_col)
    return table.concat(lines, "\n")
end

-- MODIFICATION: Use a temporary file to pass prompt to the terminal command
local function run_in_vsplit(prompt)
    local tmpfile = vim.fn.tempname()
    vim.fn.writefile(vim.split(prompt, "\n"), tmpfile)
        vim.cmd("vsplit | terminal sh -c 'gemini --model gemini-2.5-flash < " .. tmpfile .. " && rm " .. tmpfile .. "'")
end

function M.ask()
    vim.ui.input({ prompt = "Ask Gemini: " }, function(input)
        if input then
            run_in_vsplit(input)
        end
    end)
end

function M.visual_action()
    vim.ui.input({ prompt = "What to do with the selection? (e.g., explain, refactor, write tests): " }, function(input)
        if input then
            local selection = get_visual_selection()
            if selection == "" then
                print("No text selected.")
                return
            end
            run_in_vsplit(input .. "\n```\n" .. selection .. "\n```")
        end
    end)
end

vim.api.nvim_create_user_command("GeminiChatEnd", M.end_chat, {})

return M
