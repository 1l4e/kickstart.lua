local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system {
        'git',
        'clone',
        '--filter=blob:none',
        'https://github.com/folke/lazy.nvim.git',
        '--branch=stable', -- latest stable release
        lazypath,
    }
end
vim.opt.rtp:prepend(lazypath)

require('lazy').setup({
    --'tpope/vim-fugitive',
    --'tpope/vim-rhubarb',
    'mbbill/undotree',
    'xiyaowong/transparent.nvim',
    'onsails/lspkind.nvim',
    'tpope/vim-sleuth',
    {
        'theprimeagen/harpoon',
        branch = 'harpoon2',
        dependencies = { "nvim-tree/plenary.nvim" }
    },
    {
        'laytan/tailwind-sorter.nvim',
        dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-lua/plenary.nvim' },
        build = 'cd formatter && npm i && npm run build',
        config = true,
    },
    -- 'nvim-pack/nvim-spectre',
    {
        "nvim-neo-tree/neo-tree.nvim",
        event = "VeryLazy",
        branch = "v3.x",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
            "MunifTanjim/nui.nvim",
            -- "3rd/image.nvim", -- Optional image support in preview window: See `# Preview Mode` for more information
        }
    },
    {
        "NvChad/nvim-colorizer.lua",
        opts = {
            user_default_options = {
                tailwind = true,
            },
        },
    },
    {
        'neovim/nvim-lspconfig',
        opts = {
            servers = {
                tailwindcss = {},
            },
        },
        dependencies = {
            'williamboman/mason.nvim',
            'williamboman/mason-lspconfig.nvim',
            { 'j-hui/fidget.nvim', tag = 'legacy', opts = {} },
            'folke/neodev.nvim',
        },
    },

    {
        'hrsh7th/nvim-cmp',
        dependencies = {
            -- Snippet Engine & its associated nvim-cmp source
            'L3MON4D3/LuaSnip',
            'saadparwaiz1/cmp_luasnip',

            -- Adds LSP completion capabilities
            'hrsh7th/cmp-nvim-lsp',

            -- Adds a number of user-friendly snippets
            'rafamadriz/friendly-snippets',
        },
    },

    { 'folke/which-key.nvim',  opts = {} },

    -- {
    --   -- Theme inspired by Atom
    --   'joshdick/onedark.vim',
    --   name = "onedark",
    --   priority = 1000,
    --   config = function()
    --     vim.cmd.colorscheme 'onedark'
    --     vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
    --     vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
    --   end,
    -- },
    -- {
    --   'navarasu/onedark.nvim',
    -- },
    {
        "folke/tokyonight.nvim",
        lazy = false,
        priority = 1000,
        opts = {
            transparent = true,
            styles = {
                sidebars = "transparent",
                floats = "transparent",
            },
        },
        config = function()
            vim.cmd.colorscheme 'tokyonight-storm'
            vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
            vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
        end,
    },
    {
        -- Set lualine as statusline
        'nvim-lualine/lualine.nvim',
        -- See `:help lualine.txt`
        opts = {
            options = {
                icons_enabled = true,
                theme = 'tokyonight',
                component_separators = '|',
                section_separators = '',
            },
        },
    },

    {
        "lukas-reineke/indent-blankline.nvim",
        event = "VeryLazy",
        opts = {
            indent = {
                char = "│",
                tab_char = "│",
            },
            scope = { enabled = false },
            exclude = {
                filetypes = {
                    "help",
                    "alpha",
                    "dashboard",
                    "neo-tree",
                    "Trouble",
                    "trouble",
                    "lazy",
                    "mason",
                    "notify",
                    "toggleterm",
                    "lazyterm",
                },
            },
        },
        main = "ibl",
    },
    -- {
    --   "akinsho/bufferline.nvim",
    --   event = "VeryLazy",
    --   keys = {
    --     { "<leader>bp", "<Cmd>BufferLineTogglePin<CR>",            desc = "Toggle pin" },
    --     { "<leader>bP", "<Cmd>BufferLineGroupClose ungrouped<CR>", desc = "Delete non-pinned buffers" },
    --     { "<leader>bo", "<Cmd>BufferLineCloseOthers<CR>",          desc = "Delete other buffers" },
    --     { "<leader>br", "<Cmd>BufferLineCloseRight<CR>",           desc = "Delete buffers to the right" },
    --     { "<leader>bl", "<Cmd>BufferLineCloseLeft<CR>",            desc = "Delete buffers to the left" },
    --     { "<S-h>",      "<cmd>BufferLineCyclePrev<cr>",            desc = "Prev buffer" },
    --     { "<S-l>",      "<cmd>BufferLineCycleNext<cr>",            desc = "Next buffer" },
    --     { "[b",         "<cmd>BufferLineCyclePrev<cr>",            desc = "Prev buffer" },
    --     { "]b",         "<cmd>BufferLineCycleNext<cr>",            desc = "Next buffer" },
    --   },
    --   opts = {
    --     options = {
    --       -- stylua: ignore
    --       close_command = function(n) require("mini.bufremove").delete(n, false) end,
    --       -- stylua: ignore
    --       right_mouse_command = function(n) require("mini.bufremove").delete(n, false) end,
    --       diagnostics = "nvim_lsp",
    --       always_show_bufferline = false,
    --       -- diagnostics_indicator = function(_, _, diag)
    --       --     local icons = require("lazyvim.config").icons.diagnostics
    --       --     local ret = (diag.error and icons.Error .. diag.error .. " " or "")
    --       --         .. (diag.warning and icons.Warn .. diag.warning or "")
    --       --     return vim.trim(ret)
    --       -- end,
    --       offsets = {
    --         {
    --           filetype = "neo-tree",
    --           text = "Neo-tree",
    --           highlight = "Directory",
    --           text_align = "left",
    --         },
    --       },
    --     },
    --   },
    --   config = function(_, opts)
    --     require("bufferline").setup(opts)
    --     -- Fix bufferline when restoring a session
    --     vim.api.nvim_create_autocmd("BufAdd", {
    --       callback = function()
    --         vim.schedule(function()
    --           pcall(nvim_bufferline)
    --         end)
    --       end,
    --     })
    --   end,
    -- },
    -- "gc" to comment visual regions/lines
    { 'numToStr/Comment.nvim', opts = {} },

    -- Fuzzy Finder (files, lsp, etc)
    {
        'nvim-telescope/telescope.nvim',
        branch = '0.1.x',
        dependencies = {
            'nvim-lua/plenary.nvim',
            -- Fuzzy Finder Algorithm which requires local dependencies to be built.
            -- Only load if `make` is available. Make sure you have the system
            -- requirements installed.
            {
                'nvim-telescope/telescope-fzf-native.nvim',
                -- NOTE: If you are having trouble with this installation,
                --       refer to the README for telescope-fzf-native for more instructions.
                build = 'make',
                cond = function()
                    return vim.fn.executable 'make' == 1
                end,
            },
        },
    },

    {
        -- Highlight, edit, and navigate code
        'nvim-treesitter/nvim-treesitter',
        -- dependencies = {
        --     'nvim-treesitter/nvim-treesitter-textobjects',
        -- },
        build = ':TSUpdate',
    },
    'HiPhish/rainbow-delimiters.nvim',
    {
        "folke/flash.nvim",
        event = "VeryLazy",
        ---@type Flash.Config
        opts = {},
        -- stylua: ignore
        keys = {
            { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
            {
                "<leader>S",
                mode = { "n", "x", "o" },
                function() require("flash").treesitter() end,
                desc =
                "Flash Treesitter"
            },
            {
                "r",
                mode = "o",
                function() require("flash").remote() end,
                desc = "Remote Flash"
            },
            {
                "<leader>sr",
                mode = { "o", "x" },
                function() require("flash").treesitter_search() end,
                desc =
                "Treesitter Search"
            },
            {
                "<leader>SS",
                mode = { "c" },
                function() require("flash").toggle() end,
                desc =
                "Toggle Flash Search"
            },
        },
    },
    require 'kickstart.plugins.autoformat',
    -- require 'kickstart.plugins.debug',

    { import = 'custom.return' },
}, {})
