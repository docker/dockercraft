return
{
	cWebAdmin =
	{
		Desc = "",
		Functions =
		{
			GetHTMLEscapedString = { Params = "string", Return = "string", Notes = "(STATIC) Gets the HTML-escaped representation of a requested string. This is useful for user input and game data that is not guaranteed to be escaped already." },
		},
	},  -- cWebAdmin


	HTTPFormData =
	{
		Desc = "This class stores data for one form element for a {{HTTPRequest|HTTP request}}.",
		Variables =
		{
			Name = { Type = "string", Notes = "Name of the form element" },
			Type = { Type = "string", Notes = "Type of the data (usually empty)" },
			Value = { Type = "string", Notes = "Value of the form element. Contains the raw data as sent by the browser." },
		},
	},  -- HTTPFormData


	HTTPRequest =
	{
		Desc = [[
			This class encapsulates all the data that is sent to the WebAdmin through one HTTP request. Plugins
			receive this class as a parameter to the function handling the web requests, as registered in the
			{{cPluginLua}}:AddWebPage().
		]],
		Constants =
		{
			FormData = { Notes = "Array-table of {{HTTPFormData}}, contains the values of individual form elements submitted by the client" },
			Params = { Notes = "Map-table of parameters given to the request in the URL (?param=value); if a form uses GET method, this is the same as FormData. For each parameter given as \"param=value\", there is an entry in the table with \"param\" as its key and \"value\" as its value." },
			PostParams = { Notes = "Map-table of data posted through a FORM - either a GET or POST method. Logically the same as FormData, but in a map-table format (for each parameter given as \"param=value\", there is an entry in the table with \"param\" as its key and \"value\" as its value)." },
		},

		Variables =
		{
			Method = { Type = "string", Notes = "The HTTP method used to make the request. Usually GET or POST." },
			Path = { Type = "string", Notes = "The Path part of the URL (excluding the parameters)" },
			URL = { Type = "string", Notes = "The entire URL used for the request." },
			Username = { Type = "string", Notes = "Name of the logged-in user." },
		},
	},  -- HTTPRequest
}




