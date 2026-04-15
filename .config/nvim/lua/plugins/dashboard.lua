-- dashboard-nvim is a low-memory usage startup screen for Neovim.
return {
 "nvimdev/dashboard-nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  event = 'VimEnter',
  config = function()

    -- true if cwd is a .git directory, false otherwise
    local function is_git_repo()
      vim.fn.systemlist("git rev-parse --show-toplevel")
      return vim.v.shell_error == 0
    end

    require('dashboard').setup({
      theme = 'doom',
      config = {
        header = {
          [[                                                ]],
          [[                                                ]],
          [[                                          _.oo. ]],
          [[                  _.u[[/;:,.         .odMMMMMM' ]],
          [[               .o888UU[[[/;:-.  .o@P^    MMM^   ]],
          [[              oN88888UU[[[/;::-.        dP^     ]],
          [[             dNMMNN888UU[[[/;:--.   .o@P^       ]],
          [[            ,MMMMMMN888UU[[/;::-. o@^           ]],
          [[            NNMMMNN888UU[[[/~.o@P^              ]],
          [[            888888888UU[[[/o@^-..               ]],
          [[           oI8888UU[[[/o@P^:--..                ]],
          [[        .@^  YUU[[[/o@^;::---..                 ]],
          [[      oMP     ^/o@P^;:::---..                   ]],
          [[   .dMMM    .o@^ ^;::---...                     ]],
          [[  dMMMMMMM@^`       `^^^^                       ]],
          [[ YMMMUP^                                        ]],
          [[  ^^                                            ]],
          [[                                                ]],
          [[                                                ]],
        },
        center = {
          {
            icon = '',
            desc = 'Find File                      ',
            key = 'f',
            key_format = '%s',
            key_hl = '@constructor',
            action = 'Telescope find_files'
          },
          {
            icon = '',
            desc = 'Find Keyword',
            key = 'k',
            key_format = '%s',
            key_hl = '@constructor',
            action = 'Telescope live_grep'
          },
          {
            icon = '',
            desc = 'Recent Files',
            key = 'r',
            key_format = '%s',
            key_hl = '@constructor',
            action = 'Telescope oldfiles'
          },
          {
            icon = '',
            desc = 'Git Branches',
            key = 'b',
            key_format = '%s',
            key_hl = '@constructor',
            action = function()
              if not is_git_repo() then
                vim.notify("Not a git repository", vim.log.levels.WARN)
                return
              end

              require("telescope.builtin").git_branches()
            end
          },
          {
            icon = '',
            desc = 'Git Commits',
            key = 'h',
            key_format = '%s',
            key_hl = '@constructor',
            action = function()
              if not is_git_repo() then
                vim.notify("Not a git repository", vim.log.levels.WARN)
                return
              end

              require("telescope.builtin").git_commits()
            end
          },
          {
            icon = '',
            desc = 'Git Status',
            key = 's',
            key_format = '%s',
            key_hl = '@constructor',
            action = function()
              if not is_git_repo() then
                vim.notify("Not a git repository", vim.log.levels.WARN)
                return
              end

              require("telescope.builtin").git_status()
            end
          },
        },
        footer = {},
      },
    })
  end
}

