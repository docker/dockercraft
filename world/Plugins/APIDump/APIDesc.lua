return
{
	Classes =
	{
		--[[
		-- What the APIDump plugin understands / how to document stuff:
		ExampleClassName =
		{
			Desc = "Description, exported as the first paragraph of the class page. Usually enclosed within double brackets."

			Functions =
			{
				FunctionName =
				{
					{
						Params =
						{
							{ Name = "BuiltInType", Type = "number"},
							{ Name = "ClassEnum", Type = "cClass#eEnum"},
							{ Name = "GlobalEnum", Type = "eEnum"},
						},
						Returns =
						{
							{ Type = "number" },
							{ Type = "self" },  -- Returns the same object on which it was called
						},
						Notes = "Notes 1"
					},
					{
						Params = {...},
						Returns = {...},
						Notes = "Notes 2",
					},
				},
			} ,

			Constants =
			{
				ConstantName = { Notes = "Notes about the constant" },
			} ,

			ConstantGroups =
			{
				eEnum =  -- also used as the HTML anchor name
				{
					Include = {"constant1", "constant2", "const_.*"},  -- Constants to include in this group, array of identifiers, accepts wildcards
					TextBefore = "This text will be written in front of the constant list",
					TextAfter = "This text will be written after the constant list",
					ShowInDescendants = false,  -- If false, descendant classes won't list these constants
				}
			},

			Variables =
			{
				VariableName = { Type = "string", Notes = "Notes about the variable" },
			} ,

			AdditionalInfo =  -- Paragraphs to be exported after the function definitions table
			{
				{
					Header = "Header 1",
					Contents = "Contents of the additional section 1",
				},
				{
					Header = "Header 2",
					Contents = "Contents of the additional section 2",
				}
			},

			Inherits = "ParentClassName",  -- Only present if the class inherits from another API class
		},
		--]]

		cBlockArea =
		{
			Desc = [[
				This class is used when multiple adjacent blocks are to be manipulated. Because of chunking
				and multithreading, manipulating single blocks using {{cWorld|cWorld:SetBlock}}() is a rather
				time-consuming operation (locks for exclusive access need to be obtained, chunk lookup is done
				for each block), so whenever you need to manipulate multiple adjacent blocks, it's better to wrap
				the operation into a cBlockArea access. cBlockArea is capable of reading / writing across chunk
				boundaries, has no chunk lookups for get and set operations and is not subject to multithreading
				locking (because it is not shared among threads).</p>
				<p>
				cBlockArea remembers its origin (MinX, MinY, MinZ coords in the Read() call) and therefore supports
				absolute as well as relative get / set operations. Despite that, the contents of a cBlockArea can
				be written back into the world at any coords.</p>
				<p>
				cBlockArea can hold any combination of the following datatypes:<ul>
					<li>block types</li>
					<li>block metas</li>
					<li>blocklight</li>
					<li>skylight</li>
				</ul>
				Read() and Write() functions have parameters that tell the class which datatypes to read / write.
				Note that a datatype that has not been read cannot be written (FIXME).</p>
				<p>
				Typical usage:<ul>
					<li>Create cBlockArea object</li>
					<li>Read an area from the world / load from file / create anew</li>
					<li>Modify blocks inside cBlockArea</li>
					<li>Write the area back to a world / save to file</li>
				</ul></p>
			]],
			Functions =
			{
				Clear =
				{
					Notes = "Clears the object, resets it to zero size",
				},
				constructor =
				{
					Returns =
					{
						{
							Type = "cBlockArea",
						},
					},
					Notes = "Creates a new empty cBlockArea object",
				},
				CopyFrom =
				{
					Params =
					{
						{
							Name = "BlockAreaSrc",
							Type = "cBlockArea",
						},
					},
					Notes = "Copies contents from BlockAreaSrc into self",
				},
				CopyTo =
				{
					Params =
					{
						{
							Name = "BlockAreaDst",
							Type = "cBlockArea",
						},
					},
					Notes = "Copies contents from self into BlockAreaDst.",
				},
				CountNonAirBlocks =
				{
					Returns =
					{
						{
							Type = "number",
						},
					},
					Notes = "Returns the count of blocks that are not air. Returns 0 if blocktypes not available. Block metas are ignored (if present, air with any meta is still considered air).",
				},
				CountSpecificBlocks =
				{
					{
						Params =
						{
							{
								Name = "BlockType",
								Type = "number",
							},
						},
						Returns =
						{
							{
								Type = "number",
							},
						},
						Notes = "Counts the number of occurences of the specified blocktype contained in the area.",
					},
					{
						Params =
						{
							{
								Name = "BlockType",
								Type = "number",
							},
							{
								Name = "BlockMeta",
								Type = "number",
							},
						},
						Returns =
						{
							{
								Type = "number",
							},
						},
						Notes = "Counts the number of occurrences of the specified blocktype + blockmeta combination contained in the area.",
					},
				},
				Create =
				{
					{
						Params =
						{
							{
								Name = "SizeX",
								Type = "number",
							},
							{
								Name = "SizeY",
								Type = "number",
							},
							{
								Name = "SizeZ",
								Type = "number",
							},
						},
						Notes = "Initializes this BlockArea to an empty area of the specified size and origin of {0, 0, 0}. Datatypes are set to baTypes + baMetas. Any previous contents are lost.",
					},
					{
						Params =
						{
							{
								Name = "SizeX",
								Type = "number",
							},
							{
								Name = "SizeY",
								Type = "number",
							},
							{
								Name = "SizeZ",
								Type = "number",
							},
							{
								Name = "DataTypes",
								Type = "string",
							},
						},
						Notes = "Initializes this BlockArea to an empty area of the specified size and origin of {0, 0, 0}. Any previous contents are lost.",
					},
					{
						Params =
						{
							{
								Name = "Size",
								Type = "Vector3i",
							},
						},
						Notes = "Creates a new area of the specified size. Datatypes are set to baTypes + baMetas. Origin is set to all zeroes. BlockTypes are set to air, block metas to zero, blocklights to zero and skylights to full light.",
					},
					{
						Params =
						{
							{
								Name = "Size",
								Type = "Vector3i",
							},
							{
								Name = "DataTypes",
								Type = "string",
							},
						},
						Notes = "Creates a new area of the specified size and contents. Origin is set to all zeroes. BlockTypes are set to air, block metas to zero, blocklights to zero and skylights to full light.",
					},
				},
				Crop =
				{
					Params =
					{
						{
							Name = "AddMinX",
							Type = "number",
						},
						{
							Name = "SubMaxX",
							Type = "number",
						},
						{
							Name = "AddMinY",
							Type = "number",
						},
						{
							Name = "SubMaxY",
							Type = "number",
						},
						{
							Name = "AddMinZ",
							Type = "number",
						},
						{
							Name = "SubMaxZ",
							Type = "number",
						},
					},
					Notes = "Crops the specified number of blocks from each border. Modifies the size of this blockarea object.",
				},
				DumpToRawFile =
				{
					Params =
					{
						{
							Name = "FileName",
							Type = "string",
						},
					},
					Notes = "Dumps the raw data into a file. For debugging purposes only.",
				},
				Expand =
				{
					Params =
					{
						{
							Name = "SubMinX",
							Type = "number",
						},
						{
							Name = "AddMaxX",
							Type = "number",
						},
						{
							Name = "SubMinY",
							Type = "number",
						},
						{
							Name = "AddMaxY",
							Type = "number",
						},
						{
							Name = "SubMinZ",
							Type = "number",
						},
						{
							Name = "AddMaxZ",
							Type = "number",
						},
					},
					Notes = "Expands the specified number of blocks from each border. Modifies the size of this blockarea object. New blocks created with this operation are filled with zeroes.",
				},
				Fill =
				{
					Params =
					{
						{
							Name = "DataTypes",
							Type = "string",
						},
						{
							Name = "BlockType",
							Type = "number",
						},
						{
							Name = "BlockMeta",
							Type = "number",
							IsOptional = true,
						},
						{
							Name = "BlockLight",
							Type = "number",
							IsOptional = true,
						},
						{
							Name = "BlockSkyLight",
							Type = "number",
							IsOptional = true,
						},
					},
					Notes = "Fills the entire block area with the same values, specified. Uses the DataTypes param to determine which content types are modified.",
				},
				FillRelCuboid =
				{
					{
						Params =
						{
							{
								Name = "RelCuboid",
								Type = "cCuboid",
							},
							{
								Name = "DataTypes",
								Type = "string",
							},
							{
								Name = "BlockType",
								Type = "number",
							},
							{
								Name = "BlockMeta",
								Type = "number",
								IsOptional = true,
							},
							{
								Name = "BlockLight",
								Type = "number",
								IsOptional = true,
							},
							{
								Name = "BlockSkyLight",
								Type = "number",
								IsOptional = true,
							},
						},
						Notes = "Fills the specified cuboid (in relative coords) with the same values (like Fill() ).",
					},
					{
						Params =
						{
							{
								Name = "MinRelX",
								Type = "number",
							},
							{
								Name = "BlockLight",
								Type = "number",
								IsOptional = true,
							},
							{
								Name = "BlockSkyLight",
								Type = "number",
								IsOptional = true,
							},
							{
								Name = "MaxRelX",
								Type = "number",
							},
							{
								Name = "MinRelY",
								Type = "number",
							},
							{
								Name = "MaxRelY",
								Type = "number",
							},
							{
								Name = "MinRelZ",
								Type = "number",
							},
							{
								Name = "MaxRelZ",
								Type = "number",
							},
							{
								Name = "DataTypes",
								Type = "string",
							},
							{
								Name = "BlockType",
								Type = "number",
							},
							{
								Name = "BlockMeta",
								Type = "number",
								IsOptional = true,
							},
						},
						Notes = "Fills the specified cuboid with the same values (like Fill() ).",
					},
				},
				GetBlockLight =
				{
					Params =
					{
						{
							Name = "BlockX",
							Type = "number",
						},
						{
							Name = "BlockY",
							Type = "number",
						},
						{
							Name = "BlockZ",
							Type = "number",
						},
					},
					Returns =
					{
						{
							Name = "NIBBLETYPE",
							Type = "number",
						},
					},
					Notes = "Returns the blocklight at the specified absolute coords",
				},
				GetBlockMeta =
				{
					Params =
					{
						{
							Name = "BlockX",
							Type = "number",
						},
						{
							Name = "BlockY",
							Type = "number",
						},
						{
							Name = "BlockZ",
							Type = "number",
						},
					},
					Returns =
					{
						{
							Name = "NIBBLETYPE",
							Type = "number",
						},
					},
					Notes = "Returns the block meta at the specified absolute coords",
				},
				GetBlockSkyLight =
				{
					Params =
					{
						{
							Name = "BlockX",
							Type = "number",
						},
						{
							Name = "BlockY",
							Type = "number",
						},
						{
							Name = "BlockZ",
							Type = "number",
						},
					},
					Returns =
					{
						{
							Name = "NIBBLETYPE",
							Type = "number",
						},
					},
					Notes = "Returns the skylight at the specified absolute coords",
				},
				GetBlockType =
				{
					Params =
					{
						{
							Name = "BlockX",
							Type = "number",
						},
						{
							Name = "BlockY",
							Type = "number",
						},
						{
							Name = "BlockZ",
							Type = "number",
						},
					},
					Returns =
					{
						{
							Name = "BLOCKTYPE",
							Type = "number",
						},
					},
					Notes = "Returns the block type at the specified absolute coords",
				},
				GetBlockTypeMeta =
				{
					Params =
					{
						{
							Name = "BlockX",
							Type = "number",
						},
						{
							Name = "BlockY",
							Type = "number",
						},
						{
							Name = "BlockZ",
							Type = "number",
						},
					},
					Returns =
					{
						{
							Name = "BLOCKTYPE",
							Type = "number",
						},
						{
							Name = "NIBBLETYPE",
							Type = "number",
						},
					},
					Notes = "Returns the block type and meta at the specified absolute coords",
				},
				GetCoordRange =
				{
					Returns =
					{
						{
							Name = "MaxX",
							Type = "number",
						},
						{
							Name = "MaxY",
							Type = "number",
						},
						{
							Name = "MaxZ",
							Type = "number",
						},
					},
					Notes = "Returns the maximum relative coords in all 3 axes. See also GetSize().",
				},
				GetDataTypes =
				{
					Returns =
					{
						{
							Type = "number",
						},
					},
					Notes = "Returns the mask of datatypes that the object is currently holding",
				},
				GetNonAirCropRelCoords =
				{
					Params =
					{
						{
							Name = "IgnoredBlockType",
							Type = "number",
							IsOptional = true,
						},
					},
					Returns =
					{
						{
							Name = "MinRelX",
							Type = "number",
						},
						{
							Name = "MinRelY",
							Type = "number",
						},
						{
							Name = "MinRelZ",
							Type = "number",
						},
						{
							Name = "MaxRelX",
							Type = "number",
						},
						{
							Name = "MaxRelY",
							Type = "number",
						},
						{
							Name = "MaxRelZ",
							Type = "number",
						},
					},
					Notes = "Returns the minimum and maximum coords in each direction for the first block in each direction of type different to IgnoredBlockType (E_BLOCK_AIR by default). If there are no non-ignored blocks within the area, or blocktypes are not present, the returned values are reverse-ranges (MinX <- m_RangeX, MaxX <- 0 etc.). IgnoreBlockType defaults to air.",
				},
				GetOrigin =
				{
					Returns =
					{
						{
							Name = "OriginX",
							Type = "number",
						},
						{
							Name = "OriginY",
							Type = "number",
						},
						{
							Name = "OriginZ",
							Type = "number",
						},
					},
					Notes = "Returns the origin coords of where the area was read from.",
				},
				GetOriginX =
				{
					Returns =
					{
						{
							Type = "number",
						},
					},
					Notes = "Returns the origin x-coord",
				},
				GetOriginY =
				{
					Returns =
					{
						{
							Type = "number",
						},
					},
					Notes = "Returns the origin y-coord",
				},
				GetOriginZ =
				{
					Returns =
					{
						{
							Type = "number",
						},
					},
					Notes = "Returns the origin z-coord",
				},
				GetRelBlockLight =
				{
					Params =
					{
						{
							Name = "RelBlockX",
							Type = "number",
						},
						{
							Name = "RelBlockY",
							Type = "number",
						},
						{
							Name = "RelBlockZ",
							Type = "number",
						},
					},
					Returns =
					{
						{
							Name = "NIBBLETYPE",
							Type = "number",
						},
					},
					Notes = "Returns the blocklight at the specified relative coords",
				},
				GetRelBlockMeta =
				{
					Params =
					{
						{
							Name = "RelBlockX",
							Type = "number",
						},
						{
							Name = "RelBlockY",
							Type = "number",
						},
						{
							Name = "RelBlockZ",
							Type = "number",
						},
					},
					Returns =
					{
						{
							Name = "NIBBLETYPE",
							Type = "number",
						},
					},
					Notes = "Returns the block meta at the specified relative coords",
				},
				GetRelBlockSkyLight =
				{
					Params =
					{
						{
							Name = "RelBlockX",
							Type = "number",
						},
						{
							Name = "RelBlockY",
							Type = "number",
						},
						{
							Name = "RelBlockZ",
							Type = "number",
						},
					},
					Returns =
					{
						{
							Name = "NIBBLETYPE",
							Type = "number",
						},
					},
					Notes = "Returns the skylight at the specified relative coords",
				},
				GetRelBlockType =
				{
					Params =
					{
						{
							Name = "RelBlockX",
							Type = "number",
						},
						{
							Name = "RelBlockY",
							Type = "number",
						},
						{
							Name = "RelBlockZ",
							Type = "number",
						},
					},
					Returns =
					{
						{
							Name = "BLOCKTYPE",
							Type = "number",
						},
					},
					Notes = "Returns the block type at the specified relative coords",
				},
				GetRelBlockTypeMeta =
				{
					Params =
					{
						{
							Name = "RelBlockX",
							Type = "number",
						},
						{
							Name = "RelBlockY",
							Type = "number",
						},
						{
							Name = "RelBlockZ",
							Type = "number",
						},
					},
					Returns =
					{
						{
							Name = "BLOCKTYPE",
							Type = "number",
						},
						{
							Name = "NIBBLETYPE",
							Type = "number",
						},
					},
					Notes = "Returns the block type and meta at the specified relative coords",
				},
				GetSize =
				{
					Returns =
					{
						{
							Name = "SizeX",
							Type = "number",
						},
						{
							Name = "SizeY",
							Type = "number",
						},
						{
							Name = "SizeZ",
							Type = "number",
						},
					},
					Notes = "Returns the size of the area in all 3 axes. See also GetCoordRange().",
				},
				GetSizeX =
				{
					Returns =
					{
						{
							Type = "number",
						},
					},
					Notes = "Returns the size of the held data in the x-axis",
				},
				GetSizeY =
				{
					Returns =
					{
						{
							Type = "number",
						},
					},
					Notes = "Returns the size of the held data in the y-axis",
				},
				GetSizeZ =
				{
					Returns =
					{
						{
							Type = "number",
						},
					},
					Notes = "Returns the size of the held data in the z-axis",
				},
				GetVolume =
				{
					Returns =
					{
						{
							Type = "number",
						},
					},
					Notes = "Returns the volume of the area - the total number of blocks stored within.",
				},
				GetWEOffset =
				{
					Returns =
					{
						{
							Type = "Vector3i",
						},
					},
					Notes = "Returns the WE offset, a data value sometimes stored in the schematic files. Cuberite doesn't use this value, but provides access to it using this method. The default is {0, 0, 0}.",
				},
				HasBlockLights =
				{
					Returns =
					{
						{
							Type = "boolean",
						},
					},
					Notes = "Returns true if current datatypes include blocklight",
				},
				HasBlockMetas =
				{
					Returns =
					{
						{
							Type = "boolean",
						},
					},
					Notes = "Returns true if current datatypes include block metas",
				},
				HasBlockSkyLights =
				{
					Returns =
					{
						{
							Type = "boolean",
						},
					},
					Notes = "Returns true if current datatypes include skylight",
				},
				HasBlockTypes =
				{
					Returns =
					{
						{
							Type = "boolean",
						},
					},
					Notes = "Returns true if current datatypes include block types",
				},
				LoadFromSchematicFile =
				{
					Params =
					{
						{
							Name = "FileName",
							Type = "string",
						},
					},
					Notes = "Clears current content and loads new content from the specified schematic file. Returns true if successful. Returns false and logs error if unsuccessful, old content is preserved in such a case.",
				},
				LoadFromSchematicString =
				{
					Params =
					{
						{
							Name = "SchematicData",
							Type = "string",
						},
					},
					Notes = "Clears current content and loads new content from the specified string (assumed to contain .schematic data). Returns true if successful. Returns false and logs error if unsuccessful, old content is preserved in such a case.",
				},
				Merge =
				{
					{
						Params =
						{
							{
								Name = "BlockAreaSrc",
								Type = "cBlockArea",
							},
							{
								Name = "RelMinCoords",
								Type = "number",
							},
							{
								Name = "Strategy",
								Type = "string",
							},
						},
						Notes = "Merges BlockAreaSrc into this object at the specified relative coords, using the specified strategy",
					},
					{
						Params =
						{
							{
								Name = "BlockAreaSrc",
								Type = "cBlockArea",
							},
							{
								Name = "RelX",
								Type = "number",
							},
							{
								Name = "RelY",
								Type = "number",
							},
							{
								Name = "RelZ",
								Type = "number",
							},
							{
								Name = "Strategy",
								Type = "string",
							},
						},
						Notes = "Merges BlockAreaSrc into this object at the specified relative coords, using the specified strategy",
					},
				},
				MirrorXY =
				{
					Notes = "Mirrors this block area around the XY plane. Modifies blocks' metas (if present) to match (i. e. furnaces facing the opposite direction).",
				},
				MirrorXYNoMeta =
				{
					Notes = "Mirrors this block area around the XY plane. Doesn't modify blocks' metas.",
				},
				MirrorXZ =
				{
					Notes = "Mirrors this block area around the XZ plane. Modifies blocks' metas (if present)",
				},
				MirrorXZNoMeta =
				{
					Notes = "Mirrors this block area around the XZ plane. Doesn't modify blocks' metas.",
				},
				MirrorYZ =
				{
					Notes = "Mirrors this block area around the YZ plane. Modifies blocks' metas (if present)",
				},
				MirrorYZNoMeta =
				{
					Notes = "Mirrors this block area around the YZ plane. Doesn't modify blocks' metas.",
				},
				Read =
				{
					{
						Params =
						{
							{
								Name = "World",
								Type = "cWorld",
							},
							{
								Name = "Cuboid",
								Type = "cCuboid",
							},
						},
						Returns =
						{
							{
								Name = "IsSuccess",
								Type = "boolean",
							},
						},
						Notes = "Reads the area from World, returns true if successful. baTypes and baMetas are read.",
					},
					{
						Params =
						{
							{
								Name = "World",
								Type = "cWorld",
							},
							{
								Name = "Cuboid",
								Type = "cCuboid",
							},
							{
								Name = "DataTypes",
								Type = "number",
							},
						},
						Returns =
						{
							{
								Name = "IsSuccess",
								Type = "boolean",
							},
						},
						Notes = "Reads the area from World, returns true if successful. DataTypes is the sum of baXXX datatypes to be read",
					},
					{
						Params =
						{
							{
								Name = "World",
								Type = "cWorld",
							},
							{
								Name = "Point1",
								Type = "Vector3i",
							},
							{
								Name = "Point2",
								Type = "Vector3i",
							},
						},
						Returns =
						{
							{
								Name = "IsSuccess",
								Type = "boolean",
							},
						},
						Notes = "Reads the area from World, returns true if successful. baTypes and baMetas are read.",
					},
					{
						Params =
						{
							{
								Name = "World",
								Type = "cWorld",
							},
							{
								Name = "Point1",
								Type = "Vector3i",
							},
							{
								Name = "Point2",
								Type = "Vector3i",
							},
							{
								Name = "DataTypes",
								Type = "number",
							},
						},
						Returns =
						{
							{
								Name = "IsSuccess",
								Type = "boolean",
							},
						},
						Notes = "Reads the area from World, returns true if successful. DataTypes is a sum of baXXX datatypes to be read.",
					},
					{
						Params =
						{
							{
								Name = "World",
								Type = "cWorld",
							},
							{
								Name = "MinX",
								Type = "number",
							},
							{
								Name = "MaxX",
								Type = "number",
							},
							{
								Name = "MinY",
								Type = "number",
							},
							{
								Name = "MaxY",
								Type = "number",
							},
							{
								Name = "MinZ",
								Type = "number",
							},
							{
								Name = "MaxZ",
								Type = "number",
							},
						},
						Returns =
						{
							{
								Type = "boolean",
							},
						},
						Notes = "Reads the area from World, returns true if successful. baTypes and baMetas are read.",
					},
					{
						Params =
						{
							{
								Name = "World",
								Type = "cWorld",
							},
							{
								Name = "MinX",
								Type = "number",
							},
							{
								Name = "MaxX",
								Type = "number",
							},
							{
								Name = "MinY",
								Type = "number",
							},
							{
								Name = "MaxY",
								Type = "number",
							},
							{
								Name = "MinZ",
								Type = "number",
							},
							{
								Name = "MaxZ",
								Type = "number",
							},
							{
								Name = "DataTypes",
								Type = "number",
							},
						},
						Returns =
						{
							{
								Type = "boolean",
							},
						},
						Notes = "Reads the area from World, returns true if successful. DataTypes is a sum of baXXX datatypes to read.",
					},
				},
				RelLine =
				{
					{
						Params =
						{
							{
								Name = "RelPoint1",
								Type = "Vector3i",
							},
							{
								Name = "RelPoint2",
								Type = "Vector3i",
							},
							{
								Name = "DataTypes",
								Type = "number",
							},
							{
								Name = "BlockType",
								Type = "number",
							},
							{
								Name = "BlockMeta",
								Type = "number",
								IsOptional = true,
							},
							{
								Name = "BlockLight",
								Type = "number",
								IsOptional = true,
							},
							{
								Name = "BlockSkyLight",
								Type = "number",
								IsOptional = true,
							},
						},
						Notes = "Draws a line between the two specified points. Sets only datatypes specified by DataTypes (baXXX constants).",
					},
					{
						Params =
						{
							{
								Name = "RelX1",
								Type = "number",
							},
							{
								Name = "BlockLight",
								Type = "number",
								IsOptional = true,
							},
							{
								Name = "BlockSkyLight",
								Type = "number",
								IsOptional = true,
							},
							{
								Name = "RelY1",
								Type = "number",
							},
							{
								Name = "RelZ1",
								Type = "number",
							},
							{
								Name = "RelX2",
								Type = "number",
							},
							{
								Name = "RelY2",
								Type = "number",
							},
							{
								Name = "RelZ2",
								Type = "number",
							},
							{
								Name = "DataTypes",
								Type = "string",
							},
							{
								Name = "BlockType",
								Type = "number",
							},
							{
								Name = "BlockMeta",
								Type = "number",
								IsOptional = true,
							},
						},
						Notes = "Draws a line between the two specified points. Sets only datatypes specified by DataTypes (baXXX constants).",
					},
				},
				RotateCCW =
				{
					Notes = "Rotates the block area around the Y axis, counter-clockwise (east -> north). Modifies blocks' metas (if present) to match.",
				},
				RotateCCWNoMeta =
				{
					Notes = "Rotates the block area around the Y axis, counter-clockwise (east -> north). Doesn't modify blocks' metas.",
				},
				RotateCW =
				{
					Notes = "Rotates the block area around the Y axis, clockwise (north -> east). Modifies blocks' metas (if present) to match.",
				},
				RotateCWNoMeta =
				{
					Notes = "Rotates the block area around the Y axis, clockwise (north -> east). Doesn't modify blocks' metas.",
				},
				SaveToSchematicFile =
				{
					Params =
					{
						{
							Name = "FileName",
							Type = "string",
						},
					},
					Returns =
					{
						{
							Type = "boolean",
						},
					},
					Notes = "Saves the current contents to a schematic file. Returns true if successful.",
				},
				SaveToSchematicString =
				{
					Returns =
					{
						{
							Type = "string",
						},
					},
					Notes = "Saves the current contents to a string (in a .schematic file format). Returns the data if successful, nil if failed.",
				},
				SetBlockLight =
				{
					Params =
					{
						{
							Name = "BlockX",
							Type = "number",
						},
						{
							Name = "BlockY",
							Type = "number",
						},
						{
							Name = "BlockZ",
							Type = "number",
						},
						{
							Name = "BlockLight",
							Type = "number",
						},
					},
					Notes = "Sets the blocklight at the specified absolute coords",
				},
				SetBlockMeta =
				{
					Params =
					{
						{
							Name = "BlockX",
							Type = "number",
						},
						{
							Name = "BlockY",
							Type = "number",
						},
						{
							Name = "BlockZ",
							Type = "number",
						},
						{
							Name = "BlockMeta",
							Type = "number",
						},
					},
					Notes = "Sets the block meta at the specified absolute coords",
				},
				SetBlockSkyLight =
				{
					Params =
					{
						{
							Name = "BlockX",
							Type = "number",
						},
						{
							Name = "BlockY",
							Type = "number",
						},
						{
							Name = "BlockZ",
							Type = "number",
						},
						{
							Name = "BlockSkyLight",
							Type = "number",
						},
					},
					Notes = "Sets the skylight at the specified absolute coords",
				},
				SetBlockType =
				{
					Params =
					{
						{
							Name = "BlockX",
							Type = "number",
						},
						{
							Name = "BlockY",
							Type = "number",
						},
						{
							Name = "BlockZ",
							Type = "number",
						},
						{
							Name = "BlockType",
							Type = "number",
						},
					},
					Notes = "Sets the block type at the specified absolute coords",
				},
				SetBlockTypeMeta =
				{
					Params =
					{
						{
							Name = "BlockX",
							Type = "number",
						},
						{
							Name = "BlockY",
							Type = "number",
						},
						{
							Name = "BlockZ",
							Type = "number",
						},
						{
							Name = "BlockType",
							Type = "number",
						},
						{
							Name = "BlockMeta",
							Type = "number",
						},
					},
					Notes = "Sets the block type and meta at the specified absolute coords",
				},
				SetOrigin =
				{
					{
						Params =
						{
							{
								Name = "Origin",
								Type = "Vector3i",
							},
						},
						Notes = "Resets the origin for the absolute coords. Only affects how absolute coords are translated into relative coords.",
					},
					{
						Params =
						{
							{
								Name = "OriginX",
								Type = "number",
							},
							{
								Name = "OriginY",
								Type = "number",
							},
							{
								Name = "OriginZ",
								Type = "number",
							},
						},
						Notes = "Resets the origin for the absolute coords. Only affects how absolute coords are translated into relative coords.",
					},
				},
				SetRelBlockLight =
				{
					Params =
					{
						{
							Name = "RelBlockX",
							Type = "number",
						},
						{
							Name = "RelBlockY",
							Type = "number",
						},
						{
							Name = "RelBlockZ",
							Type = "number",
						},
						{
							Name = "BlockLight",
							Type = "number",
						},
					},
					Notes = "Sets the blocklight at the specified relative coords",
				},
				SetRelBlockMeta =
				{
					Params =
					{
						{
							Name = "RelBlockX",
							Type = "number",
						},
						{
							Name = "RelBlockY",
							Type = "number",
						},
						{
							Name = "RelBlockZ",
							Type = "number",
						},
						{
							Name = "BlockMeta",
							Type = "number",
						},
					},
					Notes = "Sets the block meta at the specified relative coords",
				},
				SetRelBlockSkyLight =
				{
					Params =
					{
						{
							Name = "RelBlockX",
							Type = "number",
						},
						{
							Name = "RelBlockY",
							Type = "number",
						},
						{
							Name = "RelBlockZ",
							Type = "number",
						},
						{
							Name = "BlockSkyLight",
							Type = "number",
						},
					},
					Notes = "Sets the skylight at the specified relative coords",
				},
				SetRelBlockType =
				{
					Params =
					{
						{
							Name = "RelBlockX",
							Type = "number",
						},
						{
							Name = "RelBlockY",
							Type = "number",
						},
						{
							Name = "RelBlockZ",
							Type = "number",
						},
						{
							Name = "BlockType",
							Type = "number",
						},
					},
					Notes = "Sets the block type at the specified relative coords",
				},
				SetRelBlockTypeMeta =
				{
					Params =
					{
						{
							Name = "RelBlockX",
							Type = "number",
						},
						{
							Name = "RelBlockY",
							Type = "number",
						},
						{
							Name = "RelBlockZ",
							Type = "number",
						},
						{
							Name = "BlockType",
							Type = "number",
						},
						{
							Name = "BlockMeta",
							Type = "number",
						},
					},
					Notes = "Sets the block type and meta at the specified relative coords",
				},
				SetWEOffset =
				{
					{
						Params =
						{
							{
								Name = "Offset",
								Type = "Vector3i",
							},
						},
						Notes = "Sets the WE offset, a data value sometimes stored in the schematic files. Mostly used for WorldEdit. Cuberite doesn't use this value, but provides access to it using this method.",
					},
					{
						Params =
						{
							{
								Name = "OffsetX",
								Type = "number",
							},
							{
								Name = "OffsetY",
								Type = "number",
							},
							{
								Name = "OffsetZ",
								Type = "number",
							},
						},
						Notes = "Sets the WE offset, a data value sometimes stored in the schematic files. Mostly used for WorldEdit. Cuberite doesn't use this value, but provides access to it using this method.",
					},
				},
				Write =
				{
					{
						Params =
						{
							{
								Name = "World",
								Type = "cWorld",
							},
							{
								Name = "MinPoint",
								Type = "number",
							},
						},
						Returns =
						{
							{
								Name = "IsSuccess",
								Type = "boolean",
							},
						},
						Notes = "Writes the area into World at the specified coords, returns true if successful. baTypes and baMetas are written.",
					},
					{
						Params =
						{
							{
								Name = "World",
								Type = "cWorld",
							},
							{
								Name = "MinPoint",
								Type = "number",
							},
							{
								Name = "DataTypes",
								Type = "number",
							},
						},
						Returns =
						{
							{
								Name = "IsSuccess",
								Type = "boolean",
							},
						},
						Notes = "Writes the area into World at the specified coords, returns true if successful. DataTypes is the sum of baXXX datatypes to write.",
					},
					{
						Params =
						{
							{
								Name = "World",
								Type = "cWorld",
							},
							{
								Name = "MinX",
								Type = "number",
							},
							{
								Name = "MinY",
								Type = "number",
							},
							{
								Name = "MinZ",
								Type = "number",
							},
						},
						Returns =
						{
							{
								Name = "IsSuccess",
								Type = "boolean",
							},
						},
						Notes = "Writes the area into World at the specified coords, returns true if successful. baTypes and baMetas are written.",
					},
					{
						Params =
						{
							{
								Name = "World",
								Type = "cWorld",
							},
							{
								Name = "MinX",
								Type = "number",
							},
							{
								Name = "MinY",
								Type = "number",
							},
							{
								Name = "MinZ",
								Type = "number",
							},
							{
								Name = "DataTypes",
								Type = "number",
							},
						},
						Returns =
						{
							{
								Name = "IsSuccess",
								Type = "boolean",
							},
						},
						Notes = "Writes the area into World at the specified coords, returns true if successful. DataTypes is the sum of baXXX datatypes to write.",
					},
				},
			},
			Constants =
			{
				baLight =
				{
					Notes = "Operations should work on block (emissive) light",
				},
				baMetas =
				{
					Notes = "Operations should work on block metas",
				},
				baSkyLight =
				{
					Notes = "Operations should work on skylight",
				},
				baTypes =
				{
					Notes = "Operation should work on block types",
				},
				msDifference =
				{
					Notes = "Block becomes air if 'self' and src are the same. Otherwise it becomes the src block.",
				},
				msFillAir =
				{
					Notes = "'self' is overwritten by Src only where 'self' has air blocks",
				},
				msImprint =
				{
					Notes = "Src overwrites 'self' anywhere where 'self' has non-air blocks",
				},
				msLake =
				{
					Notes = "Special mode for merging lake images",
				},
				msMask =
				{
					Notes = "The blocks that are exactly the same are kept in 'self', all differing blocks are replaced by air",
				},
				msOverwrite =
				{
					Notes = "Src overwrites anything in 'self'",
				},
				msSimpleCompare =
				{
					Notes = "The blocks that are exactly the same are replaced with air, all differing blocks are replaced by stone",
				},
				msSpongePrint =
				{
					Notes = "Similar to msImprint, sponge block doesn't overwrite anything, all other blocks overwrite everything",
				},
			},
			ConstantGroups =
			{
				BATypes =
				{
					Include = "ba.*",
					TextBefore = [[
						The following constants are used to signalize the datatype to read or write:
					]],
				},
				MergeStrategies =
				{
					Include = "ms.*",
					TextAfter = "See below for a detailed explanation of the individual merge strategies.",
					TextBefore = [[
						The Merge() function can use different strategies to combine the source and destination blocks.
						The following constants are used:
					]],
				},
			},
			AdditionalInfo =
			{
				{
					Header = "Merge strategies",
					Contents = [[
						<p>The strategy parameter specifies how individual blocks are combined together, using the table below.
						</p>
						<table class="inline">
						<tbody><tr>
						<th colspan="2">area block</th><th colspan="3">result</th>
						</tr>
						<tr>
						<th> this </th><th> Src </th><th> msOverwrite </th><th> msFillAir </th><th> msImprint </th>
						</tr>
						<tr>
						<td> air </td><td> air </td><td> air </td><td> air </td><td> air </td>
						</tr>
						<tr>
						<td> A </td><td> air </td><td> air </td><td> A </td><td> A </td>
						</tr>
						<tr>
						<td> air </td><td> B </td><td> B </td><td> B </td><td> B </td>
						</tr>
						<tr>
						<td> A </td><td> B </td><td> B </td><td> A </td><td> B </td>
						</tr>
						<tr>
						<td> A </td><td> A </td><td> A </td><td> A </td><td> A </td>
						</td>
						</tbody></table>

						<p>
						So to sum up:
						<ol>
						<li class="level1">msOverwrite completely overwrites all blocks with the Src's blocks</li>
						<li class="level1">msFillAir overwrites only those blocks that were air</li>
						<li class="level1">msImprint overwrites with only those blocks that are non-air</li>
						</ol>
						</p>

						<h3>Special strategies</h3>
						<p>For each strategy, evaluate the table rows from top downwards, the first match wins.</p>

						<p>
						<strong>msDifference</strong> - changes all the blocks which are the same to air. Otherwise the source block gets placed.
						</p>
						<table><tbody<tr>
						<th colspan="2"> area block </th><th> </th><th> Notes </th>
						</tr><tr>
						<td> * </td><td> B </td><td> B </td><td> The blocks are different so we use block B </td>
						</tr><tr>
						<td> B </td><td> B </td><td> Air </td><td> The blocks are the same so we get air. </td>
						</tr>
						</tbody></table>


						<p>
						<strong>msLake</strong> - used for merging areas with lava and water lakes, in the appropriate generator.
						</p>
						<table><tbody><tr>
						<th colspan="2"> area block </th><th> </th><th> Notes </th>
						</tr><tr>
						<th> self </th><th> Src </th><th> result </th><th> </th>
						</tr><tr>
						<td> A </td><td> sponge </td><td> A </td><td> Sponge is the NOP block </td>
						</tr><tr>
						<td> *        </td><td> air    </td><td> air    </td><td> Air always gets hollowed out, even under the oceans </td>
						</tr><tr>
						<td> water    </td><td> *      </td><td> water  </td><td> Water is never overwritten </td>
						</tr><tr>
						<td> lava     </td><td> *      </td><td> lava   </td><td> Lava is never overwritten </td>
						</tr><tr>
						<td> *        </td><td> water  </td><td> water  </td><td> Water always overwrites anything </td>
						</tr><tr>
						<td> *        </td><td> lava   </td><td> lava   </td><td> Lava always overwrites anything </td>
						</tr><tr>
						<td> dirt     </td><td> stone  </td><td> stone  </td><td> Stone overwrites dirt </td>
						</tr><tr>
						<td> grass    </td><td> stone  </td><td> stone  </td><td> ... and grass </td>
						</tr><tr>
						<td> mycelium </td><td> stone  </td><td> stone  </td><td> ... and mycelium </td>
						</tr><tr>
						<td> A        </td><td> stone  </td><td> A      </td><td> ... but nothing else </td>
						</tr><tr>
						<td> A        </td><td> *      </td><td> A      </td><td> Everything else is left as it is </td>
						</tr>
						</tbody></table>

						<p>
						<strong>msSpongePrint</strong> - used for most prefab-generators to merge the prefabs. Similar to
						msImprint, but uses the sponge block as the NOP block instead, so that the prefabs may carve out air
						pockets, too.
						</p>
						<table><tbody><tr>
						<th colspan="2"> area block </th><th> </th><th> Notes </th>
						</tr><tr>
						<th> self </th><th> Src </th><th> result </th><th> </th>
						</tr><tr>
						<td> A </td><td> sponge </td><td> A </td><td> Sponge is the NOP block </td>
						</tr><tr>
						<td> * </td><td> B </td><td> B </td><td> Everything else overwrites anything </td>
						</tr>
						</tbody></table>

						<p>
						<strong>msMask</strong> - the blocks that are the same in the other area are kept, all the
						differing blocks are replaced with air. Meta is used in the comparison, too, two blocks of the
						same type but different meta are considered different and thus replaced with air.
						</p>
						<table><tbody><tr>
						<th colspan="2"> area block </th><th> </th><th> Notes </th>
						</tr><tr>
						<th> self </th><th> Src </th><th> result </th><th> </th>
						</tr><tr>
						<td> A </td><td> A </td><td> A </td><td> Same blocks are kept </td>
						</tr><tr>
						<td> A </td><td> non-A </td><td> air </td><td> Differing blocks are replaced with air </td>
						</tr>
						</tbody></table>

						<p>
						<strong>msDifference</strong> - the blocks that are the same in both areas are replaced with air, all the
						differing blocks are kept from the first area. Meta is used in the comparison, too, two blocks of the
						same type but different meta are considered different.
						</p>
						<table><tbody><tr>
						<th colspan="2"> area block </th><th> </th><th> Notes </th>
						</tr><tr>
						<th> self </th><th> Src </th><th> result </th><th> </th>
						</tr><tr>
						<td> A </td><td> A </td><td> air </td><td> Same blocks are replaced with air </td>
						</tr><tr>
						<td> A </td><td> non-A </td><td> A </td><td> Differing blocks are kept from 'self' </td>
						</tr>
						</tbody></table>

						<p>
						<strong>msSimpleCompare</strong> - the blocks that are the same in both areas are replaced with air, all the
						differing blocks are replaced with stone. Meta is used in the comparison, too, two blocks of the
						same type but different meta are considered different.
						</p>
						<table><tbody><tr>
						<th colspan="2"> area block </th><th> </th><th> Notes </th>
						</tr><tr>
						<th> self </th><th> Src </th><th> result </th><th> </th>
						</tr><tr>
						<td> A </td><td> A </td><td> air </td><td> Same blocks are replaced with air </td>
						</tr><tr>
						<td> A </td><td> non-A </td><td> stone </td><td> Differing blocks are replaced with stone </td>
						</tr>
						</tbody></table>
]],
				},
			},
		},
		cBlockInfo =
		{
			Desc = [[
				This class is used to query and register block properties.
			]],
			Functions =
			{
				CanBeTerraformed =
				{
					IsStatic = true,
					Params =
					{
						{
							Name = "BlockType",
							Type = "number",
						},
					},
					Returns =
					{
						{
							Type = "boolean",
						},
					},
					Notes = "Returns true if the block is suitable to be changed by a generator",
				},
				FullyOccupiesVoxel =
				{
					IsStatic = true,
					Params =
					{
						{
							Name = "BlockType",
							Type = "number",
						},
					},
					Returns =
					{
						{
							Type = "boolean",
						},
					},
					Notes = "Returns whether the specified block fully occupies its voxel.",
				},
				Get =
				{
					IsStatic = true,
					Params =
					{
						{
							Name = "BlockType",
							Type = "number",
						},
					},
					Returns =
					{
						{
							Type = "cBlockInfo",
						},
					},
					Notes = "Returns the {{cBlockInfo}} structure for the specified block type.",
				},
				GetBlockHeight =
				{
					IsStatic = true,
					Params =
					{
						{
							Name = "BlockType",
							Type = "number",
						},
					},
					Returns =
					{
						{
							Type = "number",
						},
					},
					Notes = "Returns the block's hitbox height.",
				},
				GetLightValue =
				{
					IsStatic = true,
					Params =
					{
						{
							Name = "BlockType",
							Type = "number",
						},
					},
					Returns =
					{
						{
							Type = "number",
						},
					},
					Notes = "Returns how much light the specified block emits on its own.",
				},
				GetPlaceSound =
				{
					IsStatic = true,
					Params =
					{
						{
							Name = "BlockType",
							Type = "number",
						},
					},
					Notes = "Returns the name of the sound that is played when placing the block of this type.",
				},
				GetSpreadLightFalloff =
				{
					IsStatic = true,
					Params =
					{
						{
							Name = "BlockType",
							Type = "number",
						},
					},
					Returns =
					{
						{
							Type = "number",
						},
					},
					Notes = "Returns how much light the specified block type consumes.",
				},
				IsOneHitDig =
				{
					IsStatic = true,
					Params =
					{
						{
							Name = "BlockType",
							Type = "number",
						},
					},
					Returns =
					{
						{
							Type = "boolean",
						},
					},
					Notes = "Returns whether the specified block type will be destroyed after a single hit.",
				},
				IsPistonBreakable =
				{
					IsStatic = true,
					Params =
					{
						{
							Name = "BlockType",
							Type = "number",
						},
					},
					Returns =
					{
						{
							Type = "boolean",
						},
					},
					Notes = "Returns whether a piston can break the specified block type.",
				},
				IsSnowable =
				{
					IsStatic = true,
					Params =
					{
						{
							Name = "BlockType",
							Type = "number",
						},
					},
					Returns =
					{
						{
							Type = "boolean",
						},
					},
					Notes = "Returns whether the specified block type can hold snow atop.",
				},
				IsSolid =
				{
					IsStatic = true,
					Params =
					{
						{
							Name = "BlockType",
							Type = "number",
						},
					},
					Returns =
					{
						{
							Type = "boolean",
						},
					},
					Notes = "Returns whether the specified block type is solid.",
				},
				IsTransparent =
				{
					IsStatic = true,
					Params =
					{
						{
							Name = "BlockType",
							Type = "number",
						},
					},
					Returns =
					{
						{
							Type = "boolean",
						},
					},
					Notes = "Returns whether the specified block is transparent.",
				},
				RequiresSpecialTool =
				{
					IsStatic = true,
					Params =
					{
						{
							Name = "BlockType",
							Type = "number",
						},
					},
					Returns =
					{
						{
							Type = "boolean",
						},
					},
					Notes = "Returns whether the specified block requires a special tool to drop resources.",
				},
			},
			Variables =
			{
				m_CanBeTerraformed =
				{
					Type = "bool",
					Notes = "Is this block suited to be terraformed?",
				},
				m_FullyOccupiesVoxel =
				{
					Type = "bool",
					Notes = "Does this block fully occupy its voxel - is it a 'full' block?",
				},
				m_IsSnowable =
				{
					Type = "bool",
					Notes = "Can this block hold snow atop?",
				},
				m_IsSolid =
				{
					Type = "bool",
					Notes = "Is this block solid (player cannot walk through)?",
				},
				m_LightValue =
				{
					Type = "number",
					Notes = "How much light do the blocks emit on their own?",
				},
				m_OneHitDig =
				{
					Type = "bool",
					Notes = "Is a block destroyed after a single hit?",
				},
				m_PistonBreakable =
				{
					Type = "bool",
					Notes = "Can a piston break this block?",
				},
				m_PlaceSound =
				{
					Type = "string",
					Notes = "The name of the sound that is placed when a block is placed.",
				},
				m_RequiresSpecialTool =
				{
					Type = "bool",
					Notes = "Does this block require a tool to drop?",
				},
				m_SpreadLightFalloff =
				{
					Type = "number",
					Notes = "How much light do the blocks consume?",
				},
				m_Transparent =
				{
					Type = "bool",
					Notes = "Is a block completely transparent? (light doesn't get decreased(?))",
				},
			},
		},
		cChatColor =
		{
			Desc = [[
				A wrapper class for constants representing colors or effects.
			]],
			Functions =
			{

			},
			Constants =
			{
				Black =
				{
					Notes = "",
				},
				Blue =
				{
					Notes = "",
				},
				Bold =
				{
					Notes = "",
				},
				Color =
				{
					Notes = "The first character of the color-code-sequence, §",
				},
				DarkPurple =
				{
					Notes = "",
				},
				Delimiter =
				{
					Notes = "The first character of the color-code-sequence, §",
				},
				Gold =
				{
					Notes = "",
				},
				Gray =
				{
					Notes = "",
				},
				Green =
				{
					Notes = "",
				},
				Italic =
				{
					Notes = "",
				},
				LightBlue =
				{
					Notes = "",
				},
				LightGray =
				{
					Notes = "",
				},
				LightGreen =
				{
					Notes = "",
				},
				LightPurple =
				{
					Notes = "",
				},
				Navy =
				{
					Notes = "",
				},
				Plain =
				{
					Notes = "Resets all formatting to normal",
				},
				Purple =
				{
					Notes = "",
				},
				Random =
				{
					Notes = "Random letters and symbols animate instead of the text",
				},
				Red =
				{
					Notes = "",
				},
				Rose =
				{
					Notes = "",
				},
				Strikethrough =
				{
					Notes = "",
				},
				Underlined =
				{
					Notes = "",
				},
				White =
				{
					Notes = "",
				},
				Yellow =
				{
					Notes = "",
				},
			},
		},
		cChunkDesc =
		{
			Desc = [[
				The cChunkDesc class is a container for chunk data while the chunk is being generated. As such, it is
				only used as a parameter for the {{OnChunkGenerating|OnChunkGenerating}} and
				{{OnChunkGenerated|OnChunkGenerated}} hooks and cannot be constructed on its own. Plugins can use this
				class in both those hooks to manipulate generated chunks.
			]],
			Functions =
			{
				FillBlocks =
				{
					Params =
					{
						{
							Name = "BlockType",
							Type = "number",
						},
						{
							Name = "BlockMeta",
							Type = "number",
						},
					},
					Notes = "Fills the entire chunk with the specified blocks",
				},
				FillRelCuboid =
				{
					{
						Params =
						{
							{
								Name = "RelCuboid",
								Type = "cCuboid",
							},
							{
								Name = "BlockType",
								Type = "number",
							},
							{
								Name = "BlockMeta",
								Type = "number",
							},
						},
						Notes = "Fills the cuboid, specified in relative coords, by the specified block type and block meta. The cuboid may reach outside of the chunk, only the part intersecting with this chunk is filled.",
					},
					{
						Params =
						{
							{
								Name = "MinRelX",
								Type = "number",
							},
							{
								Name = "MaxRelX",
								Type = "number",
							},
							{
								Name = "MinRelY",
								Type = "number",
							},
							{
								Name = "MaxRelY",
								Type = "number",
							},
							{
								Name = "MinRelZ",
								Type = "number",
							},
							{
								Name = "MaxRelZ",
								Type = "number",
							},
							{
								Name = "BlockType",
								Type = "number",
							},
							{
								Name = "BlockMeta",
								Type = "number",
							},
						},
						Notes = "Fills the cuboid, specified in relative coords, by the specified block type and block meta. The cuboid may reach outside of the chunk, only the part intersecting with this chunk is filled.",
					},
				},
				FloorRelCuboid =
				{
					{
						Params =
						{
							{
								Name = "RelCuboid",
								Type = "cCuboid",
							},
							{
								Name = "BlockType",
								Type = "number",
							},
							{
								Name = "BlockMeta",
								Type = "number",
							},
						},
						Notes = "Fills those blocks of the cuboid (specified in relative coords) that are considered non-floor (air, water) with the specified block type and meta. Cuboid may reach outside the chunk, only the part intersecting with this chunk is filled.",
					},
					{
						Params =
						{
							{
								Name = "MinRelX",
								Type = "number",
							},
							{
								Name = "MaxRelX",
								Type = "number",
							},
							{
								Name = "MinRelY",
								Type = "number",
							},
							{
								Name = "MaxRelY",
								Type = "number",
							},
							{
								Name = "MinRelZ",
								Type = "number",
							},
							{
								Name = "MaxRelZ",
								Type = "number",
							},
							{
								Name = "BlockType",
								Type = "number",
							},
							{
								Name = "BlockMeta",
								Type = "number",
							},
						},
						Notes = "Fills those blocks of the cuboid (specified in relative coords) that are considered non-floor (air, water) with the specified block type and meta. Cuboid may reach outside the chunk, only the part intersecting with this chunk is filled.",
					},
				},
				GetBiome =
				{
					Params =
					{
						{
							Name = "RelX",
							Type = "number",
						},
						{
							Name = "RelZ",
							Type = "number",
						},
					},
					Returns =
					{
						{
							Type = "EMCSBiome",
						},
					},
					Notes = "Returns the biome at the specified relative coords",
				},
				GetBlockEntity =
				{
					Params =
					{
						{
							Name = "RelX",
							Type = "number",
						},
						{
							Name = "RelY",
							Type = "number",
						},
						{
							Name = "RelZ",
							Type = "number",
						},
					},
					Returns =
					{
						{
							Type = "cBlockEntity",
						},
					},
					Notes = "Returns the block entity for the block at the specified coords. Creates it if it doesn't exist. Returns nil if the block has no block entity capability.",
				},
				GetBlockMeta =
				{
					Params =
					{
						{
							Name = "RelX",
							Type = "number",
						},
						{
							Name = "RelY",
							Type = "number",
						},
						{
							Name = "RelZ",
							Type = "number",
						},
					},
					Returns =
					{
						{
							Name = "NIBBLETYPE",
							Type = "number",
						},
					},
					Notes = "Returns the block meta at the specified relative coords",
				},
				GetBlockType =
				{
					Params =
					{
						{
							Name = "RelX",
							Type = "number",
						},
						{
							Name = "RelY",
							Type = "number",
						},
						{
							Name = "RelZ",
							Type = "number",
						},
					},
					Returns =
					{
						{
							Name = "BLOCKTYPE",
							Type = "number",
						},
					},
					Notes = "Returns the block type at the specified relative coords",
				},
				GetBlockTypeMeta =
				{
					Params =
					{
						{
							Name = "RelX",
							Type = "number",
						},
						{
							Name = "RelY",
							Type = "number",
						},
						{
							Name = "RelZ",
							Type = "number",
						},
					},
					Returns =
					{
						{
							Name = "BLOCKTYPE",
							Type = "number",
						},
						{
							Name = "NIBBLETYPE",
							Type = "number",
						},
					},
					Notes = "Returns the block type and meta at the specified relative coords",
				},
				GetChunkX =
				{
					Returns =
					{
						{
							Type = "number",
						},
					},
					Notes = "Returns the X coord of the chunk contained.",
				},
				GetChunkZ =
				{
					Returns =
					{
						{
							Type = "number",
						},
					},
					Notes = "Returns the Z coord of the chunk contained.",
				},
				GetHeight =
				{
					Params =
					{
						{
							Name = "RelX",
							Type = "number",
						},
						{
							Name = "RelZ",
							Type = "number",
						},
					},
					Returns =
					{
						{
							Type = "number",
						},
					},
					Notes = "Returns the height at the specified relative coords",
				},
				GetMaxHeight =
				{
					Returns =
					{
						{
							Type = "number",
						},
					},
					Notes = "Returns the maximum height contained in the heightmap.",
				},
				GetMinHeight =
				{
					Returns =
					{
						{
							Type = "number",
						},
					},
					Notes = "Returns the minimum height value in the heightmap.",
				},
				IsUsingDefaultBiomes =
				{
					Returns =
					{
						{
							Type = "boolean",
						},
					},
					Notes = "Returns true if the chunk is set to use default biome generator",
				},
				IsUsingDefaultComposition =
				{
					Returns =
					{
						{
							Type = "boolean",
						},
					},
					Notes = "Returns true if the chunk is set to use default composition generator",
				},
				IsUsingDefaultFinish =
				{
					Returns =
					{
						{
							Type = "boolean",
						},
					},
					Notes = "Returns true if the chunk is set to use default finishers",
				},
				IsUsingDefaultHeight =
				{
					Returns =
					{
						{
							Type = "boolean",
						},
					},
					Notes = "Returns true if the chunk is set to use default height generator",
				},
				IsUsingDefaultStructures =
				{
					Returns =
					{
						{
							Type = "boolean",
						},
					},
					Notes = "Returns true if the chunk is set to use default structures",
				},
				RandomFillRelCuboid =
				{
					{
						Params =
						{
							{
								Name = "RelCuboid",
								Type = "cCuboid",
							},
							{
								Name = "BlockType",
								Type = "number",
							},
							{
								Name = "BlockMeta",
								Type = "number",
							},
							{
								Name = "RandomSeed",
								Type = "number",
							},
							{
								Name = "ChanceOutOf10k",
								Type = "number",
							},
						},
						Notes = "Fills the specified relative cuboid with block type and meta in random locations. RandomSeed is used for the random number genertion (same seed produces same results); ChanceOutOf10k specifies the density (how many out of every 10000 blocks should be filled). Cuboid may reach outside the chunk, only the part intersecting with this chunk is filled.",
					},
					{
						Params =
						{
							{
								Name = "MinRelX",
								Type = "number",
							},
							{
								Name = "ChanceOutOf10k",
								Type = "number",
							},
							{
								Name = "MaxRelX",
								Type = "number",
							},
							{
								Name = "MinRelY",
								Type = "number",
							},
							{
								Name = "MaxRelY",
								Type = "number",
							},
							{
								Name = "MinRelZ",
								Type = "number",
							},
							{
								Name = "MaxRelZ",
								Type = "number",
							},
							{
								Name = "BlockType",
								Type = "number",
							},
							{
								Name = "BlockMeta",
								Type = "number",
							},
							{
								Name = "RandomSeed",
								Type = "number",
							},
						},
						Notes = "Fills the specified relative cuboid with block type and meta in random locations. RandomSeed is used for the random number genertion (same seed produces same results); ChanceOutOf10k specifies the density (how many out of every 10000 blocks should be filled). Cuboid may reach outside the chunk, only the part intersecting with this chunk is filled.",
					},
				},
				ReadBlockArea =
				{
					Params =
					{
						{
							Name = "BlockArea",
							Type = "cBlockArea",
						},
						{
							Name = "MinRelX",
							Type = "number",
						},
						{
							Name = "MaxRelX",
							Type = "number",
						},
						{
							Name = "MinRelY",
							Type = "number",
						},
						{
							Name = "MaxRelY",
							Type = "number",
						},
						{
							Name = "MinRelZ",
							Type = "number",
						},
						{
							Name = "MaxRelZ",
							Type = "number",
						},
					},
					Notes = "Reads data from the chunk into the block area object. Block types and metas are processed.",
				},
				ReplaceRelCuboid =
				{
					{
						Params =
						{
							{
								Name = "RelCuboid",
								Type = "cCuboid",
							},
							{
								Name = "SrcBlockType",
								Type = "number",
							},
							{
								Name = "SrcBlockMeta",
								Type = "number",
							},
							{
								Name = "DstBlockType",
								Type = "number",
							},
							{
								Name = "DstBlockMeta",
								Type = "number",
							},
						},
						Notes = "Replaces all SrcBlockType + SrcBlockMeta blocks in the cuboid (specified in relative coords) with DstBlockType + DstBlockMeta blocks. Cuboid may reach outside the chunk, only the part intersecting with this chunk is filled.",
					},
					{
						Params =
						{
							{
								Name = "MinRelX",
								Type = "number",
							},
							{
								Name = "MaxRelX",
								Type = "number",
							},
							{
								Name = "MinRelY",
								Type = "number",
							},
							{
								Name = "MaxRelY",
								Type = "number",
							},
							{
								Name = "MinRelZ",
								Type = "number",
							},
							{
								Name = "MaxRelZ",
								Type = "number",
							},
							{
								Name = "SrcBlockType",
								Type = "number",
							},
							{
								Name = "SrcBlockMeta",
								Type = "number",
							},
							{
								Name = "DstBlockType",
								Type = "number",
							},
							{
								Name = "DstBlockMeta",
								Type = "number",
							},
						},
						Notes = "Replaces all SrcBlockType + SrcBlockMeta blocks in the cuboid (specified in relative coords) with DstBlockType + DstBlockMeta blocks. Cuboid may reach outside the chunk, only the part intersecting with this chunk is filled.",
					},
				},
				SetBiome =
				{
					Params =
					{
						{
							Name = "RelX",
							Type = "number",
						},
						{
							Name = "RelZ",
							Type = "number",
						},
						{
							Name = "Biome",
							Type = "EMCSBiome",
						},
					},
					Notes = "Sets the biome at the specified relative coords",
				},
				SetBlockMeta =
				{
					Params =
					{
						{
							Name = "RelX",
							Type = "number",
						},
						{
							Name = "RelY",
							Type = "number",
						},
						{
							Name = "RelZ",
							Type = "number",
						},
						{
							Name = "BlockMeta",
							Type = "number",
						},
					},
					Notes = "Sets the block meta at the specified relative coords",
				},
				SetBlockType =
				{
					Params =
					{
						{
							Name = "RelX",
							Type = "number",
						},
						{
							Name = "RelY",
							Type = "number",
						},
						{
							Name = "RelZ",
							Type = "number",
						},
						{
							Name = "BlockType",
							Type = "number",
						},
					},
					Notes = "Sets the block type at the specified relative coords",
				},
				SetBlockTypeMeta =
				{
					Params =
					{
						{
							Name = "RelX",
							Type = "number",
						},
						{
							Name = "RelY",
							Type = "number",
						},
						{
							Name = "RelZ",
							Type = "number",
						},
						{
							Name = "BlockType",
							Type = "number",
						},
						{
							Name = "BlockMeta",
							Type = "number",
						},
					},
					Notes = "Sets the block type and meta at the specified relative coords",
				},
				SetHeight =
				{
					Params =
					{
						{
							Name = "RelX",
							Type = "number",
						},
						{
							Name = "RelZ",
							Type = "number",
						},
						{
							Name = "Height",
							Type = "number",
						},
					},
					Notes = "Sets the height at the specified relative coords",
				},
				SetUseDefaultBiomes =
				{
					Params =
					{
						{
							Name = "ShouldUseDefaultBiomes",
							Type = "boolean",
						},
					},
					Notes = "Sets the chunk to use default biome generator or not",
				},
				SetUseDefaultComposition =
				{
					Params =
					{
						{
							Name = "ShouldUseDefaultComposition",
							Type = "boolean",
						},
					},
					Notes = "Sets the chunk to use default composition generator or not",
				},
				SetUseDefaultFinish =
				{
					Params =
					{
						{
							Name = "ShouldUseDefaultFinish",
							Type = "boolean",
						},
					},
					Notes = "Sets the chunk to use default finishers or not",
				},
				SetUseDefaultHeight =
				{
					Params =
					{
						{
							Name = "ShouldUseDefaultHeight",
							Type = "boolean",
						},
					},
					Notes = "Sets the chunk to use default height generator or not",
				},
				SetUseDefaultStructures =
				{
					Params =
					{
						{
							Name = "ShouldUseDefaultStructures",
							Type = "boolean",
						},
					},
					Notes = "Sets the chunk to use default structures or not",
				},
				UpdateHeightmap =
				{
					Notes = "Updates the heightmap to match current contents. The plugins should do that if they modify the contents and don't modify the heightmap accordingly; Cuberite expects (and checks in Debug mode) that the heightmap matches the contents when the cChunkDesc is returned from a plugin.",
				},
				WriteBlockArea =
				{
					Params =
					{
						{
							Name = "BlockArea",
							Type = "cBlockArea",
						},
						{
							Name = "MinRelX",
							Type = "number",
						},
						{
							Name = "MinRelY",
							Type = "number",
						},
						{
							Name = "MinRelZ",
							Type = "number",
						},
						{
							Name = "MergeStrategy",
							Type = "cBlockArea",
							IsOptional = true,
						},
					},
					Notes = "Writes data from the block area into the chunk",
				},
			},
			AdditionalInfo =
			{
				{
					Header = "Manipulating block entities",
					Contents = [[
						To manipulate block entities while the chunk is generated, first use SetBlockTypeMeta() to set
						the correct block type and meta at the position. Then use the GetBlockEntity() to create and
						return the correct block entity instance. Finally, use {{tolua}}.cast() to cast to the proper
						type.</p>
						Note that you don't need to check if a block entity has previously existed at the place, because
						GetBlockEntity() will automatically re-create the correct type for you.</p>
						<p>
						The following code is taken from the Debuggers plugin, it creates a sign at each chunk's [0, 0]
						coords, with the text being the chunk coords:
<pre class="prettyprint lang-lua">
function OnChunkGenerated(a_World, a_ChunkX, a_ChunkZ, a_ChunkDesc)
	-- Get the topmost block coord:
	local Height = a_ChunkDesc:GetHeight(0, 0);

	-- Create a sign there:
	a_ChunkDesc:SetBlockTypeMeta(0, Height + 1, 0, E_BLOCK_SIGN_POST, 0);
	local BlockEntity = a_ChunkDesc:GetBlockEntity(0, Height + 1, 0);
	if (BlockEntity ~= nil) then
		LOG("Setting sign lines...");
		local SignEntity = tolua.cast(BlockEntity, "cSignEntity");
		SignEntity:SetLines("Chunk:", tonumber(a_ChunkX) .. ", " .. tonumber(a_ChunkZ), "", "(Debuggers)");
	end

	-- Update the heightmap:
	a_ChunkDesc:SetHeight(0, 0, Height + 1);
end
</pre>
					]],
				},
			},
		},
		cClientHandle =
		{
			Desc = [[
				A cClientHandle represents the technical aspect of a connected player - their game client
				connection. Internally, it handles all the incoming and outgoing packets, the chunks that are to be
				sent to the client, ping times etc.
			]],
			Functions =
			{
				GenerateOfflineUUID =
				{
					IsStatic = true,
					Params =
					{
						{
							Name = "Username",
							Type = "string",
						},
					},
					Returns =
					{
						{
							Type = "string",
						},
					},
					Notes = "Generates an UUID based on the player name provided. This is used for the offline (non-auth) mode, when there's no UUID source. Each username generates a unique and constant UUID, so that when the player reconnects with the same name, their UUID is the same. Returns a 32-char UUID (no dashes).",
				},
				GetClientBrand =
				{
					Returns =
					{
						{
							Type = "string",
						},
					},
					Notes = "Returns the brand that the client has sent in their MC|Brand plugin message.",
				},
				GetIPString =
				{
					Returns =
					{
						{
							Type = "string",
						},
					},
					Notes = "Returns the IP address of the connection, as a string. Only the address part is returned, without the port number.",
				},
				GetLocale =
				{
					Returns =
					{
						{
							Name = "Locale",
							Type = "string",
						},
					},
					Notes = "Returns the locale string that the client sends as part of the protocol handshake. Can be used to provide localized strings.",
				},
				GetPing =
				{
					Returns =
					{
						{
							Type = "number",
						},
					},
					Notes = "Returns the ping time, in ms",
				},
				GetPlayer =
				{
					Returns =
					{
						{
							Type = "cPlayer",
						},
					},
					Notes = "Returns the player object connected to this client. Note that this may be nil, for example if the player object is not yet spawned.",
				},
				GetProtocolVersion =
				{
					Returns =
					{
						{
							Type = "number",
						},
					},
					Notes = "Returns the protocol version number of the protocol that the client is talking. Returns zero if the protocol version is not (yet) known.",
				},
				GetRequestedViewDistance =
				{
					Returns =
					{
						{
							Type = "number",
						},
					},
					Notes = "Returns the view distance that the player request, not the used view distance.",
				},
				GetUniqueID =
				{
					Returns =
					{
						{
							Type = "number",
						},
					},
					Notes = "Returns the UniqueID of the client used to identify the client in the server",
				},
				GetUsername =
				{
					Returns =
					{
						{
							Type = "string",
						},
					},
					Notes = "Returns the username that the client has provided",
				},
				GetUUID =
				{
					Returns =
					{
						{
							Type = "string",
						},
					},
					Notes = "Returns the authentication-based UUID of the client. This UUID should be used to identify the player when persisting any player-related data. Returns a 32-char UUID (no dashes)",
				},
				GetViewDistance =
				{
					Returns =
					{
						{
							Type = "number",
						},
					},
					Notes = "Returns the viewdistance (number of chunks loaded for the player in each direction)",
				},
				HasPluginChannel =
				{
					Params =
					{
						{
							Name = "ChannelName",
							Type = "string",
						},
					},
					Returns =
					{
						{
							Type = "boolean",
						},
					},
					Notes = "Returns true if the client has registered to receive messages on the specified plugin channel.",
				},
				IsUUIDOnline =
				{
					IsStatic = true,
					Params =
					{
						{
							Name = "UUID",
							Type = "string",
						},
					},
					Returns =
					{
						{
							Type = "boolean",
						},
					},
					Notes = "Returns true if the UUID is generated by online auth, false if it is an offline-generated UUID. We use Version-3 UUIDs for offline UUIDs, online UUIDs are Version-4, thus we can tell them apart. Accepts both 32-char and 36-char UUIDs (with and without dashes). If the string given is not a valid UUID, returns false.",
				},
				Kick =
				{
					Params =
					{
						{
							Name = "Reason",
							Type = "string",
						},
					},
					Notes = "Kicks the user with the specified reason",
				},
				SendBlockChange =
				{
					Params =
					{
						{
							Name = "BlockX",
							Type = "number",
						},
						{
							Name = "BlockY",
							Type = "number",
						},
						{
							Name = "BlockZ",
							Type = "number",
						},
						{
							Name = "BlockType",
							Type = "number",
						},
						{
							Name = "BlockMeta",
							Type = "number",
						},
					},
					Notes = "Sends a BlockChange packet to the client. This can be used to create fake blocks only for that player.",
				},
				SendEntityAnimation =
				{
					Params =
					{
						{
							Name = "Entity",
							Type = "cEntity",
						},
						{
							Name = "AnimationNumber",
							Type = "number",
						},
					},
					Notes = "Sends the specified animation of the specified entity to the client. The AnimationNumber is protocol-specific.",
				},
				SendPluginMessage =
				{
					Params =
					{
						{
							Name = "Channel",
							Type = "string",
						},
						{
							Name = "Message",
							Type = "string",
						},
					},
					Notes = "Sends the plugin message on the specified channel.",
				},
				SendSoundEffect =
				{
					Params =
					{
						{
							Name = "SoundName",
							Type = "string",
						},
						{
							Name = "X",
							Type = "number",
						},
						{
							Name = "Y",
							Type = "number",
						},
						{
							Name = "Z",
							Type = "number",
						},
						{
							Name = "Volume",
							Type = "number",
						},
						{
							Name = "Pitch",
							Type = "number",
						},
					},
					Notes = "Sends a sound effect request to the client. The sound is played at the specified coords, with the specified volume (a float, 1.0 is full volume, can be more) and pitch (0-255, 63 is 100%)",
				},
				SendTimeUpdate =
				{
					Params =
					{
						{
							Name = "WorldAge",
							Type = "number",
						},
						{
							Name = "TimeOfDay",
							Type = "number",
						},
						{
							Name = "DoDaylightCycle",
							Type = "boolean",
						},
					},
					Notes = "Sends the specified time update to the client. WorldAge is the total age of the world, in ticks. TimeOfDay is the current day's time, in ticks (0 - 24000). DoDaylightCycle is a bool that specifies whether the client should automatically move the sun (true) or keep it in the same place (false).",
				},
				SetClientBrand =
				{
					Params =
					{
						{
							Name = "ClientBrand",
							Type = "string",
						},
					},
					Notes = "Sets the value of the client's brand. Normally this value is received from the client by a MC|Brand plugin message, this function lets plugins overwrite the value.",
				},
				SetLocale =
				{
					Params =
					{
						{
							Name = "Locale",
							Type = "string",
						},
					},
					Notes = "Sets the locale that Cuberite keeps on record. Initially the locale is initialized in protocol handshake, this function allows plugins to override the stored value (but only server-side and only until the user disconnects).",
				},
				SetUsername =
				{
					Params =
					{
						{
							Name = "Name",
							Type = "string",
						},
					},
					Notes = "Sets the username",
				},
				SetViewDistance =
				{
					Params =
					{
						{
							Name = "ViewDistance",
							Type = "number",
						},
					},
					Notes = "Sets the viewdistance (number of chunks loaded for the player in each direction)",
				},
			},
			Constants =
			{
				MAX_VIEW_DISTANCE =
				{
					Notes = "The maximum value of the view distance",
				},
				MIN_VIEW_DISTANCE =
				{
					Notes = "The minimum value of the view distance",
				},
			},
		},
		cCompositeChat =
		{
			Desc = [[
				Encapsulates a chat message that can contain various formatting, URLs, commands executed on click
				and commands suggested on click. The chat message can be sent by the regular chat-sending functions,
				{{cPlayer}}:SendMessage(), {{cWorld}}:BroadcastChat() and {{cRoot}}:BroadcastChat().</p>
				<p>
				Note that most of the functions in this class are so-called chaining modifiers - they modify the
				object and then return the object itself, so that they can be chained one after another. See the
				Chaining example below for details.</p>
				<p>
				Each part of the composite chat message takes a "Style" parameter, this is a string that describes
				the formatting. It uses the following strings, concatenated together:
				<table>
				<tr><th>String</th><th>Style</th></tr>
				<tr><td>b</td><td>Bold text</td></tr>
				<tr><td>i</td><td>Italic text</td></tr>
				<tr><td>u</td><td>Underlined text</td></tr>
				<tr><td>s</td><td>Strikethrough text</td></tr>
				<tr><td>o</td><td>Obfuscated text</td></tr>
				<tr><td>@X</td><td>color X (X is 0 - 9 or a - f, same as dye meta</td></tr>
				</table>
				The following picture, taken from MineCraft Wiki, illustrates the color codes:</p>
				<img src="http://hydra-media.cursecdn.com/minecraft.gamepedia.com/4/4c/Colors.png?version=34a0f56789a95326e1f7d82047b12232" />
			]],
			Functions =
			{
				AddRunCommandPart =
				{
					Params =
					{
						{
							Name = "Text",
							Type = "string",
						},
						{
							Name = "Command",
							Type = "string",
						},
						{
							Name = "Style",
							Type = "string",
							IsOptional = true,
						},
					},
					Returns =
					{
						{
							Type = "self",
						},
					},
					Notes = "Adds a text which, when clicked, runs the specified command. Chaining.",
				},
				AddShowAchievementPart =
				{
					Params =
					{
						{
							Name = "PlayerName",
							Type = "string",
						},
						{
							Name = "AchievementName",
							Type = "string",
						},
						{
							Name = "Style",
							Type = "string",
							IsOptional = true,
						},
					},
					Notes = "Adds a text that represents the 'Achievement get' message.",
				},
				AddSuggestCommandPart =
				{
					Params =
					{
						{
							Name = "Text",
							Type = "string",
						},
						{
							Name = "Command",
							Type = "string",
						},
						{
							Name = "Style",
							Type = "string",
							IsOptional = true,
						},
					},
					Returns =
					{
						{
							Type = "self",
						},
					},
					Notes = "Adds a text which, when clicked, puts the specified command into the player's chat input area. Chaining.",
				},
				AddTextPart =
				{
					Params =
					{
						{
							Name = "Text",
							Type = "string",
						},
						{
							Name = "Style",
							Type = "string",
							IsOptional = true,
						},
					},
					Returns =
					{
						{
							Type = "self",
						},
					},
					Notes = "Adds a regular text. Chaining.",
				},
				AddUrlPart =
				{
					Params =
					{
						{
							Name = "Text",
							Type = "string",
						},
						{
							Name = "Url",
							Type = "string",
						},
						{
							Name = "Style",
							Type = "string",
							IsOptional = true,
						},
					},
					Returns =
					{
						{
							Type = "self",
						},
					},
					Notes = "Adds a text which, when clicked, opens up a browser at the specified URL. Chaining.",
				},
				Clear =
				{
					Returns = "self",
					Notes = "Removes all parts from this object",
				},
				constructor =
				{
					{
						Returns = { {Type = "cCompositeChat"} },
						Notes = "Creates an empty chat message",
					},
					{
						Params =
						{
							{
								Name = "Text",
								Type = "string",
							},
							{
								Name = "MessageType",
								Type = "eMessageType",
								IsOptional = true,
							},
						},
						Returns = { {Type = "cCompositeChat"} },
						Notes = "Creates a chat message containing the specified text, parsed by the ParseText() function. This allows easy migration from old chat messages.",
					},
				},
				CreateJsonString =
				{
					Params =
					{
						{
							Name = "AddPrefixes",
							Type = "boolean",
							IsOptional = true,
						},
					},
					Returns =
					{
						{
							Type = "string",
						},
					},
					Notes = "Returns the entire object serialized into JSON, as it would be sent to a client. AddPrefixes specifies whether the chat prefixes should be prepended to the message, true by default.",
				},
				ExtractText =
				{
					Returns =
					{
						{
							Type = "string",
						},
					},
					Notes = "Returns the text from the parts that comprises the human-readable data. Used for older protocols that don't support composite chat, and for console-logging.",
				},
				GetAdditionalMessageTypeData =
				{
					Returns =
					{
						{
							Type = "string",
						},
					},
					Notes = "Returns the AdditionalData associated with the message, such as the sender's name for mtPrivateMessage",
				},
				GetMessageType =
				{
					Returns =
					{
						{
							Type = "eMessageType",
						},
					},
					Notes = "Returns the MessageType (mtXXX constant) that is associated with this message. When sent to a player, the message will be formatted according to this message type and the player's settings (adding \"[INFO]\" prefix etc.)",
				},
				ParseText =
				{
					Params =
					{
						{
							Name = "Text",
							Type = "string",
						},
					},
					Returns =
					{
						{
							Type = "self",
						},
					},
					Notes = "Adds text, while recognizing http and https URLs and old-style formatting codes (\"@2\"). Chaining.",
				},
				SetMessageType =
				{
					Params =
					{
						{
							Name = "MessageType",
							Type = "eMessageType",
						},
						{
							Name = "AdditionalData",
							Type = "string",
							IsOptional = true,
						},
					},
					Returns =
					{
						{
							Type = "self",
						},
					},
					Notes = "Sets the MessageType (mtXXX constant) that is associated with this message. Also sets the additional data (string) associated with the message, which is specific for the message type - such as the sender's name for mtPrivateMessage. When sent to a player, the message will be formatted according to this message type and the player's settings (adding \"[INFO]\" prefix etc.). Chaining.",
				},
				UnderlineUrls =
				{
					Returns =
					{
						{
							Type = "self",
						},
					},
					Notes = "Makes all URL parts contained in the message underlined. Doesn't affect parts added in the future. Chaining.",
				},
			},
			AdditionalInfo =
			{
				{
					Header = "Chaining example",
					Contents = [[
						Sending a chat message that is composed of multiple different parts has been made easy thanks to
						chaining. Consider the following example that shows how a message containing all kinds of parts
						is sent (adapted from the Debuggers plugin):
<pre class="prettyprint lang-lua">
function OnPlayerJoined(a_Player)
	-- Send an example composite chat message to the player:
	a_Player:SendMessage(cCompositeChat()
		:AddTextPart("Hello, ")
		:AddUrlPart(a_Player:GetName(), "http://cuberite.org", "u@2")  -- Colored underlined link
		:AddSuggestCommandPart(", and welcome.", "/help", "u")       -- Underlined suggest-command
		:AddRunCommandPart(" SetDay", "/time set 0")                 -- Regular text that will execute command when clicked
		:SetMessageType(mtJoin)                                      -- It is a join-message
	)
end</pre>
					]],
				},
			},
		},
		cCraftingGrid =
		{
			Desc = [[
				cCraftingGrid represents the player's crafting grid. It is used in
				{{OnCraftingNoRecipe|OnCraftingNoRecipe}}, {{OnPostCrafting|OnPostCrafting}} and
				{{OnPreCrafting|OnPreCrafting}} hooks. Plugins may use it to inspect the items the player placed
				on their crafting grid.</p>
				<p>
				Also, an object of this type is used in {{cCraftingRecipe}}'s ConsumeIngredients() function for
				specifying the exact number of ingredients to consume in that recipe; plugins may use this to
				apply the crafting recipe.</p>
			]],
			Functions =
			{
				Clear =
				{
					Notes = "Clears the entire grid",
				},
				constructor =
				{
					Params =
					{
						{
							Name = "Width",
							Type = "number",
						},
						{
							Name = "Height",
							Type = "number",
						},
					},
					Returns =
					{
						{
							Type = "cCraftingGrid",
						},
					},
					Notes = "Creates a new CraftingGrid object. This new crafting grid is not related to any player, but may be needed for {{cCraftingRecipe}}'s ConsumeIngredients function.",
				},
				ConsumeGrid =
				{
					Params =
					{
						{
							Name = "CraftingGrid",
							Type = "cCraftingGrid",
						},
					},
					Notes = "Consumes items specified in CraftingGrid from the current contents. Used internally by {{cCraftingRecipe}}'s ConsumeIngredients() function, but available to plugins, too.",
				},
				Dump =
				{
					Notes = "DEBUG build: Dumps the contents of the grid to the log. RELEASE build: no action",
				},
				GetHeight =
				{
					Returns =
					{
						{
							Type = "number",
						},
					},
					Notes = "Returns the height of the grid",
				},
				GetItem =
				{
					Params =
					{
						{
							Name = "x",
							Type = "number",
						},
						{
							Name = "y",
							Type = "number",
						},
					},
					Returns =
					{
						{
							Type = "cItem",
						},
					},
					Notes = "Returns the item at the specified coords",
				},
				GetWidth =
				{
					Returns =
					{
						{
							Type = "number",
						},
					},
					Notes = "Returns the width of the grid",
				},
				SetItem =
				{
					{
						Params =
						{
							{
								Name = "x",
								Type = "number",
							},
							{
								Name = "y",
								Type = "number",
							},
							{
								Name = "cItem",
								Type = "cItem",
							},
						},
						Notes = "Sets the item at the specified coords",
					},
					{
						Params =
						{
							{
								Name = "x",
								Type = "number",
							},
							{
								Name = "y",
								Type = "number",
							},
							{
								Name = "ItemType",
								Type = "number",
							},
							{
								Name = "ItemCount",
								Type = "number",
							},
							{
								Name = "ItemDamage",
								Type = "number",
							},
						},
						Notes = "Sets the item at the specified coords",
					},
				},
			},
		},
		cCraftingRecipe =
		{
			Desc = [[
				This class is used to represent a crafting recipe, either a built-in one, or one created dynamically in a plugin. It is used only as a parameter for {{OnCraftingNoRecipe|OnCraftingNoRecipe}}, {{OnPostCrafting|OnPostCrafting}} and {{OnPreCrafting|OnPreCrafting}} hooks. Plugins may use it to inspect or modify a crafting recipe that a player views in their crafting window, either at a crafting table or the survival inventory screen.
</p>
		<p>Internally, the class contains a {{cCraftingGrid}} for the ingredients and a {{cItem}} for the result.
]],
			Functions =
			{
				Clear =
				{
					Notes = "Clears the entire recipe, both ingredients and results",
				},
				ConsumeIngredients =
				{
					Params =
					{
						{
							Name = "CraftingGrid",
							Type = "cCraftingGrid",
						},
					},
					Notes = "Consumes ingredients specified in the given {{cCraftingGrid|cCraftingGrid}} class",
				},
				Dump =
				{
					Notes = "DEBUG build: dumps ingredients and result into server log. RELEASE build: no action",
				},
				GetIngredient =
				{
					Params =
					{
						{
							Name = "x",
							Type = "number",
						},
						{
							Name = "y",
							Type = "number",
						},
					},
					Returns =
					{
						{
							Type = "cItem",
						},
					},
					Notes = "Returns the ingredient stored in the recipe at the specified coords",
				},
				GetIngredientsHeight =
				{
					Returns =
					{
						{
							Type = "number",
						},
					},
					Notes = "Returns the height of the ingredients' grid",
				},
				GetIngredientsWidth =
				{
					Returns =
					{
						{
							Type = "number",
						},
					},
					Notes = "Returns the width of the ingredients' grid",
				},
				GetResult =
				{
					Returns =
					{
						{
							Type = "cItem",
						},
					},
					Notes = "Returns the result of the recipe",
				},
				SetIngredient =
				{
					{
						Params =
						{
							{
								Name = "x",
								Type = "number",
							},
							{
								Name = "y",
								Type = "number",
							},
							{
								Name = "cItem",
								Type = "cItem",
							},
						},
						Notes = "Sets the ingredient at the specified coords",
					},
					{
						Params =
						{
							{
								Name = "x",
								Type = "number",
							},
							{
								Name = "y",
								Type = "number",
							},
							{
								Name = "ItemType",
								Type = "number",
							},
							{
								Name = "ItemCount",
								Type = "number",
							},
							{
								Name = "ItemDamage",
								Type = "number",
							},
						},
						Notes = "Sets the ingredient at the specified coords",
					},
				},
				SetResult =
				{
					{
						Params =
						{
							{
								Name = "cItem",
								Type = "cItem",
							},
						},
						Notes = "Sets the result item",
					},
					{
						Params =
						{
							{
								Name = "ItemType",
								Type = "number",
							},
							{
								Name = "ItemCount",
								Type = "number",
							},
							{
								Name = "ItemDamage",
								Type = "number",
							},
						},
						Notes = "Sets the result item",
					},
				},
			},
		},
		cCryptoHash =
		{
			Desc = [[
				Provides functions for generating cryptographic hashes.</p>
				<p>
				Note that all functions in this class are super-static, so they are to be called in the dot convention:
<pre class="prettyprint lang-lua">
local Hash = cCryptoHash.sha1HexString("DataToHash")
</pre></p>
				<p>Each cryptographic hash has two variants, one returns the hash as a raw binary string, the other returns the hash as a hex-encoded string twice as long as the binary string.
			]],
			Functions =
			{
				md5 =
				{
					IsStatic = true,
					IsGlobal = true,
					Params =
					{
						{
							Name = "Data",
							Type = "string",
						},
					},
					Returns =
					{
						{
							Type = "string",
						},
					},
					Notes = "Calculates the md5 hash of the data, returns it as a raw (binary) string of 16 characters.",
				},
				md5HexString =
				{
					IsStatic = true,
					IsGlobal = true,
					Params =
					{
						{
							Name = "Data",
							Type = "string",
						},
					},
					Returns =
					{
						{
							Type = "string",
						},
					},
					Notes = "Calculates the md5 hash of the data, returns it as a hex-encoded string of 32 characters.",
				},
				sha1 =
				{
					IsStatic = true,
					IsGlobal = true,
					Params =
					{
						{
							Name = "Data",
							Type = "string",
						},
					},
					Returns =
					{
						{
							Type = "string",
						},
					},
					Notes = "Calculates the sha1 hash of the data, returns it as a raw (binary) string of 20 characters.",
				},
				sha1HexString =
				{
					IsStatic = true,
					IsGlobal = true,
					Params =
					{
						{
							Name = "Data",
							Type = "string",
						},
					},
					Returns =
					{
						{
							Type = "string",
						},
					},
					Notes = "Calculates the sha1 hash of the data, returns it as a hex-encoded string of 40 characters.",
				},
			},
		},
		cEnchantments =
		{
			Desc = [[
				This class  is the storage for enchantments for a single {{cItem|cItem}} object, through its
				m_Enchantments member variable. Although it is possible to create a standalone object of this class,
				it is not yet used in any API directly.</p>
				<p>
				Enchantments can be initialized either programmatically by calling the individual functions
				(SetLevel()), or by using a string description of the enchantment combination. This string
				description is in the form "id=lvl;id=lvl;...;id=lvl;", where id is either a numerical ID of the
				enchantment, or its textual representation from the table below, and lvl is the desired enchantment
				level. The class can also create its string description from its current contents; however that
				string description will only have the numerical IDs.</p>
				<p>
				See the {{cItem}} class for usage examples.
			]],
			Functions =
			{
				Add =
				{
					Params =
					{
						{
							Name = "Other",
							Type = "cEnchantments",
						},
					},
					Notes = "Adds the enchantments contained in Other into this object. Existing enchantments are preserved, unless Other specifies a different level, in which case the level is changed to the Other's one.",
				},
				AddFromString =
				{
					Params =
					{
						{
							Name = "StringSpec",
							Type = "string",
						},
					},
					Notes = "Adds the enchantments in the string description into the object. If a specified enchantment already existed, it is overwritten.",
				},
				Clear =
				{
					Notes = "Removes all enchantments",
				},
				constructor =
				{
					{
						Returns =
						{
							{
								Type = "cEnchantments",
							},
						},
						Notes = "Creates a new empty cEnchantments object",
					},
					{
						Params =
						{
							{
								Name = "StringSpec",
								Type = "string",
							},
						},
						Returns =
						{
							{
								Type = "cEnchantments",
							},
						},
						Notes = "Creates a new cEnchantments object filled with enchantments based on the string description",
					},
				},
				Count =
				{
					Returns =
					{
						{
							Type = "number",
						},
					},
					Notes = "Get the count of enchantments contained within the class",
				},
				GetLevel =
				{
					Params =
					{
						{
							Name = "EnchantmentNumID",
							Type = "number",
						},
					},
					Returns =
					{
						{
							Type = "number",
						},
					},
					Notes = "Returns the level of the specified enchantment stored in this object; 0 if not stored",
				},
				IsEmpty =
				{
					Returns =
					{
						{
							Type = "boolean",
						},
					},
					Notes = "Returns true if the object stores no enchantments",
				},
				operator_eq =
				{
					Params =
					{
						{
							Name = "OtherEnchantments",
							Type = "cEnchantments",
						},
					},
					Returns =
					{
						{
							Type = "boolean",
						},
					},
					Notes = "Returns true if this enchantments object has the same enchantments as OtherEnchantments.",
				},
				SetLevel =
				{
					Params =
					{
						{
							Name = "EnchantmentNumID",
							Type = "number",
						},
						{
							Name = "Level",
							Type = "number",
						},
					},
					Notes = "Sets the level for the specified enchantment, adding it if not stored before, or removing it if Level < = 0",
				},
				StringToEnchantmentID =
				{
					IsStatic = true,
					Params =
					{
						{
							Name = "EnchantmentName",
							Type = "string",
						},
					},
					Returns =
					{
						{
							Type = "number",
						},
					},
					Notes = "Returns the enchantment numerical ID, -1 if not understood. Case insensitive. Also understands plain numbers.",
				},
				ToString =
				{
					Returns =
					{
						{
							Type = "string",
						},
					},
					Notes = "Returns the string description of all the enchantments stored in this object, in numerical-ID form",
				},
			},
			Constants =
			{
				enchAquaAffinity =
				{
					Notes = "",
				},
				enchBaneOfArthropods =
				{
					Notes = "",
				},
				enchBlastProtection =
				{
					Notes = "",
				},
				enchEfficiency =
				{
					Notes = "",
				},
				enchFeatherFalling =
				{
					Notes = "",
				},
				enchFireAspect =
				{
					Notes = "",
				},
				enchFireProtection =
				{
					Notes = "",
				},
				enchFlame =
				{
					Notes = "",
				},
				enchFortune =
				{
					Notes = "",
				},
				enchInfinity =
				{
					Notes = "",
				},
				enchKnockback =
				{
					Notes = "",
				},
				enchLooting =
				{
					Notes = "",
				},
				enchLuckOfTheSea =
				{
					Notes = "",
				},
				enchLure =
				{
					Notes = "",
				},
				enchPower =
				{
					Notes = "",
				},
				enchProjectileProtection =
				{
					Notes = "",
				},
				enchProtection =
				{
					Notes = "",
				},
				enchPunch =
				{
					Notes = "",
				},
				enchRespiration =
				{
					Notes = "",
				},
				enchSharpness =
				{
					Notes = "",
				},
				enchSilkTouch =
				{
					Notes = "",
				},
				enchSmite =
				{
					Notes = "",
				},
				enchThorns =
				{
					Notes = "",
				},
				enchUnbreaking =
				{
					Notes = "",
				},
			},
		},
		cEntity =
		{
			Desc = [[
				A cEntity object represents an object in the world, it has a position and orientation. cEntity is an
				abstract class, and can not be instantiated directly, instead, all entities are implemented as
				subclasses. The cEntity class works as the common interface for the operations that all (most)
				entities support.</p>
				<p>
				All cEntity objects have an Entity Type so it can be determined what kind of entity it is
				efficiently. Entities also have a class inheritance awareness, they know their class name,
				their parent class' name and can decide if there is a class within their inheritance chain.
				Since these functions operate on strings, they are slightly slower than checking the entity type
				directly, on the other hand, they are more specific directly. To check if the entity is a spider,
				you need to call IsMob(), then cast the object to {{cMonster}} and finally compare
				{{cMonster}}:GetMonsterType() to mtSpider. GetClass(), on the other hand, returns "cSpider"
				directly.</p>
				<p>
				Note that you should not store a cEntity object between two hooks' calls, because Cuberite may
				despawn / remove that entity in between the calls. If you need to refer to an entity later, use its
				UniqueID and {{cWorld|cWorld}}'s entity manipulation functions DoWithEntityByID(), ForEachEntity()
				or ForEachEntityInChunk() to access the entity again.</p>
			]],
			Functions =
			{
				AddPosition =
				{
					{
						Params =
						{
							{
								Name = "OffsetX",
								Type = "number",
							},
							{
								Name = "OffsetY",
								Type = "number",
							},
							{
								Name = "OffsetZ",
								Type = "number",
							},
						},
						Notes = "Moves the entity by the specified amount in each axis direction",
					},
					{
						Params =
						{
							{
								Name = "Offset",
								Type = "Vector3d",
							},
						},
						Notes = "Moves the entity by the specified amount in each direction",
					},
				},
				AddPosX =
				{
					Params =
					{
						{
							Name = "OffsetX",
							Type = "number",
						},
					},
					Notes = "Moves the entity by the specified amount in the X axis direction",
				},
				AddPosY =
				{
					Params =
					{
						{
							Name = "OffsetY",
							Type = "number",
						},
					},
					Notes = "Moves the entity by the specified amount in the Y axis direction",
				},
				AddPosZ =
				{
					Params =
					{
						{
							Name = "OffsetZ",
							Type = "number",
						},
					},
					Notes = "Moves the entity by the specified amount in the Z axis direction",
				},
				AddSpeed =
				{
					{
						Params =
						{
							{
								Name = "AddX",
								Type = "number",
							},
							{
								Name = "AddY",
								Type = "number",
							},
							{
								Name = "AddZ",
								Type = "number",
							},
						},
						Notes = "Adds the specified amount of speed in each axis direction.",
					},
					{
						Params =
						{
							{
								Name = "Add",
								Type = "Vector3d",
							},
						},
						Notes = "Adds the specified amount of speed in each axis direction.",
					},
				},
				AddSpeedX =
				{
					Params =
					{
						{
							Name = "AddX",
							Type = "number",
						},
					},
					Notes = "Adds the specified amount of speed in the X axis direction.",
				},
				AddSpeedY =
				{
					Params =
					{
						{
							Name = "AddY",
							Type = "number",
						},
					},
					Notes = "Adds the specified amount of speed in the Y axis direction.",
				},
				AddSpeedZ =
				{
					Params =
					{
						{
							Name = "AddZ",
							Type = "number",
						},
					},
					Notes = "Adds the specified amount of speed in the Z axis direction.",
				},
				ArmorCoversAgainst =
				{
					Params =
					{
						{
							Name = "DamageType",
							Type = "eDamageType",
						},
					},
					Returns =
					{
						{
							Type = "boolean",
						},
					},
					Notes = "Returns whether armor will protect against the specified damage type",
				},
				Destroy =
				{
					Params =
					{
						{
							Name = "ShouldBroadcast",
							Type = "boolean",
							IsOptional = true,
						},
					},
					Notes = "Schedules the entity to be destroyed; if ShouldBroadcast is not present or set to true, broadcasts the DestroyEntity packet",
				},
				GetAirLevel =
				{
					Returns =
					{
						{
							Type = "number",
						},
					},
					Notes = "Returns the air level (number of ticks of air left). Note, this function is only updated with mobs or players.",
				},
				GetArmorCoverAgainst =
				{
					Params =
					{
						{
							Name = "AttackerEntity",
							Type = "cEntity",
						},
						{
							Name = "DamageType",
							Type = "eDamageType",
						},
						{
							Name = "RawDamage",
							Type = "number",
						},
					},
					Returns =
					{
						{
							Type = "number",
						},
					},
					Notes = "Returns the number of hitpoints out of RawDamage that the currently equipped armor would cover. See {{TakeDamageInfo}} for more information on attack damage.",
				},
				GetChunkX =
				{
					Returns =
					{
						{
							Type = "number",
						},
					},
					Notes = "Returns the X-coord of the chunk in which the entity is placed",
				},
				GetChunkZ =
				{
					Returns =
					{
						{
							Type = "number",
						},
					},
					Notes = "Returns the Z-coord of the chunk in which the entity is placed",
				},
				GetClass =
				{
					Returns =
					{
						{
							Type = "string",
						},
					},
					Notes = "Returns the classname of the entity, such as \"cSpider\" or \"cPickup\"",
				},
				GetClassStatic =
				{
					Returns =
					{
						{
							Type = "string",
						},
					},
					Notes = "Returns the entity classname that this class implements. Each descendant overrides this function. Is static",
				},
				GetEntityType =
				{
					Returns =
					{
						{
							Name = "EntityType",
							Type = "cEntity#EntityType",
						},
					},
					Notes = "Returns the type of the entity, one of the {{cEntity#EntityType|etXXX}} constants. Note that to check specific entity type, you should use one of the IsXXX functions instead of comparing the value returned by this call.",
				},
				GetEquippedBoots =
				{
					Returns =
					{
						{
							Type = "cItem",
						},
					},
					Notes = "Returns the boots that the entity has equipped. Returns an empty cItem if no boots equipped or not applicable.",
				},
				GetEquippedChestplate =
				{
					Returns =
					{
						{
							Type = "cItem",
						},
					},
					Notes = "Returns the chestplate that the entity has equipped. Returns an empty cItem if no chestplate equipped or not applicable.",
				},
				GetEquippedHelmet =
				{
					Returns =
					{
						{
							Type = "cItem",
						},
					},
					Notes = "Returns the helmet that the entity has equipped. Returns an empty cItem if no helmet equipped or not applicable.",
				},
				GetEquippedLeggings =
				{
					Returns =
					{
						{
							Type = "cItem",
						},
					},
					Notes = "Returns the leggings that the entity has equipped. Returns an empty cItem if no leggings equipped or not applicable.",
				},
				GetEquippedWeapon =
				{
					Returns =
					{
						{
							Type = "cItem",
						},
					},
					Notes = "Returns the weapon that the entity has equipped. Returns an empty cItem if no weapon equipped or not applicable.",
				},
				GetGravity =
				{
					Returns =
					{
						{
							Type = "number",
						},
					},
					Notes = "Returns the number that is used as the gravity for physics simulation. 1G (9.78) by default.",
				},
				GetHeadYaw =
				{
					Returns =
					{
						{
							Type = "number",
						},
					},
					Notes = "Returns the pitch of the entity's head (FIXME: Rename to GetHeadPitch() ).",
				},
				GetHealth =
				{
					Returns =
					{
						{
							Type = "number",
						},
					},
					Notes = "Returns the current health of the entity.",
				},
				GetHeight =
				{
					Returns =
					{
						{
							Type = "number",
						},
					},
					Notes = "Returns the height (Y size) of the entity",
				},
				GetInvulnerableTicks =
				{
					Returns =
					{
						{
							Type = "number",
						},
					},
					Notes = "Returns the number of ticks that this entity will be invulnerable for. This is used for after-hit recovery - the entities are invulnerable for half a second after being hit.",
				},
				GetKnockbackAmountAgainst =
				{
					Params =
					{
						{
							Name = "ReceiverEntity",
							Type = "cEntity",
						},
					},
					Returns =
					{
						{
							Type = "number",
						},
					},
					Notes = "Returns the amount of knockback that the currently equipped items would cause when attacking the ReceiverEntity.",
				},
				GetLookVector =
				{
					Returns =
					{
						{
							Type = "Vector3f",
						},
					},
					Notes = "Returns the vector that defines the direction in which the entity is looking",
				},
				GetMass =
				{
					Returns =
					{
						{
							Type = "number",
						},
					},
					Notes = "Returns the mass of the entity. Currently unused.",
				},
				GetMaxHealth =
				{
					Returns =
					{
						{
							Type = "number",
						},
					},
					Notes = "Returns the maximum number of hitpoints this entity is allowed to have.",
				},
				GetParentClass =
				{
					Returns =
					{
						{
							Type = "string",
						},
					},
					Notes = "Returns the name of the direct parent class for this entity",
				},
				GetPitch =
				{
					Returns =
					{
						{
							Type = "number",
						},
					},
					Notes = "Returns the pitch (nose-down rotation) of the entity. Measured in degrees, normal values range from -90 to +90. +90 means looking down, 0 means looking straight ahead, -90 means looking up.",
				},
				GetPosition =
				{
					Returns =
					{
						{
							Type = "Vector3d",
						},
					},
					Notes = "Returns the entity's pivot position as a 3D vector",
				},
				GetPosX =
				{
					Returns =
					{
						{
							Type = "number",
						},
					},
					Notes = "Returns the X-coord of the entity's pivot",
				},
				GetPosY =
				{
					Returns =
					{
						{
							Type = "number",
						},
					},
					Notes = "Returns the Y-coord of the entity's pivot",
				},
				GetPosZ =
				{
					Returns =
					{
						{
							Type = "number",
						},
					},
					Notes = "Returns the Z-coord of the entity's pivot",
				},
				GetRawDamageAgainst =
				{
					Params =
					{
						{
							Name = "ReceiverEntity",
							Type = "cEntity",
						},
					},
					Returns =
					{
						{
							Type = "number",
						},
					},
					Notes = "Returns the raw damage that this entity's equipment would cause when attacking the ReceiverEntity. This includes this entity's weapon {{cEnchantments|enchantments}}, but excludes the receiver's armor or potion effects. See {{TakeDamageInfo}} for more information on attack damage.",
				},
				GetRoll =
				{
					Returns =
					{
						{
							Type = "number",
						},
					},
					Notes = "Returns the roll (sideways rotation) of the entity. Currently unused.",
				},
				GetRot =
				{
					Returns =
					{
						{
							Type = "Vector3f",
						},
					},
					Notes = "(OBSOLETE) Returns the entire rotation vector (Yaw, Pitch, Roll)",
				},
				GetSpeed =
				{
					Returns =
					{
						{
							Type = "Vector3d",
						},
					},
					Notes = "Returns the complete speed vector of the entity",
				},
				GetSpeedX =
				{
					Returns =
					{
						{
							Type = "number",
						},
					},
					Notes = "Returns the X-part of the speed vector",
				},
				GetSpeedY =
				{
					Returns =
					{
						{
							Type = "number",
						},
					},
					Notes = "Returns the Y-part of the speed vector",
				},
				GetSpeedZ =
				{
					Returns =
					{
						{
							Type = "number",
						},
					},
					Notes = "Returns the Z-part of the speed vector",
				},
				GetTicksAlive =
				{
					Returns =
					{
						{
							Type = "number",
						},
					},
					Notes = "Returns the number of ticks that this entity has been alive for.",
				},
				GetUniqueID =
				{
					Returns =
					{
						{
							Type = "number",
						},
					},
					Notes = "Returns the ID that uniquely identifies the entity within the running server. Note that this ID is not persisted to the data files.",
				},
				GetWidth =
				{
					Returns =
					{
						{
							Type = "number",
						},
					},
					Notes = "Returns the width (X and Z size) of the entity.",
				},
				GetWorld =
				{
					Returns =
					{
						{
							Type = "cWorld",
						},
					},
					Notes = "Returns the world where the entity resides",
				},
				GetYaw =
				{
					Returns =
					{
						{
							Type = "number",
						},
					},
					Notes = "Returns the yaw (direction) of the entity. Measured in degrees, values range from -180 to +180. 0 means ZP, 90 means XM, -180 means ZM, -90 means XP.",
				},
				HandleSpeedFromAttachee =
				{
					Params =
					{
						{
							Name = "ForwardAmount",
							Type = "number",
						},
						{
							Name = "SidewaysAmount",
							Type = "number",
						},
					},
					Notes = "Updates the entity's speed based on the attachee exerting the specified force forward and sideways. Used for entities being driven by other entities attached to them - usually players driving minecarts and boats.",
				},
				Heal =
				{
					Params =
					{
						{
							Name = "Hitpoints",
							Type = "number",
						},
					},
					Notes = "Heals the specified number of hitpoints. Hitpoints is expected to be a positive number.",
				},
				IsA =
				{
					Params =
					{
						{
							Name = "ClassName",
							Type = "string",
						},
					},
					Returns =
					{
						{
							Type = "boolean",
						},
					},
					Notes = "Returns true if the entity class is a descendant of the specified class name, or the specified class itself",
				},
				IsBoat =
				{
					Returns =
					{
						{
							Type = "boolean",
						},
					},
					Notes = "Returns true if the entity is a {{cBoat|boat}}.",
				},
				IsCrouched =
				{
					Returns =
					{
						{
							Type = "boolean",
						},
					},
					Notes = "Returns true if the entity is crouched. Always false for entities that don't support crouching.",
				},
				IsDestroyed =
				{
					Returns =
					{
						{
							Type = "boolean",
						},
					},
					Notes = "(<b>DEPRECATED</b>) Please use cEntity:IsTicking().",
				},
				IsEnderCrystal =
				{
					Returns =
					{
						{
							Type = "boolean",
						},
					},
					Notes = "Returns true if the entity is an ender crystal.",
				},
				IsExpOrb =
				{
					Returns =
					{
						{
							Type = "boolean",
						},
					},
					Notes = "Returns true if the entity represents an experience orb",
				},
				IsFallingBlock =
				{
					Returns =
					{
						{
							Type = "boolean",
						},
					},
					Notes = "Returns true if the entity represents a {{cFallingBlock}} entity.",
				},
				IsFireproof =
				{
					Returns =
					{
						{
							Type = "boolean",
						},
					},
					Notes = "Returns true if the entity takes no damage from being on fire.",
				},
				IsFloater =
				{
					Returns =
					{
						{
							Type = "boolean",
						},
					},
					Notes = "Returns true if the entity represents a fishing rod floater",
				},
				IsInvisible =
				{
					Returns =
					{
						{
							Type = "boolean",
						},
					},
					Notes = "Returns true if the entity is invisible",
				},
				IsItemFrame =
				{
					Returns =
					{
						{
							Type = "boolean",
						},
					},
					Notes = "Returns true if the entity is an item frame.",
				},
				IsMinecart =
				{
					Returns =
					{
						{
							Type = "boolean",
						},
					},
					Notes = "Returns true if the entity represents a {{cMinecart|minecart}}",
				},
				IsMob =
				{
					Returns =
					{
						{
							Type = "boolean",
						},
					},
					Notes = "Returns true if the entity represents any {{cMonster|mob}}.",
				},
				IsOnFire =
				{
					Returns =
					{
						{
							Type = "boolean",
						},
					},
					Notes = "Returns true if the entity is on fire",
				},
				IsOnGround =
				{
					Returns =
					{
						{
							Type = "boolean",
						},
					},
					Notes = "Returns true if the entity is on ground (not falling, not jumping, not flying)",
				},
				IsPainting =
				{
					Returns =
					{
						{
							Type = "boolean",
						},
					},
					Notes = "Returns if this entity is a painting.",
				},
				IsPawn =
				{
					Returns =
					{
						{
							Type = "boolean",
						},
					},
					Notes = "Returns true if the entity is a {{cPawn}} descendant.",
				},
				IsPickup =
				{
					Returns =
					{
						{
							Type = "boolean",
						},
					},
					Notes = "Returns true if the entity represents a {{cPickup|pickup}}.",
				},
				IsPlayer =
				{
					Returns =
					{
						{
							Type = "boolean",
						},
					},
					Notes = "Returns true if the entity represents a {{cPlayer|player}}",
				},
				IsProjectile =
				{
					Returns =
					{
						{
							Type = "boolean",
						},
					},
					Notes = "Returns true if the entity is a {{cProjectileEntity}} descendant.",
				},
				IsRclking =
				{
					Returns =
					{
						{
							Type = "boolean",
						},
					},
					Notes = "Currently unimplemented",
				},
				IsRiding =
				{
					Returns =
					{
						{
							Type = "boolean",
						},
					},
					Notes = "Returns true if the entity is attached to (riding) another entity.",
				},
				IsSprinting =
				{
					Returns =
					{
						{
							Type = "boolean",
						},
					},
					Notes = "Returns true if the entity is sprinting. Entities that cannot sprint return always false",
				},
				IsSubmerged =
				{
					Returns =
					{
						{
							Type = "boolean",
						},
					},
					Notes = "Returns true if the mob or player is submerged in water (head is in a water block). Note, this function is only updated with mobs or players.",
				},
				IsSwimming =
				{
					Returns =
					{
						{
							Type = "boolean",
						},
					},
					Notes = "Returns true if the mob or player is swimming in water (feet are in a water block). Note, this function is only updated with mobs or players.",
				},
				IsTicking =
				{
					Returns =
					{
						{
							Type = "boolean",
						},
					},
					Notes = "Returns true if the entity is valid and ticking. Returns false if the entity is not ticking and is about to leave its current world either via teleportation or destruction. If this returns false, you must stop using the cEntity pointer you have.",
				},
				IsTNT =
				{
					Returns =
					{
						{
							Type = "boolean",
						},
					},
					Notes = "Returns true if the entity represents a {{cTNTEntity|TNT entity}}",
				},
				Killed =
				{
					Params =
					{
						{
							Name = "Victim",
							Type = "cEntity",
						},
					},
					Notes = "This entity has killed another entity (the Victim). For players, adds the scoreboard statistics about the kill.",
				},
				KilledBy =
				{
					Notes = "FIXME: Remove this from API",
				},
				MoveToWorld =
				{
					{
						Params =
						{
							{
								Name = "World",
								Type = "cWorld",
							},
							{
								Name = "ShouldSendRespawn",
								Type = "boolean",
								IsOptional = true,
							},
						},
						Returns =
						{
							{
								Type = "boolean",
							},
						},
						Notes = "Removes the entity from this world and starts moving it to the specified world's spawn point. Note that to avoid deadlocks, the move is asynchronous - the entity is moved into a queue and will be moved from that queue into the destination world at some (unpredictable) time in the future. ShouldSendRespawn is used only for players, it specifies whether the player should be sent a Respawn packet upon leaving the world (The client handles respawns only between different dimensions). <b>OBSOLETE</b>, use ScheduleMoveToWorld() instead.",
					},
					{
						Params =
						{
							{
								Name = "WorldName",
								Type = "string",
							},
							{
								Name = "ShouldSendRespawn",
								Type = "boolean",
								IsOptional = true,
							},
						},
						Returns =
						{
							{
								Type = "boolean",
							},
						},
						Notes = "Removes the entity from this world and starts moving it to the specified world's spawn point. Note that to avoid deadlocks, the move is asynchronous - the entity is moved into a queue and will be moved from that queue into the destination world at some (unpredictable) time in the future. ShouldSendRespawn is used only for players, it specifies whether the player should be sent a Respawn packet upon leaving the world (The client handles respawns only between different dimensions). <b>OBSOLETE</b>, use ScheduleMoveToWorld() instead.",
					},
					{
						Params =
						{
							{
								Name = "World",
								Type = "cWorld",
							},
							{
								Name = "ShouldSendRespawn",
								Type = "boolean",
							},
							{
								Name = "Position",
								Type = "Vector3d",
							},
						},
						Returns =
						{
							{
								Type = "boolean",
							},
						},
						Notes = "Removes the entity from this world and starts moving it to the specified world. Note that to avoid deadlocks, the move is asynchronous - the entity is moved into a queue and will be moved from that queue into the destination world at some (unpredictable) time in the future. ShouldSendRespawn is used only for players, it specifies whether the player should be sent a Respawn packet upon leaving the world (The client handles respawns only between different dimensions). The Position parameter specifies the location that the entity should be placed in, in the new world. <b>OBSOLETE</b>, use ScheduleMoveToWorld() instead.",
					},
				},
				ScheduleMoveToWorld =
				{
					Params =
					{
						{
							Name = "World",
							Type = "cWorld",
						},
						{
							Name = "NewPosition",
							Type = "Vector3d",
						},
						{
							Name = "ShouldSetPortalCooldown",
							Type = "boolean",
							IsOptional = true,
						},
					},
					Notes = "Schedules a MoveToWorld call to occur on the next Tick of the entity. If ShouldSetPortalCooldown is false (default), doesn't set any portal cooldown, if it is true, the default portal cooldown is applied to the entity.",
				},
				SetGravity =
				{
					Params =
					{
						{
							Name = "Gravity",
							Type = "number",
						},
					},
					Notes = "Sets the number that is used as the gravity for physics simulation. 1G (9.78) by default.",
				},
				SetHeadYaw =
				{
					Params =
					{
						{
							Name = "HeadPitch",
							Type = "number",
						},
					},
					Notes = "Sets the head pitch (FIXME: Rename to SetHeadPitch() ).",
				},
				SetHealth =
				{
					Params =
					{
						{
							Name = "Hitpoints",
							Type = "number",
						},
					},
					Notes = "Sets the entity's health to the specified amount of hitpoints. Doesn't broadcast any hurt animation. Doesn't kill the entity if health drops below zero. Use the TakeDamage() function instead for taking damage.",
				},
				SetHeight =
				{
					Notes = "FIXME: Remove this from API",
				},
				SetInvulnerableTicks =
				{
					Params =
					{
						{
							Name = "NumTicks",
							Type = "number",
						},
					},
					Notes = "Sets the amount of ticks for which the entity will not receive any damage from other entities.",
				},
				SetIsFireproof =
				{
					Params =
					{
						{
							Name = "IsFireproof",
							Type = "boolean",
						},
					},
					Notes = "Sets whether the entity receives damage from being on fire.",
				},
				SetMass =
				{
					Params =
					{
						{
							Name = "Mass",
							Type = "number",
						},
					},
					Notes = "Sets the mass of the entity. Currently unused.",
				},
				SetMaxHealth =
				{
					Params =
					{
						{
							Name = "MaxHitpoints",
							Type = "number",
						},
					},
					Notes = "Sets the maximum hitpoints of the entity. If current health is above MaxHitpoints, it is capped to MaxHitpoints.",
				},
				SetPitch =
				{
					Params =
					{
						{
							Name = "Pitch",
							Type = "number",
						},
					},
					Notes = "Sets the pitch (nose-down rotation) of the entity",
				},
				SetPitchFromSpeed =
				{
					Notes = "Sets the entity pitch to match its speed (entity looking forwards as it moves)",
				},
				SetPosition =
				{
					{
						Params =
						{
							{
								Name = "PosX",
								Type = "number",
							},
							{
								Name = "PosY",
								Type = "number",
							},
							{
								Name = "PosZ",
								Type = "number",
							},
						},
						Notes = "Sets all three coords of the entity's pivot",
					},
					{
						Params =
						{
							{
								Name = "Vector3d",
								Type = "Vector3d",
							},
						},
						Notes = "Sets all three coords of the entity's pivot",
					},
				},
				SetPosX =
				{
					Params =
					{
						{
							Name = "PosX",
							Type = "number",
						},
					},
					Notes = "Sets the X-coord of the entity's pivot",
				},
				SetPosY =
				{
					Params =
					{
						{
							Name = "PosY",
							Type = "number",
						},
					},
					Notes = "Sets the Y-coord of the entity's pivot",
				},
				SetPosZ =
				{
					Params =
					{
						{
							Name = "PosZ",
							Type = "number",
						},
					},
					Notes = "Sets the Z-coord of the entity's pivot",
				},
				SetRoll =
				{
					Params =
					{
						{
							Name = "Roll",
							Type = "number",
						},
					},
					Notes = "Sets the roll (sideways rotation) of the entity. Currently unused.",
				},
				SetRot =
				{
					Params =
					{
						{
							Name = "Rotation",
							Type = "Vector3f",
						},
					},
					Notes = "Sets the entire rotation vector (Yaw, Pitch, Roll)",
				},
				SetSpeed =
				{
					{
						Params =
						{
							{
								Name = "SpeedX",
								Type = "number",
							},
							{
								Name = "SpeedY",
								Type = "number",
							},
							{
								Name = "SpeedZ",
								Type = "number",
							},
						},
						Notes = "Sets the current speed of the entity",
					},
					{
						Params =
						{
							{
								Name = "Speed",
								Type = "Vector3d",
							},
						},
						Notes = "Sets the current speed of the entity",
					},
				},
				SetSpeedX =
				{
					Params =
					{
						{
							Name = "SpeedX",
							Type = "number",
						},
					},
					Notes = "Sets the X component of the entity speed",
				},
				SetSpeedY =
				{
					Params =
					{
						{
							Name = "SpeedY",
							Type = "number",
						},
					},
					Notes = "Sets the Y component of the entity speed",
				},
				SetSpeedZ =
				{
					Params =
					{
						{
							Name = "SpeedZ",
							Type = "number",
						},
					},
					Notes = "Sets the Z component of the entity speed",
				},
				SetWidth =
				{
					Notes = "FIXME: Remove this from API",
				},
				SetYaw =
				{
					Params =
					{
						{
							Name = "Yaw",
							Type = "number",
						},
					},
					Notes = "Sets the yaw (direction) of the entity.",
				},
				SetYawFromSpeed =
				{
					Notes = "Sets the entity's yaw to match its current speed (entity looking forwards as it moves).",
				},
				StartBurning =
				{
					Params =
					{
						{
							Name = "NumTicks",
							Type = "number",
						},
					},
					Notes = "Sets the entity on fire for the specified number of ticks. If entity is on fire already, makes it burn for either NumTicks or the number of ticks left from the previous fire, whichever is larger.",
				},
				SteerVehicle =
				{
					Params =
					{
						{
							Name = "ForwardAmount",
							Type = "number",
						},
						{
							Name = "SidewaysAmount",
							Type = "number",
						},
					},
					Notes = "Applies the specified steering to the vehicle this entity is attached to. Ignored if not attached to any entity.",
				},
				StopBurning =
				{
					Notes = "Extinguishes the entity fire, cancels all fire timers.",
				},
				TakeDamage =
				{
					{
						Params =
						{
							{
								Name = "AttackerEntity",
								Type = "cEntity",
							},
						},
						Notes = "Causes this entity to take damage that AttackerEntity would inflict. Includes their weapon and this entity's armor.",
					},
					{
						Params =
						{
							{
								Name = "DamageType",
								Type = "eDamageType",
							},
							{
								Name = "AttackerEntity",
								Type = "cEntity",
							},
							{
								Name = "RawDamage",
								Type = "number",
							},
							{
								Name = "KnockbackAmount",
								Type = "number",
							},
						},
						Notes = "Causes this entity to take damage of the specified type, from the specified attacker (may be nil). The final damage is calculated from RawDamage using the currently equipped armor.",
					},
					{
						Params =
						{
							{
								Name = "DamageType",
								Type = "eDamageType",
							},
							{
								Name = "AttackerEntity",
								Type = "cEntity",
							},
							{
								Name = "RawDamage",
								Type = "number",
							},
							{
								Name = "FinalDamage",
								Type = "number",
							},
							{
								Name = "KnockbackAmount",
								Type = "number",
							},
						},
						Notes = "Causes this entity to take damage of the specified type, from the specified attacker (may be nil). The values are wrapped into a {{TakeDamageInfo}} structure and applied directly.",
					},
				},
				TeleportToCoords =
				{
					Params =
					{
						{
							Name = "PosX",
							Type = "number",
						},
						{
							Name = "PosY",
							Type = "number",
						},
						{
							Name = "PosZ",
							Type = "number",
						},
					},
					Notes = "Teleports the entity to the specified coords. Asks plugins if the teleport is allowed.",
				},
				TeleportToEntity =
				{
					Params =
					{
						{
							Name = "DestEntity",
							Type = "cEntity",
						},
					},
					Notes = "Teleports this entity to the specified destination entity. Asks plugins if the teleport is allowed.",
				},
			},
			Constants =
			{
				etBoat =
				{
					Notes = "The entity is a {{cBoat}}",
				},
				etEnderCrystal =
				{
					Notes = "",
				},
				etEntity =
				{
					Notes = "No further specialization available",
				},
				etExpOrb =
				{
					Notes = "The entity is a {{cExpOrb}}",
				},
				etFallingBlock =
				{
					Notes = "The entity is a {{cFallingBlock}}",
				},
				etFloater =
				{
					Notes = "The entity is a fishing rod floater",
				},
				etItemFrame =
				{
					Notes = "",
				},
				etMinecart =
				{
					Notes = "The entity is a {{cMinecart}} descendant",
				},
				etMob =
				{
					Notes = "The entity is a {{cMonster}} descendant",
				},
				etMonster =
				{
					Notes = "The entity is a {{cMonster}} descendant",
				},
				etPainting =
				{
					Notes = "The entity is a {{cPainting}}",
				},
				etPickup =
				{
					Notes = "The entity is a {{cPickup}}",
				},
				etPlayer =
				{
					Notes = "The entity is a {{cPlayer}}",
				},
				etProjectile =
				{
					Notes = "The entity is a {{cProjectileEntity}} descendant",
				},
				etTNT =
				{
					Notes = "The entity is a {{cTNTEntity}}",
				},
			},
			ConstantGroups =
			{
				EntityType =
				{
					Include = "et.*",
					TextBefore = "The following constants are used to distinguish between different entity types:",
				},
			},
		},
		cEntityEffect =
		{
			Functions =
			{
				GetPotionColor =
				{
					IsStatic = true,
					Params =
					{
						{
							Name = "ItemDamage",
							Type = "number",
						},
					},
					Returns =
					{
						{
							Type = "number",
						},
					},
					Notes = "Returns the potion color (used by the client for visuals), based on the potion's damage value",
				},
				GetPotionEffectDuration =
				{
					IsStatic = true,
					Params =
					{
						{
							Name = "ItemDamage",
							Type = "number",
						},
					},
					Returns =
					{
						{
							Type = "number",
						},
					},
					Notes = "Returns the effect duration, in ticks, based on the potion's damage value",
				},
				GetPotionEffectIntensity =
				{
					IsStatic = true,
					Params =
					{
						{
							Name = "ItemDamage",
							Type = "number",
						},
					},
					Returns =
					{
						{
							Name = "short",
							Type = "number",
						},
					},
					Notes = "Retrieves the intensity level from the potion's damage value. Returns 0 for level I potions, 1 for level II potions.",
				},
				GetPotionEffectType =
				{
					IsStatic = true,
					Params =
					{
						{
							Name = "ItemDamage",
							Type = "number",
						},
					},
					Returns =
					{
						{
							Name = "eType",
							Type = "cEntityEffect#eType",
						},
					},
					Notes = "Translates the potion's damage value into the entity effect that the potion gives",
				},
				IsPotionDrinkable =
				{
					IsStatic = true,
					Params =
					{
						{
							Name = "ItemDamage",
							Type = "number",
						},
					},
					Returns =
					{
						{
							Type = "boolean",
						},
					},
					Notes = "Returns true if the potion with the given damage is drinkable",
				},
			},
		},
		cFile =
		{
			Desc = [[
				Provides helper functions for manipulating and querying the filesystem. Most functions are static,
				so they should be called directly on the cFile class itself:
<pre class="prettyprint lang-lua">
cFile:DeleteFile("/usr/bin/virus.exe");
</pre></p>
			]],
			Functions =
			{
				ChangeFileExt =
				{
					IsStatic = true,
					Params =
					{
						{
							Name = "FileName",
							Type = "string",
						},
						{
							Name = "NewExt",
							Type = "string",
						},
					},
					Returns =
					{
						{
							Type = "string",
						},
					},
					Notes = "Returns FileName with its extension changed to NewExt. NewExt may begin with a dot, but needn't, the result is the same in both cases (the first dot, if present, is ignored). FileName may contain path elements, extension is recognized as the last dot after the last path separator in the string.",
				},
				Copy =
				{
					IsStatic = true,
					Params =
					{
						{
							Name = "SrcFileName",
							Type = "string",
						},
						{
							Name = "DstFileName",
							Type = "string",
						},
					},
					Returns =
					{
						{
							Name = "IsSuccess",
							Type = "boolean",
						},
					},
					Notes = "Copies a single file to a new destination. Returns true if successful. Fails if the destination already exists.",
				},
				CreateFolder =
				{
					IsStatic = true,
					Params =
					{
						{
							Name = "FolderPath",
							Type = "string",
						},
					},
					Returns =
					{
						{
							Name = "IsSuccess",
							Type = "boolean",
						},
					},
					Notes = "Creates a new folder. Returns true if successful. Only a single level can be created at a time, use CreateFolderRecursive() to create multiple levels of folders at once.",
				},
				CreateFolderRecursive =
				{
					IsStatic = true,
					Params =
					{
						{
							Name = "FolderPath",
							Type = "string",
						},
					},
					Returns =
					{
						{
							Name = "IsSuccess",
							Type = "boolean",
						},
					},
					Notes = "Creates a new folder, creating its parents if needed. Returns true if successful.",
				},
				Delete =
				{
					IsStatic = true,
					Params =
					{
						{
							Name = "Path",
							Type = "string",
						},
					},
					Returns =
					{
						{
							Name = "IsSuccess",
							Type = "boolean",
						},
					},
					Notes = "Deletes the specified file or folder. Returns true if successful. Only deletes folders that are empty.<br/><b>NOTE</b>: If you already know if the object is a file or folder, use DeleteFile() or DeleteFolder() explicitly.",
				},
				DeleteFile =
				{
					IsStatic = true,
					Params =
					{
						{
							Name = "FilePath",
							Type = "string",
						},
					},
					Returns =
					{
						{
							Name = "IsSuccess",
							Type = "boolean",
						},
					},
					Notes = "Deletes the specified file. Returns true if successful.",
				},
				DeleteFolder =
				{
					IsStatic = true,
					Params =
					{
						{
							Name = "FolderPath",
							Type = "string",
						},
					},
					Returns =
					{
						{
							Name = "IsSuccess",
							Type = "boolean",
						},
					},
					Notes = "Deletes the specified file or folder. Returns true if successful. Only deletes folders that are empty.",
				},
				DeleteFolderContents =
				{
					IsStatic = true,
					Params =
					{
						{
							Name = "FolderPath",
							Type = "string",
						},
					},
					Returns =
					{
						{
							Name = "IsSuccess",
							Type = "boolean",
						},
					},
					Notes = "Deletes everything from the specified folder, recursively. The specified folder stays intact. Returns true if successful.",
				},
				Exists =
				{
					IsStatic = true,
					Params =
					{
						{
							Name = "Path",
							Type = "string",
						},
					},
					Returns =
					{
						{
							Name = "Exists",
							Type = "boolean",
						},
					},
					Notes = "Returns true if the specified file or folder exists.<br/><b>OBSOLETE</b>, use IsFile() or IsFolder() instead",
				},
				GetExecutableExt =
				{
					IsStatic = true,
					Returns =
					{
						{
							Type = "string",
						},
					},
					Notes = "Returns the customary executable extension (including the dot) used by the current platform (\".exe\" on Windows, empty string on Linux). ",
				},
				GetFolderContents =
				{
					IsStatic = true,
					Params =
					{
						{
							Name = "FolderName",
							Type = "string",
						},
					},
					Returns =
					{
						{
							Type = "table",
						},
					},
					Notes = "Returns the contents of the specified folder, as an array table of strings. Each filesystem object is listed. Use the IsFile() and IsFolder() functions to determine the object type. Note that \".\" and \"..\" are NOT returned. The order of the names is arbitrary (as returned by OS, no sorting).",
				},
				GetLastModificationTime =
				{
					IsStatic = true,
					Params =
					{
						{
							Name = "Path",
							Type = "string",
						},
					},
					Returns =
					{
						{
							Type = "number",
						},
					},
					Notes = "Returns the last modification time (in current timezone) of the specified file or folder. Returns zero if file not found / not accessible. The returned value is in the same units as values returned by os.time().",
				},
				GetPathSeparator =
				{
					IsStatic = true,
					Returns =
					{
						{
							Type = "string",
						},
					},
					Notes = "Returns the primary path separator used by the current platform. Returns \"\\\" on Windows and \"/\" on Linux. Note that the platform or CRT may support additional path separators, those are not reported.",
				},
				GetSize =
				{
					IsStatic = true,
					Params =
					{
						{
							Name = "FileName",
							Type = "string",
						},
					},
					Returns =
					{
						{
							Type = "number",
						},
					},
					Notes = "Returns the size of the file, or -1 on failure.",
				},
				IsFile =
				{
					IsStatic = true,
					Params =
					{
						{
							Name = "Path",
							Type = "string",
						},
					},
					Returns =
					{
						{
							Type = "boolean",
						},
					},
					Notes = "Returns true if the specified path points to an existing file.",
				},
				IsFolder =
				{
					IsStatic = true,
					Params =
					{
						{
							Name = "Path",
							Type = "string",
						},
					},
					Returns =
					{
						{
							Type = "boolean",
						},
					},
					Notes = "Returns true if the specified path points to an existing folder.",
				},
				ReadWholeFile =
				{
					IsStatic = true,
					Params =
					{
						{
							Name = "FileName",
							Type = "string",
						},
					},
					Returns =
					{
						{
							Type = "string",
						},
					},
					Notes = "Returns the entire contents of the specified file. Returns an empty string if the file cannot be opened.",
				},
				Rename =
				{
					IsStatic = true,
					Params =
					{
						{
							Name = "OrigPath",
							Type = "string",
						},
						{
							Name = "NewPath",
							Type = "string",
						},
					},
					Returns =
					{
						{
							Name = "IsSuccess",
							Type = "boolean",
						},
					},
					Notes = "Renames a file or a folder. Returns true if successful. Undefined result if NewPath already exists.",
				},
			},
		},
		cFloater =
		{
			Desc = [[
				Manages the floater created when a player uses their fishing rod.
			]],
			Functions =
			{
				CanPickup =
				{
					Returns =
					{
						{
							Type = "boolean",
						},
					},
					Notes = "Returns true if the floater gives an item when the player right clicks.",
				},
				GetAttachedMobID =
				{
					Returns =
					{
						{
							Name = "EntityID",
							Type = "number",
						},
					},
					Notes = "Returns the EntityID of a mob that this floater is attached to. Returns -1 if not attached to any mob.",
				},
				GetOwnerID =
				{
					Returns =
					{
						{
							Name = "EntityID",
							Type = "number",
						},
					},
					Notes = "Returns the EntityID of the player who owns the floater.",
				},
			},
			Inherits = "cEntity",
		},
		cHangingEntity =
		{
			Functions =
			{
				GetFacing =
				{
					Returns =
					{
						{
							Name = "BlockFace",
							Type = "eBlockFace",
						},
					},
					Notes = "Returns the direction in which the entity is facing.",
				},
				SetFacing =
				{
					Params =
					{
						{
							Name = "BlockFace",
							Type = "eBlockFace",
						},
					},
					Notes = "Set the direction in which the entity is facing.",
				},
			},
			Inherits = "cEntity",
		},
		cIniFile =
		{
			Desc = [[
				This class implements a simple name-value storage represented on disk by an INI file. These files
				are suitable for low-volume high-latency human-readable information storage, such as for
				configuration. Cuberite itself uses INI files for settings and options.</p>
				<p>
				The INI files follow this basic structure:
<pre class="prettyprint lang-ini">
; Header comment line
[KeyName0]
; Key comment line 0
ValueName0=Value0
ValueName1=Value1

[KeyName1]
; Key comment line 0
; Key comment line 1
ValueName0=SomeOtherValue
</pre>
				The cIniFile object stores all the objects in numbered arrays and provides access to the information
				either based on names (KeyName, ValueName) or zero-based indices.</p>
				<p>
				The objects of this class are created empty. You need to either load a file using ReadFile(), or
				insert values by hand. Then you can store the object's contents to a disk file using WriteFile(), or
				just forget everything by destroying the object. Note that the file operations are quite slow.</p>
				<p>
				For storing high-volume low-latency data, use the {{sqlite3}} class. For storing
				hierarchically-structured data, use the XML format, using the LuaExpat parser in the {{lxp}} class.
			]],
			Functions =
			{
				AddHeaderComment =
				{
					Params =
					{
						{
							Name = "Comment",
							Type = "string",
						},
					},
					Notes = "Adds a comment to be stored in the file header.",
				},
				AddKeyComment =
				{
					{
						Params =
						{
							{
								Name = "KeyID",
								Type = "number",
							},
							{
								Name = "Comment",
								Type = "string",
							},
						},
						Notes = "Adds a comment to be stored in the file under the specified key",
					},
					{
						Params =
						{
							{
								Name = "KeyName",
								Type = "string",
							},
							{
								Name = "Comment",
								Type = "string",
							},
						},
						Notes = "Adds a comment to be stored in the file under the specified key",
					},
				},
				AddKeyName =
				{
					Params =
					{
						{
							Name = "KeyName",
							Type = "string",
						},
					},
					Returns =
					{
						{
							Type = "number",
						},
					},
					Notes = "Adds a new key of the specified name. Returns the KeyID of the new key.",
				},
				AddValue =
				{
					Params =
					{
						{
							Name = "KeyName",
							Type = "string",
						},
						{
							Name = "ValueName",
							Type = "string",
						},
						{
							Name = "Value",
							Type = "string",
						},
					},
					Notes = "Adds a new value of the specified name to the specified key. If another value of the same name exists in the key, both are kept (nonstandard INI file)",
				},
				AddValueB =
				{
					Params =
					{
						{
							Name = "KeyName",
							Type = "string",
						},
						{
							Name = "ValueName",
							Type = "string",
						},
						{
							Name = "Value",
							Type = "boolean",
						},
					},
					Notes = "Adds a new bool value of the specified name to the specified key. If another value of the same name exists in the key, both are kept (nonstandard INI file)",
				},
				AddValueF =
				{
					Params =
					{
						{
							Name = "KeyName",
							Type = "string",
						},
						{
							Name = "ValueName",
							Type = "string",
						},
						{
							Name = "Value",
							Type = "number",
						},
					},
					Notes = "Adds a new float value of the specified name to the specified key. If another value of the same name exists in the key, both are kept (nonstandard INI file)",
				},
				AddValueI =
				{
					Params =
					{
						{
							Name = "KeyName",
							Type = "string",
						},
						{
							Name = "ValueName",
							Type = "string",
						},
						{
							Name = "Value",
							Type = "number",
						},
					},
					Notes = "Adds a new integer value of the specified name to the specified key. If another value of the same name exists in the key, both are kept (nonstandard INI file)",
				},
				CaseInsensitive =
				{
					Notes = "Sets key names' and value names' comparisons to case insensitive (default).",
				},
				CaseSensitive =
				{
					Notes = "Sets key names and value names comparisons to case sensitive.",
				},
				Clear =
				{
					Notes = "Removes all the in-memory data. Note that , like all the other operations, this doesn't affect any file data.",
				},
				constructor =
				{
					Returns =
					{
						{
							Type = "cIniFile",
						},
					},
					Notes = "Creates a new empty cIniFile object.",
				},
				DeleteHeaderComment =
				{
					Params =
					{
						{
							Name = "CommentID",
							Type = "number",
						},
					},
					Returns =
					{
						{
							Name = "IsSuccess",
							Type = "boolean",
						},
					},
					Notes = "Deletes the specified header comment. Returns true if successful.",
				},
				DeleteHeaderComments =
				{
					Notes = "Deletes all headers comments.",
				},
				DeleteKey =
				{
					Params =
					{
						{
							Name = "KeyName",
							Type = "string",
						},
					},
					Returns =
					{
						{
							Name = "IsSuccess",
							Type = "boolean",
						},
					},
					Notes = "Deletes the specified key, and all values in that key. Returns true if successful.",
				},
				DeleteKeyComment =
				{
					{
						Params =
						{
							{
								Name = "KeyID",
								Type = "number",
							},
							{
								Name = "CommentID",
								Type = "number",
							},
						},
						Returns =
						{
							{
								Name = "IsSuccess",
								Type = "boolean",
							},
						},
						Notes = "Deletes the specified key comment. Returns true if successful.",
					},
					{
						Params =
						{
							{
								Name = "KeyName",
								Type = "string",
							},
							{
								Name = "CommentID",
								Type = "number",
							},
						},
						Returns =
						{
							{
								Name = "IsSuccess",
								Type = "boolean",
							},
						},
						Notes = "Deletes the specified key comment. Returns true if successful.",
					},
				},
				DeleteKeyComments =
				{
					{
						Params =
						{
							{
								Name = "KeyID",
								Type = "number",
							},
						},
						Returns =
						{
							{
								Name = "IsSuccess",
								Type = "boolean",
							},
						},
						Notes = "Deletes all comments for the specified key. Returns true if successful.",
					},
					{
						Params =
						{
							{
								Name = "KeyName",
								Type = "string",
							},
						},
						Returns =
						{
							{
								Name = "IsSuccess",
								Type = "boolean",
							},
						},
						Notes = "Deletes all comments for the specified key. Returns true if successful.",
					},
				},
				DeleteValue =
				{
					Params =
					{
						{
							Name = "KeyName",
							Type = "string",
						},
						{
							Name = "ValueName",
							Type = "string",
						},
					},
					Returns =
					{
						{
							Name = "IsSuccess",
							Type = "boolean",
						},
					},
					Notes = "Deletes the specified value. Returns true if successful.",
				},
				DeleteValueByID =
				{
					Params =
					{
						{
							Name = "KeyID",
							Type = "number",
						},
						{
							Name = "ValueID",
							Type = "number",
						},
					},
					Returns =
					{
						{
							Name = "IsSuccess",
							Type = "boolean",
						},
					},
					Notes = "Deletes the specified value. Returns true if successful.",
				},
				FindKey =
				{
					Params =
					{
						{
							Name = "KeyName",
							Type = "string",
						},
					},
					Returns =
					{
						{
							Type = "number",
						},
					},
					Notes = "Returns the KeyID for the specified key name, or the noID constant if the key doesn't exist.",
				},
				FindValue =
				{
					Params =
					{
						{
							Name = "KeyID",
							Type = "number",
						},
						{
							Name = "ValueName",
							Type = "string",
						},
					},
					Returns =
					{
						{
							Name = "ValueID",
							Type = "number",
						},
					},
					Notes = "Returns the ValueID for the specified value name, or the noID constant if the specified key doesn't contain a value of that name.",
				},
				Flush =
				{
					Returns =
					{
						{
							Type = "boolean",
						},
					},
					Notes = "Writes the data stored in the object to the file that was last associated with the object (ReadFile() or WriteFile()). Returns true on success, false on failure.",
				},
				GetHeaderComment =
				{
					Params =
					{
						{
							Name = "CommentID",
							Type = "number",
						},
					},
					Returns =
					{
						{
							Type = "string",
						},
					},
					Notes = "Returns the specified header comment, or an empty string if such comment doesn't exist",
				},
				GetKeyComment =
				{
					{
						Params =
						{
							{
								Name = "KeyID",
								Type = "number",
							},
							{
								Name = "CommentID",
								Type = "number",
							},
						},
						Returns =
						{
							{
								Type = "string",
							},
						},
						Notes = "Returns the specified key comment, or an empty string if such a comment doesn't exist",
					},
					{
						Params =
						{
							{
								Name = "KeyName",
								Type = "string",
							},
							{
								Name = "CommentID",
								Type = "number",
							},
						},
						Returns =
						{
							{
								Type = "string",
							},
						},
						Notes = "Returns the specified key comment, or an empty string if such a comment doesn't exist",
					},
				},
				GetKeyName =
				{
					Params =
					{
						{
							Name = "KeyID",
							Type = "number",
						},
					},
					Returns =
					{
						{
							Type = "string",
						},
					},
					Notes = "Returns the key name for the specified key ID. Inverse for FindKey().",
				},
				GetNumHeaderComments =
				{
					Returns =
					{
						{
							Type = "number",
						},
					},
					Notes = "Retuns the number of header comments.",
				},
				GetNumKeyComments =
				{
					{
						Params =
						{
							{
								Name = "KeyID",
								Type = "number",
							},
						},
						Returns =
						{
							{
								Type = "number",
							},
						},
						Notes = "Returns the number of comments under the specified key",
					},
					{
						Params =
						{
							{
								Name = "KeyName",
								Type = "string",
							},
						},
						Returns =
						{
							{
								Type = "number",
							},
						},
						Notes = "Returns the number of comments under the specified key",
					},
				},
				GetNumKeys =
				{
					Returns =
					{
						{
							Type = "number",
						},
					},
					Notes = "Returns the total number of keys. This is the range for the KeyID (0 .. GetNumKeys() - 1)",
				},
				GetNumValues =
				{
					{
						Params =
						{
							{
								Name = "KeyID",
								Type = "number",
							},
						},
						Returns =
						{
							{
								Type = "number",
							},
						},
						Notes = "Returns the number of values stored under the specified key.",
					},
					{
						Params =
						{
							{
								Name = "KeyName",
								Type = "string",
							},
						},
						Returns =
						{
							{
								Type = "number",
							},
						},
						Notes = "Returns the number of values stored under the specified key.",
					},
				},
				GetValue =
				{
					{
						Params =
						{
							{
								Name = "KeyName",
								Type = "string",
							},
							{
								Name = "ValueName",
								Type = "string",
							},
							{
								Name = "DefaultValue",
								Type = "string",
								IsOptional = true,
							},
						},
						Returns =
						{
							{
								Type = "string",
							},
						},
						Notes = "Returns the value of the specified name under the specified key. Returns DefaultValue (empty string if not given) if the value doesn't exist.",
					},
					{
						Params =
						{
							{
								Name = "KeyID",
								Type = "number",
							},
							{
								Name = "ValueID",
								Type = "number",
							},
							{
								Name = "DefaultValue",
								Type = "string",
								IsOptional = true,
							},
						},
						Returns =
						{
							{
								Type = "string",
							},
						},
						Notes = "Returns the value of the specified name under the specified key. Returns DefaultValue (empty string if not given) if the value doesn't exist.",
					},
				},
				GetValueB =
				{
					Params =
					{
						{
							Name = "KeyName",
							Type = "string",
						},
						{
							Name = "ValueName",
							Type = "string",
						},
						{
							Name = "DefaultValue",
							Type = "boolean",
							IsOptional = true,
						},
					},
					Returns =
					{
						{
							Type = "boolean",
						},
					},
					Notes = "Returns the value of the specified name under the specified key, as a bool. Returns DefaultValue (false if not given) if the value doesn't exist.",
				},
				GetValueF =
				{
					Params =
					{
						{
							Name = "KeyName",
							Type = "string",
						},
						{
							Name = "ValueName",
							Type = "string",
						},
						{
							Name = "DefaultValue",
							Type = "number",
							IsOptional = true,
						},
					},
					Returns =
					{
						{
							Type = "number",
						},
					},
					Notes = "Returns the value of the specified name under the specified key, as a floating-point number. Returns DefaultValue (zero if not given) if the value doesn't exist.",
				},
				GetValueI =
				{
					Params =
					{
						{
							Name = "KeyName",
							Type = "string",
						},
						{
							Name = "ValueName",
							Type = "string",
						},
						{
							Name = "DefaultValue",
							Type = "number",
							IsOptional = true,
						},
					},
					Returns =
					{
						{
							Type = "number",
						},
					},
					Notes = "Returns the value of the specified name under the specified key, as an integer. Returns DefaultValue (zero if not given) if the value doesn't exist.",
				},
				GetValueName =
				{
					{
						Params =
						{
							{
								Name = "KeyID",
								Type = "number",
							},
							{
								Name = "ValueID",
								Type = "number",
							},
						},
						Returns =
						{
							{
								Type = "string",
							},
						},
						Notes = "Returns the name of the value specified by its ID. Inverse for FindValue().",
					},
					{
						Params =
						{
							{
								Name = "KeyName",
								Type = "string",
							},
							{
								Name = "ValueID",
								Type = "number",
							},
						},
						Returns =
						{
							{
								Type = "string",
							},
						},
						Notes = "Returns the name of the value specified by its ID. Inverse for FindValue().",
					},
				},
				GetValueSet =
				{
					Params =
					{
						{
							Name = "KeyName",
							Type = "string",
						},
						{
							Name = "ValueName",
							Type = "string",
						},
						{
							Name = "DefaultValue",
							Type = "string",
							IsOptional = true,
						},
					},
					Returns =
					{
						{
							Type = "string",
						},
					},
					Notes = "Returns the value of the specified name under the specified key. If the value doesn't exist, creates it with the specified default (empty string if not given).",
				},
				GetValueSetB =
				{
					Params =
					{
						{
							Name = "KeyName",
							Type = "string",
						},
						{
							Name = "ValueName",
							Type = "string",
						},
						{
							Name = "DefaultValue",
							Type = "boolean",
							IsOptional = true,
						},
					},
					Returns =
					{
						{
							Type = "boolean",
						},
					},
					Notes = "Returns the value of the specified name under the specified key, as a bool. If the value doesn't exist, creates it with the specified default (false if not given).",
				},
				GetValueSetF =
				{
					Params =
					{
						{
							Name = "KeyName",
							Type = "string",
						},
						{
							Name = "ValueName",
							Type = "string",
						},
						{
							Name = "DefaultValue",
							Type = "number",
							IsOptional = true,
						},
					},
					Returns =
					{
						{
							Type = "number",
						},
					},
					Notes = "Returns the value of the specified name under the specified key, as a floating-point number. If the value doesn't exist, creates it with the specified default (zero if not given).",
				},
				GetValueSetI =
				{
					Params =
					{
						{
							Name = "KeyName",
							Type = "string",
						},
						{
							Name = "ValueName",
							Type = "string",
						},
						{
							Name = "DefaultValue",
							Type = "number",
							IsOptional = true,
						},
					},
					Returns =
					{
						{
							Type = "number",
						},
					},
					Notes = "Returns the value of the specified name under the specified key, as an integer. If the value doesn't exist, creates it with the specified default (zero if not given).",
				},
				HasValue =
				{
					Params =
					{
						{
							Name = "KeyName",
							Type = "string",
						},
						{
							Name = "ValueName",
							Type = "string",
						},
					},
					Returns =
					{
						{
							Type = "boolean",
						},
					},
					Notes = "Returns true if the specified value is present.",
				},
				ReadFile =
				{
					Params =
					{
						{
							Name = "FileName",
							Type = "string",
						},
						{
							Name = "AllowExampleFallback",
							Type = "boolean",
							IsOptional = true,
						},
					},
					Returns =
					{
						{
							Name = "IsSuccess",
							Type = "boolean",
						},
					},
					Notes = "Reads the values from the specified file. Previous in-memory contents are lost. If the file cannot be opened, and AllowExample is true, another file, \"filename.example.ini\", is loaded and then saved as \"filename.ini\". Returns true if successful, false if not.",
				},
				SetValue =
				{
					{
						Params =
						{
							{
								Name = "KeyID",
								Type = "number",
							},
							{
								Name = "ValueID",
								Type = "number",
							},
							{
								Name = "NewValue",
								Type = "string",
							},
						},
						Returns =
						{
							{
								Name = "IsSuccess",
								Type = "boolean",
							},
						},
						Notes = "Overwrites the specified value with a new value. If the specified value doesn't exist, returns false (doesn't add).",
					},
					{
						Params =
						{
							{
								Name = "KeyName",
								Type = "string",
							},
							{
								Name = "ValueName",
								Type = "string",
							},
							{
								Name = "NewValue",
								Type = "string",
							},
							{
								Name = "CreateIfNotExists",
								Type = "boolean",
								IsOptional = true,
							},
						},
						Returns =
						{
							{
								Name = "IsSuccess",
								Type = "boolean",
							},
						},
						Notes = "Overwrites the specified value with a new value. If CreateIfNotExists is true (default) and the value doesn't exist, it is first created. Returns true if the value was successfully set, false if not (didn't exists, CreateIfNotExists false).",
					},
				},
				SetValueB =
				{
					Params =
					{
						{
							Name = "KeyName",
							Type = "string",
						},
						{
							Name = "ValueName",
							Type = "string",
						},
						{
							Name = "NewValue",
							Type = "boolean",
						},
						{
							Name = "CreateIfNotExists",
							Type = "boolean",
							IsOptional = true,
						},
					},
					Returns =
					{
						{
							Name = "IsSuccess",
							Type = "boolean",
						},
					},
					Notes = "Overwrites the specified value with a new bool value. If CreateIfNotExists is true (default) and the value doesn't exist, it is first created. Returns true if the value was successfully set, false if not (didn't exists, CreateIfNotExists false).",
				},
				SetValueF =
				{
					Params =
					{
						{
							Name = "KeyName",
							Type = "string",
						},
						{
							Name = "ValueName",
							Type = "string",
						},
						{
							Name = "NewValue",
							Type = "number",
						},
						{
							Name = "CreateIfNotExists",
							Type = "boolean",
							IsOptional = true,
						},
					},
					Returns =
					{
						{
							Name = "IsSuccess",
							Type = "boolean",
						},
					},
					Notes = "Overwrites the specified value with a new floating-point number value. If CreateIfNotExists is true (default) and the value doesn't exist, it is first created. Returns true if the value was successfully set, false if not (didn't exists, CreateIfNotExists false).",
				},
				SetValueI =
				{
					Params =
					{
						{
							Name = "KeyName",
							Type = "string",
						},
						{
							Name = "ValueName",
							Type = "string",
						},
						{
							Name = "NewValue",
							Type = "number",
						},
						{
							Name = "CreateIfNotExists",
							Type = "boolean",
							IsOptional = true,
						},
					},
					Returns =
					{
						{
							Name = "IsSuccess",
							Type = "boolean",
						},
					},
					Notes = "Overwrites the specified value with a new integer value. If CreateIfNotExists is true (default) and the value doesn't exist, it is first created. Returns true if the value was successfully set, false if not (didn't exists, CreateIfNotExists false).",
				},
				WriteFile =
				{
					Params =
					{
						{
							Name = "FileName",
							Type = "string",
						},
					},
					Returns =
					{
						{
							Name = "IsSuccess",
							Type = "boolean",
						},
					},
					Notes = "Writes the current in-memory data into the specified file. Returns true if successful, false if not.",
				},
			},
			Constants =
			{
				noID =
				{
					Notes = "",
				},
			},
			AdditionalInfo =
			{
				{
					Header = "Code example: Reading a simple value",
					Contents = [[
						cIniFile is very easy to use. For example, you can find out what port the server is supposed to
						use according to settings.ini by using this little snippet:
<pre class="prettyprint lang-lua">
local IniFile = cIniFile();
if (IniFile:ReadFile("settings.ini")) then
	ServerPort = IniFile:GetValueI("Server", "Port");
end
</pre>
					]],
				},
				{
					Header = "Code example: Enumerating all objects in a file",
					Contents = [[
						To enumerate all keys in a file, you need to query the total number of keys, using GetNumKeys(),
						and then query each key's name using GetKeyName(). Similarly, to enumerate all values under a
						key, you need to query the total number of values using GetNumValues() and then query each
						value's name using GetValueName().</p>
						<p>
						The following code logs all keynames and their valuenames into the server log:
<pre class="prettyprint lang-lua">
local IniFile = cIniFile();
IniFile:ReadFile("somefile.ini")
local NumKeys = IniFile:GetNumKeys();
for k = 0, (NumKeys - 1) do
	local NumValues = IniFile:GetNumValues(k);
	LOG("key \"" .. IniFile:GetKeyName(k) .. "\" has " .. NumValues .. " values:");
	for v = 0, (NumValues - 1) do
		LOG("  value \"" .. IniFile:GetValueName(k, v) .. "\".");
	end
end
</pre>
					]],
				},
			},
		},
		cInventory =
		{
			Desc = [[
This object is used to store the items that a {{cPlayer|cPlayer}} has. It also keeps track of what item the player has currently selected in their hotbar.
Internally, the class uses three {{cItemGrid|cItemGrid}} objects to store the contents:
<li>Armor</li>
<li>Inventory</li>
<li>Hotbar</li>
These ItemGrids are available in the API and can be manipulated by the plugins, too.</p>
				<p>
				When using the raw slot access functions, such as GetSlot() and SetSlot(), the slots are numbered
				consecutively, each ItemGrid has its offset and count. To future-proff your plugins, use the named
				constants instead of hard-coded numbers.
			]],
			Functions =
			{
				AddItem =
				{
					Params =
					{
						{
							Name = "cItem",
							Type = "cItem",
						},
						{
							Name = "AllowNewStacks",
							Type = "boolean",
							IsOptional = true,
						},
					},
					Returns =
					{
						{
							Type = "number",
						},
					},
					Notes = "Adds an item to the storage; if AllowNewStacks is true (default), will also create new stacks in empty slots. Returns the number of items added",
				},
				AddItems =
				{
					Params =
					{
						{
							Name = "cItems",
							Type = "cItems",
						},
						{
							Name = "AllowNewStacks",
							Type = "boolean",
							IsOptional = true,
						},
					},
					Returns =
					{
						{
							Type = "number",
						},
					},
					Notes = "Same as AddItem, but for several items at once",
				},
				ChangeSlotCount =
				{
					Params =
					{
						{
							Name = "SlotNum",
							Type = "number",
						},
						{
							Name = "AddToCount",
							Type = "number",
						},
					},
					Returns =
					{
						{
							Type = "number",
						},
					},
					Notes = "Adds AddToCount to the count of items in the specified slot. If the slot was empty, ignores the call. Returns the new count in the slot, or -1 if invalid SlotNum",
				},
				Clear =
				{
					Notes = "Empties all slots",
				},
				CopyToItems =
				{
					Params =
					{
						{
							Name = "cItems",
							Type = "cItems",
						},
					},
					Notes = "Copies all non-empty slots into the cItems object provided; original cItems contents are preserved",
				},
				DamageEquippedItem =
				{
					Params =
					{
						{
							Name = "DamageAmount",
							Type = "number",
							IsOptional = true,
						},
					},
					Returns =
					{
						{
							Name = "HasDestroyed",
							Type = "boolean",
						},
					},
					Notes = "Adds the specified damage (1 by default) to the currently equipped item. Removes the item and returns true if the item reached its max damage and was destroyed.",
				},
				DamageItem =
				{
					Params =
					{
						{
							Name = "SlotNum",
							Type = "number",
						},
						{
							Name = "DamageAmount",
							Type = "number",
							IsOptional = true,
						},
					},
					Returns =
					{
						{
							Name = "HasDestroyed",
							Type = "boolean",
						},
					},
					Notes = "Adds the specified damage (1 by default) to the specified item. Removes the item and returns true if the item reached its max damage and was destroyed.",
				},
				GetArmorGrid =
				{
					Returns =
					{
						{
							Type = "cItemGrid",
						},
					},
					Notes = "Returns the ItemGrid representing the armor grid (1 x 4 slots)",
				},
				GetArmorSlot =
				{
					Params =
					{
						{
							Name = "ArmorSlotNum",
							Type = "number",
						},
					},
					Returns =
					{
						{
							Type = "cItem",
						},
					},
					Notes = "Returns the specified armor slot contents. Note that the returned item is read-only",
				},
				GetEquippedBoots =
				{
					Returns =
					{
						{
							Type = "cItem",
						},
					},
					Notes = "Returns the item in the \"boots\" slot of the armor grid. Note that the returned item is read-only",
				},
				GetEquippedChestplate =
				{
					Returns =
					{
						{
							Type = "cItem",
						},
					},
					Notes = "Returns the item in the \"chestplate\" slot of the armor grid. Note that the returned item is read-only",
				},
				GetEquippedHelmet =
				{
					Returns =
					{
						{
							Type = "cItem",
						},
					},
					Notes = "Returns the item in the \"helmet\" slot of the armor grid. Note that the returned item is read-only",
				},
				GetEquippedItem =
				{
					Returns =
					{
						{
							Type = "cItem",
						},
					},
					Notes = "Returns the currently selected item from the hotbar. Note that the returned item is read-only",
				},
				GetEquippedLeggings =
				{
					Returns =
					{
						{
							Type = "cItem",
						},
					},
					Notes = "Returns the item in the \"leggings\" slot of the armor grid. Note that the returned item is read-only",
				},
				GetEquippedSlotNum =
				{
					Returns =
					{
						{
							Type = "number",
						},
					},
					Notes = "Returns the hotbar slot number for the currently selected item",
				},
				GetHotbarGrid =
				{
					Returns =
					{
						{
							Type = "cItemGrid",
						},
					},
					Notes = "Returns the ItemGrid representing the hotbar grid (9 x 1 slots)",
				},
				GetHotbarSlot =
				{
					Params =
					{
						{
							Name = "HotBarSlotNum",
							Type = "number",
						},
					},
					Returns =
					{
						{
							Type = "cItem",
						},
					},
					Notes = "Returns the specified hotbar slot contents. Note that the returned item is read-only",
				},
				GetInventoryGrid =
				{
					Returns =
					{
						{
							Type = "cItemGrid",
						},
					},
					Notes = "Returns the ItemGrid representing the main inventory (9 x 3 slots)",
				},
				GetInventorySlot =
				{
					Params =
					{
						{
							Name = "InventorySlotNum",
							Type = "number",
						},
					},
					Returns =
					{
						{
							Type = "cItem",
						},
					},
					Notes = "Returns the specified main inventory slot contents. Note that the returned item is read-only",
				},
				GetOwner =
				{
					Returns =
					{
						{
							Type = "cPlayer",
						},
					},
					Notes = "Returns the player whose inventory this object represents",
				},
				GetSlot =
				{
					Params =
					{
						{
							Name = "SlotNum",
							Type = "number",
						},
					},
					Returns =
					{
						{
							Type = "cItem",
						},
					},
					Notes = "Returns the contents of the specified slot. Note that the returned item is read-only",
				},
				HasItems =
				{
					Params =
					{
						{
							Name = "cItem",
							Type = "cItem",
						},
					},
					Returns =
					{
						{
							Type = "boolean",
						},
					},
					Notes = "Returns true if there are at least as many items of the specified type as in the parameter",
				},
				HowManyCanFit =
				{
					{
						Params =
						{
							{
								Name = "ItemStack",
								Type = "cItem",
							},
							{
								Name = "AllowNewStacks",
								Type = "boolean",
								IsOptional = true,
							},
						},
						Returns =
						{
							{
								Type = "number",
							},
						},
						Notes = "Returns number of items out of a_ItemStack that can fit in the storage. If AllowNewStacks is false, only considers slots already containing the specified item. AllowNewStacks defaults to true if not given.",
					},
					{
						Params =
						{
							{
								Name = "ItemStack",
								Type = "cItem",
							},
							{
								Name = "BeginSlotNum",
								Type = "number",
							},
							{
								Name = "EndSlotNum",
								Type = "number",
							},
							{
								Name = "AllowNewStacks",
								Type = "boolean",
								IsOptional = true,
							},
						},
						Returns =
						{
							{
								Type = "number",
							},
						},
						Notes = "Returns how many items of the specified type would fit into the slot range specified. If AllowNewStacks is false, only considers slots already containing the specified item. AllowNewStacks defaults to true if not given.",
					},
				},
				HowManyItems =
				{
					Params =
					{
						{
							Name = "cItem",
							Type = "cItem",
						},
					},
					Returns =
					{
						{
							Type = "number",
						},
					},
					Notes = "Returns the number of the specified items that are currently stored",
				},
				RemoveItem =
				{
					Params =
					{
						{
							Name = "cItem",
							Type = "cItem",
						},
					},
					Returns =
					{
						{
							Type = "number",
						},
					},
					Notes = "Removes the specified item from the inventory, as many as possible, up to the item's m_ItemCount. Returns the number of items that were removed.",
				},
				RemoveOneEquippedItem =
				{
					Notes = "Removes one item from the hotbar's currently selected slot",
				},
				SendEquippedSlot =
				{
					Notes = "Sends the equipped item slot to the client",
				},
				SetArmorSlot =
				{
					Params =
					{
						{
							Name = "ArmorSlotNum",
							Type = "number",
						},
						{
							Name = "cItem",
							Type = "cItem",
						},
					},
					Notes = "Sets the specified armor slot contents",
				},
				SetEquippedSlotNum =
				{
					Params =
					{
						{
							Name = "EquippedSlotNum",
							Type = "number",
						},
					},
					Notes = "Sets the currently selected hotbar slot number",
				},
				SetHotbarSlot =
				{
					Params =
					{
						{
							Name = "HotbarSlotNum",
							Type = "number",
						},
						{
							Name = "cItem",
							Type = "cItem",
						},
					},
					Notes = "Sets the specified hotbar slot contents",
				},
				SetInventorySlot =
				{
					Params =
					{
						{
							Name = "InventorySlotNum",
							Type = "number",
						},
						{
							Name = "cItem",
							Type = "cItem",
						},
					},
					Notes = "Sets the specified main inventory slot contents",
				},
				SetSlot =
				{
					Params =
					{
						{
							Name = "SlotNum",
							Type = "number",
						},
						{
							Name = "cItem",
							Type = "cItem",
						},
					},
					Notes = "Sets the specified slot contents",
				},
			},
			Constants =
			{
				invArmorCount =
				{
					Notes = "Number of slots in the Armor part",
				},
				invArmorOffset =
				{
					Notes = "Starting slot number of the Armor part",
				},
				invHotbarCount =
				{
					Notes = "Number of slots in the Hotbar part",
				},
				invHotbarOffset =
				{
					Notes = "Starting slot number of the Hotbar part",
				},
				invInventoryCount =
				{
					Notes = "Number of slots in the main inventory part",
				},
				invInventoryOffset =
				{
					Notes = "Starting slot number of the main inventory part",
				},
				invNumSlots =
				{
					Notes = "Total number of slots in a cInventory",
				},
			},
			ConstantGroups =
			{
				SlotIndices =
				{
					Include = "inv.*",
					TextBefore = [[
						Rather than hardcoding numbers, use the following constants for slot indices and counts:
					]],
				},
			},
		},
		cItem =
		{
			Desc = [[
				cItem is what defines an item or stack of items in the game, it contains the item ID, damage,
				quantity and enchantments. Each slot in a {{cInventory}} class or a {{cItemGrid}} class is a cItem
				and each {{cPickup}} contains a cItem. The enchantments are contained in a separate
				{{cEnchantments}} class and are accessible through the m_Enchantments variable.</p>
				<p>
				To test if a cItem object represents an empty item, do not compare the item type nor the item count,
				but rather use the IsEmpty() function.</p>
				<p>
				To translate from a cItem to its string representation, use the {{Globals#functions|global function}}
				ItemToString(), ItemTypeToString() or ItemToFullString(). To translate from a string to a cItem,
				use the StringToItem() global function.
			]],
			Functions =
			{
				AddCount =
				{
					Params =
					{
						{
							Name = "AmountToAdd",
							Type = "number",
						},
					},
					Returns =
					{
						{
							Type = "cItem",
						},
					},
					Notes = "Adds the specified amount to the item count. Returns self (useful for chaining).",
				},
				Clear =
				{
					Notes = "Resets the instance to an empty item",
				},
				constructor =
				{
					{
						Returns =
						{
							{
								Type = "cItem",
							},
						},
						Notes = "Creates a new empty cItem object",
					},
					{
						Params =
						{
							{
								Name = "ItemType",
								Type = "number",
							},
							{
								Name = "Count",
								Type = "number",
								IsOptional = true,
							},
							{
								Name = "Damage",
								Type = "number",
								IsOptional = true,
							},
							{
								Name = "EnchantmentString",
								Type = "string",
								IsOptional = true,
							},
							{
								Name = "CustomName",
								Type = "string",
								IsOptional = true,
							},
							{
								Name = "Lore",
								Type = "string",
								IsOptional = true,
							},
						},
						Returns =
						{
							{
								Type = "cItem",
							},
						},
						Notes = "Creates a new cItem object of the specified type, count (1 by default), damage (0 by default), enchantments (non-enchanted by default), CustomName (empty by default) and Lore (string, empty by default)",
					},
					{
						Params =
						{
							{
								Name = "cItem",
								Type = "cItem",
							},
						},
						Returns =
						{
							{
								Type = "cItem",
							},
						},
						Notes = "Creates an exact copy of the cItem object in the parameter",
					},
				},
				CopyOne =
				{
					Returns =
					{
						{
							Type = "cItem",
						},
					},
					Notes = "Creates a copy of this object, with its count set to 1",
				},
				DamageItem =
				{
					Params =
					{
						{
							Name = "Amount",
							Type = "number",
							IsOptional = true,
						},
					},
					Returns =
					{
						{
							Name = "HasReachedMaxDamage",
							Type = "boolean",
						},
					},
					Notes = "Adds the specified damage. Returns true when damage reaches max value and the item should be destroyed (but doesn't destroy the item)",
				},
				Empty =
				{
					Notes = "Resets the instance to an empty item",
				},
				EnchantByXPLevels =
				{
					Params =
					{
						{
							Name = "NumXPLevels",
							Type = "number",
						},
					},
					Returns =
					{
						{
							Name = "HasEnchanted",
							Type = "boolean",
						},
					},
					Notes = "Randomly enchants the item using the specified number of XP levels. Returns true if the item was enchanted, false if not (not enchantable / too many enchantments already).",
				},
				GetEnchantability =
				{
					Returns =
					{
						{
							Type = "number",
						},
					},
					Notes = "Returns the enchantability of the item. Returns zero if the item doesn't have enchantability.",
				},
				GetMaxDamage =
				{
					Returns =
					{
						{
							Type = "number",
						},
					},
					Notes = "Returns the maximum value for damage that this item can get before breaking; zero if damage is not accounted for for this item type",
				},
				GetMaxStackSize =
				{
					Returns =
					{
						{
							Type = "number",
						},
					},
					Notes = "Returns the maximum stack size for this item.",
				},
				IsBothNameAndLoreEmpty =
				{
					Returns =
					{
						{
							Type = "boolean",
						},
					},
					Notes = "Returns if both the custom name and lore are not set.",
				},
				IsCustomNameEmpty =
				{
					Returns =
					{
						{
							Type = "boolean",
						},
					},
					Notes = "Returns if the custom name is empty.",
				},
				IsDamageable =
				{
					Returns =
					{
						{
							Type = "boolean",
						},
					},
					Notes = "Returns true if this item does account for its damage",
				},
				IsEmpty =
				{
					Returns =
					{
						{
							Type = "boolean",
						},
					},
					Notes = "Returns true if this object represents an empty item (zero count or invalid ItemType)",
				},
				IsEnchantable =
				{
					IsStatic = true,
					Params =
					{
						{
							Name = "ItemType",
							Type = "number",
						},
						{
							Name = "WithBook",
							Type = "boolean",
						},
					},
					Returns =
					{
						{
							Type = "boolean",
						},
					},
					Notes = "Returns true if the specified item type is enchantable. If WithBook is true, the function is used in the anvil inventory with book enchantments. So it checks the \"only book enchantments\" too. Example: You can only enchant a hoe with a book.",
				},
				IsEqual =
				{
					Params =
					{
						{
							Name = "OtherItem",
							Type = "cItem",
						},
					},
					Returns =
					{
						{
							Type = "boolean",
						},
					},
					Notes = "Returns true if the item in the parameter is the same as the one stored in the object (type, damage, lore, name and enchantments)",
				},
				IsFullStack =
				{
					Returns =
					{
						{
							Type = "boolean",
						},
					},
					Notes = "Returns true if the item is stacked up to its maximum stacking",
				},
				IsLoreEmpty =
				{
					Notes = "Returns if the lore of the cItem is empty.",
				},
				IsSameType =
				{
					Params =
					{
						{
							Name = "OtherItem",
							Type = "cItem",
						},
					},
					Returns =
					{
						{
							Type = "boolean",
						},
					},
					Notes = "Returns true if the item in the parameter is of the same ItemType as the one stored in the object. This is true even if the two items have different enchantments",
				},
			},
			Variables =
			{
				m_CustomName =
				{
					Type = "string",
					Notes = "The custom name for an item.",
				},
				m_Enchantments =
				{
					Type = "{{cEnchantments|cEnchantments}}}",
					Notes = "The enchantments of the item.",
				},
				m_ItemCount =
				{
					Type = "number",
					Notes = "Number of items in this stack",
				},
				m_ItemDamage =
				{
					Type = "number",
					Notes = "The damage of the item. Zero means no damage. Maximum damage can be queried with GetMaxDamage()",
				},
				m_ItemType =
				{
					Type = "number",
					Notes = "The item type. One of E_ITEM_ or E_BLOCK_ constants",
				},
				m_Lore =
				{
					Type = "string",
					Notes = "The lore for an item. Line breaks are represented by the ` character.",
				},
				m_RepairCost =
				{
					Type = "number",
					Notes = "The repair cost of the item. The anvil need this value",
				},
			},
			AdditionalInfo =
			{
				{
					Header = "Usage notes",
					Contents = [[
						Note that the object contained in a cItem class is quite complex and quite often new Minecraft
						versions add more stuff. Therefore it is recommended to copy cItem objects using the
						copy-constructor ("local copy = cItem(original);"), this is the only way that guarantees that
						the object will be copied at full, even with future versions of Cuberite.
					]],
				},
				{
					Header = "Example code",
					Contents = [[
						The following code shows how to create items in several different ways (adapted from the Debuggers plugin):
<pre class="prettyprint lang-lua">
-- empty item:
local Item1 = cItem();

-- enchanted sword, enchantment given as numeric string (bad style; see Item5):
local Item2 = cItem(E_ITEM_DIAMOND_SWORD, 1, 0, "1=1");

-- 1 undamaged shovel, no enchantment:
local Item3 = cItem(E_ITEM_DIAMOND_SHOVEL);

-- Add the Unbreaking enchantment. Note that Vanilla's levelcap isn't enforced:
Item3.m_Enchantments:SetLevel(cEnchantments.enchUnbreaking, 4);

-- 1 undamaged pickaxe, no enchantment:
local Item4 = cItem(E_ITEM_DIAMOND_PICKAXE);

-- Add multiple enchantments:
Item4.m_Enchantments:SetLevel(cEnchantments.enchUnbreaking, 5);
Item4.m_Enchantments:SetLevel(cEnchantments.enchEfficiency, 3);

-- enchanted chestplate, enchantment given as textual stringdesc (good style)
local Item5 = cItem(E_ITEM_DIAMOND_CHESTPLATE, 1, 0, "thorns=1;unbreaking=3");
</pre>
]],
				},
			},
		},
		cItemFrame =
		{
			Functions =
			{
				GetItem =
				{
					Returns =
					{
						{
							Type = "cItem",
							IsConst = true,
						},
					},
					Notes = "Returns the item in the frame (readonly object, do not modify)",
				},
				GetItemRotation =
				{
					Returns =
					{
						{
							Type = "number",
						},
					},
					Notes = "Returns the rotation from the item in the frame",
				},
				SetItem =
				{
					Params =
					{
						{
							Name = "Item",
							Type = "cItem",
						},
					},
					Notes = "Set the item in the frame",
				},
				SetItemRotation =
				{
					Params =
					{
						{
							Name = "ItemRotation",
							Type = "number",
						},
					},
					Notes = "Set the rotation from the item in the frame",
				},
			},
		},
		cItemGrid =
		{
			Desc = [[
This class represents a 2D array of items. It is used as the underlying storage and API for all cases that use a grid of items:
<li>{{cChestEntity|Chest}} contents</li>
<li>(TODO) Chest minecart contents</li>
<li>{{cDispenserEntity|Dispenser}} contents</li>
<li>{{cDropperEntity|Dropper}} contents</li>
<li>{{cFurnaceEntity|Furnace}} contents (?)</li>
<li>{{cHopperEntity|Hopper}} contents</li>
<li>(TODO) Hopper minecart contents</li>
<li>{{cPlayer|Player}} Inventory areas</li>
<li>(TODO) Trapped chest contents</li>
</p>
		<p>The items contained in this object are accessed either by a pair of XY coords, or a slot number (x + Width * y). There are functions available for converting between the two formats.
]],
			Functions =
			{
				AddItem =
				{
					Params =
					{
						{
							Name = "ItemStack",
							Type = "cItem",
						},
						{
							Name = "AllowNewStacks",
							Type = "boolean",
							IsOptional = true,
						},
						{
							Name = "PrioritarySlot",
							Type = "number",
							IsOptional = true,
						},
					},
					Returns =
					{
						{
							Type = "number",
						},
					},
					Notes = "Adds as many items out of ItemStack as can fit. If AllowNewStacks is set to false, only existing stacks can be topped up. If AllowNewStacks is set to true (default), empty slots can be used for the rest. If PrioritarySlot is set to a non-negative value, then the corresponding slot will be used first (if empty or compatible with added items). If PrioritarySlot is set to -1 (default), regular order applies. Returns the number of items that fit.",
				},
				AddItems =
				{
					Params =
					{
						{
							Name = "ItemStackList",
							Type = "cItems",
						},
						{
							Name = "AllowNewStacks",
							Type = "boolean",
							IsOptional = true,
						},
						{
							Name = "PrioritarySlot",
							Type = "number",
							IsOptional = true,
						},
					},
					Returns =
					{
						{
							Type = "number",
						},
					},
					Notes = "Same as AddItem, but works on an entire list of item stacks. The a_ItemStackList is modified to reflect the leftover items. If a_AllowNewStacks is set to false, only existing stacks can be topped up. If AllowNewStacks is set to true, empty slots can be used for the rest. If PrioritarySlot is set to a non-negative value, then the corresponding slot will be used first (if empty or compatible with added items). If PrioritarySlot is set to -1 (default), regular order applies. Returns the total number of items that fit.",
				},
				ChangeSlotCount =
				{
					{
						Params =
						{
							{
								Name = "SlotNum",
								Type = "number",
							},
							{
								Name = "AddToCount",
								Type = "number",
							},
						},
						Returns =
						{
							{
								Type = "number",
							},
						},
						Notes = "Adds AddToCount to the count of items in the specified slot. If the slot was empty, ignores the call. Returns the new count in the slot, or -1 if invalid SlotNum",
					},
					{
						Params =
						{
							{
								Name = "X",
								Type = "number",
							},
							{
								Name = "Y",
								Type = "number",
							},
							{
								Name = "AddToCount",
								Type = "number",
							},
						},
						Returns =
						{
							{
								Type = "number",
							},
						},
						Notes = "Adds AddToCount to the count of items in the specified slot. If the slot was empty, ignores the call. Returns the new count in the slot, or -1 if invalid slot coords",
					},
				},
				Clear =
				{
					Notes = "Empties all slots",
				},
				CopyToItems =
				{
					Params =
					{
						{
							Name = "cItems",
							Type = "cItems",
						},
					},
					Notes = "Copies all non-empty slots into the {{cItems}} object provided; original cItems contents are preserved as well.",
				},
				DamageItem =
				{
					{
						Params =
						{
							{
								Name = "SlotNum",
								Type = "number",
							},
							{
								Name = "DamageAmount",
								Type = "number",
								IsOptional = true,
							},
						},
						Returns =
						{
							{
								Name = "HasReachedMaxDamage",
								Type = "boolean",
							},
						},
						Notes = "Adds the specified damage (1 by default) to the specified item, returns true if the item reached its max damage and should be destroyed (but doesn't destroy the item).",
					},
					{
						Params =
						{
							{
								Name = "X",
								Type = "number",
							},
							{
								Name = "Y",
								Type = "number",
							},
							{
								Name = "DamageAmount",
								Type = "number",
								IsOptional = true,
							},
						},
						Returns =
						{
							{
								Name = "HasReachedMaxDamage",
								Type = "boolean",
							},
						},
						Notes = "Adds the specified damage (1 by default) to the specified item, returns true if the item reached its max damage and should be destroyed (but doesn't destroy the item).",
					},
				},
				EmptySlot =
				{
					{
						Params =
						{
							{
								Name = "SlotNum",
								Type = "number",
							},
						},
						Notes = "Destroys the item in the specified slot",
					},
					{
						Params =
						{
							{
								Name = "X",
								Type = "number",
							},
							{
								Name = "Y",
								Type = "number",
							},
						},
						Notes = "Destroys the item in the specified slot",
					},
				},
				GetFirstEmptySlot =
				{
					Returns =
					{
						{
							Type = "number",
						},
					},
					Notes = "Returns the SlotNumber of the first empty slot, -1 if all slots are full",
				},
				GetFirstUsedSlot =
				{
					Returns =
					{
						{
							Type = "number",
						},
					},
					Notes = "Returns the SlotNumber of the first non-empty slot, -1 if all slots are empty",
				},
				GetHeight =
				{
					Returns =
					{
						{
							Type = "number",
						},
					},
					Notes = "Returns the Y dimension of the grid",
				},
				GetLastEmptySlot =
				{
					Returns =
					{
						{
							Type = "number",
						},
					},
					Notes = "Returns the SlotNumber of the last empty slot, -1 if all slots are full",
				},
				GetLastUsedSlot =
				{
					Returns =
					{
						{
							Type = "number",
						},
					},
					Notes = "Returns the SlotNumber of the last non-empty slot, -1 if all slots are empty",
				},
				GetNextEmptySlot =
				{
					Params =
					{
						{
							Name = "StartFrom",
							Type = "number",
						},
					},
					Returns =
					{
						{
							Type = "number",
						},
					},
					Notes = "Returns the SlotNumber of the first empty slot following StartFrom, -1 if all the following slots are full",
				},
				GetNextUsedSlot =
				{
					Params =
					{
						{
							Name = "StartFrom",
							Type = "number",
						},
					},
					Returns =
					{
						{
							Type = "number",
						},
					},
					Notes = "Returns the SlotNumber of the first non-empty slot following StartFrom, -1 if all the following slots are full",
				},
				GetNumSlots =
				{
					Returns =
					{
						{
							Type = "number",
						},
					},
					Notes = "Returns the total number of slots in the grid (Width * Height)",
				},
				GetSlot =
				{
					{
						Params =
						{
							{
								Name = "SlotNumber",
								Type = "number",
							},
						},
						Returns =
						{
							{
								Type = "cItem",
							},
						},
						Notes = "Returns the item in the specified slot. Note that the item is read-only",
					},
					{
						Params =
						{
							{
								Name = "X",
								Type = "number",
							},
							{
								Name = "Y",
								Type = "number",
							},
						},
						Returns =
						{
							{
								Type = "cItem",
							},
						},
						Notes = "Returns the item in the specified slot. Note that the item is read-only",
					},
				},
				GetSlotCoords =
				{
					Params =
					{
						{
							Name = "SlotNum",
							Type = "number",
						},
					},
					Returns =
					{
						{
							Type = "number",
						},
						{
							Type = "number",
						},
					},
					Notes = "Returns the X and Y coords for the specified SlotNumber. Returns \"-1, -1\" on invalid SlotNumber",
				},
				GetSlotNum =
				{
					Params =
					{
						{
							Name = "X",
							Type = "number",
						},
						{
							Name = "Y",
							Type = "number",
						},
					},
					Returns =
					{
						{
							Type = "number",
						},
					},
					Notes = "Returns the SlotNumber for the specified slot coords. Returns -1 on invalid coords",
				},
				GetWidth =
				{
					Returns =
					{
						{
							Type = "number",
						},
					},
					Notes = "Returns the X dimension of the grid",
				},
				HasItems =
				{
					Params =
					{
						{
							Name = "ItemStack",
							Type = "cItem",
						},
					},
					Returns =
					{
						{
							Type = "boolean",
						},
					},
					Notes = "Returns true if there are at least as many items of the specified type as in the parameter",
				},
				HowManyCanFit =
				{
					Params =
					{
						{
							Name = "ItemStack",
							Type = "cItem",
						},
						{
							Name = "AllowNewStacks",
							Type = "boolean",
							IsOptional = true,
						},
					},
					Returns =
					{
						{
							Type = "number",
						},
					},
					Notes = "Returns the number of the specified items that can fit in the storage. If AllowNewStacks is true (default), includes empty slots in the returned count.",
				},
				HowManyItems =
				{
					Params =
					{
						{
							Name = "Item",
							Type = "cItem",
						},
					},
					Returns =
					{
						{
							Type = "number",
						},
					},
					Notes = "Returns the number of the specified item that are currently stored",
				},
				IsSlotEmpty =
				{
					{
						Params =
						{
							{
								Name = "SlotNum",
								Type = "number",
							},
						},
						Returns =
						{
							{
								Type = "boolean",
							},
						},
						Notes = "Returns true if the specified slot is empty, or an invalid slot is specified",
					},
					{
						Params =
						{
							{
								Name = "X",
								Type = "number",
							},
							{
								Name = "Y",
								Type = "number",
							},
						},
						Returns =
						{
							{
								Type = "boolean",
							},
						},
						Notes = "Returns true if the specified slot is empty, or an invalid slot is specified",
					},
				},
				RemoveItem =
				{
					Params =
					{
						{
							Name = "ItemStack",
							Type = "cItem",
						},
					},
					Returns =
					{
						{
							Type = "number",
						},
					},
					Notes = "Removes the specified item from the grid, as many as possible, up to ItemStack's m_ItemCount. Returns the number of items that were removed.",
				},
				RemoveOneItem =
				{
					{
						Params =
						{
							{
								Name = "SlotNum",
								Type = "number",
							},
						},
						Returns =
						{
							{
								Type = "cItem",
							},
						},
						Notes = "Removes one item from the stack in the specified slot and returns it as a single cItem. Empty slots are skipped and an empty item is returned",
					},
					{
						Params =
						{
							{
								Name = "X",
								Type = "number",
							},
							{
								Name = "Y",
								Type = "number",
							},
						},
						Returns =
						{
							{
								Type = "cItem",
							},
						},
						Notes = "Removes one item from the stack in the specified slot and returns it as a single cItem. Empty slots are skipped and an empty item is returned",
					},
				},
				SetSlot =
				{
					{
						Params =
						{
							{
								Name = "SlotNum",
								Type = "number",
							},
							{
								Name = "cItem",
								Type = "cItem",
							},
						},
						Notes = "Sets the specified slot to the specified item",
					},
					{
						Params =
						{
							{
								Name = "SlotNum",
								Type = "number",
							},
							{
								Name = "ItemType",
								Type = "number",
							},
							{
								Name = "ItemCount",
								Type = "number",
							},
							{
								Name = "ItemDamage",
								Type = "number",
							},
						},
						Notes = "Sets the specified slot to the specified item",
					},
					{
						Params =
						{
							{
								Name = "X",
								Type = "number",
							},
							{
								Name = "Y",
								Type = "number",
							},
							{
								Name = "cItem",
								Type = "cItem",
							},
						},
						Notes = "Sets the specified slot to the specified item",
					},
					{
						Params =
						{
							{
								Name = "X",
								Type = "number",
							},
							{
								Name = "Y",
								Type = "number",
							},
							{
								Name = "ItemType",
								Type = "number",
							},
							{
								Name = "ItemCount",
								Type = "number",
							},
							{
								Name = "ItemDamage",
								Type = "number",
							},
						},
						Notes = "Sets the specified slot to the specified item",
					},
				},
			},
			AdditionalInfo =
			{
				{
					Header = "Code example: Add items to player inventory",
					Contents = [[
						The following code tries to add 32 sticks to a player's main inventory:
<pre class="prettyprint lang-lua">
local Items = cItem(E_ITEM_STICK, 32);
local PlayerMainInventory = Player:GetInventorySlots();  -- PlayerMainInventory is of type cItemGrid
local NumAdded = PlayerMainInventory:AddItem(Items);
if (NumAdded == Items.m_ItemCount) then
  -- All the sticks did fit
  LOG("Added 32 sticks");
else
  -- Some (or all) of the sticks didn't fit
  LOG("Tried to add 32 sticks, but only " .. NumAdded .. " could fit");
end
</pre>
					]],
				},
				{
					Header = "Code example: Damage an item",
					Contents = [[
						The following code damages the helmet in the player's armor and destroys it if it reaches max damage:
<pre class="prettyprint lang-lua">
local PlayerArmor = Player:GetArmorSlots();  -- PlayerArmor is of type cItemGrid
if (PlayerArmor:DamageItem(0)) then  -- Helmet is at SlotNum 0
  -- The helmet has reached max damage, destroy it:
  PlayerArmor:EmptySlot(0);
end
</pre>
					]],
				},
			},
		},
		cItems =
		{
			Desc = [[
				This class represents a numbered collection (array) of {{cItem}} objects. The array indices start at
				zero, each consecutive item gets a consecutive index. This class is used for spawning multiple
				pickups or for mass manipulating an inventory.
				]],
			Functions =
			{
				Add =
				{
					{
						Params =
						{
							{
								Name = "cItem",
								Type = "cItem",
							},
						},
						Notes = "Adds a new item to the end of the collection",
					},
					{
						Params =
						{
							{
								Name = "ItemType",
								Type = "number",
							},
							{
								Name = "ItemCount",
								Type = "number",
							},
							{
								Name = "ItemDamage",
								Type = "number",
							},
						},
						Notes = "Adds a new item to the end of the collection",
					},
				},
				Clear =
				{
					Notes = "Removes all items from the collection",
				},
				constructor =
				{
					Returns =
					{
						{
							Type = "cItems",
						},
					},
					Notes = "Creates a new cItems object",
				},
				Contains =
				{
					Params =
					{
						{
							Name = "Item",
							Type = "cItem",
						},
					},
					Returns =
					{
						{
							Type = "boolean",
						},
					},
					Notes = "Returns true if the collection contains an item that is fully equivalent to the parameter",
				},
				ContainsType =
				{
					Params =
					{
						{
							Name = "Item",
							Type = "cItem",
						},
					},
					Returns =
					{
						{
							Type = "boolean",
						},
					},
					Notes = "Returns true if the collection contains an item that is the same type as the parameter",
				},
				Delete =
				{
					Params =
					{
						{
							Name = "Index",
							Type = "number",
						},
					},
					Notes = "Deletes item at the specified index",
				},
				Get =
				{
					Params =
					{
						{
							Name = "Index",
							Type = "number",
						},
					},
					Returns =
					{
						{
							Type = "cItem",
						},
					},
					Notes = "Returns the item at the specified index",
				},
				Set =
				{
					{
						Params =
						{
							{
								Name = "Index",
								Type = "number",
							},
							{
								Name = "cItem",
								Type = "cItem",
							},
						},
						Notes = "Sets the item at the specified index to the specified item",
					},
					{
						Params =
						{
							{
								Name = "Index",
								Type = "number",
							},
							{
								Name = "ItemType",
								Type = "number",
							},
							{
								Name = "ItemCount",
								Type = "number",
							},
							{
								Name = "ItemDamage",
								Type = "number",
							},
						},
						Notes = "Sets the item at the specified index to the specified item",
					},
				},
				Size =
				{
					Returns =
					{
						{
							Type = "number",
						},
					},
					Notes = "Returns the number of items in the collection",
				},
			},
		},
		cJson =
		{
			Desc = [[
				Exposes the Json parser and serializer available in the server. Plugins can parse Json strings into
				Lua tables, and serialize Lua tables into Json strings easily.
			]],
			Functions =
			{
				Parse =
				{
					Params =
					{
						{
							Name = "InputString",
							Type = "string",
						},
					},
					Returns =
					{
						{
							Type = "table",
						},
					},
					Notes = "Parses the Json in the input string into a Lua table. Returns nil and detailed error message if parsing fails.",
				},
				Serialize =
				{
					Params =
					{
						{
							Name = "table",
							Type = "table",
						},
						{
							Name = "options",
							Type = "table",
							IsOptional = true,
						},
					},
					Returns =
					{
						{
							Type = "string",
						},
					},
					Notes = "Serializes the input table into a Json string. The options table, if present, is used to adjust the formatting of the serialized string, see below for details.",
				},
			},
			AdditionalInfo =
			{
				{
					Header = "Serializer options",
					Contents = [[
						The "options" parameter given to the cJson:Serialize() function is a dictionary-table of "option
						name" -> "option value". The serializer warns if any unknown options are used; the following
						options are recognized:</p>
						<ul>
						<li><b>commentStyle</b> - either "All" or "None", specifies whether comments are written to the
						output. Currently unused since comments cannot be represented in a Lua table</li>
						<li><b>indentation</b> - the string that is repeated for each level of indentation of the output.
						If empty, the Json is compressed (without linebreaks).</li>
						<li><b>enableYAMLCompatibility</b> - bool manipulating the whitespace around the colons.</li>
						<li><b>dropNullPlaceholders</b> - bool specifying whether null placeholders should be dropped
						from the output</li>
						</ul>
					]],
				},
				{
					Header = "Code example: Parsing a Json string",
					Contents = [==[
						The following code, adapted from the Debuggers plugin, parses a simple Json string and verifies
						the results:
<pre class="prettyprint lang-lua">
local t1 = cJson:Parse([[{"a": 1, "b": "2", "c": [3, "4", 5]}]])
assert(t1.a == 1)
assert(t1.b == "2")
assert(t1.c[1] == 3)
assert(t1.c[2] == "4")
assert(t1.c[3] == 5)
</pre>
					]==],
				},
				{
					Header = "Code example: Serializing into a Json string",
					Contents = [[
						The following code, adapted from the Debuggers plugin, serializes a simple Lua table into a
						string, using custom indentation:
<pre class="prettyprint lang-lua">
local s1 = cJson:Serialize({a = 1, b = "2", c = {3, "4", 5}}, {indentation = "  "})
LOG("Serialization result: " .. (s1 or "<nil>"))
</pre>
					]],
				},
			},
		},
		cLuaWindow =
		{
			Desc = [[
This class is used by plugins wishing to display a custom window to the player, unrelated to block entities or entities near the player. The window can be of any type and have any contents that the plugin defines. Callbacks for when the player modifies the window contents and when the player closes the window can be set.
</p>
		<p>This class inherits from the {{cWindow|cWindow}} class, so all cWindow's functions and constants can be used, in addition to the cLuaWindow-specific functions listed below.
</p>
		<p>The contents of this window are represented by a {{cWindow|cWindow}}:GetSlot() etc. or {{cPlayer|cPlayer}}:GetInventory() to access the player inventory.
</p>
		<p>When creating a new cLuaWindow object, you need to specify both the window type and the contents' width and height. Note that Cuberite accepts any combination of these, but opening a window for a player may crash their client if the contents' dimensions don't match the client's expectations.
</p>
		<p>To open the window for a player, call {{cPlayer|cPlayer}}:OpenWindow(). Multiple players can open window of the same cLuaWindow object. All players see the same items in the window's contents (like chest, unlike crafting table).
]],
			Functions =
			{
				constructor =
				{
					Params =
					{
						{
							Name = "WindowType",
							Type = "cWindow#WindowType",
						},
						{
							Name = "ContentsWidth",
							Type = "number",
						},
						{
							Name = "ContentsHeight",
							Type = "number",
						},
						{
							Name = "Title",
							Type = "string",
						},
					},
					Notes = "Creates a new object of this class. The window is not shown to any player yet.",
				},
				GetContents =
				{
					Returns =
					{
						{
							Type = "cItemGrid",
						},
					},
					Notes = "Returns the cItemGrid object representing the internal storage in this window",
				},
				SetOnClosing =
				{
					Params =
					{
						{
							Name = "OnClosingCallback",
							Type = "function",
						},
					},
					Notes = "Sets the function that the window will call when it is about to be closed by a player",
				},
				SetOnSlotChanged =
				{
					Params =
					{
						{
							Name = "OnSlotChangedCallback",
							Type = "function",
						},
					},
					Notes = "Sets the function that the window will call when a slot is changed by a player",
				},
			},
			AdditionalInfo =
			{
				{
					Header = "Callbacks",
					Contents = [[
						The object calls the following functions at the appropriate time:
					]],
				},
				{
					Header = "OnClosing Callback",
					Contents = [[
						This callback, settable via the SetOnClosing() function, will be called when the player tries to close the window, or the window is closed for any other reason (such as a player disconnecting).</p>
<pre class="prettyprint lang-lua">
function OnWindowClosing(a_Window, a_Player, a_CanRefuse)
</pre>
						<p>
						The a_Window parameter is the cLuaWindow object representing the window, a_Player is the player for whom the window is about to close. a_CanRefuse specifies whether the callback can refuse the closing. If the callback returns true and a_CanRefuse is true, the window is not closed (internally, the server sends a new OpenWindow packet to the client).
					]],
				},
				{
					Header = "OnSlotChanged Callback",
					Contents = [[
						This callback, settable via the SetOnSlotChanged() function, will be called whenever the contents of any slot in the window's contents (i. e. NOT in the player inventory!) changes.</p>
<pre class="prettyprint lang-lua">
function OnWindowSlotChanged(a_Window, a_SlotNum)
</pre>
						<p>The a_Window parameter is the cLuaWindow object representing the window, a_SlotNum is the slot number. There is no reference to a {{cPlayer}}, because the slot change needn't originate from the player action. To get or set the slot, you'll need to retrieve a cPlayer object, for example by calling {{cWorld|cWorld}}:DoWithPlayer().
						</p>
						<p>Any returned values are ignored.
					]],
				},
				{
					Header = "Example",
					Contents = [[
						This example is taken from the Debuggers plugin, used to test the API functionality. It opens a window and refuse to close it 3 times. It also logs slot changes to the server console.
<pre class="prettyprint lang-lua">
-- Callback that refuses to close the window twice, then allows:
local Attempt = 1;
local OnClosing = function(Window, Player, CanRefuse)
	Player:SendMessage("Window closing attempt #" .. Attempt .. "; CanRefuse = " .. tostring(CanRefuse));
	Attempt = Attempt + 1;
	return CanRefuse and (Attempt <= 3);  -- refuse twice, then allow, unless CanRefuse is set to true
end

-- Log the slot changes:
local OnSlotChanged = function(Window, SlotNum)
	LOG("Window \"" .. Window:GetWindowTitle() .. "\" slot " .. SlotNum .. " changed.");
end

-- Set window contents:
-- a_Player is a cPlayer object received from the outside of this code fragment
local Window = cLuaWindow(cWindow.wtHopper, 3, 3, "TestWnd");
Window:SetSlot(a_Player, 0, cItem(E_ITEM_DIAMOND, 64));
Window:SetOnClosing(OnClosing);
Window:SetOnSlotChanged(OnSlotChanged);

-- Open the window:
a_Player:OpenWindow(Window);
</pre>
					]],
				},
			},
			Inherits = "cWindow",
		},
		cMap =
		{
			Desc = [[
				This class encapsulates a single in-game colored map.</p>
				<p>
				The contents (i.e. pixel data) of a cMap are dynamically updated by each
				tracked {{cPlayer}} instance. Furthermore, a cMap maintains and periodically
				updates	a list of map decorators, which are objects drawn on the map that
				can freely move (e.g. Player and item frame pointers).
			]],
			Functions =
			{
				EraseData =
				{
					Notes = "Erases all pixel data.",
				},
				GetCenterX =
				{
					Returns =
					{
						{
							Type = "number",
						},
					},
					Notes = "Returns the X coord of the map's center.",
				},
				GetCenterZ =
				{
					Returns =
					{
						{
							Type = "number",
						},
					},
					Notes = "Returns the Y coord of the map's center.",
				},
				GetDimension =
				{
					Returns =
					{
						{
							Type = "eDimension",
						},
					},
					Notes = "Returns the dimension of the associated world.",
				},
				GetHeight =
				{
					Returns =
					{
						{
							Type = "number",
						},
					},
					Notes = "Returns the height of the map.",
				},
				GetID =
				{
					Returns =
					{
						{
							Type = "number",
						},
					},
					Notes = "Returns the numerical ID of the map. (The item damage value)",
				},
				GetName =
				{
					Returns =
					{
						{
							Type = "string",
						},
					},
					Notes = "Returns the name of the map.",
				},
				GetNumPixels =
				{
					Returns =
					{
						{
							Type = "number",
						},
					},
					Notes = "Returns the number of pixels in this map.",
				},
				GetPixel =
				{
					Params =
					{
						{
							Name = "PixelX",
							Type = "number",
						},
						{
							Name = "PixelZ",
							Type = "number",
						},
					},
					Returns =
					{
						{
							Name = "ColorID",
							Type = "number",
						},
					},
					Notes = "Returns the color of the specified pixel.",
				},
				GetPixelWidth =
				{
					Returns =
					{
						{
							Type = "number",
						},
					},
					Notes = "Returns the width of a single pixel in blocks.",
				},
				GetScale =
				{
					Returns =
					{
						{
							Type = "number",
						},
					},
					Notes = "Returns the scale of the map. Range: [0,4]",
				},
				GetWidth =
				{
					Returns =
					{
						{
							Type = "number",
						},
					},
					Notes = "Returns the width of the map.",
				},
				GetWorld =
				{
					Returns =
					{
						{
							Type = "cWorld",
						},
					},
					Notes = "Returns the associated world.",
				},
				Resize =
				{
					Params =
					{
						{
							Name = "Width",
							Type = "number",
						},
						{
							Name = "Height",
							Type = "number",
						},
					},
					Notes = "Resizes the map. WARNING: This will erase the pixel data.",
				},
				SetPixel =
				{
					Params =
					{
						{
							Name = "PixelX",
							Type = "number",
						},
						{
							Name = "PixelZ",
							Type = "number",
						},
						{
							Name = "ColorID",
							Type = "number",
						},
					},
					Returns =
					{
						{
							Name = "IsSuccess",
							Type = "boolean",
						},
					},
					Notes = "Sets the color of the specified pixel. Returns false on error (Out of range).",
				},
				SetPosition =
				{
					Params =
					{
						{
							Name = "CenterX",
							Type = "number",
						},
						{
							Name = "CenterZ",
							Type = "number",
						},
					},
					Notes = "Relocates the map. The pixel data will not be modified.",
				},
				SetScale =
				{
					Params =
					{
						{
							Name = "Scale",
							Type = "number",
						},
					},
					Notes = "Rescales the map. The pixel data will not be modified.",
				},
			},
			Constants =
			{
				E_BASE_COLOR_BLUE =
				{
					Notes = "",
				},
				E_BASE_COLOR_BROWN =
				{
					Notes = "",
				},
				E_BASE_COLOR_DARK_BROWN =
				{
					Notes = "",
				},
				E_BASE_COLOR_DARK_GRAY =
				{
					Notes = "",
				},
				E_BASE_COLOR_DARK_GREEN =
				{
					Notes = "",
				},
				E_BASE_COLOR_GRAY_1 =
				{
					Notes = "",
				},
				E_BASE_COLOR_GRAY_2 =
				{
					Notes = "",
				},
				E_BASE_COLOR_LIGHT_BROWN =
				{
					Notes = "",
				},
				E_BASE_COLOR_LIGHT_GRAY =
				{
					Notes = "",
				},
				E_BASE_COLOR_LIGHT_GREEN =
				{
					Notes = "",
				},
				E_BASE_COLOR_PALE_BLUE =
				{
					Notes = "",
				},
				E_BASE_COLOR_RED =
				{
					Notes = "",
				},
				E_BASE_COLOR_TRANSPARENT =
				{
					Notes = "",
				},
				E_BASE_COLOR_WHITE =
				{
					Notes = "",
				},
			},
		},
		cMapManager =
		{
			Desc = [[
				This class is associated with a single {{cWorld}} instance and manages a list of maps.
			]],
			Functions =
			{
				DoWithMap =
				{
					Params =
					{
						{
							Name = "MapID",
							Type = "number",
						},
						{
							Name = "CallbackFunction",
							Type = "function",
						},
					},
					Returns =
					{
						{
							Type = "boolean",
						},
					},
					Notes = "If a map with the specified ID exists, calls the CallbackFunction for that map. The CallbackFunction has the following signature: <pre class=\"prettyprint lang-lua\">function Callback({{cMap|Map}})</pre> Returns true if the map was found and the callback called, false if map not found.",
				},
				GetNumMaps =
				{
					Returns =
					{
						{
							Type = "number",
						},
					},
					Notes = "Returns the number of registered maps.",
				},
			},
		},
		cMojangAPI =
		{
			Desc = [[
				Provides interface to various API functions that Mojang provides through their servers. Note that
				some of these calls will wait for a response from the network, and so shouldn't be used while the
				server is fully running (or at least when there are players connected) to avoid percepted lag.</p>
				<p>
				All the functions are static, call them using the <code>cMojangAPI:Function()</code> convention.</p>
				<p>
				Mojang uses two formats for UUIDs, short and dashed. Cuberite works with short UUIDs internally, but
				will convert to dashed UUIDs where needed - in the protocol login for example. The MakeUUIDShort()
				and MakeUUIDDashed() functions are provided for plugins to use for conversion between the two
				formats.</p>
				<p>
				This class will cache values returned by the API service. The cache will hold the values for 7 days
				by default, after that, they will no longer be available. This is in order to not let the server get
				banned from using the API service, since they are rate-limited to 600 queries per 10 minutes. The
				cache contents also gets updated whenever a player successfully joins, since that makes the server
				contact the API service, too, and retrieve the relevant data.</p>
			]],
			Functions =
			{
				AddPlayerNameToUUIDMapping =
				{
					IsStatic = true,
					Params =
					{
						{
							Name = "PlayerName",
							Type = "string",
						},
						{
							Name = "UUID",
							Type = "string",
						},
					},
					Notes = "Adds the specified PlayerName-to-UUID mapping into the cache, with current timestamp. Accepts both short or dashed UUIDs. ",
				},
				GetPlayerNameFromUUID =
				{
					IsStatic = true,
					Params =
					{
						{
							Name = "UUID",
							Type = "string",
						},
						{
							Name = "UseOnlyCached",
							Type = "boolean",
							IsOptional = true,
						},
					},
					Returns =
					{
						{
							Name = "PlayerName",
							Type = "string",
						},
					},
					Notes = "Returns the playername that corresponds to the given UUID, or an empty string on error. If UseOnlyCached is false (the default), queries the Mojang servers if the UUID is not in the cache. The UUID can be either short or dashed. <br /><b>WARNING</b>: Do NOT use this function with UseOnlyCached set to false while the server is running. Only use it when the server is starting up (inside the Initialize() method), otherwise you will lag the server severely.",
				},
				GetUUIDFromPlayerName =
				{
					IsStatic = true,
					Params =
					{
						{
							Name = "PlayerName",
							Type = "string",
						},
						{
							Name = "UseOnlyCached",
							Type = "boolean",
							IsOptional = true,
						},
					},
					Returns =
					{
						{
							Name = "UUID",
							Type = "string",
						},
					},
					Notes = "Returns the (short) UUID that corresponds to the given playername, or an empty string on error. If UseOnlyCached is false (the default), queries the Mojang servers if the playername is not in the cache. <br /><b>WARNING</b>: Do NOT use this function with UseOnlyCached set to false while the server is running. Only use it when the server is starting up (inside the Initialize() method), otherwise you will lag the server severely.",
				},
				GetUUIDsFromPlayerNames =
				{
					IsStatic = true,
					Params =
					{
						{
							Name = "PlayerNames",
							Type = "string",
						},
						{
							Name = "UseOnlyCached",
							Type = "boolean",
							IsOptional = true,
						},
					},
					Returns =
					{
						{
							Type = "table",
						},
					},
					Notes = "Returns a table that contains the map, 'PlayerName' -> '(short) UUID', for all valid playernames in the input array-table. PlayerNames not recognized will not be set in the returned map. If UseOnlyCached is false (the default), queries the Mojang servers for the results that are not in the cache. <br /><b>WARNING</b>: Do NOT use this function with UseOnlyCached set to false while the server is running. Only use it when the server is starting up (inside the Initialize() method), otherwise you will lag the server severely.",
				},
				MakeUUIDDashed =
				{
					IsStatic = true,
					Params =
					{
						{
							Name = "UUID",
							Type = "string",
						},
					},
					Returns =
					{
						{
							Name = "DashedUUID",
							Type = "string",
						},
					},
					Notes = "Converts the UUID to a dashed format (\"01234567-8901-2345-6789-012345678901\"). Accepts both dashed or short UUIDs. Logs a warning and returns an empty string if UUID format not recognized.",
				},
				MakeUUIDShort =
				{
					IsStatic = true,
					Params =
					{
						{
							Name = "UUID",
							Type = "string",
						},
					},
					Returns =
					{
						{
							Name = "ShortUUID",
							Type = "string",
						},
					},
					Notes = "Converts the UUID to a short format (without dashes, \"01234567890123456789012345678901\"). Accepts both dashed or short UUIDs. Logs a warning and returns an empty string if UUID format not recognized.",
				},
			},
		},
		cMonster =
		{
			Desc = [[
				This class is the base class for all computer-controlled mobs in the game.</p>
				<p>
				To spawn a mob in a world, use the {{cWorld}}:SpawnMob() function.
			]],
			Functions =
			{
				FamilyFromType =
				{
					IsStatic = true,
					Params =
					{
						{
							Name = "MobType",
							Type = "Globals#eMonsterType",
						},
					},
					Returns =
					{
						{
							Name = "MobFamily",
							Type = "cMonster#eFamily",
						},
					},
					Notes = "Returns the mob family ({{cMonster#eFamily|mfXXX}} constants) based on the mob type ({{Globals#eMonsterType|mtXXX}} constants)",
				},
				GetAge =
				{
					Returns =
					{
						{
							Type = "number",
						},
					},
					Notes = "Returns the age of the monster",
				},
				GetCustomName =
				{
					Returns =
					{
						{
							Type = "string",
						},
					},
					Notes = "Gets the custom name of the monster. If no custom name is set, the function returns an empty string.",
				},
				GetMobFamily =
				{
					Returns =
					{
						{
							Name = "MobFamily",
							Type = "cMonster#eFamily",
						},
					},
					Notes = "Returns this mob's family ({{cMonster#eFamily|mfXXX}} constant)",
				},
				GetMobType =
				{
					Returns =
					{
						{
							Name = "MobType",
							Type = "Globals#eMonsterType",
						},
					},
					Notes = "Returns the type of this mob ({{Globals#eMonsterType|mtXXX}} constant)",
				},
				GetRelativeWalkSpeed =
				{
					Returns =
					{
						{
							Type = "number",
						},
					},
					Notes = "Returns the relative walk speed of this mob. Standard is 1.0",
				},
				GetSpawnDelay =
				{
					IsStatic = true,
					Params =
					{
						{
							Name = "MobFamily",
							Type = "cMonster#eFamily",
						},
					},
					Returns =
					{
						{
							Type = "number",
						},
					},
					Notes = "Returns the spawn delay  - the number of game ticks between spawn attempts - for the specified mob family.",
				},
				HasCustomName =
				{
					Returns =
					{
						{
							Type = "boolean",
						},
					},
					Notes = "Returns true if the monster has a custom name.",
				},
				IsBaby =
				{
					Returns =
					{
						{
							Type = "boolean",
						},
					},
					Notes = "Returns true if the monster is a baby",
				},
				IsCustomNameAlwaysVisible =
				{
					Returns =
					{
						{
							Type = "boolean",
						},
					},
					Notes = "Is the custom name of this monster always visible? If not, you only see the name when you sight the mob.",
				},
				MobTypeToString =
				{
					IsStatic = true,
					Params =
					{
						{
							Name = "MobType",
							Type = "Globals#eMonsterType",
						},
					},
					Returns =
					{
						{
							Type = "string",
						},
					},
					Notes = "Returns the string representing the given mob type ({{Globals#eMonsterType|mtXXX}} constant), or empty string if unknown type.",
				},
				MobTypeToVanillaName =
				{
					IsStatic = true,
					Params =
					{
						{
							Name = "MobType",
							Type = "Globals#MobType",
						},
					},
					Returns =
					{
						{
							Type = "string",
						},
					},
					Notes = "Returns the vanilla name of the given mob type, or empty string if unknown type.",
				},
				MoveToPosition =
				{
					Params =
					{
						{
							Name = "Position",
							Type = "Vector3d",
						},
					},
					Notes = "Start moving (using a pathfinder) towards the specified position",
				},
				SetAge =
				{
					Params =
					{
						{
							Name = "Age",
							Type = "number",
						},
					},
					Notes = "Sets the age of the monster",
				},
				SetCustomName =
				{
					Params =
					{
						{
							Name = "CustomName",
							Type = "string",
						},
					},
					Notes = "Sets the custom name of the monster. You see the name over the monster. If you want to disable the custom name, simply set an empty string.",
				},
				SetCustomNameAlwaysVisible =
				{
					Params =
					{
						{
							Name = "IsCustomNameAlwaysVisible",
							Type = "boolean",
						},
					},
					Notes = "Sets the custom name visiblity of this monster. If it's false, you only see the name when you sight the mob. If it's true, you always see the custom name.",
				},
				SetRelativeWalkSpeed =
				{
					Params =
					{
						{
							Name = "RelativeWalkSpeed",
							Type = "number",
						},
					},
					Notes = "Sets the relative walk speed of this mob. The default relative speed is 1.0.",
				},
				StringToMobType =
				{
					IsStatic = true,
					Params =
					{
						{
							Name = "MobTypeString",
							Type = "string",
						},
					},
					Returns =
					{
						{
							Name = "MobType",
							Type = "Globals#eMonsterType",
						},
					},
					Notes = "Returns the mob type ({{Globals#eMonsterType|mtXXX}} constant) parsed from the string type (\"creeper\"), or mtInvalidType if unrecognized.",
				},
			},
			Constants =
			{
				mfAmbient =
				{
					Notes = "Family: ambient (bat)",
				},
				mfHostile =
				{
					Notes = "Family: hostile (blaze, cavespider, creeper, enderdragon, enderman, ghast, giant, magmacube, silverfish, skeleton, slime, spider, witch, wither, zombie, zombiepigman)",
				},
				mfMaxplusone =
				{
					Notes = "The maximum family value, plus one. Returned when monster family not recognized.",
				},
				mfPassive =
				{
					Notes = "Family: passive (chicken, cow, horse, irongolem, mooshroom, ocelot, pig, sheep, snowgolem, villager, wolf)",
				},
				mfWater =
				{
					Notes = "Family: water (squid)",
				},
				mtBat =
				{
					Notes = "",
				},
				mtBlaze =
				{
					Notes = "",
				},
				mtCaveSpider =
				{
					Notes = "",
				},
				mtChicken =
				{
					Notes = "",
				},
				mtCow =
				{
					Notes = "",
				},
				mtCreeper =
				{
					Notes = "",
				},
				mtEnderDragon =
				{
					Notes = "",
				},
				mtEnderman =
				{
					Notes = "",
				},
				mtGhast =
				{
					Notes = "",
				},
				mtGiant =
				{
					Notes = "",
				},
				mtHorse =
				{
					Notes = "",
				},
				mtInvalidType =
				{
					Notes = "Invalid monster type. Returned when monster type not recognized",
				},
				mtIronGolem =
				{
					Notes = "",
				},
				mtMagmaCube =
				{
					Notes = "",
				},
				mtMooshroom =
				{
					Notes = "",
				},
				mtOcelot =
				{
					Notes = "",
				},
				mtPig =
				{
					Notes = "",
				},
				mtSheep =
				{
					Notes = "",
				},
				mtSilverfish =
				{
					Notes = "",
				},
				mtSkeleton =
				{
					Notes = "",
				},
				mtSlime =
				{
					Notes = "",
				},
				mtSnowGolem =
				{
					Notes = "",
				},
				mtSpider =
				{
					Notes = "",
				},
				mtSquid =
				{
					Notes = "",
				},
				mtVillager =
				{
					Notes = "",
				},
				mtWitch =
				{
					Notes = "",
				},
				mtWither =
				{
					Notes = "",
				},
				mtWolf =
				{
					Notes = "",
				},
				mtZombie =
				{
					Notes = "",
				},
				mtZombiePigman =
				{
					Notes = "",
				},
			},
			ConstantGroups =
			{
				eFamily =
				{
					Include = "mf.*",
					TextBefore = [[
						Mobs are divided into families. The following constants are used for individual family types:
					]],
				},
			},
			Inherits = "cPawn",
		},
		cObjective =
		{
			Desc = [[
				This class represents a single scoreboard objective.
			]],
			Functions =
			{
				AddScore =
				{
					Params =
					{
						{
							Name = "string",
							Type = "string",
						},
						{
							Name = "number",
							Type = "number",
						},
					},
					Returns =
					{
						{
							Name = "Score",
							Type = "<unknown>",
						},
					},
					Notes = "Adds a value to the score of the specified player and returns the new value.",
				},
				GetDisplayName =
				{
					Returns =
					{
						{
							Type = "string",
						},
					},
					Notes = "Returns the display name of the objective. This name will be shown to the connected players.",
				},
				GetName =
				{
					Returns =
					{
						{
							Type = "string",
						},
					},
					Notes = "Returns the internal name of the objective.",
				},
				GetScore =
				{
					Params =
					{
						{
							Name = "string",
							Type = "string",
						},
					},
					Returns =
					{
						{
							Name = "Score",
							Type = "<unknown>",
						},
					},
					Notes = "Returns the score of the specified player.",
				},
				GetType =
				{
					Returns =
					{
						{
							Name = "eType",
							Type = "<unknown>",
						},
					},
					Notes = "Returns the type of the objective. (i.e what is being tracked)",
				},
				Reset =
				{
					Notes = "Resets the scores of the tracked players.",
				},
				ResetScore =
				{
					Params =
					{
						{
							Name = "string",
							Type = "string",
						},
					},
					Notes = "Reset the score of the specified player.",
				},
				SetDisplayName =
				{
					Params =
					{
						{
							Name = "string",
							Type = "string",
						},
					},
					Notes = "Sets the display name of the objective.",
				},
				SetScore =
				{
					Params =
					{
						{
							Name = "string",
							Type = "string",
						},
						{
							Name = "Score",
							Type = "<unknown>",
						},
					},
					Notes = "Sets the score of the specified player.",
				},
				SubScore =
				{
					Params =
					{
						{
							Name = "string",
							Type = "string",
						},
						{
							Name = "number",
							Type = "number",
						},
					},
					Returns =
					{
						{
							Name = "Score",
							Type = "<unknown>",
						},
					},
					Notes = "Subtracts a value from the score of the specified player and returns the new value.",
				},
			},
			Constants =
			{
				otAchievement =
				{
					Notes = "",
				},
				otDeathCount =
				{
					Notes = "",
				},
				otDummy =
				{
					Notes = "",
				},
				otHealth =
				{
					Notes = "",
				},
				otPlayerKillCount =
				{
					Notes = "",
				},
				otStat =
				{
					Notes = "",
				},
				otStatBlockMine =
				{
					Notes = "",
				},
				otStatEntityKill =
				{
					Notes = "",
				},
				otStatEntityKilledBy =
				{
					Notes = "",
				},
				otStatItemBreak =
				{
					Notes = "",
				},
				otStatItemCraft =
				{
					Notes = "",
				},
				otStatItemUse =
				{
					Notes = "",
				},
				otTotalKillCount =
				{
					Notes = "",
				},
			},
		},
		cPainting =
		{
			Desc = "This class represents a painting in the world. These paintings are special and different from Vanilla in that they can be critical-hit.",
			Functions =
			{
				GetDirection =
				{
					Returns =
					{
						{
							Type = "number",
						},
					},
					Notes = "Returns the direction the painting faces. Directions: ZP - 0, ZM - 2, XM - 1, XP - 3. Note that these are not the BLOCK_FACE constants.",
				},
				GetName =
				{
					Returns =
					{
						{
							Type = "string",
						},
					},
					Notes = "Returns the name of the painting",
				},
			},
		},
		cPawn =
		{
			Desc = "cPawn is a controllable pawn object, controlled by either AI or a player. cPawn inherits all functions and members of {{cEntity}}\
",
			Functions =
			{
				AddEntityEffect =
				{
					Params =
					{
						{
							Name = "EffectType",
							Type = "cEntityEffect",
						},
						{
							Name = "EffectDurationTicks",
							Type = "number",
						},
						{
							Name = "EffectIntensity",
							Type = "number",
						},
						{
							Name = "DistanceModifier",
							Type = "number",
						},
					},
					Notes = "Applies an entity effect. Checks with plugins if they allow the addition. EffectIntensity is the level of the effect (0 = Potion I, 1 = Potion II, etc). DistanceModifier is the scalar multiplied to the potion duration (only applies to splash potions).",
				},
				ClearEntityEffects =
				{
					Notes = "Removes all currently applied entity effects",
				},
				GetHealth =
				{
					Returns =
					{
						{
							Type = "number",
						},
					},
				},
				HasEntityEffect =
				{
					Params =
					{
						{
							Name = "EffectType",
							Type = "cEntityEffect",
						},
					},
					Returns =
					{
						{
							Type = "boolean",
						},
					},
					Notes = "Returns true, if the supplied entity effect type is currently applied",
				},
				Heal =
				{

				},
				KilledBy =
				{

				},
				RemoveEntityEffect =
				{
					Params =
					{
						{
							Name = "EffectType",
							Type = "cEntityEffect",
						},
					},
					Notes = "Removes a currently applied entity effect",
				},
				TakeDamage =
				{

				},
				TeleportTo =
				{

				},
				TeleportToEntity =
				{

				},
			},
			Inherits = "cEntity",
		},
		cPickup =
		{
			Desc = [[
				This class represents a pickup entity (an item that the player or mobs can pick up). It is also
				commonly known as "drops". With this class you could create your own "drop" or modify those
				created automatically.
			]],
			Functions =
			{
				CollectedBy =
				{
					Params =
					{
						{
							Name = "Player",
							Type = "cPlayer",
						},
					},
					Returns =
					{
						{
							Name = "WasCollected",
							Type = "boolean",
						},
					},
					Notes = "Tries to make the player collect the pickup. Returns true if the pickup was collected, at least partially.",
				},
				GetAge =
				{
					Returns =
					{
						{
							Type = "number",
						},
					},
					Notes = "Returns the number of ticks that the pickup has existed.",
				},
				GetItem =
				{
					Returns =
					{
						{
							Type = "cItem",
						},
					},
					Notes = "Returns the item represented by this pickup",
				},
				IsCollected =
				{
					Returns =
					{
						{
							Type = "boolean",
						},
					},
					Notes = "Returns true if this pickup has already been collected (is waiting to be destroyed)",
				},
				IsPlayerCreated =
				{
					Returns =
					{
						{
							Type = "boolean",
						},
					},
					Notes = "Returns true if the pickup was created by a player",
				},
				SetAge =
				{
					Params =
					{
						{
							Name = "AgeTicks",
							Type = "number",
						},
					},
					Notes = "Sets the pickup's age, in ticks.",
				},
			},
			Inherits = "cEntity",
		},
		cPlayer =
		{
			Desc = [[
				This class describes a player in the server. cPlayer inherits all functions and members of
				{{cPawn|cPawn}}. It handles all the aspects of the gameplay, such as hunger, sprinting, inventory
				etc.
			]],
			Functions =
			{
				AddFoodExhaustion =
				{
					Params =
					{
						{
							Name = "Exhaustion",
							Type = "number",
						},
					},
					Notes = "Adds the specified number to the food exhaustion. Only positive numbers expected.",
				},
				CalcLevelFromXp =
				{
					IsStatic = true,
					Params =
					{
						{
							Name = "XPAmount",
							Type = "number",
						},
					},
					Returns =
					{
						{
							Type = "number",
						},
					},
					Notes = "Returns the level which is reached with the specified amount of XP. Inverse of XpForLevel().",
				},
				CanFly =
				{
					Returns =
					{
						{
							Type = "boolean",
						},
					},
					Notes = "Returns if the player is able to fly.",
				},
				CloseWindow =
				{
					Params =
					{
						{
							Name = "CanRefuse",
							Type = "boolean",
							IsOptional = true,
						},
					},
					Notes = "Closes the currently open UI window. If CanRefuse is true (default), the window may refuse the closing.",
				},
				CloseWindowIfID =
				{
					Params =
					{
						{
							Name = "WindowID",
							Type = "number",
						},
						{
							Name = "CanRefuse",
							Type = "boolean",
							IsOptional = true,
						},
					},
					Notes = "Closes the currently open UI window if its ID matches the given ID. If CanRefuse is true (default), the window may refuse the closing.",
				},
				DeltaExperience =
				{
					Params =
					{
						{
							Name = "DeltaXP",
							Type = "number",
						},
					},
					Notes = "Adds or removes XP from the current XP amount. Won't allow XP to go negative. Returns the new experience, -1 on error (XP overflow).",
				},
				Feed =
				{
					Params =
					{
						{
							Name = "AddFood",
							Type = "number",
						},
						{
							Name = "AddSaturation",
							Type = "number",
						},
					},
					Returns =
					{
						{
							Type = "boolean",
						},
					},
					Notes = "Tries to add the specified amounts to food level and food saturation level (only positive amounts expected). Returns true if player was hungry and the food was consumed, false if too satiated.",
				},
				FoodPoison =
				{
					Params =
					{
						{
							Name = "NumTicks",
							Type = "number",
						},
					},
					Notes = "Starts the food poisoning for the specified amount of ticks; if already foodpoisoned, sets FoodPoisonedTicksRemaining to the larger of the two",
				},
				ForceSetSpeed =
				{
					Params =
					{
						{
							Name = "Direction",
							Type = "Vector3d",
						},
					},
					Notes = "Forces the player to move to the given direction.",
				},
				Freeze =
				{
					Params =
					{
						{
							Name = "Location",
							Type = "Vector3d",
						},
					},
					Notes = "Teleports the player to \"Location\" and prevents them from moving, locking them in place until unfreeze() is called",
				},
				GetClientHandle =
				{
					Returns =
					{
						{
							Type = "cClientHandle",
						},
					},
					Notes = "Returns the client handle representing the player's connection. May be nil (AI players).",
				},
				GetColor =
				{
					Returns =
					{
						{
							Type = "string",
						},
					},
					Notes = "Returns the full color code to be used for this player's messages (based on their rank). Prefix player messages with this code.",
				},
				GetCurrentXp =
				{
					Returns =
					{
						{
							Type = "number",
						},
					},
					Notes = "Returns the current amount of XP",
				},
				GetCustomName =
				{
					Returns =
					{
						{
							Type = "string",
						},
					},
					Notes = "Returns the custom name of this player. If the player hasn't a custom name, it will return an empty string.",
				},
				GetEffectiveGameMode =
				{
					Returns =
					{
						{
							Name = "GameMode",
							Type = "Globals#GameMode",
						},
					},
					Notes = "(OBSOLETE) Returns the current resolved game mode of the player. If the player is set to inherit the world's gamemode, returns that instead. See also GetGameMode() and IsGameModeXXX() functions. Note that this function is the same as GetGameMode(), use that function instead.",
				},
				GetEquippedItem =
				{
					Returns =
					{
						{
							Type = "cItem",
						},
					},
					Notes = "Returns the item that the player is currently holding; empty item if holding nothing.",
				},
				GetEyeHeight =
				{
					Returns =
					{
						{
							Type = "number",
						},
					},
					Notes = "Returns the height of the player's eyes, in absolute coords",
				},
				GetEyePosition =
				{
					Returns =
					{
						{
							Name = "EyePositionVector",
							Type = "Vector3d",
						},
					},
					Notes = "Returns the position of the player's eyes, as a {{Vector3d}}",
				},
				GetFloaterID =
				{
					Returns =
					{
						{
							Type = "number",
						},
					},
					Notes = "Returns the Entity ID of the fishing hook floater that belongs to the player. Returns -1 if no floater is associated with the player. FIXME: Undefined behavior when the player has used multiple fishing rods simultanously.",
				},
				GetFlyingMaxSpeed =
				{
					Returns =
					{
						{
							Type = "number",
						},
					},
					Notes = "Returns the maximum flying speed, relative to the default game flying speed. Defaults to 1, but plugins may modify it for faster or slower flying.",
				},
				GetFoodExhaustionLevel =
				{
					Returns =
					{
						{
							Type = "number",
						},
					},
					Notes = "Returns the food exhaustion level",
				},
				GetFoodLevel =
				{
					Returns =
					{
						{
							Type = "number",
						},
					},
					Notes = "Returns the food level (number of half-drumsticks on-screen)",
				},
				GetFoodPoisonedTicksRemaining =
				{
					Notes = "Returns the number of ticks left for the food posoning effect",
				},
				GetFoodSaturationLevel =
				{
					Returns =
					{
						{
							Type = "number",
						},
					},
					Notes = "Returns the food saturation (overcharge of the food level, is depleted before food level)",
				},
				GetFoodTickTimer =
				{
					Notes = "Returns the number of ticks past the last food-based heal or damage action; when this timer reaches 80, a new heal / damage is applied.",
				},
				GetGameMode =
				{
					Returns =
					{
						{
							Name = "GameMode",
							Type = "Globals#GameMode",
						},
					},
					Notes = "Returns the player's gamemode. The player may have their gamemode unassigned, in which case they inherit the gamemode from the current {{cWorld|world}}.<br /> <b>NOTE:</b> Instead of comparing the value returned by this function to the gmXXX constants, use the IsGameModeXXX() functions. These functions handle the gamemode inheritance automatically.",
				},
				GetInventory =
				{
					Returns =
					{
						{
							Name = "Inventory",
							Type = "cInventory",
						},
					},
					Notes = "Returns the player's inventory",
				},
				GetIP =
				{
					Returns =
					{
						{
							Type = "string",
						},
					},
					Notes = "Returns the IP address of the player, if available. Returns an empty string if there's no IP to report.",
				},
				GetLastBedPos =
				{
					Returns =
					{
						{
							Type = "Vector3i",
						},
					},
					Notes = "Returns the position of the last bed the player has slept in, or the world's spawn if no such position was recorded.",
				},
				GetMaxSpeed =
				{
					Returns =
					{
						{
							Type = "number",
						},
					},
					Notes = "Returns the player's current maximum speed, relative to the game default speed. Takes into account the sprinting / flying status.",
				},
				GetName =
				{
					Returns =
					{
						{
							Type = "string",
						},
					},
					Notes = "Returns the player's name",
				},
				GetNormalMaxSpeed =
				{
					Returns =
					{
						{
							Type = "number",
						},
					},
					Notes = "Returns the player's maximum walking speed, relative to the game default speed. Defaults to 1, but plugins may modify it for faster or slower walking.",
				},
				GetPermissions =
				{
					Returns =
					{
						{
							Type = "table",
						},
					},
					Notes = "Returns an array-table of all permissions (strings) that the player has assigned to them through their rank.",
				},
				GetPlayerListName =
				{
					Returns =
					{
						{
							Type = "string",
						},
					},
					Notes = "Returns the name that is used in the playerlist.",
				},
				GetResolvedPermissions =
				{
					Returns =
					{
						{
							Type = "table",
						},
					},
					Notes = "Returns all the player's permissions, as an array-table of strings.",
				},
				GetSprintingMaxSpeed =
				{
					Returns =
					{
						{
							Type = "number",
						},
					},
					Notes = "Returns the player's maximum sprinting speed, relative to the game default speed. Defaults to 1.3, but plugins may modify it for faster or slower sprinting.",
				},
				GetStance =
				{
					Returns =
					{
						{
							Type = "number",
						},
					},
					Notes = "Returns the player's stance (Y-pos of player's eyes)",
				},
				GetTeam =
				{
					Returns =
					{
						{
							Type = "cTeam",
						},
					},
					Notes = "Returns the team that the player belongs to, or nil if none.",
				},
				GetThrowSpeed =
				{
					Params =
					{
						{
							Name = "SpeedCoeff",
							Type = "number",
						},
					},
					Returns =
					{
						{
							Type = "Vector3d",
						},
					},
					Notes = "Returns the speed vector for an object thrown with the specified speed coeff. Basically returns the normalized look vector multiplied by the coeff, with a slight random variation.",
				},
				GetThrowStartPos =
				{
					Returns =
					{
						{
							Type = "Vector3d",
						},
					},
					Notes = "Returns the position where the projectiles should start when thrown by this player.",
				},
				GetUUID =
				{
					Returns =
					{
						{
							Type = "string",
						},
					},
					Notes = "Returns the (short) UUID that the player is using. Could be empty string for players that don't have a Mojang account assigned to them (in the future, bots for example).",
				},
				GetWindow =
				{
					Returns =
					{
						{
							Type = "cWindow",
						},
					},
					Notes = "Returns the currently open UI window. If the player doesn't have any UI window open, returns the inventory window.",
				},
				GetXpLevel =
				{
					Returns =
					{
						{
							Type = "number",
						},
					},
					Notes = "Returns the current XP level (based on current XP amount).",
				},
				GetXpLifetimeTotal =
				{
					Returns =
					{
						{
							Type = "number",
						},
					},
					Notes = "Returns the amount of XP that has been accumulated throughout the player's lifetime.",
				},
				GetXpPercentage =
				{
					Returns =
					{
						{
							Type = "number",
						},
					},
					Notes = "Returns the percentage of the experience bar - the amount of XP towards the next XP level. Between 0 and 1.",
				},
				HasCustomName =
				{
					Returns =
					{
						{
							Type = "boolean",
						},
					},
					Notes = "Returns true if the player has a custom name.",
				},
				HasPermission =
				{
					Params =
					{
						{
							Name = "PermissionString",
							Type = "string",
						},
					},
					Returns =
					{
						{
							Type = "boolean",
						},
					},
					Notes = "Returns true if the player has the specified permission",
				},
				Heal =
				{
					Params =
					{
						{
							Name = "HitPoints",
							Type = "number",
						},
					},
					Notes = "Heals the player by the specified amount of HPs. Only positive amounts are expected. Sends a health update to the client.",
				},
				IsEating =
				{
					Returns =
					{
						{
							Type = "boolean",
						},
					},
					Notes = "Returns true if the player is currently eating the item in their hand.",
				},
				IsFishing =
				{
					Returns =
					{
						{
							Type = "boolean",
						},
					},
					Notes = "Returns true if the player is currently fishing",
				},
				IsFlying =
				{
					Returns =
					{
						{
							Type = "boolean",
						},
					},
					Notes = "Returns true if the player is flying.",
				},
				IsFrozen =
				{
					Returns =
					{
						{
							Type = "boolean",
						},
					},
					Notes = "Returns true if the player is frozen. See Freeze()",
				},
				IsGameModeAdventure =
				{
					Returns =
					{
						{
							Type = "boolean",
						},
					},
					Notes = "Returns true if the player is in the gmAdventure gamemode, or has their gamemode unset and the world is a gmAdventure world.",
				},
				IsGameModeCreative =
				{
					Returns =
					{
						{
							Type = "boolean",
						},
					},
					Notes = "Returns true if the player is in the gmCreative gamemode, or has their gamemode unset and the world is a gmCreative world.",
				},
				IsGameModeSpectator =
				{
					Returns =
					{
						{
							Type = "boolean",
						},
					},
					Notes = "Returns true if the player is in the gmSpectator gamemode, or has their gamemode unset and the world is a gmSpectator world.",
				},
				IsGameModeSurvival =
				{
					Returns =
					{
						{
							Type = "boolean",
						},
					},
					Notes = "Returns true if the player is in the gmSurvival gamemode, or has their gamemode unset and the world is a gmSurvival world.",
				},
				IsInBed =
				{
					Returns =
					{
						{
							Type = "boolean",
						},
					},
					Notes = "Returns true if the player is currently lying in a bed.",
				},
				IsSatiated =
				{
					Returns =
					{
						{
							Type = "boolean",
						},
					},
					Notes = "Returns true if the player is satiated (cannot eat).",
				},
				IsVisible =
				{
					Returns =
					{
						{
							Type = "boolean",
						},
					},
					Notes = "Returns true if the player is visible to other players",
				},
				LoadRank =
				{
					Notes = "Reloads the player's rank, message visuals and permissions from the {{cRankManager}}, based on the player's current rank.",
				},
				MoveTo =
				{
					Params =
					{
						{
							Name = "NewPosition",
							Type = "Vector3d",
						},
					},
					Notes = "Tries to move the player into the specified position.",
				},
				OpenWindow =
				{
					Params =
					{
						{
							Name = "Window",
							Type = "cWindow",
						},
					},
					Notes = "Opens the specified UI window for the player.",
				},
				PermissionMatches =
				{
					IsStatic = true,
					Params =
					{
						{
							Name = "Permission",
							Type = "string",
						},
						{
							Name = "Template",
							Type = "string",
						},
					},
					Returns =
					{
						{
							Type = "boolean",
						},
					},
					Notes = "Returns true if the specified permission matches the specified template. The template may contain asterisk as a wildcard for any word.",
				},
				PlaceBlock =
				{
					Params =
					{
						{
							Name = "BlockX",
							Type = "number",
						},
						{
							Name = "BlockY",
							Type = "number",
						},
						{
							Name = "BlockZ",
							Type = "number",
						},
						{
							Name = "BlockType",
							Type = "number",
						},
						{
							Name = "BlockMeta",
							Type = "number",
						},
					},
					Returns =
					{
						{
							Type = "boolean",
						},
					},
					Notes = "Places a block while impersonating the player. The {{OnPlayerPlacingBlock|HOOK_PLAYER_PLACING_BLOCK}} hook is called before the placement, and if it succeeds, the block is placed and the {{OnPlayerPlacedBlock|HOOK_PLAYER_PLACED_BLOCK}} hook is called. Returns true iff the block is successfully placed. Assumes that the block is in a currently loaded chunk.",
				},
				Respawn =
				{
					Notes = "Restores the health, extinguishes fire, makes visible and sends the Respawn packet.",
				},
				SendAboveActionBarMessage =
				{
					Params =
					{
						{
							Name = "Message",
							Type = "string",
						},
					},
					Notes = "Sends the specified message to the player (shows above action bar, doesn't show for < 1.8 clients).",
				},
				SendBlocksAround =
				{
					Params =
					{
						{
							Name = "BlockX",
							Type = "number",
						},
						{
							Name = "BlockY",
							Type = "number",
						},
						{
							Name = "BlockZ",
							Type = "number",
						},
						{
							Name = "BlockRange",
							Type = "number",
							IsOptional = true,
						},
					},
					Notes = "Sends all the world's blocks in BlockRange from the specified coords to the player, as a BlockChange packet. Range defaults to 1 (only one block sent).",
				},
				SendMessage =
				{
					Params =
					{
						{
							Name = "Message",
							Type = "string",
						},
					},
					Notes = "Sends the specified message to the player.",
				},
				SendMessageFailure =
				{
					Params =
					{
						{
							Name = "Message",
							Type = "string",
						},
					},
					Notes = "Prepends Rose [INFO] / colours entire text (depending on ShouldUseChatPrefixes()) and sends message to player. For a command that failed to run because of insufficient permissions, etc.",
				},
				SendMessageFatal =
				{
					Params =
					{
						{
							Name = "Message",
							Type = "string",
						},
					},
					Notes = "Prepends Red [FATAL] / colours entire text (depending on ShouldUseChatPrefixes()) and sends message to player. For something serious, such as a plugin crash, etc.",
				},
				SendMessageInfo =
				{
					Params =
					{
						{
							Name = "Message",
							Type = "string",
						},
					},
					Notes = "Prepends Yellow [INFO] / colours entire text (depending on ShouldUseChatPrefixes()) and sends message to player. Informational message, such as command usage, etc.",
				},
				SendMessagePrivateMsg =
				{
					Params =
					{
						{
							Name = "Message",
							Type = "string",
						},
						{
							Name = "SenderName",
							Type = "string",
						},
					},
					Notes = "Prepends Light Blue [MSG: *SenderName*] / prepends SenderName and colours entire text (depending on ShouldUseChatPrefixes()) and sends message to player. For private messaging.",
				},
				SendMessageSuccess =
				{
					Params =
					{
						{
							Name = "Message",
							Type = "string",
						},
					},
					Notes = "Prepends Green [INFO] / colours entire text (depending on ShouldUseChatPrefixes()) and sends message to player. Success notification.",
				},
				SendMessageWarning =
				{
					Params =
					{
						{
							Name = "Message",
							Type = "string",
						},
					},
					Notes = "Prepends Rose [WARN] / colours entire text (depending on ShouldUseChatPrefixes()) and sends message to player. Denotes that something concerning, such as plugin reload, is about to happen.",
				},
				SendRotation =
				{
					Params =
					{
						{
							Name = "YawDegrees",
							Type = "number",
						},
						{
							Name = "PitchDegrees",
							Type = "number",
						},
					},
					Notes = "Sends the specified rotation to the player, forcing them to look that way",
				},
				SendSystemMessage =
				{
					Params =
					{
						{
							Name = "Message",
							Type = "string",
						},
					},
					Notes = "Sends the specified message to the player (doesn't show for < 1.8 clients).",
				},
				SetBedPos =
				{
					Params =
					{
						{
							Name = "Position",
							Type = "Vector3i",
						},
						{
							Name = "World",
							Type = "cWorld*",
							IsOptional = true,
						},
					},
					Notes = "Sets the position and world of the player's respawn point, which is also known as the bed position. The player will respawn at this position and world upon death. If the world is not specified, it is set to the player's current world.",
				},
				SetCanFly =
				{
					Params =
					{
						{
							Name = "CanFly",
							Type = "boolean",
						},
					},
					Notes = "Sets if the player can fly or not.",
				},
				SetCrouch =
				{
					Params =
					{
						{
							Name = "IsCrouched",
							Type = "boolean",
						},
					},
					Notes = "Sets the crouch state, broadcasts the change to other players.",
				},
				SetCurrentExperience =
				{
					Params =
					{
						{
							Name = "XPAmount",
							Type = "number",
						},
					},
					Notes = "Sets the current amount of experience (and indirectly, the XP level).",
				},
				SetCustomName =
				{
					Params =
					{
						{
							Name = "CustomName",
							Type = "string",
						},
					},
					Notes = "Sets the custom name for this player. If you want to disable the custom name, simply set an empty string. The custom name will be used in the tab-list, in the player nametag and in the tab-completion.",
				},
				SetFlying =
				{
					Params =
					{
						{
							Name = "IsFlying",
							Type = "boolean",
						},
					},
					Notes = "Sets if the player is flying or not.",
				},
				SetFlyingMaxSpeed =
				{
					Params =
					{
						{
							Name = "FlyingMaxSpeed",
							Type = "number",
						},
					},
					Notes = "Sets the flying maximum speed, relative to the game default speed. The default value is 1. Sends the updated speed to the client.",
				},
				SetFoodExhaustionLevel =
				{
					Params =
					{
						{
							Name = "ExhaustionLevel",
							Type = "number",
						},
					},
					Notes = "Sets the food exhaustion to the specified level.",
				},
				SetFoodLevel =
				{
					Params =
					{
						{
							Name = "FoodLevel",
							Type = "number",
						},
					},
					Notes = "Sets the food level (number of half-drumsticks on-screen)",
				},
				SetFoodPoisonedTicksRemaining =
				{
					Params =
					{
						{
							Name = "FoodPoisonedTicksRemaining",
							Type = "number",
						},
					},
					Notes = "Sets the number of ticks remaining for food poisoning. Doesn't send foodpoisoning effect to the client, use FoodPoison() for that.",
				},
				SetFoodSaturationLevel =
				{
					Params =
					{
						{
							Name = "FoodSaturationLevel",
							Type = "number",
						},
					},
					Notes = "Sets the food saturation (overcharge of the food level).",
				},
				SetFoodTickTimer =
				{
					Params =
					{
						{
							Name = "FoodTickTimer",
							Type = "number",
						},
					},
					Notes = "Sets the number of ticks past the last food-based heal or damage action; when this timer reaches 80, a new heal / damage is applied.",
				},
				SetGameMode =
				{
					Params =
					{
						{
							Name = "NewGameMode",
							Type = "Globals#GameMode",
						},
					},
					Notes = "Sets the gamemode for the player. The new gamemode overrides the world's default gamemode, unless it is set to gmInherit.",
				},
				SetIsFishing =
				{
					Params =
					{
						{
							Name = "IsFishing",
							Type = "boolean",
						},
						{
							Name = "FloaterEntityID",
							Type = "number",
							IsOptional = true,
						},
					},
					Notes = "Sets the 'IsFishing' flag for the player. The floater entity ID is expected for the true variant, it can be omitted when IsFishing is false. FIXME: Undefined behavior when multiple fishing rods are used simultanously",
				},
				SetName =
				{
					Params =
					{
						{
							Name = "Name",
							Type = "string",
						},
					},
					Notes = "Sets the player name. This rename will NOT be visible to any players already in the server who are close enough to see this player.",
				},
				SetNormalMaxSpeed =
				{
					Params =
					{
						{
							Name = "NormalMaxSpeed",
							Type = "number",
						},
					},
					Notes = "Sets the normal (walking) maximum speed, relative to the game default speed. The default value is 1. Sends the updated speed to the client, if appropriate.",
				},
				SetSprint =
				{
					Params =
					{
						{
							Name = "IsSprinting",
							Type = "boolean",
						},
					},
					Notes = "Sets whether the player is sprinting or not.",
				},
				SetSprintingMaxSpeed =
				{
					Params =
					{
						{
							Name = "SprintingMaxSpeed",
							Type = "number",
						},
					},
					Notes = "Sets the sprinting maximum speed, relative to the game default speed. The default value is 1.3. Sends the updated speed to the client, if appropriate.",
				},
				SetTeam =
				{
					Params =
					{
						{
							Name = "Team",
							Type = "cTeam",
						},
					},
					Notes = "Moves the player to the specified team.",
				},
				SetVisible =
				{
					Params =
					{
						{
							Name = "IsVisible",
							Type = "boolean",
						},
					},
					Notes = "Sets the player visibility to other players",
				},
				TossEquippedItem =
				{
					Params =
					{
						{
							Name = "Amount",
							Type = "number",
							IsOptional = true,
						},
					},
					Notes = "Tosses the item that the player has selected in their hotbar. Amount defaults to 1.",
				},
				TossHeldItem =
				{
					Params =
					{
						{
							Name = "Amount",
							Type = "number",
							IsOptional = true,
						},
					},
					Notes = "Tosses the item held by the cursor, when the player is in a UI window. Amount defaults to 1.",
				},
				TossPickup =
				{
					Params =
					{
						{
							Name = "Item",
							Type = "cItem",
						},
					},
					Notes = "Tosses a pickup newly created from the specified item.",
				},
				Unfreeze =
				{
					Notes = "Allows the player to move again, canceling the effects of Freeze()",
				},
				XpForLevel =
				{
					IsStatic = true,
					Params =
					{
						{
							Name = "XPLevel",
							Type = "number",
						},
					},
					Returns =
					{
						{
							Type = "number",
						},
					},
					Notes = "Returns the total amount of XP needed for the specified XP level. Inverse of CalcLevelFromXp().",
				},
			},
			Constants =
			{
				EATING_TICKS =
				{
					Notes = "Number of ticks required for consuming an item.",
				},
				MAX_FOOD_LEVEL =
				{
					Notes = "The maximum food level value. When the food level is at this value, the player cannot eat.",
				},
				MAX_HEALTH =
				{
					Notes = "The maximum health value",
				},
			},
			Inherits = "cPawn",
		},
		cRankManager =
		{
			Desc = [[
				Manages the players' permissions. The players are assigned a single rank, which contains groups of
				permissions. The functions in this class query or modify these.</p>
				<p>
				All the functions are static, call them using the <code>cRankManager:Function()</code> convention.</p>
				<p>
				The players are identified by their UUID, to support player renaming.</p>
				<p>
				The rank also contains specific "mesage visuals" - bits that are used for formatting messages from the
				players. There's a message prefix, which is put in front of every message the player sends, and the
				message suffix that is appended to each message. There's also a PlayerNameColorCode, which holds the
				color that is used for the player's name in the messages.</p>
				<p>
				Each rank can contain any number of permission groups. These groups allow for an easier setup of the
				permissions - you can share groups among ranks, so the usual approach is to group similar permissions
				together and add that group to any rank that should use those permissions.</p>
				<p>
				Permissions are added to individual groups. Each group can support unlimited permissions. Note that
				adding a permission to a group will make the permission available to all the ranks that contain that
				permission group.</p>
				<p>
				One rank is reserved as the Default rank. All players that don't have an explicit rank assigned to them
				will behave as if assigned to this rank. The default rank can be changed to any other rank at any time.
				Note that the default rank cannot be removed from the RankManager - RemoveRank() will change the default
				rank to the replacement rank, if specified, and fail if no replacement rank is specified. Renaming the
				default rank using RenameRank() will change the default rank to the new name.
			]],
			Functions =
			{
				AddGroup =
				{
					Params =
					{
						{
							Name = "GroupName",
							Type = "string",
						},
					},
					Notes = "Adds the group of the specified name. Logs a warning and does nothing if the group already exists.",
				},
				AddGroupToRank =
				{
					Params =
					{
						{
							Name = "GroupName",
							Type = "string",
						},
						{
							Name = "RankName",
							Type = "string",
						},
					},
					Returns =
					{
						{
							Type = "boolean",
						},
					},
					Notes = "Adds the specified group to the specified rank. Returns true on success, false on failure - if the group name or the rank name is not found.",
				},
				AddPermissionToGroup =
				{
					Params =
					{
						{
							Name = "Permission",
							Type = "string",
						},
						{
							Name = "GroupName",
							Type = "string",
						},
					},
					Returns =
					{
						{
							Type = "boolean",
						},
					},
					Notes = "Adds the specified permission to the specified group. Returns true on success, false on failure - if the group name is not found.",
				},
				AddRank =
				{
					Params =
					{
						{
							Name = "RankName",
							Type = "string",
						},
						{
							Name = "MsgPrefix",
							Type = "string",
						},
						{
							Name = "MsgSuffix",
							Type = "string",
						},
						{
							Name = "MsgNameColorCode",
							Type = "string",
						},
					},
					Notes = "Adds a new rank of the specified name and with the specified message visuals. Logs an info message and does nothing if the rank already exists.",
				},
				ClearPlayerRanks =
				{
					Notes = "Removes all player ranks from the database. Note that this doesn't change the cPlayer instances for the already connected players, you need to update all the instances manually.",
				},
				GetAllGroups =
				{
					Returns =
					{
						{
							Type = "table",
						},
					},
					Notes = "Returns an array-table containing the names of all the groups that are known to the manager.",
				},
				GetAllPermissions =
				{
					Returns =
					{
						{
							Type = "table",
						},
					},
					Notes = "Returns an array-table containing all the permissions that are known to the manager.",
				},
				GetAllPlayerUUIDs =
				{
					Returns =
					{
						{
							Type = "table",
						},
					},
					Notes = "Returns the short uuids of all players stored in the rank DB, sorted by the players' names (case insensitive).",
				},
				GetAllRanks =
				{
					Returns =
					{
						{
							Type = "table",
						},
					},
					Notes = "Returns an array-table containing the names of all the ranks that are known to the manager.",
				},
				GetDefaultRank =
				{
					Returns =
					{
						{
							Type = "string",
						},
					},
					Notes = "Returns the name of the default rank. ",
				},
				GetGroupPermissions =
				{
					Params =
					{
						{
							Name = "GroupName",
							Type = "string",
						},
					},
					Returns =
					{
						{
							Type = "table",
						},
					},
					Notes = "Returns an array-table containing the permissions that the specified group contains.",
				},
				GetPlayerGroups =
				{
					Params =
					{
						{
							Name = "PlayerUUID",
							Type = "string",
						},
					},
					Returns =
					{
						{
							Type = "table",
						},
					},
					Notes = "Returns an array-table of the names of the groups that are assigned to the specified player through their rank. Returns an empty table if the player is not known or has no rank or groups assigned to them.",
				},
				GetPlayerMsgVisuals =
				{
					Params =
					{
						{
							Name = "PlayerUUID",
							Type = "string",
						},
					},
					Returns =
					{
						{
							Name = "MsgPrefix",
							Type = "string",
						},
						{
							Name = "MsgSuffix",
							Type = "string",
						},
						{
							Name = "MsgNameColorCode",
							Type = "string",
						},
					},
					Notes = "Returns the message visuals assigned to the player. If the player is not explicitly assigned a rank, the default rank's visuals are returned. If there is an error, no value is returned at all.",
				},
				GetPlayerName =
				{
					Params =
					{
						{
							Name = "PlayerUUID",
							Type = "string",
						},
					},
					Returns =
					{
						{
							Name = "PlayerName",
							Type = "string",
						},
					},
					Notes = "Returns the last name that the specified player has, for a player in the ranks database. An empty string is returned if the player isn't in the database.",
				},
				GetPlayerPermissions =
				{
					Params =
					{
						{
							Name = "PlayerUUID",
							Type = "string",
						},
					},
					Returns =
					{
						{
							Type = "table",
						},
					},
					Notes = "Returns an array-table containing all permissions that the specified player is assigned through their rank. Returns the default rank's permissions if the player has no explicit rank assigned to them. Returns an empty array on error.",
				},
				GetPlayerRankName =
				{
					Params =
					{
						{
							Name = "PlayerUUID",
							Type = "string",
						},
					},
					Returns =
					{
						{
							Name = "RankName",
							Type = "string",
						},
					},
					Notes = "Returns the name of the rank that is assigned to the specified player. An empty string (NOT the default rank) is returned if the player has no rank assigned to them.",
				},
				GetRankGroups =
				{
					Params =
					{
						{
							Name = "RankName",
							Type = "string",
						},
					},
					Returns =
					{
						{
							Type = "table",
						},
					},
					Notes = "Returns an array-table of the names of all the groups that are assigned to the specified rank. Returns an empty table if there is no such rank.",
				},
				GetRankPermissions =
				{
					Params =
					{
						{
							Name = "RankName",
							Type = "string",
						},
					},
					Returns =
					{
						{
							Type = "table",
						},
					},
					Notes = "Returns an array-table of all the permissions that are assigned to the specified rank through its groups. Returns an empty table if there is no such rank.",
				},
				GetRankVisuals =
				{
					Params =
					{
						{
							Name = "RankName",
							Type = "string",
						},
					},
					Returns =
					{
						{
							Name = "MsgPrefix",
							Type = "string",
						},
						{
							Name = "MsgSuffix",
							Type = "string",
						},
						{
							Name = "MsgNameColorCode",
							Type = "string",
						},
					},
					Notes = "Returns the message visuals for the specified rank. Returns no value if the specified rank does not exist.",
				},
				GroupExists =
				{
					Params =
					{
						{
							Name = "GroupName",
							Type = "string",
						},
					},
					Returns =
					{
						{
							Type = "boolean",
						},
					},
					Notes = "Returns true iff the specified group exists.",
				},
				IsGroupInRank =
				{
					Params =
					{
						{
							Name = "GroupName",
							Type = "string",
						},
						{
							Name = "RankName",
							Type = "string",
						},
					},
					Returns =
					{
						{
							Type = "boolean",
						},
					},
					Notes = "Returns true iff the specified group is assigned to the specified rank.",
				},
				IsPermissionInGroup =
				{
					Params =
					{
						{
							Name = "Permission",
							Type = "string",
						},
						{
							Name = "GroupName",
							Type = "string",
						},
					},
					Returns =
					{
						{
							Type = "boolean",
						},
					},
					Notes = "Returns true iff the specified permission is assigned to the specified group.",
				},
				IsPlayerRankSet =
				{
					Params =
					{
						{
							Name = "PlayerUUID",
							Type = "string",
						},
					},
					Returns =
					{
						{
							Type = "boolean",
						},
					},
					Notes = "Returns true iff the specified player has a rank assigned to them.",
				},
				RankExists =
				{
					Params =
					{
						{
							Name = "RankName",
							Type = "string",
						},
					},
					Returns =
					{
						{
							Type = "boolean",
						},
					},
					Notes = "Returns true iff the specified rank exists.",
				},
				RemoveGroup =
				{
					Params =
					{
						{
							Name = "GroupName",
							Type = "string",
						},
					},
					Notes = "Removes the specified group completely. The group will be removed from all the ranks using it and then erased from the manager. Logs an info message and does nothing if the group doesn't exist.",
				},
				RemoveGroupFromRank =
				{
					Params =
					{
						{
							Name = "GroupName",
							Type = "string",
						},
						{
							Name = "RankName",
							Type = "string",
						},
					},
					Notes = "Removes the specified group from the specified rank. The group will still exist, even if it isn't assigned to any rank. Logs an info message and does nothing if the group or rank doesn't exist.",
				},
				RemovePermissionFromGroup =
				{
					Params =
					{
						{
							Name = "Permission",
							Type = "string",
						},
						{
							Name = "GroupName",
							Type = "string",
						},
					},
					Notes = "Removes the specified permission from the specified group. Logs an info message and does nothing if the group doesn't exist.",
				},
				RemovePlayerRank =
				{
					Params =
					{
						{
							Name = "PlayerUUID",
							Type = "string",
						},
					},
					Notes = "Removes the player's rank; the player's left without a rank. Note that this doesn't change the {{cPlayer}} instances for the already connected players, you need to update all the instances manually. No action if the player has no rank assigned to them already.",
				},
				RemoveRank =
				{
					Params =
					{
						{
							Name = "RankName",
							Type = "string",
						},
						{
							Name = "ReplacementRankName",
							Type = "string",
							IsOptional = true,
						},
					},
					Notes = "Removes the specified rank. If ReplacementRankName is given, the players that have RankName will get their rank set to ReplacementRankName. If it isn't given, or is an invalid rank, the players will be removed from the manager, their ranks will be unset completely. Logs an info message and does nothing if the rank is not found.",
				},
				RenameGroup =
				{
					Params =
					{
						{
							Name = "OldName",
							Type = "string",
						},
						{
							Name = "NewName",
							Type = "string",
						},
					},
					Notes = "Renames the specified group. Logs an info message and does nothing if the group is not found or the new name is already used.",
				},
				RenameRank =
				{
					Params =
					{
						{
							Name = "OldName",
							Type = "string",
						},
						{
							Name = "NewName",
							Type = "string",
						},
					},
					Notes = "Renames the specified rank. Logs an info message and does nothing if the rank is not found or the new name is already used.",
				},
				SetDefaultRank =
				{
					Params =
					{
						{
							Name = "RankName",
							Type = "string",
						},
					},
					Returns =
					{
						{
							Type = "boolean",
						},
					},
					Notes = "Sets the specified rank as the default rank. Returns true on success, false on failure (rank doesn't exist).",
				},
				SetPlayerRank =
				{
					Params =
					{
						{
							Name = "PlayerUUID",
							Type = "string",
						},
						{
							Name = "PlayerName",
							Type = "string",
						},
						{
							Name = "RankName",
							Type = "string",
						},
					},
					Notes = "Updates the rank for the specified player. The player name is provided for reference, the UUID is used for identification. Logs a warning and does nothing if the rank is not found.",
				},
				SetRankVisuals =
				{
					Params =
					{
						{
							Name = "RankName",
							Type = "string",
						},
						{
							Name = "MsgPrefix",
							Type = "string",
						},
						{
							Name = "MsgSuffix",
							Type = "string",
						},
						{
							Name = "MsgNameColorCode",
							Type = "string",
						},
					},
					Notes = "Updates the rank's message visuals. Logs an info message and does nothing if rank not found.",
				},
			},
		},
		cRoot =
		{
			Desc = [[
				This class represents the root of Cuberite's object hierarchy. There is always only one cRoot
				object. It manages and allows querying all the other objects, such as {{cServer}},
				{{cPluginManager}}, individual {{cWorld|worlds}} etc.</p>
				<p>
				To get the singleton instance of this object, you call the cRoot:Get() function. Then you can call
				the individual functions on this object. Note that some of the functions are static and don't need
				the instance, they are to be called directly on the cRoot class, such as cRoot:GetPhysicalRAMUsage()
			]],
			Functions =
			{
				BroadcastChat =
				{
					{
						Params =
						{
							{
								Name = "MessageText",
								Type = "string",
							},
							{
								Name = "MessageType",
								Type = "eMessageType",
							},
						},
						Notes = "Broadcasts a message to all players, with its message type set to MessageType (default: mtCustom).",
					},
					{
						Params =
						{
							{
								Name = "CompositeChat",
								Type = "cCompositeChat",
							},
						},
						Notes = "Broadcasts a {{cCompositeChat|composite chat message}} to all players.",
					},
				},
				BroadcastChatDeath =
				{
					Params =
					{
						{
							Name = "MessageText",
							Type = "string",
						},
					},
					Notes = "Broadcasts the specified message to all players, with its message type set to mtDeath. Use for when a player has died.",
				},
				BroadcastChatFailure =
				{
					Params =
					{
						{
							Name = "MessageText",
							Type = "string",
						},
					},
					Notes = "Broadcasts the specified message to all players, with its message type set to mtFailure. Use for a command that failed to run because of insufficient permissions, etc.",
				},
				BroadcastChatFatal =
				{
					Params =
					{
						{
							Name = "MessageText",
							Type = "string",
						},
					},
					Notes = "Broadcasts the specified message to all players, with its message type set to mtFatal. Use for a plugin that crashed, or similar.",
				},
				BroadcastChatInfo =
				{
					Params =
					{
						{
							Name = "MessageText",
							Type = "string",
						},
					},
					Notes = "Broadcasts the specified message to all players, with its message type set to mtInfo. Use for informational messages, such as command usage.",
				},
				BroadcastChatJoin =
				{
					Params =
					{
						{
							Name = "MessageText",
							Type = "string",
						},
					},
					Notes = "Broadcasts the specified message to all players, with its message type set to mtJoin. Use for players joining the server.",
				},
				BroadcastChatLeave =
				{
					Params =
					{
						{
							Name = "MessageText",
							Type = "string",
						},
					},
					Notes = "Broadcasts the specified message to all players, with its message type set to mtLeave. Use for players leaving the server.",
				},
				BroadcastChatSuccess =
				{
					Params =
					{
						{
							Name = "MessageText",
							Type = "string",
						},
					},
					Notes = "Broadcasts the specified message to all players, with its message type set to mtSuccess. Use for success messages.",
				},
				BroadcastChatWarning =
				{
					Params =
					{
						{
							Name = "MessageText",
							Type = "string",
						},
					},
					Notes = "Broadcasts the specified message to all players, with its message type set to mtWarning. Use for concerning events, such as plugin reload etc.",
				},
				DoWithPlayerByUUID =
				{
					Params =
					{
						{
							Name = "PlayerUUID",
							Type = "string",
						},
						{
							Name = "CallbackFunction",
							Type = "function",
						},
					},
					Returns =
					{
						{
							Type = "boolean",
						},
					},
					Notes = "If there is the player with the uuid, calls the CallbackFunction with the {{cPlayer}} parameter representing the player. The CallbackFunction has the following signature: <pre class=\"prettyprint lang-lua\">function Callback({{cPlayer|Player}})</pre> The function returns false if the player was not found, or whatever bool value the callback returned if the player was found.",
				},
				FindAndDoWithPlayer =
				{
					Params =
					{
						{
							Name = "PlayerName",
							Type = "string",
						},
						{
							Name = "CallbackFunction",
							Type = "function",
						},
					},
					Returns =
					{
						{
							Type = "boolean",
						},
					},
					Notes = "Calls the given callback function for the player with the name best matching the name string provided.<br>This function is case-insensitive and will match partial names.<br>Returns false if player not found or there is ambiguity, true otherwise. The CallbackFunction has the following signature: <pre class=\"prettyprint lang-lua\">function Callback({{cPlayer|Player}})</pre>",
				},
				ForEachPlayer =
				{
					Params =
					{
						{
							Name = "CallbackFunction",
							Type = "function",
						},
					},
					Notes = "Calls the given callback function for each player. The callback function has the following signature: <pre class=\"prettyprint lang-lua\">function Callback({{cPlayer|cPlayer}})</pre>",
				},
				ForEachWorld =
				{
					Params =
					{
						{
							Name = "CallbackFunction",
							Type = "function",
						},
					},
					Notes = "Calls the given callback function for each world. The callback function has the following signature: <pre class=\"prettyprint lang-lua\">function Callback({{cWorld|cWorld}})</pre>",
				},
				Get =
				{
					IsStatic = true,
					Returns =
					{
						{
							Type = "cRoot",
						},
					},
					Notes = "Returns the one and only cRoot object.",
				},
				GetBrewingRecipe =
				{
					IsStatic = true,
					Params =
					{
						{
							Name = "Bottle",
							Type = "cItem",
						},
						{
							Name = "Ingredient",
							Type = "cItem",
						},
					},
					Returns =
					{
						{
							Type = "cItem",
						},
					},
					Notes = "Returns the result item, if a recipe has been found to brew the Ingredient into Bottle. If no recipe is found, returns no value.",
				},
				GetBuildCommitID =
				{
					IsStatic = true,
					Returns =
					{
						{
							Type = "string",
						},
					},
					Notes = "For official builds (Travis CI / Jenkins) it returns the exact commit hash used for the build. For unofficial local builds, returns the approximate commit hash (since the true one cannot be determined), formatted as \"approx: &lt;CommitHash&gt;\".",
				},
				GetBuildDateTime =
				{
					IsStatic = true,
					Returns =
					{
						{
							Type = "string",
						},
					},
					Notes = "For official builds (Travic CI / Jenkins) it returns the date and time of the build. For unofficial local builds, returns the approximate datetime of the commit (since the true one cannot be determined), formatted as \"approx: &lt;DateTime-iso8601&gt;\".",
				},
				GetBuildID =
				{
					IsStatic = true,
					Returns =
					{
						{
							Type = "string",
						},
					},
					Notes = "For official builds (Travis CI / Jenkins) it returns the unique ID of the build, as recognized by the build system. For unofficial local builds, returns the string \"Unknown\".",
				},
				GetBuildSeriesName =
				{
					IsStatic = true,
					Returns =
					{
						{
							Type = "string",
						},
					},
					Notes = "For official builds (Travis CI / Jenkins) it returns the series name of the build (for example \"Cuberite Windows x64 Master\"). For unofficial local builds, returns the string \"local build\".",
				},
				GetCraftingRecipes =
				{
					Returns =
					{
						{
							Type = "cCraftingRecipe",
						},
					},
					Notes = "Returns the CraftingRecipes object",
				},
				GetDefaultWorld =
				{
					Returns =
					{
						{
							Type = "cWorld",
						},
					},
					Notes = "Returns the world object from the default world.",
				},
				GetFurnaceFuelBurnTime =
				{
					IsStatic = true,
					Params =
					{
						{
							Name = "Fuel",
							Type = "cItem",
						},
					},
					Returns =
					{
						{
							Type = "number",
						},
					},
					Notes = "Returns the number of ticks for how long the item would fuel a furnace. Returns zero if not a fuel.",
				},
				GetFurnaceRecipe =
				{
					IsStatic = true,
					Params =
					{
						{
							Name = "InItem",
							Type = "cItem",
						},
					},
					Returns =
					{
						{
							Name = "OutItem",
							Type = "cItem",
						},
						{
							Name = "NumTicks",
							Type = "number",
						},
						{
							Name = "InItem",
							Type = "cItem",
						},
					},
					Notes = "Returns the furnace recipe for smelting the specified input. If a recipe is found, returns the smelted result, the number of ticks required for the smelting operation, and the input consumed (note that Cuberite supports smelting M items into N items and different smelting rates). If no recipe is found, returns no value.",
				},
				GetPhysicalRAMUsage =
				{
					Returns =
					{
						{
							Type = "number",
						},
					},
					Notes = "Returns the amount of physical RAM that the entire Cuberite process is using, in KiB. Negative if the OS doesn't support this query.",
				},
				GetPluginManager =
				{
					Returns =
					{
						{
							Type = "cPluginManager",
						},
					},
					Notes = "Returns the cPluginManager object.",
				},
				GetPrimaryServerVersion =
				{
					Returns =
					{
						{
							Type = "number",
						},
					},
					Notes = "Returns the servers primary server version.",
				},
				GetProtocolVersionTextFromInt =
				{
					Params =
					{
						{
							Name = "ProtocolVersionNumber",
							Type = "number",
						},
					},
					Returns =
					{
						{
							Type = "string",
						},
					},
					Notes = "Returns the Minecraft client version from the given Protocol version number. If there is no version found, it returns 'Unknown protocol (Number)'",
				},
				GetServer =
				{
					Returns =
					{
						{
							Type = "cServer",
						},
					},
					Notes = "Returns the cServer object.",
				},
				GetServerUpTime =
				{
					Returns =
					{
						{
							Type = "number",
						},
					},
					Notes = "Returns the uptime of the server in seconds.",
				},
				GetTotalChunkCount =
				{
					Returns =
					{
						{
							Type = "number",
						},
					},
					Notes = "Returns the amount of loaded chunks.",
				},
				GetVirtualRAMUsage =
				{
					Returns =
					{
						{
							Type = "number",
						},
					},
					Notes = "Returns the amount of virtual RAM that the entire Cuberite process is using, in KiB. Negative if the OS doesn't support this query.",
				},
				GetWebAdmin =
				{
					Returns =
					{
						{
							Type = "cWebAdmin",
						},
					},
					Notes = "Returns the cWebAdmin object.",
				},
				GetWorld =
				{
					Params =
					{
						{
							Name = "WorldName",
							Type = "string",
						},
					},
					Returns =
					{
						{
							Type = "cWorld",
						},
					},
					Notes = "Returns the cWorld object of the given world. It returns nil if there is no world with the given name.",
				},
				QueueExecuteConsoleCommand =
				{
					Params =
					{
						{
							Name = "Message",
							Type = "string",
						},
					},
					Notes = "Queues a console command for execution through the cServer class. The command will be executed in the tick thread. The command's output will be sent to console.",
				},
				SaveAllChunks =
				{
					Notes = "Saves all the chunks in all the worlds. Note that the saving is queued on each world's tick thread and this functions returns before the chunks are actually saved.",
				},
				SetPrimaryServerVersion =
				{
					Params =
					{
						{
							Name = "Protocol Version",
							Type = "number",
						},
					},
					Notes = "Sets the servers PrimaryServerVersion to the given protocol number.",
				},
			},
			AdditionalInfo =
			{
				{
					Header = "Querying a furnace recipe",
					Contents = [[
						To find the furnace recipe for an item, use the following code (adapted from the Debuggers plugin's /fr command):
<pre class="prettyprint lang-lua">
local HeldItem = a_Player:GetEquippedItem();
local Out, NumTicks, In = cRoot:GetFurnaceRecipe(HeldItem);  -- Note STATIC call - no need for a Get()
if (Out ~= nil) then
	-- There is a recipe, list it:
	a_Player:SendMessage(
		"Furnace turns " .. ItemToFullString(In) ..
		" to " .. ItemToFullString(Out) ..
		" in " .. NumTicks .. " ticks (" ..
		tostring(NumTicks / 20) .. " seconds)."
	);
else
	-- No recipe found
	a_Player:SendMessage("There is no furnace recipe that would smelt " .. ItemToString(HeldItem));
end
</pre>
					]],
				},
			},
		},
		cScoreboard =
		{
			Desc = [[
				This class manages the objectives and teams of a single world.
			]],
			Functions =
			{
				AddPlayerScore =
				{
					Params =
					{
						{
							Name = "Name",
							Type = "string",
						},
						{
							Name = "Type",
							Type = "<unknown>",
						},
						{
							Name = "Value",
							Type = "<unknown>",
						},
					},
					Notes = "Adds a value to all player scores of the specified objective type.",
				},
				ForEachObjective =
				{
					Params =
					{
						{
							Name = "CallbackFunction",
							Type = "function",
						},
					},
					Returns =
					{
						{
							Type = "boolean",
						},
					},
					Notes = "Calls the specified callback for each objective in the scoreboard. Returns true if all objectives have been processed (including when there are zero objectives), or false if the callback function has aborted the enumeration by returning true. The callback function has the following signature: <pre class=\"prettyprint lang-lua\">function Callback({{cObjective|Objective}})</pre> The callback should return false or no value to continue with the next objective, or true to abort the enumeration.",
				},
				ForEachTeam =
				{
					Params =
					{
						{
							Name = "CallbackFunction",
							Type = "function",
						},
					},
					Returns =
					{
						{
							Type = "boolean",
						},
					},
					Notes = "Calls the specified callback for each team in the scoreboard. Returns true if all teams have been processed (including when there are zero teams), or false if the callback function has aborted the enumeration by returning true. The callback function has the following signature: <pre class=\"prettyprint lang-lua\">function Callback({{cObjective|Objective}})</pre> The callback should return false or no value to continue with the next team, or true to abort the enumeration.",
				},
				GetNumObjectives =
				{
					Returns =
					{
						{
							Type = "number",
						},
					},
					Notes = "Returns the nuber of registered objectives.",
				},
				GetNumTeams =
				{
					Returns =
					{
						{
							Type = "number",
						},
					},
					Notes = "Returns the number of registered teams.",
				},
				GetObjective =
				{
					Params =
					{
						{
							Name = "string",
							Type = "string",
						},
					},
					Returns =
					{
						{
							Type = "cObjective",
						},
					},
					Notes = "Returns the objective with the specified name.",
				},
				GetObjectiveIn =
				{
					Params =
					{
						{
							Name = "DisplaySlot",
							Type = "<unknown>",
						},
					},
					Returns =
					{
						{
							Type = "cObjective",
						},
					},
					Notes = "Returns the objective in the specified display slot. Can be nil.",
				},
				GetTeam =
				{
					Params =
					{
						{
							Name = "TeamName",
							Type = "string",
						},
					},
					Returns =
					{
						{
							Type = "cTeam",
						},
					},
					Notes = "Returns the team with the specified name.",
				},
				GetTeamNames =
				{
					Returns =
					{
						{
							Type = "table",
						},
					},
					Notes = "Returns the names of all teams, as an array-table of strings",
				},
				RegisterObjective =
				{
					Params =
					{
						{
							Name = "Name",
							Type = "string",
						},
						{
							Name = "DisplayName",
							Type = "string",
						},
						{
							Name = "Type",
							Type = "<unknown>",
						},
					},
					Returns =
					{
						{
							Type = "cObjective",
						},
					},
					Notes = "Registers a new scoreboard objective. Returns the {{cObjective}} instance, nil on error.",
				},
				RegisterTeam =
				{
					Params =
					{
						{
							Name = "Name",
							Type = "string",
						},
						{
							Name = "DisplayName",
							Type = "string",
						},
						{
							Name = "Prefix",
							Type = "<unknown>",
						},
						{
							Name = "Suffix",
							Type = "<unknown>",
						},
					},
					Returns =
					{
						{
							Type = "cTeam",
						},
					},
					Notes = "Registers a new team. Returns the {{cTeam}} instance, nil on error.",
				},
				RemoveObjective =
				{
					Params =
					{
						{
							Name = "Name",
							Type = "string",
						},
					},
					Returns =
					{
						{
							Type = "boolean",
						},
					},
					Notes = "Removes the objective with the specified name. Returns true if operation was successful.",
				},
				RemoveTeam =
				{
					Params =
					{
						{
							Name = "TeamName",
							Type = "string",
						},
					},
					Returns =
					{
						{
							Type = "boolean",
						},
					},
					Notes = "Removes the team with the specified name. Returns true if operation was successful.",
				},
				SetDisplay =
				{
					Params =
					{
						{
							Name = "Name",
							Type = "string",
						},
						{
							Name = "DisplaySlot",
							Type = "<unknown>",
						},
					},
					Notes = "Updates the currently displayed objective.",
				},
			},
			Constants =
			{
				dsCount =
				{
					Notes = "",
				},
				dsList =
				{
					Notes = "",
				},
				dsName =
				{
					Notes = "",
				},
				dsSidebar =
				{
					Notes = "",
				},
			},
		},
		cServer =
		{
			Desc = [[
				This class manages all the client connections internally. In the API layer, it allows to get and set
				the general properties of the server, such as the description and max players.</p>
				<p>
				It used to support broadcasting chat messages to all players, this functionality has been moved to
				{{cRoot}}:BroadcastChat().
				]],
			Functions =
			{
				DoesAllowMultiLogin =
				{
					Returns =
					{
						{
							Type = "boolean",
						},
					},
					Notes = "Returns true if players can log in multiple times from the same account (normally used for debugging), false if only one player per name is allowed.",
				},
				GetDescription =
				{
					Returns =
					{
						{
							Type = "string",
						},
					},
					Notes = "Returns the server description set in the settings.ini.",
				},
				GetMaxPlayers =
				{
					Returns =
					{
						{
							Type = "number",
						},
					},
					Notes = "Returns the max amount of players who can join the server.",
				},
				GetNumPlayers =
				{
					Returns =
					{
						{
							Type = "number",
						},
					},
					Notes = "Returns the amount of players online.",
				},
				GetServerID =
				{
					Returns =
					{
						{
							Type = "string",
						},
					},
					Notes = "Returns the ID of the server?",
				},
				IsHardcore =
				{
					Returns =
					{
						{
							Type = "boolean",
						},
					},
					Notes = "Returns true if the server is hardcore (players get banned on death).",
				},
				IsPlayerInQueue =
				{
					Params =
					{
						{
							Name = "Username",
							Type = "string",
						},
					},
					Returns =
					{
						{
							Type = "boolean",
						},
					},
					Notes = "Returns true if the specified player is queued to be transferred to a World.",
				},
				SetMaxPlayers =
				{
					Params =
					{
						{
							Name = "MaxPlayers",
							Type = "number",
						},
					},
					Notes = "Sets the max amount of players who can join.",
				},
				ShouldAuthenticate =
				{
					Returns =
					{
						{
							Type = "boolean",
						},
					},
					Notes = "Returns true iff the server is set to authenticate players (\"online mode\").",
				},
			},
		},
		cStringCompression =
		{
			Desc = [[
				Provides functions to compress or decompress string
				<p>
				All functions in this class are static, so they should be called in the dot convention:
<pre class="prettyprint lang-lua">
local CompressedString = cStringCompression.CompressStringGZIP("DataToCompress")
</pre>
			]],
			Functions =
			{
				CompressStringGZIP =
				{
					Params =
					{
						{
							Name = "Data",
							Type = "string",
						},
					},
					Returns =
					{
						{
							Type = "string",
						},
					},
					Notes = "Compresses data in a string using GZIP",
				},
				CompressStringZLIB =
				{
					Params =
					{
						{
							Name = "Data",
							Type = "string",
						},
						{
							Name = "factor",
							Type = "number",
						},
					},
					Returns =
					{
						{
							Type = "string",
						},
					},
					Notes = "Compresses data in a string using ZLIB. Factor 0 is no compression and factor 9 is maximum compression.",
				},
				InflateString =
				{
					Params =
					{
						{
							Name = "Data",
							Type = "string",
						},
					},
					Returns =
					{
						{
							Type = "string",
						},
					},
					Notes = "Uncompresses a string using Inflate",
				},
				UncompressStringGZIP =
				{
					Params =
					{
						{
							Name = "Data",
							Type = "string",
						},
					},
					Returns =
					{
						{
							Type = "string",
						},
					},
					Notes = "Uncompress a string using GZIP",
				},
				UncompressStringZLIB =
				{
					Params =
					{
						{
							Name = "Data",
							Type = "string",
						},
						{
							Name = "UncompressedLength",
							Type = "number",
						},
					},
					Returns =
					{
						{
							Type = "string",
						},
					},
					Notes = "Uncompresses Data using ZLIB",
				},
			},
		},
		cTeam =
		{
			Desc = [[
				This class manages a single player team.
			]],
			Functions =
			{
				AddPlayer =
				{
					Params =
					{
						{
							Name = "PlayerName",
							Type = "string",
						},
					},
					Returns =
					{
						{
							Type = "boolean",
						},
					},
					Notes = "Adds a player to this team. Returns true if the operation was successful.",
				},
				AllowsFriendlyFire =
				{
					Returns =
					{
						{
							Type = "boolean",
						},
					},
					Notes = "Returns whether team friendly fire is allowed.",
				},
				CanSeeFriendlyInvisible =
				{
					Returns =
					{
						{
							Type = "boolean",
						},
					},
					Notes = "Returns whether players can see invisible teammates.",
				},
				GetDisplayName =
				{
					Returns =
					{
						{
							Type = "string",
						},
					},
					Notes = "Returns the display name of the team.",
				},
				GetName =
				{
					Returns =
					{
						{
							Type = "string",
						},
					},
					Notes = "Returns the internal name of the team.",
				},
				GetNumPlayers =
				{
					Returns =
					{
						{
							Type = "number",
						},
					},
					Notes = "Returns the number of registered players.",
				},
				GetPrefix =
				{
					Returns =
					{
						{
							Type = "string",
						},
					},
					Notes = "Returns the prefix prepended to the names of the members of this team.",
				},
				GetSuffix =
				{
					Returns =
					{
						{
							Type = "string",
						},
					},
					Notes = "Returns the suffix appended to the names of the members of this team.",
				},
				HasPlayer =
				{
					Params =
					{
						{
							Name = "PlayerName",
							Type = "string",
						},
					},
					Returns =
					{
						{
							Type = "boolean",
						},
					},
					Notes = "Returns whether the specified player is a member of this team.",
				},
				RemovePlayer =
				{
					Params =
					{
						{
							Name = "PlayerName",
							Type = "string",
						},
					},
					Returns =
					{
						{
							Type = "boolean",
						},
					},
					Notes = "Removes the player with the specified name from this team. Returns true if the operation was successful.",
				},
				Reset =
				{
					Notes = "Removes all players from this team.",
				},
				SetCanSeeFriendlyInvisible =
				{
					Params =
					{
						{
							Name = "CanSeeFriendlyInvisible",
							Type = "boolean",
						},
					},
					Notes = "Set whether players can see invisible teammates.",
				},
				SetDisplayName =
				{
					Params =
					{
						{
							Name = "DisplayName",
							Type = "string",
						},
					},
					Notes = "Sets the display name of this team. (i.e. what will be shown to the players)",
				},
				SetFriendlyFire =
				{
					Params =
					{
						{
							Name = "AllowFriendlyFire",
							Type = "boolean",
						},
					},
					Notes = "Sets whether team friendly fire is allowed.",
				},
				SetPrefix =
				{
					Params =
					{
						{
							Name = "Prefix",
							Type = "string",
						},
					},
					Notes = "Sets the prefix prepended to the names of the members of this team.",
				},
				SetSuffix =
				{
					Params =
					{
						{
							Name = "Suffix",
							Type = "string",
						},
					},
					Notes = "Sets the suffix appended to the names of the members of this team.",
				},
			},
		},
		cTNTEntity =
		{
			Desc = "This class manages a TNT entity.",
			Functions =
			{
				Explode =
				{
					Notes = "Explode the tnt.",
				},
				GetFuseTicks =
				{
					Returns =
					{
						{
							Type = "number",
						},
					},
					Notes = "Returns the fuse ticks - the number of game ticks until the tnt explodes.",
				},
				SetFuseTicks =
				{
					Params =
					{
						{
							Name = "TicksUntilExplosion",
							Type = "number",
						},
					},
					Notes = "Set the fuse ticks until the tnt will explode.",
				},
			},
			Inherits = "cEntity",
		},
		cUrlParser =
		{
			Desc = [[
			Provides a parser for generic URLs that returns the individual components of the URL.</p>
			<p>
			Note that all functions are static. Call them by using "cUrlParser:Parse(...)" etc.
			]],
			Functions =
			{
				GetDefaultPort =
				{
					IsStatic = true,
					Params =
					{
						{
							Name = "Scheme",
							Type = "string",
						},
					},
					Returns =
					{
						{
							Type = "number",
						},
					},
					Notes = "Returns the default port that should be used for the given scheme (protocol). Returns zero if the scheme is not known.",
				},
				IsKnownScheme =
				{
					IsStatic = true,
					Params =
					{
						{
							Name = "Scheme",
							Type = "string",
						},
					},
					Returns =
					{
						{
							Type = "boolean",
						},
					},
					Notes = "Returns true if the scheme (protocol) is recognized by the parser.",
				},
				Parse =
				{
					IsStatic = true,
					Params =
					{
						{
							Name = "URL",
							Type = "string",
						},
					},
					Returns =
					{
						{
							Name = "Scheme",
							Type = "string",
						},
						{
							Name = "Username",
							Type = "string",
						},
						{
							Name = "Password",
							Type = "string",
						},
						{
							Name = "Host",
							Type = "string",
						},
						{
							Name = "Port",
							Type = "string",
						},
						{
							Name = "Path",
							Type = "string",
						},
						{
							Name = "Query",
							Type = "string",
						},
						{
							Name = "Fragment",
							Type = "string",
						},
					},
					Notes = "Returns the individual parts of the URL. Parts that are not explicitly specified in the URL are empty, the default port for the scheme is used. If parsing fails, the function returns nil and an error message.",
				},
				ParseAuthorityPart =
				{
					IsStatic = true,
					Params =
					{
						{
							Name = "AuthPart",
							Type = "string",
						},
					},
					Returns =
					{
						{
							Name = "Username",
							Type = "string",
						},
						{
							Name = "Password",
							Type = "string",
						},
						{
							Name = "Host",
							Type = "string",
						},
						{
							Name = "Port",
							Type = "string",
						},
					},
					Notes = "Parses the Authority part of the URL. Parts that are not explicitly specified in the AuthPart are returned empty, the port is returned zero. If parsing fails, the function returns nil and an error message.",
				},
			},
			AdditionalInfo =
			{
				{
					Header = "Code example",
					Contents = [[
						The following code fragment uses the cUrlParser to parse an URL string into its components, and
						prints those components out:
<pre class="prettyprint lang-lua">
local Scheme, Username, Password, Host, Port, Path, Query, Fragment = cUrlParser:Parse(
	"http://anonymous:user@example.com@ftp.cuberite.org:9921/releases/2015/?sort=date#files"
)
if not(Scheme) then
	-- Parsing failed, the second returned value (in Username) is the error message:
	LOG("  Error: " .. (Username or "<nil>"))
else
	LOG("  Scheme   = " .. Scheme)    -- "http"
	LOG("  Username = " .. Username)  -- "anonymous"
	LOG("  Password = " .. Password)  -- "user@example.com"
	LOG("  Host     = " .. Host)      -- "ftp.cuberite.org"
	LOG("  Port     = " .. Port)      -- 9921
	LOG("  Path     = " .. Path)      -- "releases/2015/"
	LOG("  Query    = " .. Query)     -- "sort=date"
	LOG("  Fragment = " .. Fragment)  -- "files"
end
</pre>
					]],
				},
			},
		},
		cWebPlugin =
		{
			Desc = "",
			Functions =
			{

			},
		},
		cWindow =
		{
			Desc = [[
				This class is the common ancestor for all window classes used by Cuberite. It is inherited by the
				{{cLuaWindow|cLuaWindow}} class that plugins use for opening custom windows. It is planned to be
				used for window-related hooks in the future. It implements the basic functionality of any
				window.</p>
				<p>
				Note that one cWindow object can be used for multiple players at the same time, and therefore the
				slot contents are player-specific (e. g. crafting grid, or player inventory). Thus the GetSlot() and
				SetSlot() functions need to have the {{cPlayer|cPlayer}} parameter that specifies the player for
				whom the contents are to be queried.</p>
				<p>
				Windows also have numeric properties, these are used to set the progressbars for furnaces or the XP
				costs for enchantment tables.
			]],
			Functions =
			{
				GetSlot =
				{
					Params =
					{
						{
							Name = "Player",
							Type = "cPlayer",
						},
						{
							Name = "SlotNumber",
							Type = "number",
						},
					},
					Returns =
					{
						{
							Type = "cItem",
						},
					},
					Notes = "Returns the item at the specified slot for the specified player. Returns nil and logs to server console on error.",
				},
				GetWindowID =
				{
					Returns =
					{
						{
							Type = "number",
						},
					},
					Notes = "Returns the ID of the window, as used by the network protocol",
				},
				GetWindowTitle =
				{
					Returns =
					{
						{
							Type = "string",
						},
					},
					Notes = "Returns the window title that will be displayed to the player",
				},
				GetWindowType =
				{
					Returns =
					{
						{
							Type = "number",
						},
					},
					Notes = "Returns the type of the window, one of the constants in the table above",
				},
				GetWindowTypeName =
				{
					Returns =
					{
						{
							Type = "string",
						},
					},
					Notes = "Returns the textual representation of the window's type, such as \"minecraft:chest\".",
				},
				IsSlotInPlayerHotbar =
				{
					Params =
					{
						{
							Name = "SlotNum",
							Type = "number",
						},
					},
					Returns =
					{
						{
							Type = "boolean",
						},
					},
					Notes = "Returns true if the specified slot number is in the player hotbar",
				},
				IsSlotInPlayerInventory =
				{
					Params =
					{
						{
							Name = "SlotNum",
							Type = "number",
						},
					},
					Returns =
					{
						{
							Type = "boolean",
						},
					},
					Notes = "Returns true if the specified slot number is in the player's main inventory or in the hotbar. Note that this returns false for armor slots!",
				},
				IsSlotInPlayerMainInventory =
				{
					Params =
					{
						{
							Name = "SlotNum",
							Type = "number",
						},
					},
					Returns =
					{
						{
							Type = "boolean",
						},
					},
					Notes = "Returns true if the specified slot number is in the player's main inventory",
				},
				SetProperty =
				{
					Params =
					{
						{
							Name = "PropertyID",
							Type = "number",
						},
						{
							Name = "PropertyValue",
							Type = "number",
						},
						{
							Name = "Player",
							Type = "cPlayer",
							IsOptional = true,
						},
					},
					Notes = "Updates a numerical property associated with the window. Typically used for furnace progressbars. Sends the UpdateWindowProperty packet to the specified Player, or to all current clients of the window if Player is not specified.",
				},
				SetSlot =
				{
					Params =
					{
						{
							Name = "Player",
							Type = "cPlayer",
						},
						{
							Name = "SlotNum",
							Type = "number",
						},
						{
							Name = "cItem",
							Type = "cItem",
						},
					},
					Notes = "Sets the contents of the specified slot for the specified player. Ignored if the slot number is invalid",
				},
				SetWindowTitle =
				{
					Params =
					{
						{
							Name = "WindowTitle",
							Type = "string",
						},
					},
					Notes = "Sets the window title that will be displayed to the player",
				},
			},
			Constants =
			{
				wtAnimalChest =
				{
					Notes = "A horse or donkey window",
				},
				wtAnvil =
				{
					Notes = "An anvil window",
				},
				wtBeacon =
				{
					Notes = "A beacon window",
				},
				wtBrewery =
				{
					Notes = "A brewing stand window",
				},
				wtChest =
				{
					Notes = "A {{cChestEntity|chest}} or doublechest window",
				},
				wtDropSpenser =
				{
					Notes = "A {{cDropperEntity|dropper}} or a {{cDispenserEntity|dispenser}} window",
				},
				wtEnchantment =
				{
					Notes = "An enchantment table window",
				},
				wtFurnace =
				{
					Notes = "A {{cFurnaceEntity|furnace}} window",
				},
				wtHopper =
				{
					Notes = "A {{cHopperEntity|hopper}} window",
				},
				wtInventory =
				{
					Notes = "An inventory window",
				},
				wtNPCTrade =
				{
					Notes = "A villager trade window",
				},
				wtWorkbench =
				{
					Notes = "A workbench (crafting table) window",
				},
			},
		},
		cWorld =
		{
			Desc = [[
				cWorld is the game world. It is the hub of all the information managed by individual classes,
				providing convenient access to them. Cuberite supports multiple worlds in any combination of
				world types. You can have two overworlds, three nethers etc. To enumerate all world the server
				provides, use the {{cRoot}}:ForEachWorld() function.</p>
				<p>
				The world data is held in individual chunks. Each chunk consists of 16 (x) * 16 (z) * 256 (y)
				blocks, each block is specified by its block type (8-bit) and block metadata (4-bit).
				Additionally, each block has two light values calculated - skylight (how much daylight it receives)
				and blocklight (how much light from light-emissive blocks it receives), both 4-bit.</p>
				<p>
				Each world runs several separate threads used for various housekeeping purposes, the most important
				of those is the Tick thread. This thread updates the game logic 20 times per second, and it is
				the thread where all the gameplay actions are evaluated. Liquid physics, entity interactions,
				player ovement etc., all are applied in this thread.</p>
				<p>
				Additional threads include the generation thread (generates new chunks as needed, storage thread
				(saves and loads chunk from the disk), lighting thread (updates block light values) and the
				chunksender thread (compresses chunks to send to the clients).</p>
				<p>
				The world provides access to all its {{cPlayer|players}}, {{cEntity|entities}} and {{cBlockEntity|block
				entities}}. Because of multithreading issues, individual objects cannot be retrieved for indefinite
				handling, but rather must be modified in callbacks, within which they are guaranteed to stay valid.</p>
				<p>
				Physics for individual blocks are handled by the simulators. These will fire in each tick for all
				blocks that have been scheduled for simulator update ("simulator wakeup"). The simulators include
				liquid physics, falling blocks, fire spreading and extinguishing and redstone.</p>
				<p>
				Game time is also handled by the world. It provides the time-of-day and the total world age.
			]],
			Functions =
			{
				AreCommandBlocksEnabled =
				{
					Returns =
					{
						{
							Type = "boolean",
						},
					},
					Notes = "Returns whether command blocks are enabled on the (entire) server",
				},
				BroadcastBlockAction =
				{
					Params =
					{
						{
							Name = "BlockX",
							Type = "number",
						},
						{
							Name = "BlockY",
							Type = "number",
						},
						{
							Name = "BlockZ",
							Type = "number",
						},
						{
							Name = "ActionByte1",
							Type = "number",
						},
						{
							Name = "ActionByte2",
							Type = "number",
						},
						{
							Name = "BlockType",
							Type = "number",
						},
						{
							Name = "ExcludeClient",
							Type = "cClientHandle",
							IsOptional = true,
						},
					},
					Notes = "Broadcasts the BlockAction packet to all clients who have the appropriate chunk loaded (except ExcludeClient). The contents of the packet are specified by the parameters for the call, the blocktype needn't match the actual block that is present in the world data at the specified location.",
				},
				BroadcastChat =
				{
					Params =
					{
						{
							Name = "Message",
							Type = "string",
						},
						{
							Name = "ExcludeClient",
							Type = "cClientHandle",
							IsOptional = true,
						},
						{
							Name = "ChatPrefix",
							Type = "eMessageType",
							IsOptional = true,
						},
					},
					Notes = "Sends the Message to all players in this world, except the optional ExcludeClient. No formatting is done by the server.",
				},
				BroadcastChatDeath =
				{
					Params =
					{
						{
							Name = "Message",
							Type = "string",
						},
						{
							Name = "ExcludeClient",
							Type = "cClientHandle",
							IsOptional = true,
						},
					},
					Notes = "Prepends Gray [DEATH] / colours entire text (depending on ShouldUseChatPrefixes()) and broadcasts message. For when a player dies.",
				},
				BroadcastChatFailure =
				{
					Params =
					{
						{
							Name = "Message",
							Type = "string",
						},
						{
							Name = "ExcludeClient",
							Type = "cClientHandle",
							IsOptional = true,
						},
					},
					Notes = "Prepends Rose [INFO] / colours entire text (depending on ShouldUseChatPrefixes()) and broadcasts message. For a command that failed to run because of insufficient permissions, etc.",
				},
				BroadcastChatFatal =
				{
					Params =
					{
						{
							Name = "Message",
							Type = "string",
						},
						{
							Name = "ExcludeClient",
							Type = "cClientHandle",
							IsOptional = true,
						},
					},
					Notes = "Prepends Red [FATAL] / colours entire text (depending on ShouldUseChatPrefixes()) and broadcasts message. For a plugin that crashed, or similar.",
				},
				BroadcastChatInfo =
				{
					Params =
					{
						{
							Name = "Message",
							Type = "string",
						},
						{
							Name = "ExcludeClient",
							Type = "cClientHandle",
							IsOptional = true,
						},
					},
					Notes = "Prepends Yellow [INFO] / colours entire text (depending on ShouldUseChatPrefixes()) and broadcasts message. For informational messages, such as command usage.",
				},
				BroadcastChatSuccess =
				{
					Params =
					{
						{
							Name = "Message",
							Type = "string",
						},
						{
							Name = "ExcludeClient",
							Type = "cClientHandle",
							IsOptional = true,
						},
					},
					Notes = "Prepends Green [INFO] / colours entire text (depending on ShouldUseChatPrefixes()) and broadcasts message. For success messages.",
				},
				BroadcastChatWarning =
				{
					Params =
					{
						{
							Name = "Message",
							Type = "string",
						},
						{
							Name = "ExcludeClient",
							Type = "cClientHandle",
							IsOptional = true,
						},
					},
					Notes = "Prepends Rose [WARN] / colours entire text (depending on ShouldUseChatPrefixes()) and broadcasts message. For concerning events, such as plugin reload etc.",
				},
				BroadcastEntityAnimation =
				{
					Params =
					{
						{
							Name = "TargetEntity",
							Type = "cEntity",
						},
						{
							Name = "Animation",
							Type = "number",
						},
						{
							Name = "ExcludeClient",
							Type = "cClientHandle",
							IsOptional = true,
						},
					},
					Notes = "Sends an animation of an entity to all clienthandles (except ExcludeClient if given)",
				},
				BroadcastParticleEffect =
				{
					Params =
					{
						{
							Name = "ParticleName",
							Type = "string",
						},
						{
							Name = "X",
							Type = "number",
						},
						{
							Name = "Y",
							Type = "number",
						},
						{
							Name = "Z",
							Type = "number",
						},
						{
							Name = "OffsetX",
							Type = "number",
						},
						{
							Name = "OffsetY",
							Type = "number",
						},
						{
							Name = "OffsetZ",
							Type = "number",
						},
						{
							Name = "ParticleData",
							Type = "number",
						},
						{
							Name = "ParticleAmount",
							Type = "number",
						},
						{
							Name = "ExcludeClient",
							Type = "cClientHandle",
							IsOptional = true,
						},
					},
					Notes = "Spawns the specified particles to all players in the world exept the optional ExeptClient. A list of available particles by thinkofdeath can be found {{https://gist.github.com/thinkofdeath/5110835|Here}}",
				},
				BroadcastSoundEffect =
				{
					Params =
					{
						{
							Name = "SoundName",
							Type = "string",
						},
						{
							Name = "X",
							Type = "number",
						},
						{
							Name = "Y",
							Type = "number",
						},
						{
							Name = "Z",
							Type = "number",
						},
						{
							Name = "Volume",
							Type = "number",
						},
						{
							Name = "Pitch",
							Type = "number",
						},
						{
							Name = "ExcludeClient",
							Type = "cClientHandle",
							IsOptional = true,
						},
					},
					Notes = "Sends the specified sound effect to all players in this world, except the optional ExceptClient",
				},
				BroadcastSoundParticleEffect =
				{
					Params =
					{
						{
							Name = "EffectID",
							Type = "number",
						},
						{
							Name = "X",
							Type = "number",
						},
						{
							Name = "Y",
							Type = "number",
						},
						{
							Name = "Z",
							Type = "number",
						},
						{
							Name = "EffectData",
							Type = "string",
						},
						{
							Name = "ExcludeClient",
							Type = "cClientHandle",
							IsOptional = true,
						},
					},
					Notes = "Sends the specified effect to all players in this world, except the optional ExceptClient",
				},
				CastThunderbolt =
				{
					Params =
					{
						{
							Name = "X",
							Type = "number",
						},
						{
							Name = "Y",
							Type = "number",
						},
						{
							Name = "Z",
							Type = "number",
						},
					},
					Notes = "Creates a thunderbolt at the specified coords",
				},
				ChangeWeather =
				{
					Notes = "Forces the weather to change in the next game tick. Weather is changed according to the normal rules: wSunny <-> wRain <-> wStorm",
				},
				ChunkStay =
				{
					Params =
					{
						{
							Name = "ChunkCoordTable",
							Type = "table",
						},
						{
							Name = "OnChunkAvailable",
							Type = "function",
						},
						{
							Name = "OnAllChunksAvailable",
							Type = "function",
						},
					},
					Notes = "Queues the specified chunks to be loaded or generated and calls the specified callbacks once they are loaded. ChunkCoordTable is an arra-table of chunk coords, each coord being a table of 2 numbers: { {Chunk1x, Chunk1z}, {Chunk2x, Chunk2z}, ...}. When any of those chunks are made available (including being available at the start of this call), the OnChunkAvailable() callback is called. When all the chunks are available, the OnAllChunksAvailable() callback is called. The function signatures are: <pre class=\"prettyprint lang-lua\">function OnChunkAvailable(ChunkX, ChunkZ)\
function OnAllChunksAvailable()</pre> All return values from the callbacks are ignored.",
				},
				CreateProjectile =
				{
					Params =
					{
						{
							Name = "X",
							Type = "number",
						},
						{
							Name = "Y",
							Type = "number",
						},
						{
							Name = "Z",
							Type = "number",
						},
						{
							Name = "ProjectileKind",
							Type = "cProjectileEntity#eKind",
						},
						{
							Name = "Creator",
							Type = "cEntity",
						},
						{
							Name = "Originating Item",
							Type = "cItem",
						},
						{
							Name = "Speed",
							Type = "Vector3d",
							IsOptional = true,
						},
					},
					Notes = "Creates a new projectile of the specified kind at the specified coords. The projectile's creator is set to Creator (may be nil). The item that created the projectile entity, commonly the {{cPlayer|player}}'s currently equipped item, is used at present for fireworks to correctly set their entity metadata. It is not used for any other projectile. Optional speed indicates the initial speed for the projectile.",
				},
				DigBlock =
				{
					Params =
					{
						{
							Name = "X",
							Type = "number",
						},
						{
							Name = "Y",
							Type = "number",
						},
						{
							Name = "Z",
							Type = "number",
						},
					},
					Notes = "Replaces the specified block with air, without dropping the usual pickups for the block. Wakes up the simulators for the block and its neighbors.",
				},
				DoExplosionAt =
				{
					Params =
					{
						{
							Name = "Force",
							Type = "number",
						},
						{
							Name = "X",
							Type = "number",
						},
						{
							Name = "Y",
							Type = "number",
						},
						{
							Name = "Z",
							Type = "number",
						},
						{
							Name = "CanCauseFire",
							Type = "boolean",
						},
						{
							Name = "Source",
							Type = "eExplosionSource",
						},
						{
							Name = "SourceData",
							Type = "any",
						},
					},
					Notes = "Creates an explosion of the specified relative force in the specified position. If CanCauseFire is set, the explosion will set blocks on fire, too. The Source parameter specifies the source of the explosion, one of the esXXX constants. The SourceData parameter is specific to each source type, usually it provides more info about the source.",
				},
				DoWithBeaconAt =
				{
					Params =
					{
						{
							Name = "BlockX",
							Type = "number",
						},
						{
							Name = "BlockY",
							Type = "number",
						},
						{
							Name = "BlockZ",
							Type = "number",
						},
						{
							Name = "CallbackFunction",
							Type = "function",
						},
					},
					Returns =
					{
						{
							Type = "boolean",
						},
					},
					Notes = "If there is a beacon at the specified coords, calls the CallbackFunction with the {{cBeaconEntity}} parameter representing the beacon. The CallbackFunction has the following signature: <pre class=\"prettyprint lang-lua\">function Callback({{cBeaconEntity|BeaconEntity}})</pre> The function returns false if there is no beacon, or if there is, it returns the bool value that the callback has returned.",
				},
				DoWithBlockEntityAt =
				{
					Params =
					{
						{
							Name = "BlockX",
							Type = "number",
						},
						{
							Name = "BlockY",
							Type = "number",
						},
						{
							Name = "BlockZ",
							Type = "number",
						},
						{
							Name = "CallbackFunction",
							Type = "function",
						},
					},
					Returns =
					{
						{
							Type = "boolean",
						},
					},
					Notes = "If there is a block entity at the specified coords, calls the CallbackFunction with the {{cBlockEntity}} parameter representing the block entity. The CallbackFunction has the following signature: <pre class=\"prettyprint lang-lua\">function Callback({{cBlockEntity|BlockEntity}})</pre> The function returns false if there is no block entity, or if there is, it returns the bool value that the callback has returned. Use {{tolua}}.cast() to cast the Callback's BlockEntity parameter to the correct {{cBlockEntity}} descendant.",
				},
				DoWithBrewingstandAt =
				{
					Params =
					{
						{
							Name = "BlockX",
							Type = "number",
						},
						{
							Name = "BlockY",
							Type = "number",
						},
						{
							Name = "BlockZ",
							Type = "number",
						},
						{
							Name = "CallbackFunction",
							Type = "function",
						},
					},
					Returns =
					{
						{
							Type = "boolean",
						},
					},
					Notes = "If there is a brewingstand at the specified coords, calls the CallbackFunction with the {{cBrewingstandEntity}} parameter representing the brewingstand. The CallbackFunction has the following signature: <pre class=\"prettyprint lang-lua\">function Callback({{cBrewingstandEntity|cBrewingstandEntity}})</pre> The function returns false if there is no brewingstand, or if there is, it returns the bool value that the callback has returned.",
				},
				DoWithChestAt =
				{
					Params =
					{
						{
							Name = "BlockX",
							Type = "number",
						},
						{
							Name = "BlockY",
							Type = "number",
						},
						{
							Name = "BlockZ",
							Type = "number",
						},
						{
							Name = "CallbackFunction",
							Type = "function",
						},
					},
					Returns =
					{
						{
							Type = "boolean",
						},
					},
					Notes = "If there is a chest at the specified coords, calls the CallbackFunction with the {{cChestEntity}} parameter representing the chest. The CallbackFunction has the following signature: <pre class=\"prettyprint lang-lua\">function Callback({{cChestEntity|ChestEntity}})</pre> The function returns false if there is no chest, or if there is, it returns the bool value that the callback has returned.",
				},
				DoWithCommandBlockAt =
				{
					Params =
					{
						{
							Name = "BlockX",
							Type = "number",
						},
						{
							Name = "BlockY",
							Type = "number",
						},
						{
							Name = "BlockZ",
							Type = "number",
						},
						{
							Name = "CallbackFunction",
							Type = "function",
						},
					},
					Returns =
					{
						{
							Type = "boolean",
						},
					},
					Notes = "If there is a command block at the specified coords, calls the CallbackFunction with the {{cCommandBlockEntity}} parameter representing the command block. The CallbackFunction has the following signature: <pre class=\"prettyprint lang-lua\">function Callback({{cCommandBlockEntity|CommandBlockEntity}})</pre> The function returns false if there is no command block, or if there is, it returns the bool value that the callback has returned.",
				},
				DoWithDispenserAt =
				{
					Params =
					{
						{
							Name = "BlockX",
							Type = "number",
						},
						{
							Name = "BlockY",
							Type = "number",
						},
						{
							Name = "BlockZ",
							Type = "number",
						},
						{
							Name = "CallbackFunction",
							Type = "function",
						},
					},
					Returns =
					{
						{
							Type = "boolean",
						},
					},
					Notes = "If there is a dispenser at the specified coords, calls the CallbackFunction with the {{cDispenserEntity}} parameter representing the dispenser. The CallbackFunction has the following signature: <pre class=\"prettyprint lang-lua\">function Callback({{cDispenserEntity|DispenserEntity}})</pre> The function returns false if there is no dispenser, or if there is, it returns the bool value that the callback has returned.",
				},
				DoWithDropperAt =
				{
					Params =
					{
						{
							Name = "BlockX",
							Type = "number",
						},
						{
							Name = "BlockY",
							Type = "number",
						},
						{
							Name = "BlockZ",
							Type = "number",
						},
						{
							Name = "CallbackFunction",
							Type = "function",
						},
					},
					Returns =
					{
						{
							Type = "boolean",
						},
					},
					Notes = "If there is a dropper at the specified coords, calls the CallbackFunction with the {{cDropperEntity}} parameter representing the dropper. The CallbackFunction has the following signature: <pre class=\"prettyprint lang-lua\">function Callback({{cDropperEntity|DropperEntity}})</pre> The function returns false if there is no dropper, or if there is, it returns the bool value that the callback has returned.",
				},
				DoWithDropSpenserAt =
				{
					Params =
					{
						{
							Name = "BlockX",
							Type = "number",
						},
						{
							Name = "BlockY",
							Type = "number",
						},
						{
							Name = "BlockZ",
							Type = "number",
						},
						{
							Name = "CallbackFunction",
							Type = "function",
						},
					},
					Returns =
					{
						{
							Type = "boolean",
						},
					},
					Notes = "If there is a dropper or a dispenser at the specified coords, calls the CallbackFunction with the {{cDropSpenserEntity}} parameter representing the dropper or dispenser. The CallbackFunction has the following signature: <pre class=\"prettyprint lang-lua\">function Callback({{cDropSpenserEntity|DropSpenserEntity}})</pre> Note that this can be used to access both dispensers and droppers in a similar way. The function returns false if there is neither dispenser nor dropper, or if there is, it returns the bool value that the callback has returned.",
				},
				DoWithEntityByID =
				{
					Params =
					{
						{
							Name = "EntityID",
							Type = "number",
						},
						{
							Name = "CallbackFunction",
							Type = "function",
						},
					},
					Returns =
					{
						{
							Type = "boolean",
						},
					},
					Notes = "If an entity with the specified ID exists, calls the callback with the {{cEntity}} parameter representing the entity. The CallbackFunction has the following signature: <pre class=\"prettyprint lang-lua\">function Callback({{cEntity|Entity}})</pre> The function returns false if the entity was not found, and it returns the same bool value that the callback has returned if the entity was found.",
				},
				DoWithFlowerPotAt =
				{
					Params =
					{
						{
							Name = "BlockX",
							Type = "number",
						},
						{
							Name = "BlockY",
							Type = "number",
						},
						{
							Name = "BlockZ",
							Type = "number",
						},
						{
							Name = "CallbackFunction",
							Type = "function",
						},
					},
					Returns =
					{
						{
							Type = "boolean",
						},
					},
					Notes = "If there is a flower pot at the specified coords, calls the CallbackFunction with the {{cFlowerPotEntity}} parameter representing the flower pot. The CallbackFunction has the following signature: <pre class=\"prettyprint lang-lua\">function Callback({{cFlowerPotEntity|FlowerPotEntity}})</pre> The function returns false if there is no flower pot, or if there is, it returns the bool value that the callback has returned.",
				},
				DoWithFurnaceAt =
				{
					Params =
					{
						{
							Name = "BlockX",
							Type = "number",
						},
						{
							Name = "BlockY",
							Type = "number",
						},
						{
							Name = "BlockZ",
							Type = "number",
						},
						{
							Name = "CallbackFunction",
							Type = "function",
						},
					},
					Returns =
					{
						{
							Type = "boolean",
						},
					},
					Notes = "If there is a furnace at the specified coords, calls the CallbackFunction with the {{cFurnaceEntity}} parameter representing the furnace. The CallbackFunction has the following signature: <pre class=\"prettyprint lang-lua\">function Callback({{cFurnaceEntity|FurnaceEntity}})</pre> The function returns false if there is no furnace, or if there is, it returns the bool value that the callback has returned.",
				},
				DoWithMobHeadAt =
				{
					Params =
					{
						{
							Name = "BlockX",
							Type = "number",
						},
						{
							Name = "BlockY",
							Type = "number",
						},
						{
							Name = "BlockZ",
							Type = "number",
						},
						{
							Name = "CallbackFunction",
							Type = "function",
						},
					},
					Returns =
					{
						{
							Type = "boolean",
						},
					},
					Notes = "If there is a mob head at the specified coords, calls the CallbackFunction with the {{cMobHeadEntity}} parameter representing the furnace. The CallbackFunction has the following signature: <pre class=\"prettyprint lang-lua\">function Callback({{cMobHeadEntity|MobHeadEntity}})</pre> The function returns false if there is no mob head, or if there is, it returns the bool value that the callback has returned.",
				},
				DoWithNoteBlockAt =
				{
					Params =
					{
						{
							Name = "BlockX",
							Type = "number",
						},
						{
							Name = "BlockY",
							Type = "number",
						},
						{
							Name = "BlockZ",
							Type = "number",
						},
						{
							Name = "CallbackFunction",
							Type = "function",
						},
					},
					Returns =
					{
						{
							Type = "boolean",
						},
					},
					Notes = "If there is a note block at the specified coords, calls the CallbackFunction with the {{cNoteEntity}} parameter representing the note block. The CallbackFunction has the following signature: <pre class=\"prettyprint lang-lua\">function Callback({{cNoteEntity|NoteEntity}})</pre> The function returns false if there is no note block, or if there is, it returns the bool value that the callback has returned.",
				},
				DoWithPlayer =
				{
					Params =
					{
						{
							Name = "PlayerName",
							Type = "string",
						},
						{
							Name = "CallbackFunction",
							Type = "function",
						},
					},
					Returns =
					{
						{
							Type = "boolean",
						},
					},
					Notes = "If there is a player of the specified name (exact match), calls the CallbackFunction with the {{cPlayer}} parameter representing the player. The CallbackFunction has the following signature: <pre class=\"prettyprint lang-lua\">function Callback({{cPlayer|Player}})</pre> The function returns false if the player was not found, or whatever bool value the callback returned if the player was found.",
				},
				DoWithPlayerByUUID =
				{
					Params =
					{
						{
							Name = "PlayerUUID",
							Type = "string",
						},
						{
							Name = "CallbackFunction",
							Type = "function",
						},
					},
					Returns =
					{
						{
							Type = "boolean",
						},
					},
					Notes = "If there is the player with the uuid, calls the CallbackFunction with the {{cPlayer}} parameter representing the player. The CallbackFunction has the following signature: <pre class=\"prettyprint lang-lua\">function Callback({{cPlayer|Player}})</pre> The function returns false if the player was not found, or whatever bool value the callback returned if the player was found.",
				},
				FastSetBlock =
				{
					{
						Params =
						{
							{
								Name = "BlockX",
								Type = "number",
							},
							{
								Name = "BlockY",
								Type = "number",
							},
							{
								Name = "BlockZ",
								Type = "number",
							},
							{
								Name = "BlockType",
								Type = "number",
							},
							{
								Name = "BlockMeta",
								Type = "number",
							},
						},
						Notes = "Sets the block at the specified coords, without waking up the simulators or replacing the block entities for the previous block type. Do not use if the block being replaced has a block entity tied to it!",
					},
					{
						Params =
						{
							{
								Name = "BlockCoords",
								Type = "Vector3i",
							},
							{
								Name = "BlockType",
								Type = "number",
							},
							{
								Name = "BlockMeta",
								Type = "number",
							},
						},
						Notes = "Sets the block at the specified coords, without waking up the simulators or replacing the block entities for the previous block type. Do not use if the block being replaced has a block entity tied to it!",
					},
				},
				FindAndDoWithPlayer =
				{
					Params =
					{
						{
							Name = "PlayerName",
							Type = "string",
						},
						{
							Name = "CallbackFunction",
							Type = "function",
						},
					},
					Returns =
					{
						{
							Type = "boolean",
						},
					},
					Notes = "Calls the given callback function for the player with the name best matching the name string provided.<br>This function is case-insensitive and will match partial names.<br>Returns false if player not found or there is ambiguity, true otherwise. The CallbackFunction has the following signature: <pre class=\"prettyprint lang-lua\">function Callback({{cPlayer|Player}})</pre>",
				},
				ForEachBlockEntityInChunk =
				{
					Params =
					{
						{
							Name = "ChunkX",
							Type = "number",
						},
						{
							Name = "ChunkZ",
							Type = "number",
						},
						{
							Name = "CallbackFunction",
							Type = "function",
						},
					},
					Returns =
					{
						{
							Type = "boolean",
						},
					},
					Notes = "Calls the specified callback for each block entity in the chunk. Returns true if all block entities in the chunk have been processed (including when there are zero block entities), or false if the callback has aborted the enumeration by returning true. The CallbackFunction has the following signature: <pre class=\"prettyprint lang-lua\">function Callback({{cBlockEntity|BlockEntity}})</pre> The callback should return false or no value to continue with the next block entity, or true to abort the enumeration. Use {{tolua}}.cast() to cast the Callback's BlockEntity parameter to the correct {{cBlockEntity}} descendant.",
				},
				ForEachBrewingstandInChunk =
				{
					Params =
					{
						{
							Name = "ChunkX",
							Type = "number",
						},
						{
							Name = "ChunkZ",
							Type = "number",
						},
						{
							Name = "CallbackFunction",
							Type = "function",
						},
					},
					Returns =
					{
						{
							Type = "boolean",
						},
					},
					Notes = "Calls the specified callback for each brewingstand in the chunk. Returns true if all brewingstands in the chunk have been processed (including when there are zero brewingstands), or false if the callback has aborted the enumeration by returning true. The CallbackFunction has the following signature: <pre class=\"prettyprint lang-lua\">function Callback({{cBrewingstandEntity|cBrewingstandEntity}})</pre> The callback should return false or no value to continue with the next brewingstand, or true to abort the enumeration.",
				},
				ForEachChestInChunk =
				{
					Params =
					{
						{
							Name = "ChunkX",
							Type = "number",
						},
						{
							Name = "ChunkZ",
							Type = "number",
						},
						{
							Name = "CallbackFunction",
							Type = "function",
						},
					},
					Returns =
					{
						{
							Type = "boolean",
						},
					},
					Notes = "Calls the specified callback for each chest in the chunk. Returns true if all chests in the chunk have been processed (including when there are zero chests), or false if the callback has aborted the enumeration by returning true. The CallbackFunction has the following signature: <pre class=\"prettyprint lang-lua\">function Callback({{cChestEntity|ChestEntity}})</pre> The callback should return false or no value to continue with the next chest, or true to abort the enumeration.",
				},
				ForEachEntity =
				{
					Params =
					{
						{
							Name = "CallbackFunction",
							Type = "function",
						},
					},
					Returns =
					{
						{
							Type = "boolean",
						},
					},
					Notes = "Calls the specified callback for each entity in the loaded world. Returns true if all the entities have been processed (including when there are zero entities), or false if the callback function has aborted the enumeration by returning true. The callback function has the following signature: <pre class=\"prettyprint lang-lua\">function Callback({{cEntity|Entity}})</pre> The callback should return false or no value to continue with the next entity, or true to abort the enumeration.",
				},
				ForEachEntityInBox =
				{
					Params =
					{
						{
							Name = "Box",
							Type = "cBoundingBox",
						},
						{
							Name = "CallbackFunction",
							Type = "function",
						},
					},
					Returns =
					{
						{
							Type = "boolean",
						},
					},
					Notes = "Calls the specified callback for each entity in the specified bounding box. Returns true if all the entities have been processed (including when there are zero entities), or false if the callback function has aborted the enumeration by returning true. If any chunk within the bounding box is not valid, it is silently skipped without any notification. The callback function has the following signature: <pre class=\"prettyprint lang-lua\">function Callback({{cEntity|Entity}})</pre> The callback should return false or no value to continue with the next entity, or true to abort the enumeration.",
				},
				ForEachEntityInChunk =
				{
					Params =
					{
						{
							Name = "ChunkX",
							Type = "number",
						},
						{
							Name = "ChunkZ",
							Type = "number",
						},
						{
							Name = "CallbackFunction",
							Type = "function",
						},
					},
					Returns =
					{
						{
							Type = "boolean",
						},
					},
					Notes = "Calls the specified callback for each entity in the specified chunk. Returns true if all the entities have been processed (including when there are zero entities), or false if the chunk is not loaded or the callback function has aborted the enumeration by returning true. The callback function has the following signature: <pre class=\"prettyprint lang-lua\">function Callback({{cEntity|Entity}})</pre> The callback should return false or no value to continue with the next entity, or true to abort the enumeration.",
				},
				ForEachFurnaceInChunk =
				{
					Params =
					{
						{
							Name = "ChunkX",
							Type = "number",
						},
						{
							Name = "ChunkZ",
							Type = "number",
						},
						{
							Name = "CallbackFunction",
							Type = "function",
						},
					},
					Returns =
					{
						{
							Type = "boolean",
						},
					},
					Notes = "Calls the specified callback for each furnace in the chunk. Returns true if all furnaces in the chunk have been processed (including when there are zero furnaces), or false if the callback has aborted the enumeration by returning true. The CallbackFunction has the following signature: <pre class=\"prettyprint lang-lua\">function Callback({{cFurnaceEntity|FurnaceEntity}})</pre> The callback should return false or no value to continue with the next furnace, or true to abort the enumeration.",
				},
				ForEachPlayer =
				{
					Params =
					{
						{
							Name = "CallbackFunction",
							Type = "function",
						},
					},
					Returns =
					{
						{
							Type = "boolean",
						},
					},
					Notes = "Calls the specified callback for each player in the loaded world. Returns true if all the players have been processed (including when there are zero players), or false if the callback function has aborted the enumeration by returning true. The callback function has the following signature: <pre class=\"prettyprint lang-lua\">function Callback({{cPlayer|Player}})</pre> The callback should return false or no value to continue with the next player, or true to abort the enumeration.",
				},
				GenerateChunk =
				{
					Params =
					{
						{
							Name = "ChunkX",
							Type = "number",
						},
						{
							Name = "ChunkZ",
							Type = "number",
						},
					},
					Notes = "Queues the specified chunk in the chunk generator. Ignored if the chunk is already generated (use RegenerateChunk() to force chunk re-generation).",
				},
				GetBiomeAt =
				{
					Params =
					{
						{
							Name = "BlockX",
							Type = "number",
						},
						{
							Name = "BlockZ",
							Type = "number",
						},
					},
					Returns =
					{
						{
							Name = "eBiome",
							Type = "EMCSBiome",
						},
					},
					Notes = "Returns the biome at the specified coords. Reads the biome from the chunk, if it is loaded, otherwise it uses the chunk generator to provide the biome value.",
				},
				GetBlock =
				{
					{
						Params =
						{
							{
								Name = "BlockX",
								Type = "number",
							},
							{
								Name = "BlockY",
								Type = "number",
							},
							{
								Name = "BlockZ",
								Type = "number",
							},
						},
						Returns =
						{
							{
								Name = "BLOCKTYPE",
								Type = "number",
							},
						},
						Notes = "Returns the block type of the block at the specified coords, or 0 if the appropriate chunk is not loaded.",
					},
					{
						Params =
						{
							{
								Name = "BlockCoords",
								Type = "Vector3i",
							},
						},
						Returns =
						{
							{
								Name = "BLOCKTYPE",
								Type = "number",
							},
						},
						Notes = "Returns the block type of the block at the specified coords, or 0 if the appropriate chunk is not loaded.",
					},
				},
				GetBlockBlockLight =
				{
					{
						Params =
						{
							{
								Name = "BlockX",
								Type = "number",
							},
							{
								Name = "BlockY",
								Type = "number",
							},
							{
								Name = "BlockZ",
								Type = "number",
							},
						},
						Returns =
						{
							{
								Type = "number",
							},
						},
						Notes = "Returns the amount of block light at the specified coords, or 0 if the appropriate chunk is not loaded.",
					},
					{
						Params =
						{
							{
								Name = "Pos",
								Type = "Vector3i",
							},
						},
						Returns =
						{
							{
								Type = "number",
							},
						},
						Notes = "Returns the amount of block light at the specified coords, or 0 if the appropriate chunk is not loaded.",
					},
				},
				GetBlockInfo =
				{
					Params =
					{
						{
							Name = "BlockX",
							Type = "number",
						},
						{
							Name = "BlockY",
							Type = "number",
						},
						{
							Name = "BlockZ",
							Type = "number",
						},
					},
					Returns =
					{
						{
							Name = "IsBlockValid",
							Type = "boolean",
						},
						{
							Name = "BlockType",
							Type = "number",
						},
						{
							Name = "BlockMeta",
							Type = "number",
						},
						{
							Name = "BlockSkyLight",
							Type = "number",
						},
						{
							Name = "BlockBlockLight",
							Type = "number",
						},
					},
					Notes = "Returns the complete block info for the block at the specified coords. The first value specifies if the block is in a valid loaded chunk, the other values are valid only if BlockValid is true.",
				},
				GetBlockMeta =
				{
					{
						Params =
						{
							{
								Name = "BlockX",
								Type = "number",
							},
							{
								Name = "BlockY",
								Type = "number",
							},
							{
								Name = "BlockZ",
								Type = "number",
							},
						},
						Returns =
						{
							{
								Type = "number",
							},
						},
						Notes = "Returns the block metadata of the block at the specified coords, or 0 if the appropriate chunk is not loaded.",
					},
					{
						Params =
						{
							{
								Name = "BlockCoords",
								Type = "Vector3i",
							},
						},
						Returns =
						{
							{
								Type = "number",
							},
						},
						Notes = "Returns the block metadata of the block at the specified coords, or 0 if the appropriate chunk is not loaded.",
					},
				},
				GetBlockSkyLight =
				{
					Params =
					{
						{
							Name = "BlockX",
							Type = "number",
						},
						{
							Name = "BlockY",
							Type = "number",
						},
						{
							Name = "BlockZ",
							Type = "number",
						},
					},
					Returns =
					{
						{
							Type = "number",
						},
					},
					Notes = "Returns the block skylight of the block at the specified coords, or 0 if the appropriate chunk is not loaded.",
				},
				GetBlockTypeMeta =
				{
					Params =
					{
						{
							Name = "BlockX",
							Type = "number",
						},
						{
							Name = "BlockY",
							Type = "number",
						},
						{
							Name = "BlockZ",
							Type = "number",
						},
					},
					Returns =
					{
						{
							Name = "IsBlockValid",
							Type = "boolean",
						},
						{
							Name = "BlockType",
							Type = "number",
						},
						{
							Name = "BlockMeta",
							Type = "number",
						},
					},
					Notes = "Returns the block type and metadata for the block at the specified coords. The first value specifies if the block is in a valid loaded chunk, the other values are valid only if BlockValid is true.",
				},
				GetDefaultWeatherInterval =
				{
					Params =
					{
						{
							Name = "Weather",
							Type = "eWeather",
						},
					},
					Notes = "Returns the default weather interval for the specific weather type. Returns -1 for any unknown weather.",
				},
				GetDimension =
				{
					Returns =
					{
						{
							Type = "eDimension",
						},
					},
					Notes = "Returns the dimension of the world - dimOverworld, dimNether or dimEnd.",
				},
				GetGameMode =
				{
					Returns =
					{
						{
							Type = "eGameMode",
						},
					},
					Notes = "Returns the gamemode of the world - gmSurvival, gmCreative or gmAdventure.",
				},
				GetGeneratorQueueLength =
				{
					Returns =
					{
						{
							Type = "number",
						},
					},
					Notes = "Returns the number of chunks that are queued in the chunk generator.",
				},
				GetHeight =
				{
					Params =
					{
						{
							Name = "BlockX",
							Type = "number",
						},
						{
							Name = "BlockZ",
							Type = "number",
						},
					},
					Returns =
					{
						{
							Type = "number",
						},
					},
					Notes = "Returns the maximum height of the particula block column in the world. If the chunk is not loaded, it waits for it to load / generate. <b>WARNING</b>: Do not use, Use TryGetHeight() instead for a non-waiting version, otherwise you run the risk of a deadlock!",
				},
				GetIniFileName =
				{
					Returns =
					{
						{
							Type = "string",
						},
					},
					Notes = "Returns the name of the world.ini file that the world uses to store the information.",
				},
				GetLightingQueueLength =
				{
					Returns =
					{
						{
							Type = "number",
						},
					},
					Notes = "Returns the number of chunks in the lighting thread's queue.",
				},
				GetLinkedEndWorldName =
				{
					Returns =
					{
						{
							Type = "string",
						},
					},
					Notes = "Returns the name of the end world this world is linked to.",
				},
				GetLinkedNetherWorldName =
				{
					Returns =
					{
						{
							Type = "string",
						},
					},
					Notes = "Returns the name of the Netherworld linked to this world.",
				},
				GetLinkedOverworldName =
				{
					Returns =
					{
						{
							Type = "string",
						},
					},
					Notes = "Returns the name of the world this world is linked to.",
				},
				GetMapManager =
				{
					Returns =
					{
						{
							Type = "cMapManager",
						},
					},
					Notes = "Returns the {{cMapManager|MapManager}} object used by this world.",
				},
				GetMaxCactusHeight =
				{
					Returns =
					{
						{
							Type = "number",
						},
					},
					Notes = "Returns the configured maximum height to which cacti will grow naturally.",
				},
				GetMaxNetherPortalHeight =
				{
					Returns =
					{
						{
							Type = "number",
						},
					},
					Notes = "Returns the maximum height for a nether portal",
				},
				GetMaxNetherPortalWidth =
				{
					Returns =
					{
						{
							Type = "number",
						},
					},
					Notes = "Returns the maximum width for a nether portal",
				},
				GetMaxSugarcaneHeight =
				{
					Returns =
					{
						{
							Type = "number",
						},
					},
					Notes = "Returns the configured maximum height to which sugarcane will grow naturally.",
				},
				GetMaxViewDistance =
				{
					Returns =
					{
						{
							Type = "number",
						},
					},
					Notes = "Returns the maximum viewdistance that players can see in this world. The view distance is the amount of chunks around the player that the player can see.",
				},
				GetMinNetherPortalHeight =
				{
					Returns =
					{
						{
							Type = "number",
						},
					},
					Notes = "Returns the minimum height for a nether portal",
				},
				GetMinNetherPortalWidth =
				{
					Returns =
					{
						{
							Type = "number",
						},
					},
					Notes = "Returns the minimum width for a nether portal",
				},
				GetName =
				{
					Returns =
					{
						{
							Type = "string",
						},
					},
					Notes = "Returns the name of the world, as specified in the settings.ini file.",
				},
				GetNumChunks =
				{
					Returns =
					{
						{
							Type = "number",
						},
					},
					Notes = "Returns the number of chunks currently loaded.",
				},
				GetNumUnusedDirtyChunks =
				{
					Returns =
					{
						{
							Type = "number",
						},
					},
					Notes = "Returns the number of unused dirty chunks. That's the number of chunks that we can save and then unload.",
				},
				GetScoreBoard =
				{
					Returns =
					{
						{
							Type = "cScoreBoard",
						},
					},
					Notes = "Returns the {{cScoreBoard|ScoreBoard}} object used by this world. ",
				},
				GetSeed =
				{
					Returns =
					{
						{
							Type = "number",
						},
					},
					Notes = "Returns the seed of the world.",
				},
				GetSignLines =
				{
					Params =
					{
						{
							Name = "BlockX",
							Type = "number",
						},
						{
							Name = "BlockY",
							Type = "number",
						},
						{
							Name = "BlockZ",
							Type = "number",
						},
					},
					Returns =
					{
						{
							Name = "IsValid",
							Type = "boolean",
						},
						{
							Name = "Line1",
							Type = "string",
							IsOptional = true,
						},
						{
							Name = "Line2",
							Type = "string",
							IsOptional = true,
						},
						{
							Name = "Line3",
							Type = "string",
							IsOptional = true,
						},
						{
							Name = "Line4",
							Type = "string",
							IsOptional = true,
						},
					},
					Notes = "Returns true and the lines of a sign at the specified coords, or false if there is no sign at the coords.",
				},
				GetSpawnX =
				{
					Returns =
					{
						{
							Type = "number",
						},
					},
					Notes = "Returns the X coord of the default spawn",
				},
				GetSpawnY =
				{
					Returns =
					{
						{
							Type = "number",
						},
					},
					Notes = "Returns the Y coord of the default spawn",
				},
				GetSpawnZ =
				{
					Returns =
					{
						{
							Type = "number",
						},
					},
					Notes = "Returns the Z coord of the default spawn",
				},
				GetStorageLoadQueueLength =
				{
					Returns =
					{
						{
							Type = "number",
						},
					},
					Notes = "Returns the number of chunks queued up for loading",
				},
				GetStorageSaveQueueLength =
				{
					Returns =
					{
						{
							Type = "number",
						},
					},
					Notes = "Returns the number of chunks queued up for saving",
				},
				GetTicksUntilWeatherChange =
				{
					Returns =
					{
						{
							Type = "number",
						},
					},
					Notes = "Returns the number of ticks that will pass before the weather is changed",
				},
				GetTimeOfDay =
				{
					Returns =
					{
						{
							Type = "number",
						},
					},
					Notes = "Returns the number of ticks that have passed from the sunrise, 0 .. 24000.",
				},
				GetTNTShrapnelLevel =
				{
					Returns =
					{
						{
							Name = "ShrapnelLevel",
							Type = "Globals#eShrapnelLevel",
						},
					},
					Notes = "Returns the shrapnel level, representing the block types that are propelled outwards following an explosion. Based on this value and a random picker, blocks are selectively converted to physics entities (FallingSand) and flung outwards.",
				},
				GetWeather =
				{
					Returns =
					{
						{
							Type = "eWeather",
						},
					},
					Notes = "Returns the current weather in the world (wSunny, wRain, wStorm). To check for weather, use IsWeatherXXX() functions instead.",
				},
				GetWorldAge =
				{
					Returns =
					{
						{
							Type = "number",
						},
					},
					Notes = "Returns the total age of the world, in ticks. The age always grows, cannot be set by plugins and is unrelated to TimeOfDay.",
				},
				GrowCactus =
				{
					Params =
					{
						{
							Name = "BlockX",
							Type = "number",
						},
						{
							Name = "BlockY",
							Type = "number",
						},
						{
							Name = "BlockZ",
							Type = "number",
						},
						{
							Name = "NumBlocksToGrow",
							Type = "number",
						},
					},
					Returns =
					{
						{
							Type = "number",
						},
					},
					Notes = "Grows a cactus block at the specified coords, by up to the specified number of blocks. Adheres to the world's maximum cactus growth (GetMaxCactusHeight()). Returns the amount of blocks the cactus grew inside this call.",
				},
				GrowMelonPumpkin =
				{
					Params =
					{
						{
							Name = "BlockX",
							Type = "number",
						},
						{
							Name = "BlockY",
							Type = "number",
						},
						{
							Name = "BlockZ",
							Type = "number",
						},
						{
							Name = "StemBlockType",
							Type = "number",
						},
					},
					Returns =
					{
						{
							Type = "boolean",
						},
					},
					Notes = "Grows a melon or pumpkin, based on the stem block type specified (assumed to be at the coords provided). Checks for normal melon / pumpkin growth conditions - stem not having another produce next to it and suitable ground below. Returns true if the melon or pumpkin grew successfully.",
				},
				GrowRipePlant =
				{
					Params =
					{
						{
							Name = "BlockX",
							Type = "number",
						},
						{
							Name = "BlockY",
							Type = "number",
						},
						{
							Name = "BlockZ",
							Type = "number",
						},
						{
							Name = "IsByBonemeal",
							Type = "boolean",
						},
					},
					Returns =
					{
						{
							Type = "boolean",
						},
					},
					Notes = "Grows the plant at the specified coords. If IsByBonemeal is true, checks first if the specified plant type is bonemealable in the settings. Returns true if the plant was grown, false if not.",
				},
				GrowSugarcane =
				{
					Params =
					{
						{
							Name = "BlockX",
							Type = "number",
						},
						{
							Name = "BlockY",
							Type = "number",
						},
						{
							Name = "BlockZ",
							Type = "number",
						},
						{
							Name = "NumBlocksToGrow",
							Type = "number",
						},
					},
					Returns =
					{
						{
							Type = "number",
						},
					},
					Notes = "Grows a sugarcane block at the specified coords, by up to the specified number of blocks. Adheres to the world's maximum sugarcane growth (GetMaxSugarcaneHeight()). Returns the amount of blocks the sugarcane grew inside this call.",
				},
				GrowTree =
				{
					Params =
					{
						{
							Name = "BlockX",
							Type = "number",
						},
						{
							Name = "BlockY",
							Type = "number",
						},
						{
							Name = "BlockZ",
							Type = "number",
						},
					},
					Notes = "Grows a tree based at the specified coords. If there is a sapling there, grows the tree based on that sapling, otherwise chooses a tree image based on the biome.",
				},
				GrowTreeByBiome =
				{
					Params =
					{
						{
							Name = "BlockX",
							Type = "number",
						},
						{
							Name = "BlockY",
							Type = "number",
						},
						{
							Name = "BlockZ",
							Type = "number",
						},
					},
					Notes = "Grows a tree based at the specified coords. The tree type is picked from types available for the biome at those coords.",
				},
				GrowTreeFromSapling =
				{
					Params =
					{
						{
							Name = "BlockX",
							Type = "number",
						},
						{
							Name = "BlockY",
							Type = "number",
						},
						{
							Name = "BlockZ",
							Type = "number",
						},
						{
							Name = "SaplingMeta",
							Type = "number",
						},
					},
					Notes = "Grows a tree based at the specified coords. The tree type is determined from the sapling meta (the sapling itself needn't be present).",
				},
				IsBlockDirectlyWatered =
				{
					Params =
					{
						{
							Name = "BlockX",
							Type = "number",
						},
						{
							Name = "BlockY",
							Type = "number",
						},
						{
							Name = "BlockZ",
							Type = "number",
						},
					},
					Returns =
					{
						{
							Type = "boolean",
						},
					},
					Notes = "Returns true if the specified block has a water block right next to it (on the X/Z axes)",
				},
				IsDaylightCycleEnabled =
				{
					Returns =
					{
						{
							Type = "boolean",
						},
					},
					Notes = "Returns true if the daylight cycle is enabled.",
				},
				IsDeepSnowEnabled =
				{
					Returns =
					{
						{
							Type = "boolean",
						},
					},
					Notes = "Returns whether the configuration has DeepSnow enabled.",
				},
				IsGameModeAdventure =
				{
					Returns =
					{
						{
							Type = "boolean",
						},
					},
					Notes = "Returns true if the current gamemode is gmAdventure.",
				},
				IsGameModeCreative =
				{
					Returns =
					{
						{
							Type = "boolean",
						},
					},
					Notes = "Returns true if the current gamemode is gmCreative.",
				},
				IsGameModeSpectator =
				{
					Returns =
					{
						{
							Type = "boolean",
						},
					},
					Notes = "Returns true if the current gamemode is gmSpectator.",
				},
				IsGameModeSurvival =
				{
					Returns =
					{
						{
							Type = "boolean",
						},
					},
					Notes = "Returns true if the current gamemode is gmSurvival.",
				},
				IsPVPEnabled =
				{
					Returns =
					{
						{
							Type = "boolean",
						},
					},
					Notes = "Returns whether PVP is enabled in the world settings.",
				},
				IsTrapdoorOpen =
				{
					Params =
					{
						{
							Name = "BlockX",
							Type = "number",
						},
						{
							Name = "BlockY",
							Type = "number",
						},
						{
							Name = "BlockZ",
							Type = "number",
						},
					},
					Returns =
					{
						{
							Type = "boolean",
						},
					},
					Notes = "Returns false if there is no trapdoor there or if the block isn't a trapdoor or if the chunk wasn't loaded. Returns true if trapdoor is open.",
				},
				IsWeatherRain =
				{
					Returns =
					{
						{
							Type = "boolean",
						},
					},
					Notes = "Returns true if the current world is raining (no thunderstorm).",
				},
				IsWeatherRainAt =
				{
					Params =
					{
						{
							Name = "BlockX",
							Type = "number",
						},
						{
							Name = "BlockZ",
							Type = "number",
						},
					},
					Returns =
					{
						{
							Type = "boolean",
						},
					},
					Notes = "Returns true if the specified location is raining (takes biomes into account - it never rains in a desert).",
				},
				IsWeatherStorm =
				{
					Returns =
					{
						{
							Type = "boolean",
						},
					},
					Notes = "Returns true if the current world is stormy.",
				},
				IsWeatherStormAt =
				{
					Params =
					{
						{
							Name = "BlockX",
							Type = "number",
						},
						{
							Name = "BlockZ",
							Type = "number",
						},
					},
					Returns =
					{
						{
							Type = "boolean",
						},
					},
					Notes = "Returns true if the specified location is stormy (takes biomes into account - no storm in a desert).",
				},
				IsWeatherSunny =
				{
					Returns =
					{
						{
							Type = "boolean",
						},
					},
					Notes = "Returns true if the current weather is sunny.",
				},
				IsWeatherSunnyAt =
				{
					Params =
					{
						{
							Name = "BlockX",
							Type = "number",
						},
						{
							Name = "BlockZ",
							Type = "number",
						},
					},
					Returns =
					{
						{
							Type = "boolean",
						},
					},
					Notes = "Returns true if the current weather is sunny at the specified location (takes into account biomes).",
				},
				IsWeatherWet =
				{
					Returns =
					{
						{
							Type = "boolean",
						},
					},
					Notes = "Returns true if the current world has any precipitation (rain or storm).",
				},
				IsWeatherWetAt =
				{
					Params =
					{
						{
							Name = "BlockX",
							Type = "number",
						},
						{
							Name = "BlockZ",
							Type = "number",
						},
					},
					Returns =
					{
						{
							Type = "boolean",
						},
					},
					Notes = "Returns true if the specified location has any precipitation (rain or storm) (takes biomes into account, deserts are never wet).",
				},
				PrepareChunk =
				{
					Params =
					{
						{
							Name = "ChunkX",
							Type = "number",
						},
						{
							Name = "ChunkZ",
							Type = "number",
						},
						{
							Name = "Callback",
							Type = "function",
							IsOptional = true,
						},
					},
					Notes = "Queues the chunk for preparing - making sure that it's generated and lit. It is legal to call with no callback. The callback function has the following signature: <pre class=\"prettyprint lang-lua\">function Callback(ChunkX, ChunkZ)</pre>",
				},
				QueueBlockForTick =
				{
					Params =
					{
						{
							Name = "BlockX",
							Type = "number",
						},
						{
							Name = "BlockY",
							Type = "number",
						},
						{
							Name = "BlockZ",
							Type = "number",
						},
						{
							Name = "TicksToWait",
							Type = "number",
						},
					},
					Notes = "Queues the specified block to be ticked after the specified number of gameticks.",
				},
				QueueSaveAllChunks =
				{
					Notes = "Queues all chunks to be saved in the world storage thread",
				},
				QueueSetBlock =
				{
					Params =
					{
						{
							Name = "BlockX",
							Type = "number",
						},
						{
							Name = "BlockY",
							Type = "number",
						},
						{
							Name = "BlockZ",
							Type = "number",
						},
						{
							Name = "BlockType",
							Type = "number",
						},
						{
							Name = "BlockMeta",
							Type = "number",
						},
						{
							Name = "TickDelay",
							Type = "number",
						},
					},
					Notes = "Queues the block to be set to the specified blocktype and meta after the specified amount of game ticks. Uses SetBlock() for the actual setting, so simulators are woken up and block entities are handled correctly.",
				},
				QueueTask =
				{
					Params =
					{
						{
							Name = "TaskFunction",
							Type = "function",
						},
					},
					Notes = "Queues the specified function to be executed in the tick thread. This is the primary means of interaction with a cWorld from the WebAdmin page handlers (see {{WebWorldThreads}}). The function signature is <pre class=\"pretty-print lang-lua\">function()</pre>All return values from the function are ignored. Note that this function is actually called *after* the QueueTask() function returns. Note that it is unsafe to store references to Cuberite objects, such as entities, across from the caller to the task handler function; store the EntityID instead.",
				},
				QueueUnloadUnusedChunks =
				{
					Notes = "Queues a cTask that unloads chunks that are no longer needed and are saved.",
				},
				RegenerateChunk =
				{
					Params =
					{
						{
							Name = "ChunkX",
							Type = "number",
						},
						{
							Name = "ChunkZ",
							Type = "number",
						},
					},
					Notes = "Queues the specified chunk to be re-generated, overwriting the current data. To queue a chunk for generating only if it doesn't exist, use the GenerateChunk() instead.",
				},
				ScheduleTask =
				{
					Params =
					{
						{
							Name = "DelayTicks",
							Type = "number",
						},
						{
							Name = "TaskFunction",
							Type = "function",
						},
					},
					Notes = "Queues the specified function to be executed in the world's tick thread after a the specified number of ticks. This enables operations to be queued for execution in the future. The function signature is <pre class=\"pretty-print lang-lua\">function({{cWorld|World}})</pre>All return values from the function are ignored. Note that it is unsafe to store references to Cuberite objects, such as entities, across from the caller to the task handler function; store the EntityID instead.",
				},
				SendBlockTo =
				{
					Params =
					{
						{
							Name = "BlockX",
							Type = "number",
						},
						{
							Name = "BlockY",
							Type = "number",
						},
						{
							Name = "BlockZ",
							Type = "number",
						},
						{
							Name = "Player",
							Type = "cPlayer",
						},
					},
					Notes = "Sends the block at the specified coords to the specified player's client, as an UpdateBlock packet.",
				},
				SetAreaBiome =
				{
					{
						Params =
						{
							{
								Name = "MinX",
								Type = "number",
							},
							{
								Name = "MaxX",
								Type = "number",
							},
							{
								Name = "MinZ",
								Type = "number",
							},
							{
								Name = "MaxZ",
								Type = "number",
							},
							{
								Name = "Biome",
								Type = "EMCSBiome",
							},
						},
						Returns =
						{
							{
								Type = "boolean",
							},
						},
						Notes = "Sets the biome in the rectangular area specified. Returns true if successful, false if any of the chunks were unloaded.",
					},
					{
						Params =
						{
							{
								Name = "Cuboid",
								Type = "cCuboid",
							},
							{
								Name = "Biome",
								Type = "EMCSBiome",
							},
						},
						Returns =
						{
							{
								Type = "boolean",
							},
						},
						Notes = "Sets the biome in the cuboid specified. Returns true if successful, false if any of the chunks were unloaded. The cuboid needn't be sorted.",
					},
				},
				SetBiomeAt =
				{
					Params =
					{
						{
							Name = "BlockX",
							Type = "number",
						},
						{
							Name = "BlockZ",
							Type = "number",
						},
						{
							Name = "Biome",
							Type = "EMCSBiome",
						},
					},
					Returns =
					{
						{
							Type = "boolean",
						},
					},
					Notes = "Sets the biome at the specified block coords. Returns true if successful, false otherwise.",
				},
				SetBlock =
				{
					Params =
					{
						{
							Name = "BlockX",
							Type = "number",
						},
						{
							Name = "BlockY",
							Type = "number",
						},
						{
							Name = "BlockZ",
							Type = "number",
						},
						{
							Name = "BlockType",
							Type = "number",
						},
						{
							Name = "BlockMeta",
							Type = "number",
						},
						{
							Name = "ShouldSendToClients",
							Type = "boolean",
							IsOptional = true,
						},
					},
					Notes = "Sets the block at the specified coords, replaces the block entities for the previous block type, creates a new block entity for the new block, if appropriate, and wakes up the simulators. This is the preferred way to set blocks, as opposed to FastSetBlock(), which is only to be used under special circumstances. If ShouldSendToClients is true (default), the change is broadcast to all players who have this chunk loaded; if false, the change is made server-side only.",
				},
				SetBlockMeta =
				{
					{
						Params =
						{
							{
								Name = "BlockX",
								Type = "number",
							},
							{
								Name = "BlockY",
								Type = "number",
							},
							{
								Name = "BlockZ",
								Type = "number",
							},
							{
								Name = "BlockMeta",
								Type = "number",
							},
							{
								Name = "ShouldMarkChunkDirty",
								Type = "boolean",
								IsOptional = true,
							},
							{
								Name = "ShouldSendToClients",
								Type = "boolean",
								IsOptional = true,
							},
						},
						Notes = "Sets the meta for the block at the specified coords. If ShouldMarkChunkDirty is true (default), the chunk is marked dirty and will be saved later on. If ShouldSendToClients is true (default), the change is broadcast to all clients who have the chunk loaded, if false, the change is kept server-side only.",
					},
					{
						Params =
						{
							{
								Name = "BlockCoords",
								Type = "Vector3i",
							},
							{
								Name = "BlockMeta",
								Type = "number",
							},
						},
						Notes = "Sets the meta for the block at the specified coords.",
					},
				},
				SetChunkAlwaysTicked =
				{
					Params =
					{
						{
							Name = "ChunkX",
							Type = "number",
						},
						{
							Name = "ChunkZ",
							Type = "number",
						},
						{
							Name = "IsAlwaysTicked",
							Type = "boolean",
						},
					},
					Notes = "Sets the chunk to always be ticked even when it doesn't contain any clients. IsAlwaysTicked set to true turns forced ticking on, set to false turns it off. Every call with 'true' should be paired with a later call with 'false', otherwise the ticking won't stop. Multiple actions can request ticking independently, the ticking will continue until the last call with 'false'. Note that when the chunk unloads, it loses the value of this flag.",
				},
				SetCommandBlockCommand =
				{
					Params =
					{
						{
							Name = "BlockX",
							Type = "number",
						},
						{
							Name = "BlockY",
							Type = "number",
						},
						{
							Name = "BlockZ",
							Type = "number",
						},
						{
							Name = "Command",
							Type = "string",
						},
					},
					Returns =
					{
						{
							Type = "boolean",
						},
					},
					Notes = "Sets the command to be executed in a command block at the specified coordinates. Returns if command was changed.",
				},
				SetCommandBlocksEnabled =
				{
					Params =
					{
						{
							Name = "AreEnabled",
							Type = "boolean",
						},
					},
					Notes = "Sets whether command blocks should be enabled on the (entire) server.",
				},
				SetDaylightCycleEnabled =
				{
					Params =
					{
						{
							Name = "IsEnabled",
							Type = "boolean",
						},
					},
					Notes = "Starts or stops the daylight cycle.",
				},
				SetLinkedEndWorldName =
				{
					Params =
					{
						{
							Name = "WorldName",
							Type = "string",
						},
					},
					Notes = "Sets the name of the world that the end portal should link to.",
				},
				SetLinkedNetherWorldName =
				{
					Params =
					{
						{
							Name = "WorldName",
							Type = "string",
						},
					},
					Notes = "Sets the name of the world that the nether portal should link to.",
				},
				SetLinkedOverworldName =
				{
					Params =
					{
						{
							Name = "WorldName",
							Type = "string",
						},
					},
					Notes = "Sets the name of the world that the nether portal should link to?",
				},
				SetMaxNetherPortalHeight =
				{
					Params =
					{
						{
							Name = "Height",
							Type = "number",
						},
					},
					Notes = "Sets the maximum height for a nether portal",
				},
				SetMaxNetherPortalWidth =
				{
					Params =
					{
						{
							Name = "Width",
							Type = "number",
						},
					},
					Notes = "Sets the maximum width for a nether portal",
				},
				SetMaxViewDistance =
				{
					Params =
					{
						{
							Name = "MaxViewDistance",
							Type = "number",
						},
					},
					Notes = "Sets the maximum viewdistance of the players in the world. This maximum takes precedence over each player's ViewDistance setting.",
				},
				SetMinNetherPortalHeight =
				{
					Params =
					{
						{
							Name = "Height",
							Type = "number",
						},
					},
					Notes = "Sets the minimum height for a nether portal",
				},
				SetMinNetherPortalWidth =
				{
					Params =
					{
						{
							Name = "Width",
							Type = "number",
						},
					},
					Notes = "Sets the minimum width for a nether portal",
				},
				SetNextBlockTick =
				{
					Params =
					{
						{
							Name = "BlockX",
							Type = "number",
						},
						{
							Name = "BlockY",
							Type = "number",
						},
						{
							Name = "BlockZ",
							Type = "number",
						},
					},
					Notes = "Sets the blockticking to start at the specified block in the next tick.",
				},
				SetShouldUseChatPrefixes =
				{
					Returns =
					{
						{
							Name = "ShouldUseChatPrefixes",
							Type = "boolean",
						},
					},
					Notes = "Sets whether coloured chat prefixes such as [INFO] is used with the SendMessageXXX() or BroadcastChatXXX(), or simply the entire message is coloured in the respective colour.",
				},
				SetSignLines =
				{
					Params =
					{
						{
							Name = "BlockX",
							Type = "number",
						},
						{
							Name = "BlockY",
							Type = "number",
						},
						{
							Name = "BlockZ",
							Type = "number",
						},
						{
							Name = "Line1",
							Type = "string",
						},
						{
							Name = "Line2",
							Type = "string",
						},
						{
							Name = "Line3",
							Type = "string",
						},
						{
							Name = "Line4",
							Type = "string",
						},
						{
							Name = "Player",
							Type = "cPlayer",
							IsOptional = true,
						},
					},
					Notes = "Sets the sign text at the specified coords. The sign-updating hooks are called for the change. The Player parameter is used to indicate the player from whom the change has come, it may be nil.",
				},
				SetSpawn =
				{
					Params =
					{
						{
							Name = "X",
							Type = "number",
						},
						{
							Name = "Y",
							Type = "number",
						},
						{
							Name = "Z",
							Type = "number",
						},
					},
					Returns =
					{
						{
							Type = "boolean",
						},
					},
					Notes = "Sets the default spawn at the specified coords. Returns false if the new spawn couldn't be stored in the INI file.",
				},
				SetTicksUntilWeatherChange =
				{
					Params =
					{
						{
							Name = "NumTicks",
							Type = "number",
						},
					},
					Notes = "Sets the number of ticks after which the weather will be changed.",
				},
				SetTimeOfDay =
				{
					Params =
					{
						{
							Name = "TimeOfDayTicks",
							Type = "number",
						},
					},
					Notes = "Sets the time of day, expressed as number of ticks past sunrise, in the range 0 .. 24000.",
				},
				SetTNTShrapnelLevel =
				{
					Params =
					{
						{
							Name = "ShrapnelLevel",
							Type = "Globals#eShrapnelLevel",
						},
					},
					Notes = "Sets the Shrapnel level of the world.",
				},
				SetTrapdoorOpen =
				{
					Params =
					{
						{
							Name = "BlockX",
							Type = "number",
						},
						{
							Name = "BlockY",
							Type = "number",
						},
						{
							Name = "BlockZ",
							Type = "number",
						},
						{
							Name = "IsOpen",
							Type = "boolean",
						},
					},
					Notes = "Opens or closes a trapdoor at the specific coordinates.",
				},
				SetWeather =
				{
					Params =
					{
						{
							Name = "Weather",
							Type = "eWeather",
						},
					},
					Notes = "Sets the current weather (wSunny, wRain, wStorm) and resets the TicksUntilWeatherChange to the default value for the new weather. The normal weather-changing hooks are called for the change.",
				},
				ShouldBroadcastAchievementMessages =
				{
					Returns =
					{
						{
							Type = "boolean",
						},
					},
					Notes = "Returns true if the server should broadcast achievement messages in this world.",
				},
				ShouldBroadcastDeathMessages =
				{
					Returns =
					{
						{
							Type = "boolean",
						},
					},
					Notes = "Returns true if the server should broadcast death messages in this world.",
				},
				ShouldLavaSpawnFire =
				{
					Returns =
					{
						{
							Type = "boolean",
						},
					},
					Notes = "Returns true if the world is configured to spawn fires near lava (world.ini: [Physics].ShouldLavaSpawnFire value)",
				},
				ShouldUseChatPrefixes =
				{
					Returns =
					{
						{
							Type = "boolean",
						},
					},
					Notes = "Returns whether coloured chat prefixes are prepended to chat messages or the entire message is simply coloured.",
				},
				SpawnBoat =
				{
					Params =
					{
						{
							Name = "X",
							Type = "number",
						},
						{
							Name = "Y",
							Type = "number",
						},
						{
							Name = "Z",
							Type = "number",
						},
					},
					Returns =
					{
						{
							Name = "EntityID",
							Type = "number",
						},
					},
					Notes = "Spawns a boat at the specific coordinates. Returns the entity ID of the new boat, or {{cEntity#NO_ID|cEntity.NO_ID}} if no boat was created.",
				},
				SpawnExperienceOrb =
				{
					Params =
					{
						{
							Name = "X",
							Type = "number",
						},
						{
							Name = "Y",
							Type = "number",
						},
						{
							Name = "Z",
							Type = "number",
						},
						{
							Name = "Reward",
							Type = "number",
						},
					},
					Returns =
					{
						{
							Name = "EntityID",
							Type = "number",
						},
					},
					Notes = "Spawns an {{cExpOrb|experience orb}} at the specified coords, with the given reward",
				},
				SpawnFallingBlock =
				{
					Params =
					{
						{
							Name = "X",
							Type = "number",
						},
						{
							Name = "Y",
							Type = "number",
						},
						{
							Name = "Z",
							Type = "number",
						},
						{
							Name = "BlockType",
							Type = "number",
						},
						{
							Name = "BlockMeta",
							Type = "number",
						},
					},
					Returns =
					{
						{
							Name = "EntityID",
							Type = "number",
						},
					},
					Notes = "Spawns a {{cFallingBlock|Falling Block}} entity at the specified coords with the given block type/meta",
				},
				SpawnItemPickups =
				{
					{
						Params =
						{
							{
								Name = "Pickups",
								Type = "cItems",
							},
							{
								Name = "X",
								Type = "number",
							},
							{
								Name = "Y",
								Type = "number",
							},
							{
								Name = "Z",
								Type = "number",
							},
							{
								Name = "FlyAwaySpeed",
								Type = "number",
								IsOptional = true,
							},
							{
								Name = "IsPlayerCreated",
								Type = "boolean",
								IsOptional = true,
							},
						},
						Notes = "Spawns the specified pickups at the position specified. The FlyAwaySpeed is a coefficient (default: 1) used to initialize the random speed in which the pickups fly away from the spawn position. The IsPlayerCreated parameter (default: false) is used to initialize the created {{cPickup}} object's IsPlayerCreated value.",
					},
					{
						Params =
						{
							{
								Name = "Pickups",
								Type = "cItems",
							},
							{
								Name = "X",
								Type = "number",
							},
							{
								Name = "Y",
								Type = "number",
							},
							{
								Name = "Z",
								Type = "number",
							},
							{
								Name = "SpeedX",
								Type = "number",
							},
							{
								Name = "SpeedY",
								Type = "number",
							},
							{
								Name = "SpeedZ",
								Type = "number",
							},
							{
								Name = "IsPlayerCreated",
								Type = "boolean",
								IsOptional = true,
							},
						},
						Notes = "Spawns the specified pickups at the position specified. All the pickups fly away from the spawn position using the specified speed. The IsPlayerCreated parameter (default: false) is used to initialize the created {{cPickup}} object's IsPlayerCreated value.",
					},
				},
				SpawnMinecart =
				{
					Params =
					{
						{
							Name = "X",
							Type = "number",
						},
						{
							Name = "Y",
							Type = "number",
						},
						{
							Name = "Z",
							Type = "number",
						},
						{
							Name = "MinecartType",
							Type = "number",
						},
						{
							Name = "Item",
							Type = "cItem",
							IsOptional = true,
						},
						{
							Name = "BlockHeight",
							Type = "number",
							IsOptional = true,
						},
					},
					Returns =
					{
						{
							Name = "EntityID",
							Type = "number",
						},
					},
					Notes = "Spawns a minecart at the specific coordinates. MinecartType is the item type of the minecart. If the minecart is an empty minecart then the given Item (default: empty) is the block to be displayed inside the minecart, and BlockHeight (default: 1) is the relative distance of the block from the minecart. Returns the entity ID of the new minecart, or {{cEntity#NO_ID|cEntity.NO_ID}} if no minecart was created.",
				},
				SpawnMob =
				{
					Params =
					{
						{
							Name = "X",
							Type = "number",
						},
						{
							Name = "Y",
							Type = "number",
						},
						{
							Name = "Z",
							Type = "number",
						},
						{
							Name = "MonsterType",
							Type = "cMonster",
						},
						{
							Name = "IsBaby",
							Type = "boolean",
							IsOptional = true,
						},
					},
					Returns =
					{
						{
							Name = "EntityID",
							Type = "number",
						},
					},
					Notes = "Spawns the specified type of mob at the specified coords. If the Baby parameter is true, the mob will be a baby. Returns the EntityID of the creates entity, or -1 on failure. ",
				},
				SpawnPrimedTNT =
				{
					Params =
					{
						{
							Name = "X",
							Type = "number",
						},
						{
							Name = "Y",
							Type = "number",
						},
						{
							Name = "Z",
							Type = "number",
						},
						{
							Name = "FuseTicks",
							Type = "number",
						},
						{
							Name = "InitialVelocityCoeff",
							Type = "number",
						},
					},
					Notes = "Spawns a {{cTNTEntity|primed TNT entity}} at the specified coords, with the given fuse ticks. The entity gets a random speed multiplied by the InitialVelocityCoeff, 1 being the default value.",
				},
				TryGetHeight =
				{
					Params =
					{
						{
							Name = "BlockX",
							Type = "number",
						},
						{
							Name = "BlockZ",
							Type = "number",
						},
					},
					Returns =
					{
						{
							Name = "IsValid",
							Type = "boolean",
						},
						{
							Name = "Height",
							Type = "number",
						},
					},
					Notes = "Returns true and height of the highest non-air block if the chunk is loaded, or false otherwise.",
				},
				UpdateSign =
				{
					Params =
					{
						{
							Name = "BlockX",
							Type = "number",
						},
						{
							Name = "BlockY",
							Type = "number",
						},
						{
							Name = "BlockZ",
							Type = "number",
						},
						{
							Name = "Line1",
							Type = "string",
						},
						{
							Name = "Line2",
							Type = "string",
						},
						{
							Name = "Line3",
							Type = "string",
						},
						{
							Name = "Line4",
							Type = "string",
						},
						{
							Name = "Player",
							Type = "cPlayer",
							IsOptional = true,
						},
					},
					Notes = "(<b>DEPRECATED</b>) Please use SetSignLines().",
				},
				UseBlockEntity =
				{
					Params =
					{
						{
							Name = "Player",
							Type = "cPlayer",
						},
						{
							Name = "BlockX",
							Type = "number",
						},
						{
							Name = "BlockY",
							Type = "number",
						},
						{
							Name = "BlockZ",
							Type = "number",
						},
					},
					Notes = "Makes the specified Player use the block entity at the specified coords (open chest UI, etc.) If the cords are in an unloaded chunk or there's no block entity, ignores the call.",
				},
				VillagersShouldHarvestCrops =
				{
					Notes = "Returns true if villagers can harvest crops.",
				},
				WakeUpSimulators =
				{
					Params =
					{
						{
							Name = "BlockX",
							Type = "number",
						},
						{
							Name = "BlockY",
							Type = "number",
						},
						{
							Name = "BlockZ",
							Type = "number",
						},
					},
					Notes = "Wakes up the simulators for the specified block.",
				},
				WakeUpSimulatorsInArea =
				{
					Params =
					{
						{
							Name = "MinBlockX",
							Type = "number",
						},
						{
							Name = "MaxBlockX",
							Type = "number",
						},
						{
							Name = "MinBlockY",
							Type = "number",
						},
						{
							Name = "MaxBlockY",
							Type = "number",
						},
						{
							Name = "MinBlockZ",
							Type = "number",
						},
						{
							Name = "MaxBlockZ",
							Type = "number",
						},
					},
					Notes = "Wakes up the simulators for all the blocks in the specified area (edges inclusive).",
				},
			},
			AdditionalInfo =
			{
				{
					Header = "Using callbacks",
					Contents = [[
						To avoid problems with stale objects, the cWorld class will not let plugins get a direct pointer
						to an {{cEntity|entity}}, {{cBlockEntity|block entity}} or a {{cPlayer|player}}. Such an object
						could be modified or even destroyed by another thread while the plugin holds it, so it would be
						rather unsafe.</p>
						<p>
						Instead, the cWorld provides access to these objects using callbacks. The plugin provides a
						function that is called and receives the object as a parameter; cWorld guarantees that while
						the callback is executing, the object will stay valid. If a plugin needs to "remember" the
						object outside of the callback, it needs to store the entity ID, blockentity coords or player
						name.</p>
						<p>
						The following code examples show how to use the callbacks</p>
						<p>
						This code teleports player Player to another player named ToName in the same world:
<pre class="prettyprint lang-lua">
-- Player is a cPlayer object
-- ToName is a string
-- World is a cWorld object
World:ForEachPlayer(
	function (a_OtherPlayer)
	if (a_OtherPlayer:GetName() == ToName) then
		Player:TeleportToEntity(a_OtherPlayer);
	end
);
</pre></p>
						<p>
						This code fills each furnace in the chunk with 64 coals:
<pre class="prettyprint lang-lua">
-- Player is a cPlayer object
-- World is a cWorld object
World:ForEachFurnaceInChunk(Player:GetChunkX(), Player:GetChunkZ(),
	function (a_Furnace)
		a_Furnace:SetFuelSlot(cItem(E_ITEM_COAL, 64));
	end
);
</pre></p>
						<p>
						This code teleports all spiders up by 100 blocks:
<pre class="prettyprint lang-lua">
-- World is a cWorld object
World:ForEachEntity(
	function (a_Entity)
		if not(a_Entity:IsMob()) then
			return;
		end

		-- Get the cMonster out of cEntity, now that we know the entity represents one.
		local Monster = tolua.cast(a_Entity, "cMonster");
		if (Monster:GetMobType() == mtSpider) then
			Monster:TeleportToCoords(Monster:GetPosX(), Monster:GetPosY() + 100, Monster:GetPosZ());
		end
	end
);
</pre></p>
					]],
				},
			},
		},
		Globals =
		{
			Desc = [[
				These functions are available directly, without a class instance. Any plugin can call them at any
				time.
			]],
			Functions =
			{
				AddFaceDirection =
				{
					Params =
					{
						{
							Name = "BlockX",
							Type = "number",
						},
						{
							Name = "BlockY",
							Type = "number",
						},
						{
							Name = "BlockZ",
							Type = "number",
						},
						{
							Name = "BlockFace",
							Type = "eBlockFace",
						},
						{
							Name = "IsInverse",
							Type = "boolean",
							IsOptional = true,
						},
					},
					Returns =
					{
						{
							Name = "BlockX",
							Type = "number",
						},
						{
							Name = "BlockY",
							Type = "number",
						},
						{
							Name = "BlockZ",
							Type = "number",
						},
					},
					Notes = "Returns the coords of a block adjacent to the specified block through the specified {{Globals#BlockFaces|face}}",
				},
				BlockFaceToString =
				{
					Params =
					{
						{
							Name = "eBlockFace",
							Type = "eBlockFace",
						},
					},
					Returns =
					{
						{
							Type = "string",
						},
					},
					Notes = "Returns the string representation of the {{Globals#BlockFaces|eBlockFace}} constant. Uses the axis-direction-based names, such as BLOCK_FACE_XP.",
				},
				BlockStringToType =
				{
					Params =
					{
						{
							Name = "BlockTypeString",
							Type = "string",
						},
					},
					Returns =
					{
						{
							Name = "BLOCKTYPE",
							Type = "number",
						},
					},
					Notes = "Returns the block type parsed from the given string",
				},
				Clamp =
				{
					Params =
					{
						{
							Name = "Number",
							Type = "number",
						},
						{
							Name = "Min",
							Type = "number",
						},
						{
							Name = "Max",
							Type = "number",
						},
					},
					Returns =
					{
						{
							Type = "number",
						},
					},
					Notes = "Clamp the number to the specified range.",
				},
				ClickActionToString =
				{
					Params =
					{
						{
							Name = "ClickAction",
							Type = "eClickAction",
						},
					},
					Returns =
					{
						{
							Type = "string",
						},
					},
					Notes = "Returns a string description of the ClickAction enumerated value",
				},
				DamageTypeToString =
				{
					Params =
					{
						{
							Name = "DamageType",
							Type = "eDamageType",
						},
					},
					Returns =
					{
						{
							Type = "string",
						},
					},
					Notes = "Converts the {{Globals#eDamageType|DamageType}} to a string representation ",
				},
				EscapeString =
				{
					Params =
					{
						{
							Name = "Input",
							Type = "string",
						},
					},
					Returns =
					{
						{
							Type = "string",
						},
					},
					Notes = "Returns a copy of the string with all quotes and backslashes escaped by a backslash",
				},
				GetChar =
				{
					Params =
					{
						{
							Name = "Input",
							Type = "string",
						},
						{
							Name = "Index",
							Type = "number",
						},
					},
					Returns =
					{
						{
							Type = "string",
						},
					},
					Notes = "(<b>OBSOLETE</b>, use standard Lua string.sub() instead) Returns one character from the string, specified by index. ",
				},
				GetIniItemSet =
				{
					Params =
					{
						{
							Name = "IniFile",
							Type = "cIniFile",
						},
						{
							Name = "SectionName",
							Type = "string",
						},
						{
							Name = "KeyName",
							Type = "string",
						},
						{
							Name = "DefaultValue",
							Type = "string",
						},
					},
					Returns =
					{
						{
							Type = "cItem",
						},
					},
					Notes = "Returns the item that has been read from the specified INI file value. If the value is not present in the INI file, the DefaultValue is stored in the file and parsed as the result. Returns empty item if the value cannot be parsed. ",
				},
				GetTime =
				{
					Returns =
					{
						{
							Type = "number",
						},
					},
					Notes = "Returns the current OS time, as a unix time stamp (number of seconds since Jan 1, 1970)",
				},
				IsBiomeNoDownfall =
				{
					Params =
					{
						{
							Name = "Biome",
							Type = "EMCSBiome",
						},
					},
					Returns =
					{
						{
							Type = "boolean",
						},
					},
					Notes = "Returns true if the biome is 'dry', that is, there is no precipitation during rains and storms.",
				},
				IsValidBlock =
				{
					Params =
					{
						{
							Name = "BlockType",
							Type = "number",
						},
					},
					Returns =
					{
						{
							Type = "boolean",
						},
					},
					Notes = "Returns true if BlockType is a known block type",
				},
				IsValidItem =
				{
					Params =
					{
						{
							Name = "ItemType",
							Type = "number",
						},
					},
					Returns =
					{
						{
							Type = "boolean",
						},
					},
					Notes = "Returns true if ItemType is a known item type",
				},
				ItemToFullString =
				{
					Params =
					{
						{
							Name = "cItem",
							Type = "cItem",
						},
					},
					Returns =
					{
						{
							Type = "string",
						},
					},
					Notes = "Returns the string representation of the item, in the format 'ItemTypeText:ItemDamage * Count'",
				},
				ItemToString =
				{
					Params =
					{
						{
							Name = "cItem",
							Type = "cItem",
						},
					},
					Returns =
					{
						{
							Type = "string",
						},
					},
					Notes = "Returns the string representation of the item type",
				},
				ItemTypeToString =
				{
					Params =
					{
						{
							Name = "ItemType",
							Type = "number",
						},
					},
					Returns =
					{
						{
							Type = "string",
						},
					},
					Notes = "Returns the string representation of ItemType ",
				},
				LOG =
				{
					{
						Params =
						{
							{
								Name = "Message",
								Type = "string",
							},
						},
						Notes = "Logs a text into the server console and logfile using 'normal' severity (gray text)",
					},
					{
						Params =
						{
							{
								Name = "Message",
								Type = "cCompositeChat",
							},
						},
						Notes = "Logs the {{cCompositeChat}}'s human-readable text into the server console. The severity is converted from the CompositeChat's MessageType.",
					},
				},
				LOGERROR =
				{
					{
						Params =
						{
							{
								Name = "Message",
								Type = "string",
							},
						},
						Notes = "Logs a text into the server console and logfile using 'error' severity (black text on red background)",
					},
					{
						Params =
						{
							{
								Name = "Message",
								Type = "cCompositeChat",
							},
						},
						Notes = "Logs the {{cCompositeChat}}'s human-readable text into the server console and logfile using 'error' severity (black text on red background)",
					},
				},
				LOGINFO =
				{
					{
						Params =
						{
							{
								Name = "Message",
								Type = "string",
							},
						},
						Notes = "Logs a text into the server console and logfile using 'info' severity (yellow text)",
					},
					{
						Params =
						{
							{
								Name = "Message",
								Type = "cCompositeChat",
							},
						},
						Notes = "Logs the {{cCompositeChat}}'s human-readable text into the server console and logfile using 'info' severity (yellow text)",
					},
				},
				LOGWARN =
				{
					{
						Params =
						{
							{
								Name = "Message",
								Type = "string",
							},
						},
						Notes = "Logs a text into the server console and logfile using 'warning' severity (red text); OBSOLETE, use LOGWARNING() instead",
					},
					{
						Params =
						{
							{
								Name = "Message",
								Type = "cCompositeChat",
							},
						},
						Notes = "Logs the {{cCompositeChat}}'s human-readable text into the server console and logfile using 'warning' severity (red text); OBSOLETE, use LOGWARNING() instead",
					},
				},
				LOGWARNING =
				{
					{
						Params =
						{
							{
								Name = "Message",
								Type = "string",
							},
						},
						Notes = "Logs a text into the server console and logfile using 'warning' severity (red text)",
					},
					{
						Params =
						{
							{
								Name = "Message",
								Type = "cCompositeChat",
							},
						},
						Notes = "Logs the {{cCompositeChat}}'s human-readable text into the server console and logfile using 'warning' severity (red text)",
					},
				},
				md5 =
				{
					Params =
					{
						{
							Name = "Data",
							Type = "string",
						},
					},
					Returns =
					{
						{
							Type = "string",
						},
					},
					Notes = "<b>OBSOLETE</b>, use the {{cCryptoHash}} functions instead.<br>Converts a string to a raw binary md5 hash.",
				},
				MirrorBlockFaceY =
				{
					Params =
					{
						{
							Name = "eBlockFace",
							Type = "eBlockFace",
						},
					},
					Returns =
					{
						{
							Type = "eBlockFace",
						},
					},
					Notes = "Returns the {{Globals#BlockFaces|eBlockFace}} that corresponds to the given {{Globals#BlockFaces|eBlockFace}} after mirroring it around the Y axis (or rotating 180 degrees around it).",
				},
				NoCaseCompare =
				{
					Params =
					{
						{
							Name = "Value1",
							Type = "string",
						},
						{
							Name = "Value2",
							Type = "string",
						},
					},
					Returns =
					{
						{
							Type = "number",
						},
					},
					Notes = "Case-insensitive string comparison; returns 0 if the strings are the same, -1 if Value1 is smaller and 1 if Value2 is smaller",
				},
				NormalizeAngleDegrees =
				{
					Params =
					{
						{
							Name = "AngleDegrees",
							Type = "number",
						},
					},
					Returns =
					{
						{
							Name = "AngleDegrees",
							Type = "number",
						},
					},
					Notes = "Returns the angle, wrapped into the [-180, +180) range.",
				},
				ReplaceString =
				{
					Params =
					{
						{
							Name = "full-string",
							Type = "string",
						},
						{
							Name = "to-be-replaced-string",
							Type = "string",
						},
						{
							Name = "to-replace-string",
							Type = "string",
						},
					},
					Returns =
					{
						{
							Type = "string",
						},
					},
					Notes = "Replaces *each* occurence of to-be-replaced-string in full-string with to-replace-string",
				},
				RotateBlockFaceCCW =
				{
					Params =
					{
						{
							Name = "eBlockFace",
							Type = "eBlockFace",
						},
					},
					Returns =
					{
						{
							Type = "eBlockFace",
						},
					},
					Notes = "Returns the {{Globals#BlockFaces|eBlockFace}} that corresponds to the given {{Globals#BlockFaces|eBlockFace}} after rotating it around the Y axis 90 degrees counter-clockwise.",
				},
				RotateBlockFaceCW =
				{
					Params =
					{
						{
							Name = "eBlockFace",
							Type = "eBlockFace",
						},
					},
					Returns =
					{
						{
							Type = "eBlockFace",
						},
					},
					Notes = "Returns the {{Globals#BlockFaces|eBlockFace}} that corresponds to the given {{Globals#BlockFaces|eBlockFace}} after rotating it around the Y axis 90 degrees clockwise.",
				},
				StringSplit =
				{
					Params =
					{
						{
							Name = "Input",
							Type = "string",
						},
						{
							Name = "SeperatorsString",
							Type = "string",
						},
					},
					Returns =
					{
						{
							Type = "table",
						},
					},
					Notes = "Seperates string into multiple by splitting every time any of the characters in SeperatorsString is encountered. Returns and array-table of strings.",
				},
				StringSplitAndTrim =
				{
					Params =
					{
						{
							Name = "Input",
							Type = "string",
						},
						{
							Name = "SeperatorsString",
							Type = "string",
						},
					},
					Returns =
					{
						{
							Type = "table",
						},
					},
					Notes = "Seperates string into multiple by splitting every time any of the characters in SeperatorsString is encountered. Each of the separate strings is trimmed (whitespace removed from the beginning and end of the string). Returns an array-table of strings.",
				},
				StringSplitWithQuotes =
				{
					Params =
					{
						{
							Name = "Input",
							Type = "string",
						},
						{
							Name = "SeperatorsString",
							Type = "string",
						},
					},
					Returns =
					{
						{
							Type = "table",
						},
					},
					Notes = "Seperates string into multiple by splitting every time any of the characters in SeperatorsString is encountered. Whitespace wrapped with single or double quotes will be ignored. Returns an array-table of strings.",
				},
				StringToBiome =
				{
					Params =
					{
						{
							Name = "Input",
							Type = "string",
						},
					},
					Returns =
					{
						{
							Name = "BiomeType",
							Type = "Globals#BiomeTypes",
						},
					},
					Notes = "Converts a string representation to a {{Globals#BiomeTypes|BiomeType}} enumerated value. Returns biInvalidBiome if the input is not a recognized biome.",
				},
				StringToDamageType =
				{
					Params =
					{
						{
							Name = "Input",
							Type = "string",
						},
					},
					Returns =
					{
						{
							Name = "DamageType",
							Type = "Globals#DamageType",
						},
					},
					Notes = "Converts a string representation to a {{Globals#DamageType|DamageType}} enumerated value. Returns -1 if the inupt is not a recognized damage type.",
				},
				StringToDimension =
				{
					Params =
					{
						{
							Name = "Input",
							Type = "string",
						},
					},
					Returns =
					{
						{
							Name = "Dimension",
							Type = "Globals#WorldDimension",
						},
					},
					Notes = "Converts a string representation to a {{Globals#WorldDimension|Dimension}} enumerated value. Returns dimNotSet if the input is not a recognized dimension.",
				},
				StringToItem =
				{
					Params =
					{
						{
							Name = "StringToParse",
							Type = "string",
						},
						{
							Name = "DestItem",
							Type = "cItem",
						},
					},
					Returns =
					{
						{
							Type = "boolean",
						},
					},
					Notes = "Parses the item specification in the given string and sets it into DestItem; returns true if successful",
				},
				StringToMobType =
				{
					Params =
					{
						{
							Name = "MobTypeString",
							Type = "string",
						},
					},
					Returns =
					{
						{
							Name = "MobType",
							Type = "Globals#MobType",
						},
					},
					Notes = "(<b>DEPRECATED!</b>) Please use cMonster:StringToMobType(). Converts a string representation to a {{Globals#MobType|MobType}} enumerated value",
				},
				StripColorCodes =
				{
					Params =
					{
						{
							Name = "Input",
							Type = "string",
						},
					},
					Returns =
					{
						{
							Type = "string",
						},
					},
					Notes = "Removes all control codes used by MC for colors and styles",
				},
				TrimString =
				{
					Params =
					{
						{
							Name = "Input",
							Type = "string",
						},
					},
					Returns =
					{
						{
							Type = "string",
						},
					},
					Notes = "Removes whitespace at both ends of the string",
				},
			},
			Constants =
			{
				BLOCK_FACE_BOTTOM =
				{
					Notes = "Please use BLOCK_FACE_YM instead. Interacting with the bottom face of the block.",
				},
				BLOCK_FACE_EAST =
				{
					Notes = "Please use BLOCK_FACE_XM instead. Interacting with the eastern face of the block.",
				},
				BLOCK_FACE_MAX =
				{
					Notes = "Used for range checking - highest legal value for an {{Globals#eBlockFace|eBlockFace}}",
				},
				BLOCK_FACE_MIN =
				{
					Notes = "Used for range checking - lowest legal value for an {{Globals#eBlockFace|eBlockFace}}",
				},
				BLOCK_FACE_NONE =
				{
					Notes = "Interacting with no block face - swinging the item in the air",
				},
				BLOCK_FACE_NORTH =
				{
					Notes = "Please use BLOCK_FACE_ZM instead. Interacting with the northern face of the block.",
				},
				BLOCK_FACE_SOUTH =
				{
					Notes = "Please use BLOCK_FACE_ZP instead. Interacting with the southern face of the block.",
				},
				BLOCK_FACE_TOP =
				{
					Notes = "Please use BLOCK_FACE_YP instead. Interacting with the top face of the block.",
				},
				BLOCK_FACE_WEST =
				{
					Notes = "Please use BLOCK_FACE_XP instead. Interacting with the western face of the block.",
				},
				BLOCK_FACE_XM =
				{
					Notes = "Interacting with the X- face of the block",
				},
				BLOCK_FACE_XP =
				{
					Notes = "Interacting with the X+ face of the block",
				},
				BLOCK_FACE_YM =
				{
					Notes = "Interacting with the Y- face of the block",
				},
				BLOCK_FACE_YP =
				{
					Notes = "Interacting with the Y+ face of the block",
				},
				BLOCK_FACE_ZM =
				{
					Notes = "Interacting with the Z- face of the block",
				},
				BLOCK_FACE_ZP =
				{
					Notes = "Interacting with the Z+ face of the block",
				},
				DIG_STATUS_CANCELLED =
				{
					Notes = "The player has let go of the mine block key before finishing mining the block",
				},
				DIG_STATUS_DROP_HELD =
				{
					Notes = "The player has dropped a single item using the Drop Item key (default: Q)",
				},
				DIG_STATUS_DROP_STACK =
				{
					Notes = "The player has dropped a full stack of items using the Drop Item key (default: Q) while holding down a specific modifier key (in windows, control)",
				},
				DIG_STATUS_FINISHED =
				{
					Notes = "The player thinks that it has finished mining a block",
				},
				DIG_STATUS_SHOOT_EAT =
				{
					Notes = "The player has finished shooting a bow or finished eating",
				},
				DIG_STATUS_STARTED =
				{
					Notes = "The player has started digging",
				},
				DIG_STATUS_SWAP_ITEM_IN_HAND =
				{
					Notes = "The player has swapped their held item with the item in their offhand slot (1.9)",
				},
				E_META_DROPSPENSER_ACTIVATED =
				{
					Notes = "A flag in the metadata of droppers and dispensers that indicates that the dropper or dispenser is currently activated. If this flag is set, the block must be unpowered first and powered again to shoot the next item.",
				},
				E_META_DROPSPENSER_FACING_MASK =
				{
					Notes = "A mask that indicates the bits of the metadata that specify the facing of droppers and dispensers.",
				},
				E_META_DROPSPENSER_FACING_XM =
				{
					Notes = "A flag in the metadata of droppers and dispensers that indicates that the dropper or dispenser is looking in the negative X direction.",
				},
				E_META_DROPSPENSER_FACING_XP =
				{
					Notes = "A flag in the metadata of droppers and dispensers that indicates that the dropper or dispenser is looking in the positive X direction.",
				},
				E_META_DROPSPENSER_FACING_YM =
				{
					Notes = "A flag in the metadata of droppers and dispensers that indicates that the dropper or dispenser is looking in the negative Y direction.",
				},
				E_META_DROPSPENSER_FACING_YP =
				{
					Notes = "A flag in the metadata of droppers and dispensers that indicates that the dropper or dispenser is looking in the positive Y direction.",
				},
				E_META_DROPSPENSER_FACING_ZM =
				{
					Notes = "A flag in the metadata of droppers and dispensers that indicates that the dropper or dispenser is looking in the negative Z direction.",
				},
				E_META_DROPSPENSER_FACING_ZP =
				{
					Notes = "A flag in the metadata of droppers and dispensers that indicates that the dropper or dispenser is looking in the positive Z direction.",
				},
				esBed =
				{
					Notes = "A bed explosion. The SourceData param is the {{Vector3i|position}} of the bed.",
				},
				esEnderCrystal =
				{
					Notes = "An ender crystal entity explosion. The SourceData param is the {{cEntity|ender crystal entity}} object.",
				},
				esGhastFireball =
				{
					Notes = "A ghast fireball explosion. The SourceData param is the {{cGhastFireballEntity|ghast fireball entity}} object.",
				},
				esMonster =
				{
					Notes = "A monster explosion (creeper). The SourceData param is the {{cMonster|monster entity}} object.",
				},
				esOther =
				{
					Notes = "Any other explosion. The SourceData param is unused.",
				},
				esPlugin =
				{
					Notes = "An explosion started by a plugin, without any further information. The SourceData param is unused. ",
				},
				esPrimedTNT =
				{
					Notes = "A TNT explosion. The SourceData param is the {{cTNTEntity|TNT entity}} object.",
				},
				esWitherBirth =
				{
					Notes = "An explosion at a wither's birth. The SourceData param is the {{cMonster|wither entity}} object.",
				},
				esWitherSkull =
				{
					Notes = "A wither skull explosion. The SourceData param is the {{cWitherSkullEntity|wither skull entity}} object.",
				},
				mtCustom =
				{
					Notes = "Send raw data without any processing",
				},
				mtDeath =
				{
					Notes = "Denotes death of player",
				},
				mtError =
				{
					Notes = "Something could not be done (i.e. command not executed due to insufficient privilege)",
				},
				mtFail =
				{
					Notes = "Something could not be done (i.e. command not executed due to insufficient privilege)",
				},
				mtFailure =
				{
					Notes = "Something could not be done (i.e. command not executed due to insufficient privilege)",
				},
				mtFatal =
				{
					Notes = "Something catastrophic occured (i.e. plugin crash)",
				},
				mtInfo =
				{
					Notes = "Informational message (i.e. command usage)",
				},
				mtInformation =
				{
					Notes = "Informational message (i.e. command usage)",
				},
				mtJoin =
				{
					Notes = "A player has joined the server",
				},
				mtLeave =
				{
					Notes = "A player has left the server",
				},
				mtMaxPlusOne =
				{
					Notes = "The first invalid type, used for checking on LuaAPI boundaries",
				},
				mtPM =
				{
					Notes = "Player to player messaging identifier",
				},
				mtPrivateMessage =
				{
					Notes = "Player to player messaging identifier",
				},
				mtSuccess =
				{
					Notes = "Something executed successfully",
				},
				mtWarning =
				{
					Notes = "Something concerning (i.e. reload) is about to happen",
				},
			},
			ConstantGroups =
			{
				eBlockFace =
				{
					Include = "^BLOCK_FACE_.*",
					TextBefore = [[
						These constants are used to describe individual faces of the block. They are used when the
						client is interacting with a block in the {{OnPlayerBreakingBlock|HOOK_PLAYER_BREAKING_BLOCK}},
						{{OnPlayerBrokenBlock|HOOK_PLAYER_BROKEN_BLOCK}}, {{OnPlayerLeftClick|HOOK_PLAYER_LEFT_CLICK}},
						{{OnPlayerPlacedBlock|HOOK_PLAYER_PLACED_BLOCK}}, {{OnPlayerPlacingBlock|HOOK_PLAYER_PLACING_BLOCK}},
						{{OnPlayerRightClick|HOOK_PLAYER_RIGHT_CLICK}}, {{OnPlayerUsedBlock|HOOK_PLAYER_USED_BLOCK}},
						{{OnPlayerUsedItem|HOOK_PLAYER_USED_ITEM}}, {{OnPlayerUsingBlock|HOOK_PLAYER_USING_BLOCK}},
						and {{OnPlayerUsingItem|HOOK_PLAYER_USING_ITEM}} hooks, or when the {{cLineBlockTracer}} hits a
						block, etc.
					]],
				},
				eBlockType =
				{
					Include = "^E_BLOCK_.*",
					TextBefore = [[
						These constants are used for block types. They correspond directly with MineCraft's data values
						for blocks.
					]],
				},
				eClickAction =
				{
					Include = "^ca.*",
					TextBefore = [[
						These constants are used to signalize various interactions that the user can do with the
						{{cWindow|UI windows}}. The server translates the protocol events into these constants. Note
						that there is a global ClickActionToString() function that can translate these constants into
						their textual representation.
					]],
				},
				eDamageType =
				{
					Include = "^dt.*",
					TextBefore = [[
						These constants are used for specifying the cause of damage to entities. They are used in the
						{{TakeDamageInfo}} structure, as well as in {{cEntity}}'s damage-related API functions.
					]],
				},
				DigStatuses =
				{
					Include = "^DIG_STATUS_.*",
					TextBefore = [[
						These constants are used to describe digging statuses, but in reality cover several more cases.
						They are used with {{OnPlayerLeftClick|HOOK_PLAYER_LEFT_CLICK}}.
					]],
				},
				eDimension =
				{
					Include = "^dim.*",
					TextBefore = [[
						These constants represent dimension of a world. In Cuberite, the dimension is only reflected in
						the world's overall tint - overworld gets sky-like colors and dark shades, the nether gets
						reddish haze and the end gets dark haze. World generator is not directly affected by the
						dimension, same as fluid simulators; those only default to the expected values if not set
						specifically otherwise in the world.ini file.
					]],
				},
				eExplosionSource =
				{
					Include = "^es.*",
					TextBefore = [[
						These constants are used to differentiate the various sources of explosions. They are used in
						the {{OnExploded|HOOK_EXPLODED}} hook, {{OnExploding|HOOK_EXPLODING}} hook and in the
						{{cWorld}}:DoExplosionAt() function. These constants also dictate the type of the additional
						data provided with the explosions, such as the exploding creeper {{cEntity|entity}} or the
						{{Vector3i|coords}} of the exploding bed.
					]],
				},
				eGameMode =
				{
					Include =
					{
						"^gm.*",
						"^eGameMode_.*",
					},
					TextBefore = [[
						The following constants are used for the gamemode - survival, creative or adventure. Use the
						gmXXX constants, the eGameMode_ constants are deprecated and will be removed from the API.
					]],
				},
				EMCSBiome =
				{
					Include = "^bi.*",
					TextBefore = [[
						These constants represent the biomes that the server understands. Note that there is a global
						StringToBiome() function that can convert a string into one of these constants.
					]],
				},
				eMessageType =
				{
					-- Need to be specified explicitly, because there's also eMonsterType using the same "mt" prefix
					Include =
					{
						"mtCustom",
						"mtDeath",
						"mtError",
						"mtFail",
						"mtFailure",
						"mtFatal",
						"mtInfo",
						"mtInformation",
						"mtJoin",
						"mtLeave",
						"mtMaxPlusOne",
						"mtPrivateMessage",
						"mtPM",
						"mtSuccess",
						"mtWarning",
					},
					TextBefore = [[
						These constants are used together with messaging functions and classes, they specify the type of
						message being sent. The server can be configured to modify the message text (add prefixes) based
						on the message's type.
					]],
				},
				eMonsterType =
				{
					Include =
					{
						"mtInvalidType",
						"mtBat",
						"mtBlaze",
						"mtCaveSpider",
						"mtChicken",
						"mtCow",
						"mtCreeper",
						"mtEnderDragon",
						"mtEnderman",
						"mtGhast",
						"mtGiant",
						"mtGuardian",
						"mtHorse",
						"mtIronGolem",
						"mtMagmaCube",
						"mtMooshroom",
						"mtOcelot",
						"mtPig",
						"mtRabbit",
						"mtSheep",
						"mtSilverfish",
						"mtSkeleton",
						"mtSlime",
						"mtSnowGolem",
						"mtSpider",
						"mtSquid",
						"mtVillager",
						"mtWitch",
						"mtWither",
						"mtWolf",
						"mtZombie",
						"mtZombiePigman",
						"mtMax",
					},
					TextBefore = [[
						The following constants are used for distinguishing between the individual mob types:
					]],
				},
				eShrapnelLevel =
				{
					Include = "^sl.*",
					TextBefore = [[
						The following constants define the block types that are propelled outwards after an explosion.
					]],
				},
				eSpreadSource =
				{
					Include = "^ss.*",
					TextBefore = [[
						These constants are used to differentiate the various sources of spreads, such as grass growing.
						They are used in the {{OnBlockSpread|HOOK_BLOCK_SPREAD}} hook.
					]],
				},
				eWeather =
				{
					Include =
					{
						"^eWeather_.*",
						"wSunny",
						"wRain",
						"wStorm",
						"wThunderstorm",
					},
					TextBefore = [[
						These constants represent the weather in the world. Note that unlike vanilla, Cuberite allows
						different weathers even in non-overworld {{Globals#eDimension|dimensions}}.
					]],
				},
				ItemTypes =
				{
					Include = "^E_ITEM_.*",
					TextBefore = [[
						These constants are used for item types. They correspond directly with MineCraft's data values
						for items.
					]],
				},
				MetaValues =
				{
					Include = "^E_META_.*",
				},
			},
		},
		ItemCategory =
		{
			Desc = [[
				This class contains static functions for determining item categories. All of the functions are
				called directly on the class table, unlike most other object, which require an instance first.
			]],
			Functions =
			{
				IsArmor =
				{
					IsStatic = true,
					Params =
					{
						{
							Name = "ItemType",
							Type = "number",
						},
					},
					Returns =
					{
						{
							Type = "boolean",
						},
					},
					Notes = "Returns true if the specified item type is any kind of an armor.",
				},
				IsAxe =
				{
					IsStatic = true,
					Params =
					{
						{
							Name = "ItemType",
							Type = "number",
						},
					},
					Returns =
					{
						{
							Type = "boolean",
						},
					},
					Notes = "Returns true if the specified item type is any kind of an axe.",
				},
				IsBoots =
				{
					IsStatic = true,
					Params =
					{
						{
							Name = "ItemType",
							Type = "number",
						},
					},
					Returns =
					{
						{
							Type = "boolean",
						},
					},
					Notes = "Returns true if the specified item type is any kind of boots.",
				},
				IsChestPlate =
				{
					IsStatic = true,
					Params =
					{
						{
							Name = "ItemType",
							Type = "number",
						},
					},
					Returns =
					{
						{
							Type = "boolean",
						},
					},
					Notes = "Returns true if the specified item type is any kind of a chestplate.",
				},
				IsHelmet =
				{
					IsStatic = true,
					Params =
					{
						{
							Name = "ItemType",
							Type = "number",
						},
					},
					Returns =
					{
						{
							Type = "boolean",
						},
					},
					Notes = "Returns true if the specified item type is any kind of a helmet.",
				},
				IsHoe =
				{
					IsStatic = true,
					Params =
					{
						{
							Name = "ItemType",
							Type = "number",
						},
					},
					Returns =
					{
						{
							Type = "boolean",
						},
					},
					Notes = "Returns true if the specified item type is any kind of a hoe.",
				},
				IsLeggings =
				{
					IsStatic = true,
					Params =
					{
						{
							Name = "ItemType",
							Type = "number",
						},
					},
					Returns =
					{
						{
							Type = "boolean",
						},
					},
					Notes = "Returns true if the specified item type is any kind of a leggings.",
				},
				IsMinecart =
				{
					IsStatic = true,
					Params =
					{
						{
							Name = "ItemType",
							Type = "number",
						},
					},
					Returns =
					{
						{
							Type = "boolean",
						},
					},
					Notes = "Returns true if the specified item type is any kind of a minecart.",
				},
				IsPickaxe =
				{
					IsStatic = true,
					Params =
					{
						{
							Name = "ItemType",
							Type = "number",
						},
					},
					Returns =
					{
						{
							Type = "boolean",
						},
					},
					Notes = "Returns true if the specified item type is any kind of a pickaxe.",
				},
				IsShovel =
				{
					IsStatic = true,
					Params =
					{
						{
							Name = "ItemType",
							Type = "number",
						},
					},
					Returns =
					{
						{
							Type = "boolean",
						},
					},
					Notes = "Returns true if the specified item type is any kind of a shovel.",
				},
				IsSword =
				{
					IsStatic = true,
					Params =
					{
						{
							Name = "ItemType",
							Type = "number",
						},
					},
					Returns =
					{
						{
							Type = "boolean",
						},
					},
					Notes = "Returns true if the specified item type is any kind of a sword.",
				},
				IsTool =
				{
					IsStatic = true,
					Params =
					{
						{
							Name = "ItemType",
							Type = "number",
						},
					},
					Returns =
					{
						{
							Type = "boolean",
						},
					},
					Notes = "Returns true if the specified item type is any kind of a tool (axe, hoe, pickaxe, shovel or FIXME: sword)",
				},
			},
			AdditionalInfo =
			{
				{
					Header = "Code example",
					Contents = [[
						The following code snippet checks if the player holds a shovel.
<pre class="prettyprint lang-lua">
-- a_Player is a {{cPlayer}} object, possibly received as a hook param
local HeldItem = a_Player:GetEquippedItem()
if (ItemCategory.IsShovel(HeldItem.m_ItemType)) then
	-- It's a shovel
end
</pre>
					]],
				},
			},
		},
		lxp =
		{
			Desc = [[
				This class provides an interface to the XML parser,
				{{http://matthewwild.co.uk/projects/luaexpat/|LuaExpat}}. It provides a SAX interface with an
				incremental XML parser.</p>
				<p>
				With an event-based API like SAX the XML document can be fed to the parser in chunks, and the
				parsing begins as soon as the parser receives the first document chunk. LuaExpat reports parsing
				events (such as the start and end of elements) directly to the application through callbacks. The
				parsing of huge documents can benefit from this piecemeal operation.</p>
				<p>
				See the online
				{{http://matthewwild.co.uk/projects/luaexpat/manual.html#parser|LuaExpat documentation}} for details
				on how to work with this parser. The code examples below should provide some basic help, too.
			]],
			Functions =
			{
				new =
				{
					Params =
					{
						{
							Name = "CallbacksTable",
							Type = "table",
						},
						{
							Name = "SeparatorChar",
							Type = "string",
							IsOptional = true,
						},
					},
					Returns =
					{
						{
							Name = "XMLParser object",
							Type = "table",
						},
					},
					Notes = "Creates a new XML parser object, with the specified callbacks table and optional separator character.",
				},
			},
			Constants =
			{
				_COPYRIGHT =
				{
					Notes = "",
				},
				_DESCRIPTION =
				{
					Notes = "",
				},
				_VERSION =
				{
					Notes = "",
				},
			},
			AdditionalInfo =
			{
				{
					Header = "Parser callbacks",
					Contents = [[
						The callbacks table passed to the new() function specifies the Lua functions that the parser
						calls upon various events. The following table lists the most common functions used, for a
						complete list see the online
						{{http://matthewwild.co.uk/projects/luaexpat/manual.html#parser|LuaExpat documentation}}.</p>
						<table>
						<tr><th>Function name</th><th>Parameters</th><th>Notes</th></tr>
						<tr><td>CharacterData</td><td>Parser, string</td><td>Called when the parser recognizes a raw string inside the element</td></tr>
						<tr><td>EndElement</td><td>Parser, ElementName</td><td>Called when the parser detects the ending of an XML element</td></tr>
						<tr><td>StartElement</td><td>Parser, ElementName, AttributesTable</td><td>Called when the parser detects the start of an XML element. The AttributesTable is a Lua table containing all the element's attributes, both in the array section (in the order received) and in the dictionary section.</td></tr>
						</table>
					]],
				},
				{
					Header = "XMLParser object",
					Contents = [[
						The XMLParser object returned by lxp.new provides the functions needed to parse the XML. The
						following list provides the most commonly used ones, for a complete list see the online
						{{http://matthewwild.co.uk/projects/luaexpat/manual.html#parser|LuaExpat documentation}}.
						<ul>
							<li>close() - closes the parser, freeing all memory used by it.</li>
							<li>getCallbacks() - returns the callbacks table for this parser.</li>
							<li>parse(string) - parses more document data. the string contains the next part (or possibly all) of the document. Returns non-nil for success or nil, msg, line, col, pos for error.</li>
							<li>stop() - aborts parsing (can be called from within the parser callbacks).</li>
						</ul>
					]],
				},
				{
					Header = "Code example",
					Contents = [[
						The following code reads an entire XML file and outputs its logical structure into the console:
<pre class="prettyprint lang-lua">
local Depth = 0;

-- Define the callbacks:
local Callbacks = {
	CharacterData = function(a_Parser, a_String)
		LOG(string.rep(" ", Depth) .. "* " .. a_String);
	end

	EndElement = function(a_Parser, a_ElementName)
		Depth = Depth - 1;
		LOG(string.rep(" ", Depth) .. "- " .. a_ElementName);
	end

	StartElement = function(a_Parser, a_ElementName, a_Attribs)
		LOG(string.rep(" ", Depth) .. "+ " .. a_ElementName);
		Depth = Depth + 1;
	end
}

-- Create the parser:
local Parser = lxp.new(Callbacks);

-- Parse the XML file:
local f = io.open("file.xml", "rb");
while (true) do
	local block = f:read(128 * 1024);  -- Use a 128KiB buffer for reading
	if (block == nil) then
		-- End of file
		break;
	end
	Parser:parse(block);
end

-- Signalize to the parser that no more data is coming
Parser:parse();

-- Close the parser:
Parser:close();
</pre>
					]],
				},
			},
		},
		sqlite3 =
		{
			Desc = [[
			]],
			Functions =
			{
				complete =
				{
					IsStatic = true,
					IsGlobal = true,  -- Emulate a global function without a self parameter - this is called with a dot convention
					Params =
					{
						{
							Name = "SQL",
							Type = "string",
						},
					},
					Returns =
					{
						{
							Type = "boolean",
						},
					},
					Notes = "Returns true if the input string comprises one or more complete SQL statements.",
				},
				open =
				{
					IsStatic = true,
					IsGlobal = true,  -- Emulate a global function without a self parameter - this is called with a dot convention
					Params =
					{
						{
							Name = "FileName",
							Type = "string",
						},
					},
					Returns =
					{
						{
							Name = "DBClass",
							Type = "SQLite DB object",
						},
					},
					Notes = [[
					Opens (or creates if it does not exist) an SQLite database with name filename and returns its
					handle (the returned object should be used for all further method calls in connection
					with this specific database, see
					{{http://lua.sqlite.org/index.cgi/doc/tip/doc/lsqlite3.wiki#database_methods|Database methods}}).
					Example:
<pre class="prettyprint lang-lua">
-- open the database:
myDB = sqlite3.open('MyDatabaseFile.sqlite3')

-- do some database calls...

-- Close the database:
myDB:close()
</pre>
				]],
				},
				open_memory =
				{
					IsStatic = true,
					IsGlobal = true,  -- Emulate a global function without a self parameter - this is called with a dot convention
					Returns =
					{
						{
							Name = "DBClass",
							Type = "SQLite DB object",
						},
					},
					Notes = "Opens an SQLite database in memory and returns its handle. In case of an error, the function returns nil, an error code and an error message. (In-memory databases are volatile as they are never stored on disk.)",
				},
				version =
				{
					IsStatic = true,
					IsGlobal = true,  -- Emulate a global function without a self parameter - this is called with a dot convention
					Returns =
					{
						{
							Type = "string",
						},
					},
					Notes = "Returns a string with SQLite version information, in the form 'x.y[.z]'.",
				},
			},
		},
		TakeDamageInfo =
		{
			Desc = [[
				This class contains the amount of damage, and the entity that caused the damage. It is used in the
				{{OnTakeDamage|HOOK_TAKE_DAMAGE}} hook and in the {{cEntity}}'s TakeDamage() function.
			]],
			Variables =
			{
				Attacker =
				{
					Type = "{{cEntity}}",
					Notes = "The entity who is attacking. Only valid if dtAttack.",
				},
				DamageType =
				{
					Type = "eDamageType",
					Notes = "Source of the damage. One of the dtXXX constants.",
				},
				FinalDamage =
				{
					Type = "number",
					Notes = "The final amount of damage that will be applied to the Receiver. It is the RawDamage minus any Receiver's armor-protection.",
				},
				Knockback =
				{
					Type = "{{Vector3d}}",
					Notes = "Vector specifying the amount and direction of knockback that will be applied to the Receiver ",
				},
				RawDamage =
				{
					Type = "number",
					Notes = "Amount of damage that the attack produces on the Receiver, including the Attacker's equipped weapon, but excluding the Receiver's armor.",
				},
			},
			AdditionalInfo =
			{
				{
					Header = "",
					Contents = [[
						The TDI is passed as the second parameter in the HOOK_TAKE_DAMAGE hook, and can be used to
						modify the damage before it is applied to the receiver:
<pre class="prettyprint lang-lua">
function OnTakeDamage(Receiver, TDI)
	LOG("Damage: Raw ".. TDI.RawDamage .. ", Final:" .. TDI.FinalDamage);

	-- If the attacker is a spider, make it deal 999 points of damage (insta-death spiders):
	if ((TDI.Attacker ~= nil) and TDI.Attacker:IsA("cSpider")) then
		TDI.FinalDamage = 999;
	end
end
</pre>
					]],
				},
			},
		},
		tolua =
		{
			Desc = [[
				This class represents the tolua bridge between the Lua API and Cuberite. It supports some low
				level operations and queries on the objects. See also the tolua++'s documentation at
				{{http://www.codenix.com/~tolua/tolua++.html#utilities}}. Normally you shouldn't use any of these
				functions except for type()
			]],
			Functions =
			{
				cast =
				{
					Params =
					{
						{
							Name = "Object",
							Type = "any",
						},
						{
							Name = "TypeStr",
							Type = "string",
						},
					},
					Returns =
					{
						{
							Name = "Object",
							Type = "any",
						},
					},
					Notes = "Casts the object to the specified type.<br/><b>Note:</b> This is a potentially unsafe operation and it could crash the server. There is normally no need to use this function at all, so don't use it unless you know exactly what you're doing.",
				},
				getpeer =
				{
					Notes = "",
				},
				inherit =
				{
					Notes = "",
				},
				releaseownership =
				{
					Notes = "",
				},
				setpeer =
				{
					Notes = "",
				},
				takeownership =
				{
					Notes = "",
				},
				type =
				{
					Params =
					{
						{
							Name = "Object",
							Type = "any",
						},
					},
					Returns =
					{
						{
							Name = "TypeStr",
							Type = "string",
						},
					},
					Notes = "Returns a string representing the type of the object. This works similar to Lua's built-in type() function, but recognizes the underlying C++ classes, too.",
				},
			},
		},
	},
	ExtraPages =
	{
		{
			FileName = "Writing-a-Cuberite-plugin.html",
			Title = "Writing a Cuberite plugin",
		},
		{
			FileName = "InfoFile.html",
			Title = "Using the Info.lua file",
		},
		{
			FileName = "SettingUpDecoda.html",
			Title = "Setting up the Decoda Lua IDE",
		},
		{
			FileName = "SettingUpZeroBrane.html",
			Title = "Setting up the ZeroBrane Studio Lua IDE",
		},
		{
			FileName = "UsingChunkStays.html",
			Title = "Using ChunkStays",
		},
		{
			FileName = "WebWorldThreads.html",
			Title = "Webserver vs World threads",
		},
	},
	IgnoreClasses =
	{
		"^coroutine$",
		"^g_TrackedPages$",
		"^debug$",
		"^io$",
		"^math$",
		"^package$",
		"^os$",
		"^string$",
		"^table$",
		"^g_Stats$",
	},
	IgnoreFunctions =
	{
		"Globals.assert",
		"%a+%.delete",
		"CreateAPITables",
		"DumpAPIHtml",
		"DumpAPITxt",
		"Initialize",
		"LinkifyString",
		"ListMissingPages",
		"ListUndocumentedObjects",
		"ListUnexportedObjects",
		"LoadAPIFiles",
		"Globals.collectgarbage",
		"ReadDescriptions",
		"ReadHooks",
		"WriteHtmlClass",
		"WriteHtmlHook",
		"WriteStats",
		"Globals.xpcall",
		"Globals.decoda_output",
		"sqlite3.__newindex",
		"%a+%.__%a+",
		"%a+%.%.collector",
		"%a+%.new",
		"%a+%.new_local",
	},
	IgnoreConstants =
	{
		"cChestEntity.__cBlockEntityWindowOwner__",
		"cDropSpenserEntity.__cBlockEntityWindowOwner__",
		"cFurnaceEntity.__cBlockEntityWindowOwner__",
		"cHopperEntity.__cBlockEntityWindowOwner__",
		"cLuaWindow.__cItemGrid__cListener__",
		"Globals._CuberiteInternal_.*",
		"Globals.esMax",
	},
	IgnoreVariables =
	{
		"__.*__",
	},
}
