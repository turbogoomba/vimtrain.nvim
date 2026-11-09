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
        vim.api.nvim_set_current_buf(main)
        vim.api.nvim_buf_set_lines(main, 0, 1, false, current_task)
    end,
    {}
)

