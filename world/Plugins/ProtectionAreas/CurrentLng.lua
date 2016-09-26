
-- CurrentLng.lua
-- This file provides all the translatable strings
-- The expectation is that the translators will create copies of this file, translate the texts and then the users will overwrite this file with a specific language version
-- Note that the individual languages must not have ".lua" extension, otherwise Cuberite will load them and the plugin won't work!





--- Messages sent to players
g_Msgs =
{
	AllUsersAlreadyAllowed     = "All the specified users were already allowed.";
	AreaAdded                  = "Area added, ID %s";
	AreaAllowed                = "Allowed";
	AreaDeleted                = "Area ID %s deleted";
	AreaNotAllowed             = "NOT allowed";
	Coords1Set                 = "Coords1 set as {%d, %d}";
	Coords2Set                 = "Coords2 set as {%d, %d}";
	ErrCmdStateNilAddArea      = "Cannot add area, internal plugin error (CmdState == nil)";
	ErrCmdStateNilListAreas    = "Cannot list areas, internal plugin error (CmdState == nil)";
	ErrDBFailAddUsers          = "Cannot add users, DB failure";
	ErrExpectedAreaID          = "Parameter mismatch. Expected <AreaID>.";
	ErrExpectedAreaIDUserName  = "Parameter mismatch. Expected <AreaID> <UserName>.";
	ErrExpectedAreaIDUsernames = "Not enough parameters. Expected <AreaID> and a list of usernames.";
	ErrExpectedCoordsUsernames = "Not enough parameters. Expected <x1> <z1> <x2> <z2> coords and a list of usernames.";
	ErrExpectedListOfUsernames = "Not enough parameters. Expected a list of usernames.";
	ErrExpectedUserName        = "Parameter mismatch. Expected <UserName>.";
	ErrListNotWanded           = "Cannot list areas, no query point has been selected. Use a ProtWand lclk / rclk to select a point first";
	ErrNoAreaWanded            = "Cannot add area, no area has been selected. Use a ProtWand lclk / rclk to select area first";
	ErrNoSpaceForWand          = "Cannot give wand, no space in your inventory";
	ErrNoSuchArea              = "No such area: %s";
	ErrParseAreaID             = "Cannot parse <AreaID>.";
	ErrParseCoords             = "Cannot parse coords.";
	ErrParseCoordsListAreas    = "Cannot list areas, cannot parse coords in params";
	ErrSyntaxErrorListAreas    = "Cannot list areas, syntax error. Expected either no params or <x> <z>.";
	ListAreasFooter            = "Area list finished";
	ListAreasHeader            = "Listing protection areas intersecting block column {%d, %d}:";
	ListAreasRow               = "  %s, %s, created by %s";
	ListUsersFooter            = "End of area %s user list, total %d users";
	ListUsersHeader            = "Area ID %s: {%d, %d} - {%d, %d}, created by %s; allowed users:";
	ListUsersRow               = "  %s";
	NotAllowedToBuild          = "You are not allowed to build here!";
	NotAllowedToDig            = "You are not allowed to dig here!";
	RemovedUser                = "Removed %s from area %d";
	RemovedUserAll             = "Removed %s from all areas";
	UsersAdded                 = "Users added: %s";
	WandGiven                  = "Wand given";
} ;





