local tasks = require("vimtrain.tasks")
local training_wheels = true
local current_task

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

            vim.api.nvim_buf_set_lines(main, 0, -1, false, current_task.before) -- writes the task to buffer
            -- vim.api.nvim_buf_set_lines(main, 0, -1, false, make_grid()) -- writes the task to buffer
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



