function HandleMOTDCommand( Split, Player )
	ShowMOTDTo( Player )
	return true
end

function LoadMotd()

	-- Check if the file 'motd.txt' exists, if not, create it with default content:
	if (not cFile:IsFile("motd.txt")) then
		CreateFile = io.open( "motd.txt", "w" )
		CreateFile:write("@6Welcome to the Cuberite test server!\n@6http://www.cuberite.org/\n@6Type /help for all commands")
		CreateFile:close()
	end

	for line in io.lines( "motd.txt" ) do
		line = line:gsub("(@.)", 
			function(a_Str)
				local Char = a_Str:sub(2, 2)
				if (Char == "@") then
					-- If the input was "@@" then simply replace it with a single "@"
					return "@"
				end
				
				local Color = ReturnColorFromChar(Char)
				if (Color) then
					return Color
				end
			end
		)
		
		table.insert(Messages, line)
	end
end

function ShowMOTDTo( Player )
	for I=1, #Messages do
		Player:SendMessage(Messages[I])
	end
end

