local lyaml = require("lyaml")

local flake = require("config.system").flakeDirectory
local filepath = flake .. "/modules/theme/colors.yaml"
local file, err1 = io.open(filepath, "r")
if not file then
  error("Error opening file: " .. err1)
end

local yaml_string = file:read("*all")
file:close()

local data, err2 = lyaml.load(yaml_string)
if not data then
  error("Error parsing YAML: " .. err2)
end

return data.palette
