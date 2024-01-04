_G.utils = {}

function utils.table_except(table, keys)
  local new_table = vim.deepcopy(table)

  for _, key in pairs(keys) do
    new_table[key] = nil
  end

  return new_table
end

function utils.table_pop(table, key)
  local element = table[key]
  table[key] = nil
  return element
end

function utils.table_unique(table)
  -- make unique keys
  local hash = {}
  for _, v in ipairs(table) do
    hash[v] = true
  end

  -- transform keys back into values
  local res = {}
  for k, _ in pairs(hash) do
    res[#res + 1] = k
  end

  return res
end

-- Ensure an object is a table
function utils.table_wrap(obj)
  if type(obj) == "table" then
    return obj
  else
    return { obj }
  end
end
