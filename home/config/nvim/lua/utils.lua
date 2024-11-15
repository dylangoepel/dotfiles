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

function utils.buf_get_line()
    return vim.api.nvim_buf_get_lines(0, vim.fn.getpos('.')[2] - 1, vim.fn.getpos('.')[2], true)[1]
end

function utils.buf_get_selection()
  local _, srow, scol = unpack(vim.fn.getpos('v'))
  local _, erow, ecol = unpack(vim.fn.getpos('.'))

  -- visual line mode
  if vim.fn.mode() == 'V' then
    if srow > erow then
      return vim.api.nvim_buf_get_lines(0, erow - 1, srow, true)
    else
      return vim.api.nvim_buf_get_lines(0, srow - 1, erow, true)
    end
  end

  -- regular visual mode
  if vim.fn.mode() == 'v' then
    if srow < erow or (srow == erow and scol <= ecol) then
      return vim.api.nvim_buf_get_text(0, srow - 1, scol - 1, erow - 1, ecol, {})
    else
      return vim.api.nvim_buf_get_text(0, erow - 1, ecol - 1, srow - 1, scol, {})
    end
  end

  -- visual block mode
  if vim.fn.mode() == '\22' then
    local lines = {}
    if srow > erow then
      srow, erow = erow, srow
    end
    if scol > ecol then
      scol, ecol = ecol, scol
    end
    for i = srow, erow do
      table.insert(
        lines,
        vim.api.nvim_buf_get_text(0, i - 1, math.min(scol - 1, ecol), i - 1, math.max(scol - 1, ecol), {})[1]
      )
    end
    return lines
  end
end


return utils
