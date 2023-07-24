return {
  {
    'nvim-neotest/neotest',
    dependencies = {
      'nvim-lua/plenary.nvim',
    },
    keys = function()
      local options = function(desc)
        return { desc = 'Test: ' .. desc, noremap = true, nowait = true, silent = true }
      end

      local open = function()
        require('neotest').output.open({ enter = true, auto_close = true })
      end

      return {
        { '<leader>Tt', function() require('neotest').run.run(vim.fn.expand('%')) end, options('Run File') },
        { '<leader>TT', function() require('neotest').run.run(vim.loop.cwd()) end,     options('Run All Test Files') },
        { '<leader>Tr', function() require('neotest').run.run() end,                   options('Run Nearest') },
        { '<leader>Ts', function() require('neotest').summary.toggle() end,            options('Toggle Summary') },
        { '<leader>To', open,                                                          options('Show Output') },
        { '<leader>TO', function() require('neotest').output_panel.toggle() end,       options('Toggle Output Panel') },
        { '<leader>TS', function() require('neotest').run.stop() end,                  options('Stop') },
      }
    end,
    opts = {
      -- Can be a list of adapters like what neotest expects,
      -- or a list of adapter names,
      -- or a table of adapter names, mapped to adapter configs.
      --
      -- The adapter will then be automatically loaded with the config.
      adapters = {},
      -- Example for loading neotest-go with a custom config
      -- adapters = {
      --   ["neotest-go"] = {
      --     args = { "-tags=integration" },
      --   },
      -- },
      status = {
        virtual_text = true,
      },
      output = {
        open_on_run = true,
      },
    },
  },
}
