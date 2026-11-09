vim.api.nvim_create_user_command(
    "VimTrain",
    function()
        -- Creates the buffer "main"
       local main = vim.api.nvim_create_buf(false, true)
        -- Opens current buffer over current buffer
        vim.api.nvim_set_current_buf(main)
        vim.api.nvim_buf_set_lines(main, 0, 1, false, { "This is a Neovim practice plugin!" })
    end,
    {}
)
