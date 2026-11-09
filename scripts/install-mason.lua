local packages = { "stylua", "shfmt", "tree-sitter-cli" }

require("lazy").load({ plugins = { "mason.nvim" } })

local registry = require("mason-registry")
local errors = {}

for _, name in ipairs(packages) do
	local pkg = registry.get_package(name)

	if pkg:is_installed() then
		print("[Mason] " .. name .. ": already installed")
	elseif pkg:is_installing() then
		print("[Mason] " .. name .. ": installation already running")
	else
		print("[Mason] Installing " .. name)

		pkg:install({}, function(success, err)
			if not success then
				table.insert(errors, name .. ": " .. tostring(err))
			end
		end)
	end
end

local completed = vim.wait(300000, function()
	for _, name in ipairs(packages) do
		local pkg = registry.get_package(name)
		if pkg:is_installing() then
			return false
		end
	end
	return true
end, 100)

if not completed then
	table.insert(errors, "Installation timed out after 5 minutes")
end

for _, name in ipairs(packages) do
	if not registry.get_package(name):is_installed() then
		table.insert(errors, name .. ": not installed")
	end
end

if #errors > 0 then
	for _, err in ipairs(errors) do
		io.stderr:write("[Mason] ERROR: " .. err .. "\n")
	end
	vim.cmd("cq")
else
	print("[Mason] All required packages installed successfully")
end
