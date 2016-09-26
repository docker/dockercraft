local CHAT_HISTORY = 50
local LastMessageID = 0

local JavaScript = [[
	<script type="text/javascript">
		function createXHR() 
		{
			var request = false;
			try {
				request = new ActiveXObject('Msxml2.XMLHTTP');
			}
			catch (err2) {
				try {
					request = new ActiveXObject('Microsoft.XMLHTTP');
				}
				catch (err3) {
					try {
						request = new XMLHttpRequest();
					}
					catch (err1) {
						request = false;
					}
				}
			}
			return request;
		}
		
		function OpenPage( url, postParams, callback ) 
		{
			var xhr = createXHR();
			xhr.onreadystatechange=function()
			{ 
				if (xhr.readyState == 4)
				{
					callback( xhr )
				} 
			}; 
			xhr.open( (postParams!=null)?"POST":"GET", url , true);
			if( postParams != null )
			{
				xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
			}
			xhr.send(postParams); 
		}

		function LoadPageInto( url, postParams, storage ) 
		{
			OpenPage( url, postParams, function( xhr ) 
			{
				var ScrollBottom = storage.scrollTop + storage.offsetHeight;
				var bAutoScroll = (ScrollBottom >= storage.scrollHeight); // Detect whether we scrolled to the bottom of the div
				
				results = xhr.responseText.split("<<divider>>");
				if( results[2] != LastMessageID ) return; // Check if this message was meant for us
				
				LastMessageID = results[1];
				if( results[0] != "" )
				{
					storage.innerHTML += results[0];
					
					if( bAutoScroll == true )
					{
						storage.scrollTop = storage.scrollHeight;
					}
				}
			} );
			
			
			return false;
		}
		
		function SendChatMessage() 
		{
			var MessageContainer = document.getElementById('ChatMessage');
			if( MessageContainer.value == "" ) return;
			
			var postParams = "ChatMessage=" + MessageContainer.value;
			OpenPage( "/~webadmin/Core/Chat/", postParams, function( xhr ) 
			{
				RefreshChat();
			} );
			MessageContainer.value = "";
		}
		
		function RefreshChat() 
		{
			var postParams = "JustChat=true&LastMessageID=" + LastMessageID;
			LoadPageInto("/~webadmin/Core/Chat/", postParams, document.getElementById('ChatDiv'));
		}
		
		setInterval(RefreshChat, 1000);
		window.onload = RefreshChat;
		
		var LastMessageID = 0;
		
	</script>
]]
-- Array of {PluginName, FunctionName} tables
local OnWebChatCallbacks = {}
local ChatLogMessages = {}
local WebCommands     = {}
local ltNormal        = 1
local ltInfo          = 2
local ltWarning       = 3
local ltError         = 4

-- Adds Webchat callback, plugins can return true to 
-- prevent message from appearing / being processed
-- by further callbacks
-- OnWebChat(Username, Message)
function AddWebChatCallback(PluginName, FunctionName) 
	for k, v in pairs(OnWebChatCallbacks) do
		if v[1] == PluginName and v[2] == FunctionName then
			return false
		end
	end
	table.insert(OnWebChatCallbacks, {PluginName, FunctionName})
	return true
end

-- Removes webchat callback
function RemoveWebChatCallback(PluginName, FunctionName) 
	for i = #OnWebChatCallbacks, 0, -1 do
		if OnWebChatCallbacks[i][1] == PluginName and OnWebChatCallbacks[i][2] == FunctionName then
			table.remove(OnWebChatCallbacks, i)
			return true
		end
	end
	return false
end


-- Checks the chatlogs to see if the size gets too big.
function TrimWebChatIfNeeded()
	while( #ChatLogMessages > CHAT_HISTORY ) do
		table.remove( ChatLogMessages, 1 )
	end
end





-- Adds a plain message to the chat log
-- The a_WebUserName parameter can be either a string(name) to send it to a certain webuser or nil to send it to every webuser.
function WEBLOG(a_Message, a_WebUserName)
	LastMessageID = LastMessageID + 1
	table.insert(ChatLogMessages, {timestamp = os.date("[%Y-%m-%d %H:%M:%S]", os.time()), webuser = a_WebUserName, message = a_Message, id = LastMessageID, logtype = ltNormal})
	TrimWebChatIfNeeded()
end





-- Adds a yellow-ish message to the chat log.
-- The a_WebUserName parameter can be either a string(name) to send it to a certain webuser or nil to send it to every webuser.
function WEBLOGINFO(a_Message, a_WebUserName)
	LastMessageID = LastMessageID + 1
	table.insert(ChatLogMessages, {timestamp = os.date("[%Y-%m-%d %H:%M:%S]", os.time()), webuser = a_WebUserName, message = a_Message, id = LastMessageID, logtype = ltInfo})
	TrimWebChatIfNeeded()
end





-- Adds a red message to the chat log
-- The a_WebUserName parameter can be either a string(name) to send it to a certain webuser or nil to send it to every webuser.
function WEBLOGWARN(a_Message, a_WebUserName)
	LastMessageID = LastMessageID + 1
	table.insert(ChatLogMessages, {timestamp = os.date("[%Y-%m-%d %H:%M:%S]", os.time()), webuser = a_WebUserName, message = a_Message, id = LastMessageID, logtype = ltWarning})
	TrimWebChatIfNeeded()
end





-- Adds a message with a red background to the chat log
-- The a_WebUserName parameter can be either a string(name) to send it to a certain webuser or nil to send it to every webuser.
function WEBLOGERROR(a_Message, a_WebUserName)
	LastMessageID = LastMessageID + 1
	table.insert(ChatLogMessages, {timestamp = os.date("[%Y-%m-%d %H:%M:%S]", os.time()), webuser = a_WebUserName, message = a_Message, id = LastMessageID, logtype = ltError})
	TrimWebChatIfNeeded()
end





-- This function allows other plugins to add new commands to the webadmin.
-- a_CommandString is the the way you call the command                                         ("/help")
-- a_HelpString is the message that tells you what the command does                            ("Shows a list of all the possible commands")
-- a_PluginName is the name of the plugin binding the command                                  ("Core")
-- a_CallbackName is the name if the function that will be called when the command is executed ("HandleWebHelpCommand")
function BindWebCommand(a_CommandString, a_HelpString, a_PluginName, a_CallbackName)
	assert(type(a_CommandString) == 'string')
	assert(type(a_PluginName) == 'string')
	assert(type(a_CallbackName) == 'string')
	
	-- Check if the command is already bound. Return false with an error message if.
	for Idx, CommandInfo in ipairs(WebCommands) do
		if (CommandInfo.Command == a_CommandString) then
			return false, "That command is already bound to a plugin called \"" .. CommandInfo.PluginName .. "\"."
		end
	end
	
	-- Insert the command into the array and return true
	table.insert(WebCommands, {CommandString = a_CommandString, HelpString = a_HelpString, PluginName = a_PluginName, CallbackName = a_CallbackName})
	return true
end





-- Used by the webadmin to use /help
function HandleWebHelpCommand(a_User, a_Message)
	local Content = "Available Commands:"
	for Idx, CommandInfo in ipairs(WebCommands) do
		if (CommandInfo.HelpString ~= "") then
			Content = Content .. '<br />' .. CommandInfo.CommandString .. '&ensp; - &ensp;' .. CommandInfo.HelpString
		end
	end
	
	WEBLOG(Content, a_User)
	return true
end





-- Used by the webadmin to reload the server
function HandleWebReloadCommand(a_User, a_Message)
	cPluginManager:Get():ReloadPlugins()
	WEBLOG("Reloading Plugins", a_User)
	return true
end





-- Register some basic commands
BindWebCommand("/help", "Shows a list of all the possible commands", "Core", "HandleWebHelpCommand")
BindWebCommand("/reload", "Reloads all the plugins", "Core", "HandleWebReloadCommand")





-- Add a chatmessage from a player to the chatlog
function OnChat(a_Player, a_Message)
	WEBLOG("[" .. a_Player:GetName() .. "]: " .. a_Message)
end





--- Removes html tags
--- Creates a tag when http(s) links are send.
--- It does this by selecting all the characters between "http(s)://" and a space, and puts an anker tag around it.
local function ParseMessage(a_Message)
	local function PlaceString(a_Url)
		return '<a href="' .. a_Url .. '" target="_blank">' .. a_Url .. '</a>'
	end
	
	a_Message = a_Message:gsub("<", "&lt;"):gsub(">", "&gt;"):gsub("=", "&#61;"):gsub('"', 	"&#34;"):gsub("'", "&#39;"):gsub("&", "&amp;")
	a_Message = a_Message:gsub('http://[^%s]+', PlaceString):gsub('https://[^%s]+', PlaceString)
	return a_Message
end





function HandleRequest_Chat( Request )
	-- The webadmin asks if there are new messages.
	if( Request.PostParams["JustChat"] ~= nil ) then
		local LastIdx = tonumber(Request.PostParams["LastMessageID"] or 0) or 0
		local Content = ""
		
		-- Go through each message to see if they are older then the last message, and add them to the content
		for key, MessageInfo in pairs(ChatLogMessages) do 
			if( MessageInfo.id > LastIdx ) then
				if (not MessageInfo.webuser or (MessageInfo.webuser == Request.Username)) then
					local Message = MessageInfo.timestamp .. ' ' .. ParseMessage(MessageInfo.message)
					if (MessageInfo.logtype == ltNormal) then
						Content = Content .. Message .. "<br />"
					elseif (MessageInfo.logtype == ltInfo) then
						Content = Content .. '<span style="color: #FE9A2E;">' .. Message .. '</span><br />'
					elseif (MessageInfo.logtype == ltWarning) then
						Content = Content .. '<span style="color: red;">' .. Message .. '</span><br />'
					elseif (MessageInfo.logtype == ltError) then
						Content = Content .. '<span style="background-color: red; color: black;">' .. Message .. '</span><br />'
					end
				end
			end
		end
		Content = Content .. "<<divider>>" .. LastMessageID .. "<<divider>>" .. LastIdx
		return Content
	end
	
	-- Check if the webuser send a chat message.
	if( Request.PostParams["ChatMessage"] ~= nil ) then
		local Split = StringSplit(Request.PostParams["ChatMessage"])
		local CommandExecuted = false
		
		-- Check if the message was actualy a command
		for Idx, CommandInfo in ipairs(WebCommands) do
			if (CommandInfo.CommandString == Split[1]) then
				-- cPluginManager:CallPlugin doesn't support calling yourself, so we have to check if the command is from the Core.
				if (CommandInfo.PluginName == "Core") then
					if (not _G[CommandInfo.CallbackName](Request.Username, Request.PostParams["ChatMessage"])) then
						WEBLOG("Something went wrong while calling \"" .. CommandInfo.CallbackName .. "\" From \"" .. CommandInfo.PluginName .. "\".", Request.Username)
					end
				else
					if (not cPluginManager:CallPlugin(CommandInfo.PluginName, CommandInfo.CallbackName, Request.Username, Request.PostParams["ChatMessage"])) then
						WEBLOG("Something went wrong while calling \"" .. CommandInfo.CallbackName .. "\" From \"" .. CommandInfo.PluginName .. "\".", Request.Username)
					end
				end
				return ""
			end
		end
		
		-- If the message starts with a '/' then the message is a command, but since it wasn't executed a few lines above the command didn't exist
		if (Request.PostParams["ChatMessage"]:sub(1, 1) == "/") then
			WEBLOG('Unknown Command "' .. Request.PostParams["ChatMessage"] .. '"', nil)
			return ""
		end
		
		-- Broadcast the message to the server
		for k, v in pairs(OnWebChatCallbacks) do
			if cPluginManager:CallPlugin(v[1], v[2], Request.Username, Request.PostParams["ChatMessage"]) then
				return ""
			end
		end
		cRoot:Get():BroadcastChat(cCompositeChat("[WEB] <" .. Request.Username .. "> " .. Request.PostParams["ChatMessage"]):UnderlineUrls())
		
		-- Add the message to the chatlog
		WEBLOG("[WEB] [" .. Request.Username .. "]: " .. Request.PostParams["ChatMessage"])
		return ""
	end

	local Content = JavaScript
	Content = Content .. [[
	<div style="font-family: Courier; border: 1px solid #DDD; padding: 10px; width: 97%; height: 400px; overflow: scroll;" id="ChatDiv"></div>
	<input type="text" id="ChatMessage" onKeyPress="if (event.keyCode == 13) { SendChatMessage(); }"><input type="submit" value="Submit" onClick="SendChatMessage();">
	]]
	return Content
end
