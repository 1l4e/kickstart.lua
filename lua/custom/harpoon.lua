local harpoon = require("harpoon")

harpoon:setup()
vim.keymap.set("n", "<leader>ea", function() harpoon:list():append() end)
vim.keymap.set("n", "<C-e>", function() toggle_telescope(harpoon:list()) end,
    { desc = "Open harpoon window" })

-- vim.keymap.set("n", "<leader>1", function() harpoon:list():select(1) end)
-- vim.keymap.set("n", "<leader>2", function() harpoon:list().select(2) end)
-- vim.keymap.set("n", "<leader>3", function() harpoon:list().select(3) end)
-- vim.keymap.set("n", "<leader>4", function() harpoon:list().select(4) end)
vim.keymap.set("n", "<C-h>", function() harpoon:list():select(1) end)
vim.keymap.set("n", "<C-t>", function() harpoon:list():select(2) end)
vim.keymap.set("n", "<C-n>", function() harpoon:list():select(3) end)
vim.keymap.set("n", "<C-s>", function() harpoon:list():select(4) end)
