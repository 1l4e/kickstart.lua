local trouble = require("trouble.providers.telescope")
require('telescope').setup {
    defaults = {
        mappings = {
            i = {
                ['<C-u>'] = false,
                ['<C-d>'] = false,
                ["<c-t>"] = trouble.open_with_trouble,
            },
            n = {
                ["<c-t>"] = trouble.open_with_trouble,
            }
        },
    },
}
