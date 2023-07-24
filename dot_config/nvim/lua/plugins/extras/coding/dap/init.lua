return {
  {
    'mfussenegger/nvim-dap',
    dependencies = {
      {
        'rcarriga/nvim-dap-ui',
        dependencies = {
          'nvim-neotest/nvim-nio',
        },
        keys = function()
          local options = function(desc)
            return { desc = 'Dap: ' .. desc, noremap = true, nowait = true, silent = true }
          end

          return {
            { '<leader>du', function() require('dapui').toggle() end, options('Toggle DAP UI') },
            { '<leader>de', function() require('dapui').eval() end,   options('Evaluate Expression') },
          }
        end,
        opts = {
          icons = {
            expanded = '⌄',
            collapsed = '›',
            current_frame = '›',
          },
          controls = {
            enabled = false,
          },
        },
        config = function(_, opts)
          local dap = require('dap')
          local dapui = require('dapui')

          -- Open/close the UI on DAP events. The UI will remain open at the end
          -- of a debugging session, but may be closed manually.
          dap.listeners.after.event_initialized['dapui_config'] = dapui.open
          dap.listeners.before.event_exited['dapui_config'] = dapui.close

          dapui.setup(opts)
        end,
      },
      {
        'theHamsta/nvim-dap-virtual-text',
        opts = {},
      },
    },
    enabled = true,
    keys = function()
      local options = function(desc)
        return { desc = 'Dap: ' .. desc, noremap = true, nowait = true, silent = true }
      end

      local set_breakpoint = function()
        require('dap').set_breakpoint(vim.fn.input('Breakpoint condition: '))
      end

      return {
        { '<leader>dB', set_breakpoint,                                    options('Breakpoint Condition') },
        { '<leader>db', function() require('dap').toggle_breakpoint() end, options('Toggle Breakpoint') },
        { '<leader>dc', function() require('dap').continue() end,          options('Continue') },
        { '<leader>dC', function() require('dap').run_to_cursor() end,     options('Run To Cursor') },
        { '<leader>do', function() require('dap').step_over() end,         options('Step Over') },
        { '<leader>di', function() require('dap').step_into() end,         options('Step Into') },
        { '<leader>dO', function() require('dap').step_out() end,          options('Step Out') },
        { '<leader>dl', function() require('dap').run_last() end,          options('Run Last') },
        { '<leader>dp', function() require('dap').pause() end,             options('Pause') },
        { '<leader>dr', function() require('dap').repl.toggle() end,       options('Toggle REPL') },
        { '<leader>dt', function() require('dap').terminte() end,          options('Terminate') },
        { '<leader>dR', function() require('dap').restart() end,           options('Restart') },
      }
    end,
    cmd = {
      'DapContinue',
      'DapToggleBreakpoint',
    },
    opts = {
      signs = {
        DapBreakpoint = '●',
        DapBreakpointCondition = '◍',
        DapBreakpointRejected = '✗',
        DapLogPoint = '◎',
        DapStopped = '➜',
      },
    },
    config = function(_, opts)
      for name, icon in pairs(opts.signs) do
        vim.fn.sign_define(name, { text = icon, texthl = name, numhl = '' })
      end
    end,
  },
}
