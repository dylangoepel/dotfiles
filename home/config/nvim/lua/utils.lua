local utils = {}

function utils.setOpts(vals)
  for k, v in pairs(vals) do
      for kk, vv in pairs(v) do
          if k == "cmd" then
              vim.cmd[kk](vv)
          else
              vim[k][kk] = vv
          end
      end
  end
end

Automake_id = {}
local function toggleAutocmd(c, event)
        return function()
            if Automake_id[c] == nil then
                local ret = vim.api.nvim_create_autocmd(event, {
                    callback = function()
                        vim.cmd(c)
                    end
                })
                Automake_id[c] = ret
            else
                vim.api.nvim_del_autocmd(Automake_id[c])
                Automake_id[c] = nil
            end
        end
end

function utils.perFiletype(opts)
    for ft, c in pairs(opts) do
        local fts = {}
        for v in string.gmatch(ft, "[^|]+") do
            table.insert(fts, v)
        end
        vim.api.nvim_create_autocmd('BufRead', {
            pattern = fts,
            callback = c,
        })
    end
end

function utils.setKeymap(map, opts)
    local modes = { normal = 'n', visual = 'v', terminal = 't', insert = 'i' }
    local keymapAll = function(f, mode, prefix, keys)
        for k, v in pairs(keys) do
            if type(v) == "table" then
                if v.onEvent ~= nil then
                    vim.keymap.set(mode, prefix .. k, toggleAutocmd(v[1], v.onEvent), opts)
                else
                    f(f, mode, prefix .. k, v)
                end
            else
                vim.keymap.set(mode, prefix .. k, v, opts)
            end
        end
    end
    for mode, keys in pairs(map) do
        keymapAll(keymapAll, modes[mode], '', keys)
    end
end

return utils
