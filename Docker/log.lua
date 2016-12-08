
-- Print contents of `tbl`, with indentation.
-- `indent` sets the initial level of indentation.
function logTable (tbl, indent)
  if not indent then indent = 0 end
	for k, v in pairs(tbl) do
		formatting = string.rep("  ", indent) .. k .. ": "
		if type(v) == "table" then
			print(formatting)
			logTable(v, indent+1)
		elseif type(v) == 'boolean' then
			print(formatting .. tostring(v))
		elseif type(v) == 'function' then
			print(formatting .. '<function>') -- TODO: display the function's name
		else
			print(formatting .. v)
		end
	end
end