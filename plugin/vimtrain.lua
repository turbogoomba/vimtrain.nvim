-- Here i made the first task
local task = {
    message = "Delete this 'Hello' from the following sentence",
    before = { "Hello World!" },
    after =  { "World!" } ,
}

-- This is testing the task
-- vim.print(task.message)
-- vim.print(task.before)

vim.api.nvim_create_user_command(
    "VimTrain",
    function()
        -- Creates the buffer "main"
        local main = vim.api.nvim_create_buf(false, true)

        -- Opens current buffer over current buffer
        local current_task = task.before

        vim.api.nvim_set_current_buf(main) -- Defines the current window
        vim.api.nvim_buf_set_lines(main, 0, 1, false, current_task) -- writes the task to buffer

        -- Displays the current task
        vim.wo.winbar = task.message

        -- Checks if text has changed
        vim.api.nvim_create_autocmd({ "TextChanged", "TextChangedI" }, {
            buffer = main,
            callback = function()
                -- Pulls the task to check current result
                local task_result = vim.api.nvim_buf_get_lines(main, 0, -1, false)
                if vim.deep_equal({ task.after }, { task_result }) then -- Checks if you completed the task
                    print("COMPLETE")
                else
                    print("FAIL")
                end
            end,
        })
    end,
    {}
)



