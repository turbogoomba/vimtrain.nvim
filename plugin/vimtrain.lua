local tasks = require("vimtrain.tasks")
local training_wheels = true
local movement_task = true
local current_task
local col
local row
-- local pos = vim.api.nvim_win_get_pos(0)

-- Implements the grid
local function make_grid()
    local grid_list = {}
    for i = 1, 15 do
        local row = string.rep(". ", 15)
        table.insert(grid_list, row)
    end
    return grid_list
end

vim.api.nvim_create_user_command(
    "VimTrain",
    function()
        -- Creates the buffer "main"
        local main = vim.api.nvim_create_buf(false, true)

        local function show_task()
            if training_wheels then
                local display_hint = current_task.message .. " | " .. current_task.hint
                vim.wo.winbar = display_hint
            else
                vim.wo.winbar = current_task.message
            end
        end

        local function make_task()
            local previous_task = current_task

            repeat
                current_task = tasks[math.random(#tasks)]
            until current_task ~= previous_task

            local grid = make_grid()
            col = math.random(1, 15)
            row = math.random(1, 15)
            local x_coord = 2 * col - 1

            -- Replaces the dot at x_coord in the chosen row with an x
            local line = grid[row]
            grid[row] = line:sub(1, x_coord - 1) .. "x" .. line:sub(x_coord + 1)

            vim.api.nvim_buf_set_lines(main, 0, -1, false, grid) -- writes the grid to buffer
            vim.api.nvim_win_set_cursor(0, { 1, 0 })
            show_task()
        end


        vim.api.nvim_set_current_buf(main) -- Defines the current windowk
        make_task()

        -- Checks if text has changed
        vim.api.nvim_create_autocmd({ "TextChanged", "TextChangedI" }, {
            buffer = main,
            callback = function()
                -- Pulls the task to check current result
                local task_result = vim.api.nvim_buf_get_lines(main, 0, -1, false)
                if vim.deep_equal({ current_task.after }, { task_result }) then -- Checks if you completed the task
                    vim.wo.winbar = "%#DiagnosticOk# COMPLETE!"
                    vim.defer_fn(function()
                        make_task()
                    end, 1000)
                else
                    show_task()
                end
            end,
        })
    end,
    {}
)



