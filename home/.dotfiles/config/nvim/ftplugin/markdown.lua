local function has_suffix(s, t)
    return s:sub(-#t) == t
end
local function has_prefix(s, t)
    return s:sub(0, #t) == t
end

local function get_region_inside(open, close)
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

local function get_paren_region()
    return get_region_inside('(', ')')
end

local function markdownEnter()
    local filename = get_paren_region()
    if filename == "" then
        return
    end
    local n = filename:find('#page=')
    if n ~= nil then
        local fname = filename:sub(1, n - 1)
        local pageno = filename:sub(n + #'#page=')
        vim.cmd('Dispatch! zathura --page=' .. pageno .. ' "' .. vim.fn.expand("%:h") .. '/' .. fname .. '"')
    elseif has_suffix(filename, ".pdf") then
        vim.cmd('Dispatch! zathura "' .. vim.fn.expand("%:h") .. '/' .. filename .. '"')
    elseif has_prefix(filename, "http://") or has_prefix(filename, "https://")  then
        vim.cmd('Dispatch! firefox "' .. filename .. '"')
    elseif has_suffix(filename, ".html") then
        vim.cmd('Dispatch! firefox "' .. vim.fn.expand("%:h") .. '/' .. filename .. '"')
    else
        vim.cmd('e ' .. vim.fn.expand("%:h") .. '/' .. filename)
    end
end

vim.keymap.set({'n'}, '<cr>', markdownEnter, {buffer = true})
