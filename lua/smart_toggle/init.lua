local M = {}

local toggle_map = {
  -- Booleans (case-sensitive)
  ["true"] = "false", ["false"] = "true",
  ["True"] = "False", ["False"] = "True",
  ["TRUE"] = "FALSE", ["FALSE"] = "TRUE",

  ["yes"] = "no", ["no"] = "yes",
  ["Yes"] = "No", ["No"] = "Yes",
  ["YES"] = "NO", ["NO"] = "YES",

  ["on"] = "off", ["off"] = "on",
  ["On"] = "Off", ["Off"] = "On",
  ["ON"] = "OFF", ["OFF"] = "ON",

  -- Quotes
  ["'"] = '"', ['"'] = "'",

  -- Operators
  ["+"] = "-", ["-"] = "+",
}

local function toggle_word_at_cursor()
  local row, col = unpack(vim.api.nvim_win_get_cursor(0))
  local line = vim.api.nvim_get_current_line()

  -- Try character under cursor (e.g. quote or operator)
  local char = line:sub(col + 1, col + 1)
  if toggle_map[char] then
    local new_line = line:sub(1, col) .. toggle_map[char] .. line:sub(col + 2)
    vim.api.nvim_set_current_line(new_line)
    return
  end

  -- Otherwise, try toggling word under cursor
  local start_col = col + 1
  while start_col > 1 and line:sub(start_col - 1, start_col - 1):match("[%w_]") do
    start_col = start_col - 1
  end

  local end_col = start_col
  while end_col <= #line and line:sub(end_col, end_col):match("[%w_]") do
    end_col = end_col + 1
  end

  local word = line:sub(start_col, end_col - 1)
  local replacement = toggle_map[word]
  if not replacement then
    vim.api.nvim_feedkeys("~", "n", false)
    return
  end

  local new_line = line:sub(1, start_col - 1) .. replacement .. line:sub(end_col)
  vim.api.nvim_set_current_line(new_line)
end

local function toggle_words_in_visual()
  local start_pos = vim.fn.getpos("'<")
  local end_pos = vim.fn.getpos("'>")

  for lnum = start_pos[2], end_pos[2] do
    local line = vim.fn.getline(lnum)

    -- Toggle quotes and symbols (single/double, +/-, etc.)
    line = line:gsub("['\"+-]", toggle_map)

    -- Toggle known words
    local function word_replacer(w)
      return toggle_map[w] or w
    end
    line = line:gsub("%f[%w_](%w+)%f[^%w_]", word_replacer)

    vim.fn.setline(lnum, line)
  end
end

function M.setup()
  vim.keymap.set("n", "~", toggle_word_at_cursor, { desc = "Smart toggle under cursor" })
  vim.keymap.set("x", "~", function()
    toggle_words_in_visual()
    vim.cmd("normal! gv")
  end, { desc = "Smart toggle in selection" })
end

return M
