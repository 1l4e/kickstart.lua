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
        branch = "v3.x",
        cmd = "Neotree",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
            "MunifTanjim/nui.nvim",
            "3rd/image.nvim",
        },
        keys = {
            {
                "<leader>ft",
                function()
                    require("neo-tree.command").execute({ toggle = true, dir = Util.root() })
                end,
                desc = "Explorer NeoTree (root dir)",
            },
            {
                "<leader>pv",
                function()
                    require("neo-tree.command").execute({ toggle = true, dir = vim.loop.cwd() })
                end,
                desc = "Explorer NeoTree (cwd)",
            },
            { "<leader>e", "<leader>fe", desc = "Explorer NeoTree (root dir)", remap = true },
            { "<leader>E", "<leader>fE", desc = "Explorer NeoTree (cwd)",      remap = true },
            {
                "<leader>ge",
                function()
                    require("neo-tree.command").execute({ source = "git_status", toggle = true })
                end,
                desc = "Git explorer",
            },
            {
                "<leader>be",
                function()
                    require("neo-tree.command").execute({ source = "buffers", toggle = true })
                end,
                desc = "Buffer explorer",
            },
        },
        deactivate = function()
            vim.cmd([[Neotree close]])
        end,
        init = function()
            if vim.fn.argc(-1) == 1 then
                local stat = vim.loop.fs_stat(vim.fn.argv(0))
                if stat and stat.type == "directory" then
                    require("neo-tree")
                end
            end
        end,
        opts = {
            sources = { "filesystem", "buffers", "git_status", "document_symbols" },
            open_files_do_not_replace_types = { "terminal", "Trouble", "trouble", "qf", "Outline" },
            filesystem = {
                bind_to_cwd = false,
                follow_current_file = { enabled = true },
                use_libuv_file_watcher = true,
            },
            window = {
                mappings = {
                    ["<space>"] = "none",
                    ["Y"] = function(state)
                        local node = state.tree:get_node()
                        local path = node:get_id()
                        vim.fn.setreg("+", path, "c")
                    end,
                },
            },
            default_component_configs = {
                indent = {
                    with_expanders = true, -- if nil and file nesting is enabled, will enable expanders
                    expander_collapsed = "",
                    expander_expanded = "",
                    expander_highlight = "NeoTreeExpander",
                },
            },
        },
        config = function(_, opts)
            local function on_move(data)
                Util.lsp.on_rename(data.source, data.destination)
            end

            local events = require("neo-tree.events")
            opts.event_handlers = opts.event_handlers or {}
            vim.list_extend(opts.event_handlers, {
                { event = events.FILE_MOVED,   handler = on_move },
                { event = events.FILE_RENAMED, handler = on_move },
            })
            opts.update_focused_file = {
                enable = true,
            }
            require("neo-tree").setup(opts)
            vim.api.nvim_create_autocmd("TermClose", {
                pattern = "*lazygit",
                callback = function()
                    if package.loaded["neo-tree.sources.git_status"] then
                        require("neo-tree.sources.git_status").refresh()
                    end
                end,
            })
            vim.api.nvim_create_autocmd({ "colorscheme" },
                {
                    desc = "Transparent background",
                    group = vim.api.nvim_create_augroup("transparent_background", { clear = true }),
                    pattern = "*",
                    callback = function()
                        vim.api.nvim_set_hl(0, "Normal", { bg = "NONE", ctermbg = "NONE" })
                        vim.api.nvim_set_hl(0, "NeoTreeNormal", { bg = "none", ctermbg = "NONE" })
                        vim.api.nvim_set_hl(0, "NeoTreeNormalNC", { bg = "none", ctermbg = "NONE" })
                    end
                })
        end,
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
        config = function()
            require("lualine").setup({
                sections = {
                    lualine_x = {
                        {
                            require("noice").api.statusline.mode.get,
                            cond = require("noice").api.statusline.mode.has,
                            color = { fg = "#ff9e64" },
                        }
                    }
                }
            })
        end
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
    {
        "rcarriga/nvim-notify",
        keys = {
            {
                "<leader>un",
                function()
                    require("notify").dismiss({ silent = true, pending = true })
                end,
                desc = "Dismiss all Notifications",
            },
        },
        opts = {
            timeout = 3000,
            max_height = function()
                return math.floor(vim.o.lines * 0.75)
            end,
            max_width = function()
                return math.floor(vim.o.columns * 0.75)
            end,
            on_open = function(win)
                vim.api.nvim_win_set_config(win, { zindex = 100 })
            end,
        },
    },
    {
        "stevearc/dressing.nvim",
        lazy = true,
        init = function()
            ---@diagnostic disable-next-line: duplicate-set-field
            vim.ui.select = function(...)
                require("lazy").load({ plugins = { "dressing.nvim" } })
                return vim.ui.select(...)
            end
            ---@diagnostic disable-next-line: duplicate-set-field
            vim.ui.input = function(...)
                require("lazy").load({ plugins = { "dressing.nvim" } })
                return vim.ui.input(...)
            end
        end,
    },
    {
        "folke/noice.nvim",
        event = "VeryLazy",
        opts = {
            lsp = {
                override = {
                    ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
                    ["vim.lsp.util.stylize_markdown"] = true,
                    ["cmp.entry.get_documentation"] = true,
                },
            },
            routes = {
                {
                    filter = {
                        event = "msg_show",
                        any = {
                            { find = "%d+L, %d+B" },
                            { find = "; after #%d+" },
                            { find = "; before #%d+" },
                        },
                    },
                    view = "mini",
                },
            },
            presets = {
                bottom_search = true,
                command_palette = true,
                long_message_to_split = true,
                inc_rename = true,
            },
        },
        -- stylua: ignore
        keys = {
            { "<S-Enter>",   function() require("noice").redirect(vim.fn.getcmdline()) end,                 mode = "c",                 desc = "Redirect Cmdline" },
            { "<leader>snl", function() require("noice").cmd("last") end,                                   desc = "Noice Last Message" },
            { "<leader>snh", function() require("noice").cmd("history") end,                                desc = "Noice History" },
            { "<leader>sna", function() require("noice").cmd("all") end,                                    desc = "Noice All" },
            { "<leader>snd", function() require("noice").cmd("dismiss") end,                                desc = "Dismiss All" },
            { "<c-f>",       function() if not require("noice.lsp").scroll(4) then return "<c-f>" end end,  silent = true,              expr = true,              desc = "Scroll forward",  mode = { "i", "n", "s" } },
            { "<c-b>",       function() if not require("noice.lsp").scroll(-4) then return "<c-b>" end end, silent = true,              expr = true,              desc = "Scroll backward", mode = { "i", "n", "s" } },
        },
    },
    {
        "dstein64/vim-startuptime",
        cmd = "StartupTime",
        config = function()
            vim.g.startuptime_tries = 10
        end,
    },
    require 'kickstart.plugins.autoformat',
    -- require 'kickstart.plugins.debug',

    { import = 'custom.plugins' },
    { import = 'custom.return' },
}, {})
