-- Eviline config for lualine
-- Author: shadmansaleh
-- Credit: glepnir
local lualine = require('lualine')

-- Color table for highlights
-- stylua: ignore
local colors = {
  bg       = '#202328',
  fg       = '#bbc2cf',
  yellow   = '#ECBE7B',
  cyan     = '#008080',
  darkblue = '#081633',
  green    = '#98be65',
  orange   = '#FF8800',
  violet   = '#a9a1e1',
  lilac  = '#c678dd',
  blue     = '#51afef',
  red      = '#ec5f67',
}

local conditions = {
  buffer_not_empty = function()
    return vim.fn.empty(vim.fn.expand('%:t')) ~= 1
  end,
  hide_in_width = function()
    return vim.fn.winwidth(0) > 80
  end,
  check_git_workspace = function()
    local filepath = vim.fn.expand('%:p:h')
    local gitdir = vim.fn.finddir('.git', filepath .. ';')
    return gitdir and #gitdir > 0 and #gitdir < #filepath
  end,
}

-- Config
local config = {
  options = {
    -- Disable sections and component separators
    component_separators = '',
    section_separators = '',
    theme = {
      -- We are going to use lualine_c an lualine_x as left and
      -- right section. Both are highlighted by c theme .  So we
      -- are just setting default looks o statusline
      normal = { c = { fg = colors.fg, bg = colors.bg } },
      inactive = { c = { fg = colors.fg, bg = colors.bg } },
    },
  },
  sections = {
    -- these are to remove the defaults
    lualine_a = {},
    lualine_b = {},
    lualine_y = {},
    lualine_z = {},
    -- These will be filled later
    lualine_c = {},
    lualine_x = {},
  },
  inactive_sections = {
    -- these are to remove the defaults
    lualine_a = {},
    lualine_b = {},
    lualine_y = {},
    lualine_z = {},
    lualine_c = {},
    lualine_x = {},
  },
}

-- Inserts a component in lualine_c at left section
local function ins_left(component)
  table.insert(config.sections.lualine_c, component)
end

-- Inserts a component in lualine_x at right section
local function ins_right(component)
  table.insert(config.sections.lualine_x, component)
end

local function auto_color()
    -- auto change color according to neovims mode
    local mode_color = {
      n = colors.orange,
      i = colors.green,
      v = colors.blue,
      ['␖'] = colors.blue,
      V = colors.blue,
      c = colors.lilac,
      no = colors.red,
      s = colors.red,
      S = colors.red,
      ['␓'] = colors.red,
      ic = colors.yellow,
      R = colors.violet,
      Rv = colors.violet,
      cv = colors.red,
      ce = colors.red,
      r = colors.cyan,
      rm = colors.cyan,
      ['r?'] = colors.cyan,
      ['!'] = colors.red,
      t = colors.red,
    }
    return { fg = mode_color[vim.fn.mode()] }
end

ins_left {
    function()
        return '▊'
    end,
    color = auto_color,
    padding = { left = 0, right = 0 }, -- We don't need space before this
}

ins_left {
    'location',
    color = colors.white,
    padding = { left = 0, right = 1 }, -- We don't need space before this
}

ins_left {
  'filename',
  cond = conditions.buffer_not_empty,
  color = { fg = colors.white, gui = 'bold' },
}

ins_left {
  'filesize',
  color = { fg = colors.violet, gui = 'bold' },
}

ins_right {
  'diagnostics',
  sources = { 'nvim_diagnostic' },
  symbols = { error = ' ', warn = ' ', info = ' ' },
  diagnostics_color = {
    error = { fg = colors.red },
    warn = { fg = colors.yellow },
    info = { fg = colors.cyan },
  },
}


ins_right {
  -- Lsp server name .
  function()
    local clients = vim.lsp.get_clients()
    if next(clients) == nil then
      return ''
    end
    for _, client in ipairs(clients) do
      local filetypes = client.config.filetypes
      if filetypes and vim.fn.index(filetypes, vim.bo.filetype) ~= -1 then
        return client.name
      end
    end
    return ''
  end,
  icon = '',
  color = { fg = colors.white, gui = 'bold' },
  padding = { left = 1, right = 1 }, -- We don't need space before this
}

ins_right {
    function()
        return '▊'
    end,
    color = auto_color,
    padding = { left = 0, right = 0 }, -- We don't need space before this
}

-- Now don't forget to initialize lualine
lualine.setup(config)
