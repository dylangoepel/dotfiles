local utils = {}

function utils.removePrefix(s, pre)
    if s:sub(1, pre:len()) == pre then
        return s:sub(pre:len() + 1)
    end
    return s
end

function utils.bufferDir()
    return utils.removePrefix(vim.fn.expand("%:p:h"), "oil://")
end
function utils.bufferPath()
    return utils.removePrefix(vim.fn.expand("%:p"), "oil://")
end

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
                elseif v.opts ~= nil then
                    vim.keymap.set(mode, prefix .. k, v[1], v.opts)
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

function utils.has_suffix(s, t)
    return s:sub(-#t) == t
end
function utils.has_prefix(s, t)
    return s:sub(0, #t) == t
end

function utils.get_region_inside(open, close)
    local pos = vim.fn.getpos('.')
    local line = vim.api.nvim_buf_get_lines(0, pos[2] - 1, pos[2], true)[1]
    local endPos = line:sub(pos[3]):find(close)
    if endPos == nil then
        return ""
    end
    local startPos = nil
    for i = 1,endPos + pos[3] - 1 do
        local c = string.sub(line, endPos + pos[3] - 1 - i, endPos + pos[3] - 1 - i)
        if c == open then
            startPos = endPos + pos[3] - 1 - i
            break
        end
    end
    if startPos == nil then
        return ""
    end
    return line:sub(startPos + 1, endPos + pos[3] - 2)
end

function utils.get_paren_region()
    return utils.get_region_inside('(', ')')
end

function utils.markdownEnter()
    local filename = utils.get_paren_region()
    if filename == "" then
        return
    end
    local n = filename:find('?p=')
    if n ~= nil then
        local fname = filename:sub(1, n - 1)
        local pageno = filename:sub(n + #'?p=')
        vim.cmd('Dispatch! zathura --page=' .. pageno .. ' "' .. vim.fn.expand("%:h") .. '/' .. fname .. '"')
    elseif utils.has_suffix(filename, ".pdf") then
        vim.cmd('Dispatch! zathura "' .. vim.fn.expand("%:h") .. '/' .. filename .. '"')
    elseif utils.has_prefix(filename, "http://") or utils.has_prefix(filename, "https://")  then
        vim.cmd('Dispatch! firefox "' .. filename .. '"')
    elseif utils.has_suffix(filename, ".html") then
        vim.cmd('Dispatch! firefox "' .. vim.fn.expand("%:h") .. '/' .. filename .. '"')
    else
        vim.cmd('e ' .. vim.fn.expand("%:h") .. '/' .. filename)
    end
end


return utils
