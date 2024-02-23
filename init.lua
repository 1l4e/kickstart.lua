require("custom.set")
require("custom.lazy")
require("custom.which-key")
require("custom.telescope")
require("custom.treesitter")
require("custom.rainbow")
require("custom.harpoon")
require("custom.remap")
require("custom.lsp")
require("custom.mini")

-- [[ Highlight on yank ]]
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = '*',
})

-- document existing key chains
require('tailwind-sorter').setup({
  on_save_enabled = true,                                                                                        -- If `true`, automatically enables on save sorting.
  on_save_pattern = { '*.html', '*.jsx', '*.tsx', '*.twig', '*.hbs', '*.php', '*.heex', '*.astro', '*.svelte' }, -- The file patterns to watch and sort.
  node_path = 'node',
})
require('neodev').setup()


-- require("conform").setup({
--   formatters_by_ft = {
--     lua = { "stylua" },
--     -- Conform will run multiple formatters sequentially
--     python = { "isort", "black" },
--     -- Use a sub-list to run only the first available formatter
--     javascript = { { "prettierd", "prettier" } },
--   },
--   format_on_save = {
--     -- These options will be passed to conform.format()
--     timeout_ms = 500,
--     lsp_fallback = true,
--   },
-- })
-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
