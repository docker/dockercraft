function HandleRequest_ManageServer( Request )
	local Content = "" 
	if (Request.PostParams["RestartServer"] ~= nil) then
		cRoot:Get():QueueExecuteConsoleCommand("restart");
	elseif (Request.PostParams["ReloadServer"] ~= nil) then
		cRoot:Get():GetPluginManager():ReloadPlugins();
	elseif (Request.PostParams["StopServer"] ~= nil) then
		cRoot:Get():QueueExecuteConsoleCommand("stop");
	elseif (Request.PostParams["WorldSaveAllChunks"] ~= nil) then
		cRoot:Get():GetWorld(Request.PostParams["WorldSaveAllChunks"]):QueueSaveAllChunks();
	end
	Content = Content .. [[
	<form method="POST">
	<table>
	<th colspan="2">Manage Server</th>
	<tr><td><input type="submit" value="Restart Server" name="RestartServer">  restart the server</td></tr> <br />
	<tr><td><input type="submit" value="Reload Server" name="ReloadServer"> reload the server</td></tr> <br />
	<tr><td><input type="submit" value="Stop Server" name="StopServer"> stop the server</td></tr> <br />
	</th>
	</table>
	<table>
	<th colspan="2">Manage Worlds</th>
	]]
	local LoopWorlds = function( World )
		Content = Content .. [[
		<tr><td><input type="submit" value="]] .. World:GetName() .. [[" name="WorldSaveAllChunks"> Save all the chunks of world ]] .. World:GetName() .. [[</td></tr> <br />
		
		]]
	end
	cRoot:Get():ForEachWorld( LoopWorlds )
	Content = Content .. "</th></table>"
	
	return Content
end

