
-- web_utils.lua

-- Implements various utility functions related to the webadmin pages





local ins = table.insert
local con = table.concat





--- Returns the HTML-formatted error message with the specified reason
function HTMLError(a_Reason)
	return "<b style='color: #a00'>" .. a_Reason .. "</b>"
end





--- Returns a HTML string representing a form's Submit button
-- The form has the subpage hidden field added, and any hidden values in the a_HiddenValues map
-- All keys are left as-is, all values are HTML-escaped
function GetFormButton(a_SubpageName, a_ButtonText, a_HiddenValues)
	-- Check params:
	assert(type(a_SubpageName) == "string")
	assert(type(a_ButtonText) == "string")
	assert(type(a_HiddenValues or {}) == "table")
	
	local res = {"<input type='submit' value='"}
	ins(res, cWebAdmin:GetHTMLEscapedString(a_ButtonText))
	ins(res, "'/><input type='hidden' name='subpage' value='")
	ins(res, a_SubpageName)
	ins(res, "'/>")
	for k, v in pairs(a_HiddenValues) do
		ins(res, "<input type='hidden' name='")
		ins(res, k)
		ins(res, "' value='")
		ins(res, cWebAdmin:GetHTMLEscapedString(v))
		ins(res, "'/>")
	end
	
	return con(res)
end





