-- APIDesc.lua

-- Contains the API objects' descriptions




g_APIDesc =
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
				FunctionName = { Params = "Parameter list", Return = "Return values list", Notes = "Notes" ),
				OverloadedFunctionName =  -- When a function supports multiple parameter variants
				{
					{ Params = "Parameter list 1", Return = "Return values list 1", Notes = "Notes 1" },
					{ Params = "Parameter list 2", Return = "Return values list 2", Notes = "Notes 2" },
				}
			} ,

			Constants =
			{
				ConstantName = { Notes = "Notes about the constant" },
			} ,

			ConstantGroups =
			{
				GroupName1 =  -- GroupName1 is used as the HTML anchor name
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
		]]--

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
				constructor = { Params = "", Return = "cBlockArea", Notes = "Creates a new empty cBlockArea object" },
				Clear = { Params = "", Return = "", Notes = "Clears the object, resets it to zero size" },
				CopyFrom = { Params = "BlockAreaSrc", Return = "", Notes = "Copies contents from BlockAreaSrc into self" },
				CopyTo = { Params = "BlockAreaDst", Return = "", Notes = "Copies contents from self into BlockAreaDst." },
				CountNonAirBlocks = { Params = "", Return = "number", Notes = "Returns the count of blocks that are not air. Returns 0 if blocktypes not available. Block metas are ignored (if present, air with any meta is still considered air)." },
				CountSpecificBlocks =
				{
					{ Params = "BlockType", Return = "number", Notes = "Counts the number of occurences of the specified blocktype contained in the area." },
					{ Params = "BlockType, BlockMeta", Return = "number", Notes = "Counts the number of occurrences of the specified blocktype + blockmeta combination contained in the area." },
				},
				Create = { Params = "SizeX, SizeY, SizeZ, [DataTypes]", Return = "", Notes = "Initializes this BlockArea to an empty area of the specified size and origin of {0, 0, 0}. Any previous contents are lost." },
				Crop = { Params = "AddMinX, SubMaxX, AddMinY, SubMaxY, AddMinZ, SubMaxZ", Return = "", Notes = "Crops the specified number of blocks from each border. Modifies the size of this blockarea object." },
				DumpToRawFile = { Params = "FileName", Return = "", Notes = "Dumps the raw data into a file. For debugging purposes only." },
				Expand = { Params = "SubMinX, AddMaxX, SubMinY, AddMaxY, SubMinZ, AddMaxZ", Return = "", Notes = "Expands the specified number of blocks from each border. Modifies the size of this blockarea object. New blocks created with this operation are filled with zeroes." },
				Fill = { Params = "DataTypes, BlockType, [BlockMeta], [BlockLight], [BlockSkyLight]", Return = "", Notes = "Fills the entire block area with the same values, specified. Uses the DataTypes param to determine which content types are modified." },
				FillRelCuboid =
				{
					{ Params = "{{cCuboid|RelCuboid}}, DataTypes, BlockType, [BlockMeta], [BlockLight], [BlockSkyLight]", Return = "", Notes = "Fills the specified cuboid (in relative coords) with the same values (like Fill() )." },
					{ Params = "MinRelX, MaxRelX, MinRelY, MaxRelY, MinRelZ, MaxRelZ, DataTypes, BlockType, [BlockMeta], [BlockLight], [BlockSkyLight]", Return = "", Notes = "Fills the specified cuboid with the same values (like Fill() )." },
				},
				GetBlockLight = { Params = "BlockX, BlockY, BlockZ", Return = "NIBBLETYPE", Notes = "Returns the blocklight at the specified absolute coords" },
				GetBlockMeta = { Params = "BlockX, BlockY, BlockZ", Return = "NIBBLETYPE", Notes = "Returns the block meta at the specified absolute coords" },
				GetBlockSkyLight = { Params = "BlockX, BlockY, BlockZ", Return = "NIBBLETYPE", Notes = "Returns the skylight at the specified absolute coords" },
				GetBlockType = { Params = "BlockX, BlockY, BlockZ", Return = "BLOCKTYPE", Notes = "Returns the block type at the specified absolute coords" },
				GetBlockTypeMeta = { Params = "BlockX, BlockY, BlockZ", Return = "BLOCKTYPE, NIBBLETYPE", Notes = "Returns the block type and meta at the specified absolute coords" },
				GetCoordRange = {Params = "", Return = "MaxX, MaxY, MaxZ", Notes = "Returns the maximum relative coords in all 3 axes. See also GetSize()." },
				GetDataTypes = { Params = "", Return = "number", Notes = "Returns the mask of datatypes that the object is currently holding" },
				GetOrigin = { Params = "", Return = "OriginX, OriginY, OriginZ", Notes = "Returns the origin coords of where the area was read from." },
				GetOriginX = { Params = "", Return = "number", Notes = "Returns the origin x-coord" },
				GetOriginY = { Params = "", Return = "number", Notes = "Returns the origin y-coord" },
				GetOriginZ = { Params = "", Return = "number", Notes = "Returns the origin z-coord" },
				GetNonAirCropRelCoords = { Params = "[IgnoreBlockType]", Return = "MinRelX, MinRelY, MinRelZ, MaxRelX, MaxRelY, MaxRelZ", Notes = "Returns the minimum and maximum coords in each direction for the first non-ignored block in each direction. If there are no non-ignored blocks within the area, or blocktypes are not present, the returned values are reverse-ranges (MinX <- m_RangeX, MaxX <- 0 etc.). IgnoreBlockType defaults to air." },
				GetRelBlockLight = { Params = "RelBlockX, RelBlockY, RelBlockZ", Return = "NIBBLETYPE", Notes = "Returns the blocklight at the specified relative coords" },
				GetRelBlockMeta = { Params = "RelBlockX, RelBlockY, RelBlockZ", Return = "NIBBLETYPE", Notes = "Returns the block meta at the specified relative coords" },
				GetRelBlockSkyLight = { Params = "RelBlockX, RelBlockY, RelBlockZ", Return = "NIBBLETYPE", Notes = "Returns the skylight at the specified relative coords" },
				GetRelBlockType = { Params = "RelBlockX, RelBlockY, RelBlockZ", Return = "BLOCKTYPE", Notes = "Returns the block type at the specified relative coords" },
				GetRelBlockTypeMeta = { Params = "RelBlockX, RelBlockY, RelBlockZ", Return = "BLOCKTYPE, NIBBLETYPE", Notes = "Returns the block type and meta at the specified relative coords" },
				GetSize = { Params = "", Return = "SizeX, SizeY, SizeZ", Notes = "Returns the size of the area in all 3 axes. See also GetCoordRange()." },
				GetSizeX = { Params = "", Return = "number", Notes = "Returns the size of the held data in the x-axis" },
				GetSizeY = { Params = "", Return = "number", Notes = "Returns the size of the held data in the y-axis" },
				GetSizeZ = { Params = "", Return = "number", Notes = "Returns the size of the held data in the z-axis" },
				GetVolume = { Params = "", Return = "number", Notes = "Returns the volume of the area - the total number of blocks stored within." },
				GetWEOffset = { Params = "", Return = "{{Vector3i}}", Notes = "Returns the WE offset, a data value sometimes stored in the schematic files. Cuberite doesn't use this value, but provides access to it using this method. The default is {0, 0, 0}."},
				HasBlockLights = { Params = "", Return = "bool", Notes = "Returns true if current datatypes include blocklight" },
				HasBlockMetas = { Params = "", Return = "bool", Notes = "Returns true if current datatypes include block metas" },
				HasBlockSkyLights = { Params = "", Return = "bool", Notes = "Returns true if current datatypes include skylight" },
				HasBlockTypes = { Params = "", Return = "bool", Notes = "Returns true if current datatypes include block types" },
				LoadFromSchematicFile = { Params = "FileName", Return = "", Notes = "Clears current content and loads new content from the specified schematic file. Returns true if successful. Returns false and logs error if unsuccessful, old content is preserved in such a case." },
				LoadFromSchematicString = { Params = "SchematicData", Return = "", Notes = "Clears current content and loads new content from the specified string (assumed to contain .schematic data). Returns true if successful. Returns false and logs error if unsuccessful, old content is preserved in such a case." },
				Merge =
				{
					{ Params = "BlockAreaSrc, {{Vector3i|RelMinCoords}}, Strategy", Return = "", Notes = "Merges BlockAreaSrc into this object at the specified relative coords, using the specified strategy" },
					{ Params = "BlockAreaSrc, RelX, RelY, RelZ, Strategy", Return = "", Notes = "Merges BlockAreaSrc into this object at the specified relative coords, using the specified strategy" },
				},
				MirrorXY = { Params = "", Return = "", Notes = "Mirrors this block area around the XY plane. Modifies blocks' metas (if present) to match (i. e. furnaces facing the opposite direction)." },
				MirrorXYNoMeta = { Params = "", Return = "", Notes = "Mirrors this block area around the XY plane. Doesn't modify blocks' metas." },
				MirrorXZ = { Params = "", Return = "", Notes = "Mirrors this block area around the XZ plane. Modifies blocks' metas (if present)" },
				MirrorXZNoMeta = { Params = "", Return = "", Notes = "Mirrors this block area around the XZ plane. Doesn't modify blocks' metas." },
				MirrorYZ = { Params = "", Return = "", Notes = "Mirrors this block area around the YZ plane. Modifies blocks' metas (if present)" },
				MirrorYZNoMeta = { Params = "", Return = "", Notes = "Mirrors this block area around the YZ plane. Doesn't modify blocks' metas." },
				Read =
				{
					{ Params = "World, {{cCuboid|Cuboid}}, DataTypes", Return = "bool", Notes = "Reads the area from World, returns true if successful" },
					{ Params = "World, {{Vector3i|Point1}}, {{Vector3i|Point2}}, DataTypes", Return = "bool", Notes = "Reads the area from World, returns true if successful" },
					{ Params = "World, X1, X2, Y1, Y2, Z1, Z2, DataTypes", Return = "bool", Notes = "Reads the area from World, returns true if successful" },
				},
				RelLine =
				{
					{ Params = "{{Vector3i|RelPoint1}}, {{Vector3i|RelPoint2}}, DataTypes, BlockType, [BlockMeta], [BlockLight], [BlockSkyLight]", Return = "", Notes = "Draws a line between the two specified points. Sets only datatypes specified by DataTypes (baXXX constants)." },
					{ Params = "RelX1, RelY1, RelZ1, RelX2, RelY2, RelZ2, DataTypes, BlockType, [BlockMeta], [BlockLight], [BlockSkyLight]", Return = "", Notes = "Draws a line between the two specified points. Sets only datatypes specified by DataTypes (baXXX constants)." },
				},
				RotateCCW = { Params = "", Return = "", Notes = "Rotates the block area around the Y axis, counter-clockwise (east -> north). Modifies blocks' metas (if present) to match." },
				RotateCCWNoMeta = { Params = "", Return = "", Notes = "Rotates the block area around the Y axis, counter-clockwise (east -> north). Doesn't modify blocks' metas." },
				RotateCW = { Params = "", Return = "", Notes = "Rotates the block area around the Y axis, clockwise (north -> east). Modifies blocks' metas (if present) to match." },
				RotateCWNoMeta = { Params = "", Return = "", Notes = "Rotates the block area around the Y axis, clockwise (north -> east). Doesn't modify blocks' metas." },
				SaveToSchematicFile = { Params = "FileName", Return = "", Notes = "Saves the current contents to a schematic file. Returns true if successful." },
				SaveToSchematicString = { Params = "", Return = "string", Notes = "Saves the current contents to a string (in a .schematic file format). Returns the data if successful, nil if failed." },
				SetBlockLight = { Params = "BlockX, BlockY, BlockZ, BlockLight", Return = "", Notes = "Sets the blocklight at the specified absolute coords" },
				SetBlockMeta = { Params = "BlockX, BlockY, BlockZ, BlockMeta", Return = "", Notes = "Sets the block meta at the specified absolute coords" },
				SetBlockSkyLight = { Params = "BlockX, BlockY, BlockZ, SkyLight", Return = "", Notes = "Sets the skylight at the specified absolute coords" },
				SetBlockType = { Params = "BlockX, BlockY, BlockZ, BlockType", Return = "", Notes = "Sets the block type at the specified absolute coords" },
				SetBlockTypeMeta = { Params = "BlockX, BlockY, BlockZ, BlockType, BlockMeta", Return = "", Notes = "Sets the block type and meta at the specified absolute coords" },
				SetOrigin =
				{
					{ Params = "{{Vector3i|Origin}}", Return = "", Notes = "Resets the origin for the absolute coords. Only affects how absolute coords are translated into relative coords." },
					{ Params = "OriginX, OriginY, OriginZ", Return = "", Notes = "Resets the origin for the absolute coords. Only affects how absolute coords are translated into relative coords." },
				},
				SetRelBlockLight = { Params = "RelBlockX, RelBlockY, RelBlockZ, BlockLight", Return = "", Notes = "Sets the blocklight at the specified relative coords" },
				SetRelBlockMeta = { Params = "RelBlockX, RelBlockY, RelBlockZ, BlockMeta", Return = "", Notes = "Sets the block meta at the specified relative coords" },
				SetRelBlockSkyLight = { Params = "RelBlockX, RelBlockY, RelBlockZ, SkyLight", Return = "", Notes = "Sets the skylight at the specified relative coords" },
				SetRelBlockType = { Params = "RelBlockX, RelBlockY, RelBlockZ, BlockType", Return = "", Notes = "Sets the block type at the specified relative coords" },
				SetRelBlockTypeMeta = { Params = "RelBlockX, RelBlockY, RelBlockZ, BlockType, BlockMeta", Return = "", Notes = "Sets the block type and meta at the specified relative coords" },
				SetWEOffset =
				{
					{ Params = "{{Vector3i|Offset}}", Return = "", Notes = "Sets the WE offset, a data value sometimes stored in the schematic files. Mostly used for WorldEdit. Cuberite doesn't use this value, but provides access to it using this method." },
					{ Params = "OffsetX, OffsetY, OffsetZ", Return = "", Notes = "Sets the WE offset, a data value sometimes stored in the schematic files. Mostly used for WorldEdit. Cuberite doesn't use this value, but provides access to it using this method." },
				},
				Write =
				{
					{ Params = "World, {{Vector3i|MinPoint}}, DataTypes", Return = "bool", Notes = "Writes the area into World at the specified coords, returns true if successful" },
					{ Params = "World, MinX, MinY, MinZ, DataTypes", Return = "bool", Notes = "Writes the area into World at the specified coords, returns true if successful" },
				},
			},
			Constants =
			{
				baTypes = { Notes = "Operation should work on block types" },
				baMetas = { Notes = "Operations should work on block metas" },
				baLight = { Notes = "Operations should work on block (emissive) light" },
				baSkyLight = { Notes = "Operations should work on skylight" },
				msDifference = { Notes = "Block becomes air if 'self' and src are the same. Otherwise it becomes the src block." },
				msFillAir = { Notes = "'self' is overwritten by Src only where 'self' has air blocks" },
				msImprint = { Notes = "Src overwrites 'self' anywhere where 'self' has non-air blocks" },
				msLake = { Notes = "Special mode for merging lake images" },
				msMask = { Notes = "The blocks that are exactly the same are kept in 'self', all differing blocks are replaced by air"},
				msOverwrite = { Notes = "Src overwrites anything in 'self'" },
				msSimpleCompare = { Notes = "The blocks that are exactly the same are replaced with air, all differing blocks are replaced by stone"},
				msSpongePrint = { Notes = "Similar to msImprint, sponge block doesn't overwrite anything, all other blocks overwrite everything"},
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
					TextBefore = [[
						The Merge() function can use different strategies to combine the source and destination blocks.
						The following constants are used:
					]],
					TextAfter = "See below for a detailed explanation of the individual merge strategies.",
				},
			},
			AdditionalInfo =
			{
				{
					Header = "Merge strategies",
					Contents =
					[[
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
				},  -- Merge strategies
			},  -- AdditionalInfo
		},  -- cBlockArea

		cBlockInfo =
		{
			Desc = [[
				This class is used to query and register block properties.
			]],
			Functions =
			{
				CanBeTerraformed = { Params = "Type", Return = "bool", Notes = "(STATIC) Returns true if the block is suitable to be changed by a generator" },
				FullyOccupiesVoxel = { Params = "Type", Return = "bool", Notes = "(STATIC) Returns whether the specified block fully occupies its voxel." },
				Get = { Params = "Type", Return = "{{cBlockInfo}}", Notes = "(STATIC) Returns the {{cBlockInfo}} structure for the specified type." },
				GetLightValue = { Params = "Type", Return = "number", Notes = "(STATIC) Returns how much light the specified block emits on its own." },
				GetPlaceSound = { Params = "Type", Return = "", Notes = "(STATIC) Returns the name of the sound that is played when placing the block." },
				GetSpreadLightFalloff = { Params = "Type", Return = "number", Notes = "(STATIC) Returns how much light the specified block consumes." },
				IsOneHitDig = { Params = "Type", Return = "bool", Notes = "(STATIC) Returns whether the specified block will be destroyed after a single hit." },
				IsPistonBreakable = { Params = "Type", Return = "bool", Notes = "(STATIC) Returns whether a piston can break the specified block." },
				IsSnowable = { Params = "Type", Return = "bool", Notes = "(STATIC) Returns whether the specified block can hold snow atop." },
				IsSolid = { Params = "Type", Return = "bool", Notes = "(STATIC) Returns whether the specified block is solid." },
				IsTransparent = { Params = "Type", Return = "bool", Notes = "(STATIC) Returns whether the specified block is transparent." },
				RequiresSpecialTool = { Params = "Type", Return = "bool", Notes = "(STATIC) Returns whether the specified block requires a special tool to drop." },
			},
			Variables =
			{
				m_CanBeTerraformed = { Type = "bool", Notes = "Is this block suited to be terraformed?" },
				m_FullyOccupiesVoxel = { Type = "bool", Notes = "Does this block fully occupy its voxel - is it a 'full' block?" },
				m_IsSnowable = { Type = "bool", Notes = "Can this block hold snow atop?" },
				m_IsSolid = { Type = "bool", Notes = "Is this block solid (player cannot walk through)?" },
				m_LightValue = { Type = "number", Notes = "How much light do the blocks emit on their own?" },
				m_OneHitDig = { Type = "bool", Notes = "Is a block destroyed after a single hit?" },
				m_PistonBreakable = { Type = "bool", Notes = "Can a piston break this block?" },
				m_PlaceSound = { Type = "string", Notes = "The name of the sound that is placed when a block is placed." },
				m_RequiresSpecialTool = { Type = "bool", Notes = "Does this block require a tool to drop?" },
				m_SpreadLightFalloff = { Type = "number", Notes = "How much light do the blocks consume?" },
				m_Transparent = { Type = "bool", Notes = "Is a block completely transparent? (light doesn't get decreased(?))" },
			},
		}, -- cBlockInfo

		cChatColor =
		{
			Desc = [[
				A wrapper class for constants representing colors or effects.
			]],

			Functions = {},
			Constants =
			{
				Black         = { Notes = "" },
				Blue          = { Notes = "" },
				Bold          = { Notes = "" },
				Color         = { Notes = "The first character of the color-code-sequence, �" },
				DarkPurple    = { Notes = "" },
				Delimiter     = { Notes = "The first character of the color-code-sequence, �" },
				Gold          = { Notes = "" },
				Gray          = { Notes = "" },
				Green         = { Notes = "" },
				Italic        = { Notes = "" },
				LightBlue     = { Notes = "" },
				LightGray     = { Notes = "" },
				LightGreen    = { Notes = "" },
				LightPurple   = { Notes = "" },
				Navy          = { Notes = "" },
				Plain         = { Notes = "Resets all formatting to normal" },
				Purple        = { Notes = "" },
				Random        = { Notes = "Random letters and symbols animate instead of the text" },
				Red           = { Notes = "" },
				Rose          = { Notes = "" },
				Strikethrough = { Notes = "" },
				Underlined    = { Notes = "" },
				White         = { Notes = "" },
				Yellow        = { Notes = "" },
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
				FillBlocks                = { Params = "BlockType, BlockMeta", Return = "", Notes = "Fills the entire chunk with the specified blocks" },
				FillRelCuboid =
				{
					{ Params = "{{cCuboid|RelCuboid}}, BlockType, BlockMeta", Return = "", Notes = "Fills the cuboid, specified in relative coords, by the specified block type and block meta. The cuboid may reach outside of the chunk, only the part intersecting with this chunk is filled." },
					{ Params = "MinRelX, MaxRelX, MinRelY, MaxRelY, MinRelZ, MaxRelZ, BlockType, BlockMeta", Return = "", Notes = "Fills the cuboid, specified in relative coords, by the specified block type and block meta. The cuboid may reach outside of the chunk, only the part intersecting with this chunk is filled." },
				},
				FloorRelCuboid =
				{
					{ Params = "{{cCuboid|RelCuboid}}, BlockType, BlockMeta", Return = "", Notes = "Fills those blocks of the cuboid (specified in relative coords) that are considered non-floor (air, water) with the specified block type and meta. Cuboid may reach outside the chunk, only the part intersecting with this chunk is filled." },
					{ Params = "MinRelX, MaxRelX, MinRelY, MaxRelY, MinRelZ, MaxRelZ, BlockType, BlockMeta", Return = "", Notes = "Fills those blocks of the cuboid (specified in relative coords) that are considered non-floor (air, water) with the specified block type and meta. Cuboid may reach outside the chunk, only the part intersecting with this chunk is filled." },
				},
				GetBiome                  = { Params = "RelX, RelZ", Return = "EMCSBiome", Notes = "Returns the biome at the specified relative coords" },
				GetBlockEntity            = { Params = "RelX, RelY, RelZ", Return = "{{cBlockEntity}} descendant", Notes = "Returns the block entity for the block at the specified coords. Creates it if it doesn't exist. Returns nil if the block has no block entity capability." },
				GetBlockMeta              = { Params = "RelX, RelY, RelZ", Return = "NIBBLETYPE", Notes = "Returns the block meta at the specified relative coords" },
				GetBlockType              = { Params = "RelX, RelY, RelZ", Return = "BLOCKTYPE", Notes = "Returns the block type at the specified relative coords" },
				GetBlockTypeMeta          = { Params = "RelX, RelY, RelZ", Return = "BLOCKTYPE, NIBBLETYPE", Notes = "Returns the block type and meta at the specified relative coords" },
				GetChunkX                 = { Params = "", Return = "number", Notes = "Returns the X coord of the chunk contained." },
				GetChunkZ                 = { Params = "", Return = "number", Notes = "Returns the Z coord of the chunk contained." },
				GetHeight                 = { Params = "RelX, RelZ", Return = "number", Notes = "Returns the height at the specified relative coords" },
				GetMaxHeight              = { Params = "", Return = "number", Notes = "Returns the maximum height contained in the heightmap." },
				GetMinHeight              = { Params = "", Return = "number", Notes = "Returns the minimum height value in the heightmap." },
				IsUsingDefaultBiomes      = { Params = "", Return = "bool", Notes = "Returns true if the chunk is set to use default biome generator" },
				IsUsingDefaultComposition = { Params = "", Return = "bool", Notes = "Returns true if the chunk is set to use default composition generator" },
				IsUsingDefaultFinish      = { Params = "", Return = "bool", Notes = "Returns true if the chunk is set to use default finishers" },
				IsUsingDefaultHeight      = { Params = "", Return = "bool", Notes = "Returns true if the chunk is set to use default height generator" },
				IsUsingDefaultStructures  = { Params = "", Return = "bool", Notes = "Returns true if the chunk is set to use default structures" },
				RandomFillRelCuboid =
				{
					{ Params = "{{cCuboid|RelCuboid}}, BlockType, BlockMeta, RandomSeed, ChanceOutOf10k", Return = "", Notes = "Fills the specified relative cuboid with block type and meta in random locations. RandomSeed is used for the random number genertion (same seed produces same results); ChanceOutOf10k specifies the density (how many out of every 10000 blocks should be filled). Cuboid may reach outside the chunk, only the part intersecting with this chunk is filled." },
					{ Params = "MinRelX, MaxRelX, MinRelY, MaxRelY, MinRelZ, MaxRelZ, BlockType, BlockMeta, RandomSeed, ChanceOutOf10k", Return = "", Notes = "Fills the specified relative cuboid with block type and meta in random locations. RandomSeed is used for the random number genertion (same seed produces same results); ChanceOutOf10k specifies the density (how many out of every 10000 blocks should be filled). Cuboid may reach outside the chunk, only the part intersecting with this chunk is filled." },
				},
				ReadBlockArea             = { Params = "{{cBlockArea|BlockArea}}, MinRelX, MaxRelX, MinRelY, MaxRelY, MinRelZ, MaxRelZ", Return = "", Notes = "Reads data from the chunk into the block area object. Block types and metas are processed." },
				ReplaceRelCuboid =
				{
					{ Params = "{{cCuboid|RelCuboid}}, SrcType, SrcMeta, DstType, DstMeta", Return = "", Notes = "Replaces all SrcType+SrcMeta blocks in the cuboid (specified in relative coords) with DstType+DstMeta blocks. Cuboid may reach outside the chunk, only the part intersecting with this chunk is filled." },
					{ Params = "MinRelX, MaxRelX, MinRelY, MaxRelY, MinRelZ, MaxRelZ, SrcType, SrcMeta, DstType, DstMeta", Return = "", Notes = "Replaces all SrcType+SrcMeta blocks in the cuboid (specified in relative coords) with DstType+DstMeta blocks. Cuboid may reach outside the chunk, only the part intersecting with this chunk is filled." },
				},
				SetBiome                  = { Params = "RelX, RelZ, EMCSBiome", Return = "", Notes = "Sets the biome at the specified relative coords" },
				SetBlockMeta              = { Params = "RelX, RelY, RelZ, BlockMeta", Return = "", Notes = "Sets the block meta at the specified relative coords" },
				SetBlockType              = { Params = "RelX, RelY, RelZ, BlockType", Return = "", Notes = "Sets the block type at the specified relative coords" },
				SetBlockTypeMeta          = { Params = "RelX, RelY, RelZ, BlockType, BlockMeta", Return = "", Notes = "Sets the block type and meta at the specified relative coords" },
				SetHeight                 = { Params = "RelX, RelZ, Height", Return = "", Notes = "Sets the height at the specified relative coords" },
				SetUseDefaultBiomes       = { Params = "bool", Return = "", Notes = "Sets the chunk to use default biome generator or not" },
				SetUseDefaultComposition  = { Params = "bool", Return = "", Notes = "Sets the chunk to use default composition generator or not" },
				SetUseDefaultFinish       = { Params = "bool", Return = "", Notes = "Sets the chunk to use default finishers or not" },
				SetUseDefaultHeight       = { Params = "bool", Return = "", Notes = "Sets the chunk to use default height generator or not" },
				SetUseDefaultStructures   = { Params = "bool", Return = "", Notes = "Sets the chunk to use default structures or not" },
				UpdateHeightmap           = { Params = "",     Return = "", Notes = "Updates the heightmap to match current contents. The plugins should do that if they modify the contents and don't modify the heightmap accordingly; Cuberite expects (and checks in Debug mode) that the heightmap matches the contents when the cChunkDesc is returned from a plugin." },
				WriteBlockArea            = { Params = "{{cBlockArea|BlockArea}}, MinRelX, MinRelY, MinRelZ", Return = "", Notes = "Writes data from the block area into the chunk" },
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
			},  -- AdditionalInfo
		},  -- cChunkDesc

		cClientHandle =
		{
			Desc = [[
				A cClientHandle represents the technical aspect of a connected player - their game client
				connection. Internally, it handles all the incoming and outgoing packets, the chunks that are to be
				sent to the client, ping times etc.
			]],

			Functions =
			{
				GenerateOfflineUUID = { Params = "Username", Return = "string", Notes = "(STATIC) Generates an UUID based on the player name provided. This is used for the offline (non-auth) mode, when there's no UUID source. Each username generates a unique and constant UUID, so that when the player reconnects with the same name, their UUID is the same. Returns a 32-char UUID (no dashes)." },
				GetClientBrand = { Params = "", Return = "string", Notes = "Returns the brand that the client has sent in their MC|Brand plugin message." },
				GetIPString = { Params = "", Return = "string", Notes = "Returns the IP address of the connection, as a string. Only the address part is returned, without the port number." },
				GetLocale = { Params = "", Return = "Locale", Notes = "Returns the locale string that the client sends as part of the protocol handshake. Can be used to provide localized strings." },
				GetPing = { Params = "", Return = "number", Notes = "Returns the ping time, in ms" },
				GetPlayer = { Params = "", Return = "{{cPlayer|cPlayer}}", Notes = "Returns the player object connected to this client. Note that this may be nil, for example if the player object is not yet spawned." },
				GetProtocolVersion = { Params = "", Return = "number", Notes = "Returns the protocol version number of the protocol that the client is talking. Returns zero if the protocol version is not (yet) known." },
				GetUniqueID = { Params = "", Return = "number", Notes = "Returns the UniqueID of the client used to identify the client in the server" },
				GetUUID = { Params = "", Return = "string", Notes = "Returns the authentication-based UUID of the client. This UUID should be used to identify the player when persisting any player-related data. Returns a 32-char UUID (no dashes)" },
				GetUsername = { Params = "", Return = "string", Notes = "Returns the username that the client has provided" },
				GetViewDistance = { Params = "", Return = "number", Notes = "Returns the viewdistance (number of chunks loaded for the player in each direction)" },
				GetRequestedViewDistance = { Params = "", Return = "number", Notes = "Returns the view distance that the player request, not the used view distance." },
				HasPluginChannel = { Params = "ChannelName", Return = "bool", Notes = "Returns true if the client has registered to receive messages on the specified plugin channel." },
				IsUUIDOnline = { Params = "UUID", Return = "bool", Notes = "(STATIC) Returns true if the UUID is generated by online auth, false if it is an offline-generated UUID. We use Version-3 UUIDs for offline UUIDs, online UUIDs are Version-4, thus we can tell them apart. Accepts both 32-char and 36-char UUIDs (with and without dashes). If the string given is not a valid UUID, returns false."},
				Kick = { Params = "Reason", Return = "", Notes = "Kicks the user with the specified reason" },
				SendPluginMessage = { Params = "Channel, Message", Return = "", Notes = "Sends the plugin message on the specified channel." },
				SetClientBrand = { Params = "ClientBrand", Return = "", Notes = "Sets the value of the client's brand. Normally this value is received from the client by a MC|Brand plugin message, this function lets plugins overwrite the value." },
				SetLocale = { Params = "Locale", Return = "", Notes = "Sets the locale that Cuberite keeps on record. Initially the locale is initialized in protocol handshake, this function allows plugins to override the stored value (but only server-side and only until the user disconnects)." },
				SetUsername = { Params = "Name", Return = "", Notes = "Sets the username" },
				SetViewDistance = { Params = "ViewDistance", Return = "", Notes = "Sets the viewdistance (number of chunks loaded for the player in each direction)" },
				SendBlockChange = { Params = "BlockX, BlockY, BlockZ, BlockType, BlockMeta", Return = "", Notes = "Sends a BlockChange packet to the client. This can be used to create fake blocks only for that player." },
				SendEntityAnimation = { Params = "{{cEntity|Entity}}, AnimationNumber", Return = "", Notes = "Sends the specified animation of the specified entity to the client. The AnimationNumber is protocol-specific." },
				SendSoundEffect = { Params = "SoundName, X, Y, Z, Volume, Pitch", Return = "", Notes = "Sends a sound effect request to the client. The sound is played at the specified coords, with the specified volume (a float, 1.0 is full volume, can be more) and pitch (0-255, 63 is 100%)" },
				SendTimeUpdate = { Params = "WorldAge, TimeOfDay, DoDaylightCycle", Return = "", Notes = "Sends the specified time update to the client. WorldAge is the total age of the world, in ticks. TimeOfDay is the current day's time, in ticks (0 - 24000). DoDaylightCycle is a bool that specifies whether the client should automatically move the sun (true) or keep it in the same place (false)." },
			},
			Constants =
			{
				MAX_VIEW_DISTANCE = { Notes = "The maximum value of the view distance" },
				MIN_VIEW_DISTANCE = { Notes = "The minimum value of the view distance" },
			},
		},  -- cClientHandle

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
				constructor =
				{
					{ Params = "", Return = "", Notes = "Creates an empty chat message" },
					{ Params = "Text", Return = "", Notes = "Creates a chat message containing the specified text, parsed by the ParseText() function. This allows easy migration from old chat messages." },
				},
				AddRunCommandPart = { Params = "Text, Command, [Style]", Return = "self", Notes = "Adds a text which, when clicked, runs the specified command. Chaining." },
				AddShowAchievementPart = { Params = "PlayerName, AchievementName, [Style]", Return = "", Notes = "Adds a text that represents the 'Achievement get' message." },
				AddSuggestCommandPart = { Params = "Text, Command, [Style]", Return = "self", Notes = "Adds a text which, when clicked, puts the specified command into the player's chat input area. Chaining." },
				AddTextPart = { Params = "Text, [Style]", Return = "self", Notes = "Adds a regular text. Chaining." },
				AddUrlPart = { Params = "Text, Url, [Style]", Return = "self", Notes = "Adds a text which, when clicked, opens up a browser at the specified URL. Chaining." },
				Clear = { Params = "", Return = "", Notes = "Removes all parts from this object" },
				CreateJsonString = { Params = "[AddPrefixes]", Return = "string", Notes = "Returns the entire object serialized into JSON, as it would be sent to a client. AddPrefixes specifies whether the chat prefixes should be prepended to the message, true by default." },
				ExtractText = { Params = "", Return = "string", Notes = "Returns the text from the parts that comprises the human-readable data. Used for older protocols that don't support composite chat and for console-logging." },
				GetAdditionalMessageTypeData = { Params = "", Return = "string", Notes = "Returns the AdditionalData associated with the message, such as the sender's name for mtPrivateMessage" },
				GetMessageType = { Params = "", Return = "MessageType", Notes = "Returns the MessageType (mtXXX constant) that is associated with this message. When sent to a player, the message will be formatted according to this message type and the player's settings (adding \"[INFO]\" prefix etc.)" },
				ParseText = { Params = "Text", Return = "self", Notes = "Adds text, while recognizing http and https URLs and old-style formatting codes (\"@2\"). Chaining." },
				SetMessageType = { Params = "MessageType, AdditionalData", Return = "self", Notes = "Sets the MessageType (mtXXX constant) that is associated with this message. Also sets the additional data (string) associated with the message, which is specific for the message type - such as the sender's name for mtPrivateMessage. When sent to a player, the message will be formatted according to this message type and the player's settings (adding \"[INFO]\" prefix etc.). Chaining." },
				UnderlineUrls = { Params = "", Return = "self", Notes = "Makes all URL parts contained in the message underlined. Doesn't affect parts added in the future. Chaining." },
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
		:AddUrlPart(a_Player:GetName(), "http://www.mc-server.org", "u@2")  -- Colored underlined link
		:AddSuggestCommandPart(", and welcome.", "/help", "u")       -- Underlined suggest-command
		:AddRunCommandPart(" SetDay", "/time set 0")                 -- Regular text that will execute command when clicked
		:SetMessageType(mtJoin)                                      -- It is a join-message
	)
end</pre>
					]],
				},
			},  -- AdditionalInfo
		},  -- cCompositeChat

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
				constructor = { Params = "Width, Height", Return = "cCraftingGrid", Notes = "Creates a new CraftingGrid object. This new crafting grid is not related to any player, but may be needed for {{cCraftingRecipe}}'s ConsumeIngredients function." },
				Clear = { Params = "", Return = "", Notes = "Clears the entire grid" },
				ConsumeGrid = { Params = "{{cCraftingGrid|CraftingGrid}}", Return = "", Notes = "Consumes items specified in CraftingGrid from the current contents. Used internally by {{cCraftingRecipe}}'s ConsumeIngredients() function, but available to plugins, too." },
				Dump = { Params = "", Return = "", Notes = "DEBUG build: Dumps the contents of the grid to the log. RELEASE build: no action" },
				GetHeight = { Params = "", Return = "number", Notes = "Returns the height of the grid" },
				GetItem = { Params = "x, y", Return = "{{cItem|cItem}}", Notes = "Returns the item at the specified coords" },
				GetWidth = { Params = "", Return = "number", Notes = "Returns the width of the grid" },
				SetItem =
				{
					{ Params = "x, y, {{cItem|cItem}}", Return = "", Notes = "Sets the item at the specified coords" },
					{ Params = "x, y, ItemType, ItemCount, ItemDamage", Return = "", Notes = "Sets the item at the specified coords" },
				},
			},
		},  -- cCraftingGrid

		cCraftingRecipe =
		{
			Desc = [[
				This class is used to represent a crafting recipe, either a built-in one, or one created dynamically in a plugin. It is used only as a parameter for {{OnCraftingNoRecipe|OnCraftingNoRecipe}}, {{OnPostCrafting|OnPostCrafting}} and {{OnPreCrafting|OnPreCrafting}} hooks. Plugins may use it to inspect or modify a crafting recipe that a player views in their crafting window, either at a crafting table or the survival inventory screen.
</p>
		<p>Internally, the class contains a {{cCraftingGrid}} for the ingredients and a {{cItem}} for the result.
]],
			Functions =
			{
				Clear = { Params = "", Return = "", Notes = "Clears the entire recipe, both ingredients and results" },
				ConsumeIngredients = { Params = "CraftingGrid", Return = "", Notes = "Consumes ingredients specified in the given {{cCraftingGrid|cCraftingGrid}} class" },
				Dump = { Params = "", Return = "", Notes = "DEBUG build: dumps ingredients and result into server log. RELEASE build: no action" },
				GetIngredient = { Params = "x, y", Return = "{{cItem|cItem}}", Notes = "Returns the ingredient stored in the recipe at the specified coords" },
				GetIngredientsHeight = { Params = "", Return = "number", Notes = "Returns the height of the ingredients' grid" },
				GetIngredientsWidth = { Params = "", Return = "number", Notes = "Returns the width of the ingredients' grid" },
				GetResult = { Params = "", Return = "{{cItem|cItem}}", Notes = "Returns the result of the recipe" },
				SetIngredient =
				{
					{ Params = "x, y, {{cItem|cItem}}", Return = "", Notes = "Sets the ingredient at the specified coords" },
					{ Params = "x, y, ItemType, ItemCount, ItemDamage", Return = "", Notes = "Sets the ingredient at the specified coords" },
				},
				SetResult =
				{
					{ Params = "{{cItem|cItem}}", Return = "", Notes = "Sets the result item" },
					{ Params = "ItemType, ItemCount, ItemDamage", Return = "", Notes = "Sets the result item" },
				},
			},
		},  -- cCraftingRecipe

		cCryptoHash =
		{
			Desc =
			[[
				Provides functions for generating cryptographic hashes.</p>
				<p>
				Note that all functions in this class are static, so they should be called in the dot convention:
<pre class="prettyprint lang-lua">
local Hash = cCryptoHash.sha1HexString("DataToHash")
</pre></p>
				<p>Each cryptographic hash has two variants, one returns the hash as a raw binary string, the other returns the hash as a hex-encoded string twice as long as the binary string.
			]],

			Functions =
			{
				md5 = { Params = "Data", Return = "string", Notes = "(STATIC) Calculates the md5 hash of the data, returns it as a raw (binary) string of 16 characters." },
				md5HexString = { Params = "Data", Return = "string", Notes = "(STATIC) Calculates the md5 hash of the data, returns it as a hex-encoded string of 32 characters." },
				sha1 = { Params = "Data", Return = "string", Notes = "(STATIC) Calculates the sha1 hash of the data, returns it as a raw (binary) string of 20 characters." },
				sha1HexString = { Params = "Data", Return = "string", Notes = "(STATIC) Calculates the sha1 hash of the data, returns it as a hex-encoded string of 40 characters." },
			},
		},  -- cCryptoHash

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
				constructor =
				{
					{ Params = "", Return = "cEnchantments", Notes = "Creates a new empty cEnchantments object" },
					{ Params = "StringSpec", Return = "cEnchantments", Notes = "Creates a new cEnchantments object filled with enchantments based on the string description" },
				},
				operator_eq = { Params = "OtherEnchantments", Return = "bool", Notes = "Returns true if this enchantments object has the same enchantments as OtherEnchantments." },
				AddFromString = { Params = "StringSpec", Return = "", Notes = "Adds the enchantments in the string description into the object. If a specified enchantment already existed, it is overwritten." },
				Clear = { Params = "", Return = "", Notes = "Removes all enchantments" },
				GetLevel = { Params = "EnchantmentNumID", Return = "number", Notes = "Returns the level of the specified enchantment stored in this object; 0 if not stored" },
				IsEmpty = { Params = "", Return = "bool", Notes = "Returns true if the object stores no enchantments" },
				SetLevel = { Params = "EnchantmentNumID, Level", Return = "", Notes = "Sets the level for the specified enchantment, adding it if not stored before or removing it if level < = 0" },
				StringToEnchantmentID = { Params = "EnchantmentTextID", Return = "number", Notes = "(static) Returns the enchantment numerical ID, -1 if not understood. Case insensitive. Also understands plain numbers." },
				ToString = { Params = "", Return = "string", Notes = "Returns the string description of all the enchantments stored in this object, in numerical-ID form" },
			},
			Constants =
			{
				-- Only list these enchantment IDs, as they don't really need any kind of documentation:
				enchAquaAffinity = { Notes = "" },
				enchBaneOfArthropods = { Notes = "" },
				enchBlastProtection = { Notes = "" },
				enchEfficiency = { Notes = "" },
				enchFeatherFalling = { Notes = "" },
				enchFireAspect = { Notes = "" },
				enchFireProtection = { Notes = "" },
				enchFlame = { Notes = "" },
				enchFortune = { Notes = "" },
				enchInfinity = { Notes = "" },
				enchKnockback = { Notes = "" },
				enchLooting = { Notes = "" },
				enchLuckOfTheSea = { Notes = "" },
				enchLure = { Notes = "" },
				enchPower = { Notes = "" },
				enchProjectileProtection = { Notes = "" },
				enchProtection = { Notes = "" },
				enchPunch = { Notes = "" },
				enchRespiration = { Notes = "" },
				enchSharpness = { Notes = "" },
				enchSilkTouch = { Notes = "" },
				enchSmite = { Notes = "" },
				enchThorns = { Notes = "" },
				enchUnbreaking = { Notes = "" },
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
					{ Params = "OffsetX, OffsetY, OffsetZ", Return = "", Notes = "Moves the entity by the specified amount in each axis direction" },
					{ Params = "{{Vector3d|Offset}}", Return = "", Notes = "Moves the entity by the specified amount in each direction" },
				},
				AddPosX = { Params = "OffsetX", Return = "", Notes = "Moves the entity by the specified amount in the X axis direction" },
				AddPosY = { Params = "OffsetY", Return = "", Notes = "Moves the entity by the specified amount in the Y axis direction" },
				AddPosZ = { Params = "OffsetZ", Return = "", Notes = "Moves the entity by the specified amount in the Z axis direction" },
				AddSpeed =
				{
					{ Params = "AddX, AddY, AddZ", Return = "", Notes = "Adds the specified amount of speed in each axis direction." },
					{ Params = "{{Vector3d|Add}}", Return = "", Notes = "Adds the specified amount of speed in each axis direction." },
				},
				AddSpeedX = { Params = "AddX", Return = "", Notes = "Adds the specified amount of speed in the X axis direction." },
				AddSpeedY = { Params = "AddY", Return = "", Notes = "Adds the specified amount of speed in the Y axis direction." },
				AddSpeedZ = { Params = "AddZ", Return = "", Notes = "Adds the specified amount of speed in the Z axis direction." },
				ArmorCoversAgainst = { Params = "{{cEntity|AttackerEntity}}, DamageType, RawDamage", Return = "number", Notes = "Returns the points out of a_RawDamage that the currently equipped armor would cover." },
				Destroy = { Params = "", Return = "", Notes = "Schedules the entity to be destroyed" },
				GetAirLevel = { Params = "", Return = "number", Notes = "Returns the air level (number of ticks of air left). Note, this function is only updated with mobs or players." },
				GetArmorCoverAgainst = { Params = "AttackerEntity, DamageType, RawDamage", Return = "number", Notes = "Returns the number of hitpoints out of RawDamage that the currently equipped armor would cover. See {{TakeDamageInfo}} for more information on attack damage." },
				GetChunkX = { Params = "", Return = "number", Notes = "Returns the X-coord of the chunk in which the entity is placed" },
				GetChunkZ = { Params = "", Return = "number", Notes = "Returns the Z-coord of the chunk in which the entity is placed" },
				GetClass = { Params = "", Return = "string", Notes = "Returns the classname of the entity, such as \"cSpider\" or \"cPickup\"" },
				GetClassStatic = { Params = "", Return = "string", Notes = "Returns the entity classname that this class implements. Each descendant overrides this function. Is static" },
				GetEntityType = { Params = "", Return = "{{cEntity#EntityType|EntityType}}", Notes = "Returns the type of the entity, one of the {{cEntity#EntityType|etXXX}} constants. Note that to check specific entity type, you should use one of the IsXXX functions instead of comparing the value returned by this call." },
				GetEquippedBoots = { Params = "", Return = "{{cItem}}", Notes = "Returns the boots that the entity has equipped. Returns an empty cItem if no boots equipped or not applicable." },
				GetEquippedChestplate = { Params = "", Return = "{{cItem}}", Notes = "Returns the chestplate that the entity has equipped. Returns an empty cItem if no chestplate equipped or not applicable." },
				GetEquippedHelmet = { Params = "", Return = "{{cItem}}", Notes = "Returns the helmet that the entity has equipped. Returns an empty cItem if no helmet equipped or not applicable." },
				GetEquippedLeggings = { Params = "", Return = "{{cItem}}", Notes = "Returns the leggings that the entity has equipped. Returns an empty cItem if no leggings equipped or not applicable." },
				GetEquippedWeapon = { Params = "", Return = "{{cItem}}", Notes = "Returns the weapon that the entity has equipped. Returns an empty cItem if no weapon equipped or not applicable." },
				GetGravity = { Params = "", Return = "number", Notes = "Returns the number that is used as the gravity for physics simulation. 1G (9.78) by default." },
				GetHeadYaw = { Params = "", Return = "number", Notes = "Returns the pitch of the entity's head (FIXME: Rename to GetHeadPitch() )." },
				GetHealth = { Params = "", Return = "number", Notes = "Returns the current health of the entity." },
				GetHeight = { Params = "", Return = "number", Notes = "Returns the height (Y size) of the entity" },
				GetInvulnerableTicks = { Params = "", Return = "number", Notes = "Returns the number of ticks that this entity will be invulnerable for. This is used for after-hit recovery - the entities are invulnerable for half a second after being hit." },
				GetKnockbackAmountAgainst = { Params = "ReceiverEntity", Return = "number", Notes = "Returns the amount of knockback that the currently equipped items would cause when attacking the ReceiverEntity." },
				GetLookVector = { Params = "", Return = "{{Vector3f}}", Notes = "Returns the vector that defines the direction in which the entity is looking" },
				GetMass = { Params = "", Return = "number", Notes = "Returns the mass of the entity. Currently unused." },
				GetMaxHealth = { Params = "", Return = "number", Notes = "Returns the maximum number of hitpoints this entity is allowed to have." },
				GetParentClass = { Params = "", Return = "string", Notes = "Returns the name of the direct parent class for this entity" },
				GetPitch = { Params = "", Return = "number", Notes = "Returns the pitch (nose-down rotation) of the entity. Measured in degrees, normal values range from -90 to +90. +90 means looking down, 0 means looking straight ahead, -90 means looking up." },
				GetPosition = { Params = "", Return = "{{Vector3d}}", Notes = "Returns the entity's pivot position as a 3D vector" },
				GetPosX = { Params = "", Return = "number", Notes = "Returns the X-coord of the entity's pivot" },
				GetPosY = { Params = "", Return = "number", Notes = "Returns the Y-coord of the entity's pivot" },
				GetPosZ = { Params = "", Return = "number", Notes = "Returns the Z-coord of the entity's pivot" },
				GetRawDamageAgainst = { Params = "ReceiverEntity", Return = "number", Notes = "Returns the raw damage that this entity's equipment would cause when attacking the ReceiverEntity. This includes this entity's weapon {{cEnchantments|enchantments}}, but excludes the receiver's armor or potion effects. See {{TakeDamageInfo}} for more information on attack damage." },
				GetRoll = { Params = "", Return = "number", Notes = "Returns the roll (sideways rotation) of the entity. Currently unused." },
				GetRot = { Params = "", Return = "{{Vector3f}}", Notes = "(OBSOLETE) Returns the entire rotation vector (Yaw, Pitch, Roll)" },
				GetSpeed = { Params = "", Return = "{{Vector3d}}", Notes = "Returns the complete speed vector of the entity" },
				GetSpeedX = { Params = "", Return = "number", Notes = "Returns the X-part of the speed vector" },
				GetSpeedY = { Params = "", Return = "number", Notes = "Returns the Y-part of the speed vector" },
				GetSpeedZ = { Params = "", Return = "number", Notes = "Returns the Z-part of the speed vector" },
				GetTicksAlive = { Params = "", Return = "number", Notes = "Returns the number of ticks that this entity has been alive for." },
				GetUniqueID = { Params = "", Return = "number", Notes = "Returns the ID that uniquely identifies the entity within the running server. Note that this ID is not persisted to the data files." },
				GetWidth = { Params = "", Return = "number", Notes = "Returns the width (X and Z size) of the entity." },
				GetWorld = { Params = "", Return = "{{cWorld}}", Notes = "Returns the world where the entity resides" },
				GetYaw = { Params = "", Return = "number", Notes = "Returns the yaw (direction) of the entity. Measured in degrees, values range from -180 to +180. 0 means ZP, 90 means XM, -180 means ZM, -90 means XP." },
				HandleSpeedFromAttachee = { Params = "ForwardAmount, SidewaysAmount", Return = "", Notes = "Updates the entity's speed based on the attachee exerting the specified force forward and sideways. Used for entities being driven by other entities attached to them - usually players driving minecarts and boats." },
				Heal = { Params = "Hitpoints", Return = "", Notes = "Heals the specified number of hitpoints. Hitpoints is expected to be a positive number." },
				IsA = { Params = "ClassName", Return = "bool", Notes = "Returns true if the entity class is a descendant of the specified class name, or the specified class itself" },
				IsBoat = { Params = "", Return = "bool", Notes = "Returns true if the entity is a {{cBoat|boat}}." },
				IsCrouched = { Params = "", Return = "bool", Notes = "Returns true if the entity is crouched. Always false for entities that don't support crouching." },
				IsDestroyed = { Params = "", Return = "bool", Notes = "Returns true if the entity has been destroyed and is awaiting removal from the internal structures." },
				IsEnderCrystal = { Params = "", Return = "bool", Notes = "Returns true if the entity is an ender crystal." },
				IsExpOrb = { Params = "", Return = "bool", Notes = "Returns true if the entity represents an experience orb" },
				IsFallingBlock = { Params = "", Return = "bool", Notes = "Returns true if the entity represents a {{cFallingBlock}} entity." },
				IsFireproof = { Params = "", Return = "bool", Notes = "Returns true if the entity takes no damage from being on fire." },
				IsFloater = { Params = "", Return = "bool", Notes = "Returns true if the entity represents a fishing rod floater" },
				IsInvisible = { Params = "", Return = "bool", Notes = "Returns true if the entity is invisible" },
				IsItemFrame = { Params = "", Return = "bool", Notes = "Returns true if the entity is an item frame." },
				IsMinecart = { Params = "", Return = "bool", Notes = "Returns true if the entity represents a {{cMinecart|minecart}}" },
				IsMob = { Params = "", Return = "bool", Notes = "Returns true if the entity represents any {{cMonster|mob}}." },
				IsOnFire = { Params = "", Return = "bool", Notes = "Returns true if the entity is on fire" },
				IsOnGround = { Params = "", Return = "bool", Notes = "Returns true if the entity is on ground (not falling, not jumping, not flying)" },
				IsPainting = { Params = "", Return = "bool", Notes = "Returns if this entity is a painting." },
				IsPawn = { Params = "", Return = "bool", Notes = "Returns true if the entity is a {{cPawn}} descendant." },
				IsPickup = { Params = "", Return = "bool", Notes = "Returns true if the entity represents a {{cPickup|pickup}}." },
				IsPlayer = { Params = "", Return = "bool", Notes = "Returns true if the entity represents a {{cPlayer|player}}" },
				IsProjectile = { Params = "", Return = "bool", Notes = "Returns true if the entity is a {{cProjectileEntity}} descendant." },
				IsRclking = { Params = "", Return = "bool", Notes = "Currently unimplemented" },
				IsRiding = { Params = "", Return = "bool", Notes = "Returns true if the entity is attached to (riding) another entity." },
				IsSprinting = { Params = "", Return = "bool", Notes = "Returns true if the entity is sprinting. Entities that cannot sprint return always false" },
				IsSubmerged = { Params = "", Return = "bool", Notes = "Returns true if the mob or player is submerged in water (head is in a water block). Note, this function is only updated with mobs or players." },
				IsSwimming = { Params = "", Return = "bool", Notes = "Returns true if the mob or player is swimming in water (feet are in a water block). Note, this function is only updated with mobs or players." },
				IsTNT = { Params = "", Return = "bool", Notes = "Returns true if the entity represents a {{cTNTEntity|TNT entity}}" },
				Killed = { Params = "{{cEntity|Victim}}", Return = "", Notes = "This entity has killed another entity (the Victim). For players, adds the scoreboard statistics about the kill." },
				KilledBy = { Notes = "FIXME: Remove this from API" },
				MoveToWorld =
				{
					{ Params = "{{cWorld|World}}, [ShouldSendRespawn]", Return = "bool", Notes = "Removes the entity from this world and starts moving it to the specified world. Note that to avoid deadlocks, the move is asynchronous - the entity is moved into a queue and will be moved from that queue into the destination world at some (unpredictable) time in the future. ShouldSendRespawn is used only for players, it specifies whether the player should be sent a Repawn packet upon leaving the world (The client handles respawns only between different dimensions)." },
					{ Params = "WorldName, [ShouldSendRespawn]", Return = "bool", Notes = "Removes the entity from this world and starts moving it to the specified world. Note that to avoid deadlocks, the move is asynchronous - the entity is moved into a queue and will be moved from that queue into the destination world at some (unpredictable) time in the future. ShouldSendRespawn is used only for players, it specifies whether the player should be sent a Repawn packet upon leaving the world (The client handles respawns only between different dimensions)." },
				},
				SetGravity = { Params = "Gravity", Return = "", Notes = "Sets the number that is used as the gravity for physics simulation. 1G (9.78) by default." },
				SetHeadYaw = { Params = "HeadPitch", Return = "", Notes = "Sets the head pitch (FIXME: Rename to SetHeadPitch() )." },
				SetHealth = { Params = "Hitpoints", Return = "", Notes = "Sets the entity's health to the specified amount of hitpoints. Doesn't broadcast any hurt animation. Doesn't kill the entity if health drops below zero. Use the TakeDamage() function instead for taking damage." },
				SetHeight = { Params = "", Return = "", Notes = "FIXME: Remove this from API" },
				SetInvulnerableTicks = { Params = "NumTicks", Return = "", Notes = "Sets the amount of ticks for which the entity will not receive any damage from other entities." },
				SetIsFireproof = { Params = "IsFireproof", Return = "", Notes = "Sets whether the entity receives damage from being on fire." },
				SetMass = { Params = "Mass", Return = "", Notes = "Sets the mass of the entity. Currently unused." },
				SetMaxHealth = { Params = "MaxHitpoints", Return = "", Notes = "Sets the maximum hitpoints of the entity. If current health is above MaxHitpoints, it is capped to MaxHitpoints." },
				SetPitch = { Params = "number", Return = "", Notes = "Sets the pitch (nose-down rotation) of the entity" },
				SetPitchFromSpeed = { Params = "", Return = "", Notes = "Sets the entity pitch to match its speed (entity looking forwards as it moves)" },
				SetPosition =
				{
					{ Params = "PosX, PosY, PosZ", Return = "", Notes = "Sets all three coords of the entity's pivot" },
					{ Params = "{{Vector3d|Vector3d}}", Return = "", Notes = "Sets all three coords of the entity's pivot" },
				},
				SetPosX = { Params = "number", Return = "", Notes = "Sets the X-coord of the entity's pivot" },
				SetPosY = { Params = "number", Return = "", Notes = "Sets the Y-coord of the entity's pivot" },
				SetPosZ = { Params = "number", Return = "", Notes = "Sets the Z-coord of the entity's pivot" },
				SetRoll = { Params = "number", Return = "", Notes = "Sets the roll (sideways rotation) of the entity. Currently unused." },
				SetRot = { Params = "{{Vector3f|Rotation}}", Return = "", Notes = "Sets the entire rotation vector (Yaw, Pitch, Roll)" },
				SetYawFromSpeed = { Params = "", Return = "", Notes = "Sets the entity's yaw to match its current speed (entity looking forwards as it moves)." },
				SetSpeed =
				{
					{ Params = "SpeedX, SpeedY, SpeedZ", Return = "", Notes = "Sets the current speed of the entity" },
					{ Params = "{{Vector3d|Speed}}", Return = "", Notes = "Sets the current speed of the entity" },
				},
				SetSpeedX = { Params = "SpeedX", Return = "", Notes = "Sets the X component of the entity speed" },
				SetSpeedY = { Params = "SpeedY", Return = "", Notes = "Sets the Y component of the entity speed" },
				SetSpeedZ = { Params = "SpeedZ", Return = "", Notes = "Sets the Z component of the entity speed" },
				SetWidth = { Params = "", Return = "", Notes = "FIXME: Remove this from API" },
				SetYaw = { Params = "number", Return = "", Notes = "Sets the yaw (direction) of the entity." },
				StartBurning = { Params = "NumTicks", Return = "", Notes = "Sets the entity on fire for the specified number of ticks. If entity is on fire already, makes it burn for either NumTicks or the number of ticks left from the previous fire, whichever is larger." },
				SteerVehicle = { Params = "ForwardAmount, SidewaysAmount", Return = "", Notes = "Applies the specified steering to the vehicle this entity is attached to. Ignored if not attached to any entity." },
				StopBurning = { Params = "", Return = "", Notes = "Extinguishes the entity fire, cancels all fire timers." },
				TakeDamage =
				{
					{ Params = "AttackerEntity", Return = "", Notes = "Causes this entity to take damage that AttackerEntity would inflict. Includes their weapon and this entity's armor." },
					{ Params = "DamageType, AttackerEntity, RawDamage, KnockbackAmount", Return = "", Notes = "Causes this entity to take damage of the specified type, from the specified attacker (may be nil). The final damage is calculated from RawDamage using the currently equipped armor." },
					{ Params = "DamageType, ArrackerEntity, RawDamage, FinalDamage, KnockbackAmount", Return = "", Notes = "Causes this entity to take damage of the specified type, from the specified attacker (may be nil). The values are wrapped into a {{TakeDamageInfo}} structure and applied directly." },
				},
				TeleportToCoords = { Params = "PosX, PosY, PosZ", Return = "", Notes = "Teleports the entity to the specified coords. Asks plugins if the teleport is allowed." },
				TeleportToEntity = { Params = "DestEntity", Return = "", Notes = "Teleports this entity to the specified destination entity. Asks plugins if the teleport is allowed." },
			},
			Constants =
			{
				etBoat = { Notes = "The entity is a {{cBoat}}" },
				etEnderCrystal = { Notes = "" },
				etEntity = { Notes = "No further specialization available" },
				etExpOrb = { Notes = "The entity is a {{cExpOrb}}" },
				etFallingBlock = { Notes = "The entity is a {{cFallingBlock}}" },
				etFloater = { Notes = "The entity is a fishing rod floater" },
				etItemFrame = { Notes = "" },
				etMinecart = { Notes = "The entity is a {{cMinecart}} descendant" },
				etMob = { Notes = "The entity is a {{cMonster}} descendant" },
				etMonster = { Notes = "The entity is a {{cMonster}} descendant" },
				etPainting = { Notes = "The entity is a {{cPainting}}" },
				etPickup = { Notes = "The entity is a {{cPickup}}" },
				etPlayer = { Notes = "The entity is a {{cPlayer}}" },
				etProjectile = { Notes = "The entity is a {{cProjectileEntity}} descendant" },
				etTNT = { Notes = "The entity is a {{cTNTEntity}}" },
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
				ChangeFileExt = { Params = "FileName, NewExt", Return = "string", Notes = "(STATIC) Returns FileName with its extension changed to NewExt. NewExt may begin with a dot, but needn't, the result is the same in both cases (the first dot, if present, is ignored). FileName may contain path elements, extension is recognized as the last dot after the last path separator in the string." },
				Copy = { Params = "SrcFileName, DstFileName", Return = "bool", Notes = "(STATIC) Copies a single file to a new destination. Returns true if successful. Fails if the destination already exists." },
				CreateFolder = { Params = "FolderPath", Return = "bool", Notes = "(STATIC) Creates a new folder. Returns true if successful. Only a single level can be created at a time, use CreateFolderRecursive() to create multiple levels of folders at once." },
				CreateFolderRecursive = { Params = "FolderPath", Return = "bool", Notes = "(STATIC) Creates a new folder, creating its parents if needed. Returns true if successful." },
				Delete = { Params = "Path", Return = "bool", Notes = "(STATIC) Deletes the specified file or folder. Returns true if successful. Only deletes folders that are empty.<br/><b>NOTE</b>: If you already know if the object is a file or folder, use DeleteFile() or DeleteFolder() explicitly." },
				DeleteFile = { Params = "FilePath", Return = "bool", Notes = "(STATIC) Deletes the specified file. Returns true if successful." },
				DeleteFolder = { Params = "FolderPath", Return = "bool", Notes = "(STATIC) Deletes the specified file or folder. Returns true if successful. Only deletes folders that are empty." },
				DeleteFolderContents = { Params = "FolderPath", Return = "bool", Notes = "(STATIC) Deletes everything from the specified folder, recursively. The specified folder stays intact. Returns true if successful." },
				Exists = { Params = "Path", Return = "bool", Notes = "(STATIC) Returns true if the specified file or folder exists.<br/><b>OBSOLETE</b>, use IsFile() or IsFolder() instead" },
				GetExecutableExt = { Params = "", Return = "string", Notes = "(STATIC) Returns the customary executable extension (including the dot) used by the current platform (\".exe\" on Windows, empty string on Linux). " },
				GetFolderContents = { Params = "FolderName", Return = "array table of strings", Notes = "(STATIC) Returns the contents of the specified folder, as an array table of strings. Each filesystem object is listed. Use the IsFile() and IsFolder() functions to determine the object type." },
				GetLastModificationTime = { Params = "Path", Return = "number", Notes = "(STATIC) Returns the last modification time (in current timezone) of the specified file or folder. Returns zero if file not found / not accessible. The returned value is in the same units as values returned by os.time()." },
				GetPathSeparator = { Params = "", Return = "string", Notes = "(STATIC) Returns the primary path separator used by the current platform. Returns \"\\\" on Windows and \"/\" on Linux. Note that the platform or CRT may support additional path separators, those are not reported." },
				GetSize = { Params = "FileName", Return = "number", Notes = "(STATIC) Returns the size of the file, or -1 on failure." },
				IsFile = { Params = "Path", Return = "bool", Notes = "(STATIC) Returns true if the specified path points to an existing file." },
				IsFolder = { Params = "Path", Return = "bool", Notes = "(STATIC) Returns true if the specified path points to an existing folder." },
				ReadWholeFile = { Params = "FileName", Return = "string", Notes = "(STATIC) Returns the entire contents of the specified file. Returns an empty string if the file cannot be opened." },
				Rename = { Params = "OrigPath, NewPath", Return = "bool", Notes = "(STATIC) Renames a file or a folder. Returns true if successful. Undefined result if NewPath already exists." },
			},
		},  -- cFile

		cFloater =
		{
			Desc = [[
				When a player uses his/her fishing rod it creates a floater entity. This class manages it.
			]],
			Functions =
			{
				CanPickup = { Params = "", Return = "bool", Notes = "Returns true if the floater gives an item when the player right clicks." },
				GetAttachedMobID = { Params = "", Return = "EntityID", Notes = "A floater can get attached to an mob. When it is and this functions gets called it returns the mob ID. If it isn't attached to a mob it returns -1" },
				GetOwnerID = { Params = "", Return = "EntityID", Notes = "Returns the EntityID of the player who owns the floater." },
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
				constructor = { Params = "", Return = "cIniFile", Notes = "Creates a new empty cIniFile object." },
				AddHeaderComment = { Params = "Comment", Return = "", Notes = "Adds a comment to be stored in the file header." },
				AddKeyComment =
				{
					{ Params = "KeyID, Comment", Return = "", Notes = "Adds a comment to be stored in the file under the specified key" },
					{ Params = "KeyName, Comment", Return = "", Notes = "Adds a comment to be stored in the file under the specified key" },
				},
				AddKeyName = { Params = "KeyName", Returns = "number", Notes = "Adds a new key of the specified name. Returns the KeyID of the new key." },
				AddValue = { Params = "KeyName, ValueName, Value", Return = "", Notes = "Adds a new value of the specified name to the specified key. If another value of the same name exists in the key, both are kept (nonstandard INI file)" },
				AddValueB = { Params = "KeyName, ValueName, Value", Return = "", Notes = "Adds a new bool value of the specified name to the specified key. If another value of the same name exists in the key, both are kept (nonstandard INI file)" },
				AddValueF = { Params = "KeyName, ValueName, Value", Return = "", Notes = "Adds a new float value of the specified name to the specified key. If another value of the same name exists in the key, both are kept (nonstandard INI file)" },
				AddValueI = { Params = "KeyName, ValueName, Value", Return = "", Notes = "Adds a new integer value of the specified name to the specified key. If another value of the same name exists in the key, both are kept (nonstandard INI file)" },
				CaseInsensitive = { Params = "", Return = "", Notes = "Sets key names' and value names' comparisons to case insensitive (default)." },
				CaseSensitive = { Params = "", Return = "", Notes = "Sets key names and value names comparisons to case sensitive." },
				Clear = { Params = "", Return = "", Notes = "Removes all the in-memory data. Note that , like all the other operations, this doesn't affect any file data." },
				DeleteHeaderComment = { Params = "CommentID", Return = "bool" , Notes = "Deletes the specified header comment. Returns true if successful."},
				DeleteHeaderComments = { Params = "", Return = "", Notes = "Deletes all headers comments." },
				DeleteKey = { Params = "KeyName", Return = "bool", Notes = "Deletes the specified key, and all values in that key. Returns true if successful." },
				DeleteKeyComment =
				{
					{ Params = "KeyID, CommentID", Return = "bool", Notes = "Deletes the specified key comment. Returns true if successful." },
					{ Params = "KeyName, CommentID", Return = "bool", Notes = "Deletes the specified key comment. Returns true if successful." },
				},
				DeleteKeyComments =
				{
					{ Params = "KeyID", Return = "bool", Notes = "Deletes all comments for the specified key. Returns true if successful." },
					{ Params = "KeyName", Return = "bool", Notes = "Deletes all comments for the specified key. Returns true if successful." },
				},
				DeleteValue = { Params = "KeyName, ValueName", Return = "bool", Notes = "Deletes the specified value. Returns true if successful." },
				DeleteValueByID = { Params = "KeyID, ValueID", Return = "bool", Notes = "Deletes the specified value. Returns true if successful." },
				FindKey = { Params = "KeyName", Return = "number", Notes = "Returns the KeyID for the specified key name, or the noID constant if the key doesn't exist." },
				FindValue = { Params = "KeyID, ValueName", Return = "numebr", Notes = "Returns the ValueID for the specified value name, or the noID constant if the specified key doesn't contain a value of that name." },
				GetHeaderComment = { Params = "CommentID", Return = "string", Notes = "Returns the specified header comment, or an empty string if such comment doesn't exist" },
				GetKeyComment =
				{
					{ Params = "KeyID, CommentID", Return = "string", Notes = "Returns the specified key comment, or an empty string if such a comment doesn't exist" },
					{ Params = "KeyName, CommentID", Return = "string", Notes = "Returns the specified key comment, or an empty string if such a comment doesn't exist" },
				},
				GetKeyName = { Params = "KeyID", Return = "string", Notes = "Returns the key name for the specified key ID. Inverse for FindKey()." },
				GetNumHeaderComments = { Params = "", Return = "number", Notes = "Retuns the number of header comments." },
				GetNumKeyComments =
				{
					{ Params = "KeyID", Return = "number", Notes = "Returns the number of comments under the specified key" },
					{ Params = "KeyName", Return = "number", Notes = "Returns the number of comments under the specified key" },
				},
				GetNumKeys = { Params = "", Return = "number", Notes = "Returns the total number of keys. This is the range for the KeyID (0 .. GetNumKeys() - 1)" },
				GetNumValues =
				{
					{ Params = "KeyID", Return = "number", Notes = "Returns the number of values stored under the specified key." },
					{ Params = "KeyName", Return = "number", Notes = "Returns the number of values stored under the specified key." },
				},
				GetValue =
				{
					{ Params = "KeyName, ValueName", Return = "string", Notes = "Returns the value of the specified name under the specified key. Returns an empty string if the value doesn't exist." },
					{ Params = "KeyID, ValueID", Return = "string", Notes = "Returns the value of the specified name under the specified key. Returns an empty string if the value doesn't exist." },
				},
				GetValueB = { Params = "KeyName, ValueName", Return = "bool", Notes = "Returns the value of the specified name under the specified key, as a bool. Returns false if the value doesn't exist." },
				GetValueF = { Params = "KeyName, ValueName", Return = "number", Notes = "Returns the value of the specified name under the specified key, as a floating-point number. Returns zero if the value doesn't exist." },
				GetValueI = { Params = "KeyName, ValueName", Return = "number", Notes = "Returns the value of the specified name under the specified key, as an integer. Returns zero if the value doesn't exist." },
				GetValueName =
				{
					{ Params = "KeyID, ValueID", Return = "string", Notes = "Returns the name of the specified value Inverse for FindValue()." },
					{ Params = "KeyName, ValueID", Return = "string", Notes = "Returns the name of the specified value Inverse for FindValue()." },
				},
				GetValueSet = { Params = "KeyName, ValueName, Default", Return = "string", Notes = "Returns the value of the specified name under the specified key. If the value doesn't exist, creates it with the specified default." },
				GetValueSetB = { Params = "KeyName, ValueName, Default", Return = "bool", Notes = "Returns the value of the specified name under the specified key, as a bool. If the value doesn't exist, creates it with the specified default." },
				GetValueSetF = { Params = "KeyName, ValueName, Default", Return = "number", Notes = "Returns the value of the specified name under the specified key, as a floating-point number. If the value doesn't exist, creates it with the specified default." },
				GetValueSetI = { Params = "KeyName, ValueName, Default", Return = "number", Notes = "Returns the value of the specified name under the specified key, as an integer. If the value doesn't exist, creates it with the specified default." },
				HasValue = { Params = "KeyName, ValueName", Return = "bool", Notes = "Returns true if the specified value is present." },
				ReadFile = { Params = "FileName, [AllowExampleFallback]", Return = "bool", Notes = "Reads the values from the specified file. Previous in-memory contents are lost. If the file cannot be opened, and AllowExample is true, another file, \"filename.example.ini\", is loaded and then saved as \"filename.ini\". Returns true if successful, false if not." },
				SetValue =
				{
					{ Params = "KeyID, ValueID, NewValue", Return = "bool", Notes = "Overwrites the specified value with a new value. If the specified value doesn't exist, returns false (doesn't add)." },
					{ Params = "KeyName, ValueName, NewValue, [CreateIfNotExists]", Return = "bool", Notes = "Overwrites the specified value with a new value. If CreateIfNotExists is true (default) and the value doesn't exist, it is first created. Returns true if the value was successfully set, false if not (didn't exists, CreateIfNotExists false)." },
				},
				SetValueB = { Params = "KeyName, ValueName, NewValueBool, [CreateIfNotExists]", Return = "bool", Notes = "Overwrites the specified value with a new bool value. If CreateIfNotExists is true (default) and the value doesn't exist, it is first created. Returns true if the value was successfully set, false if not (didn't exists, CreateIfNotExists false)." },
				SetValueF = { Params = "KeyName, ValueName, NewValueFloat, [CreateIfNotExists]", Return = "bool", Notes = "Overwrites the specified value with a new floating-point number value. If CreateIfNotExists is true (default) and the value doesn't exist, it is first created. Returns true if the value was successfully set, false if not (didn't exists, CreateIfNotExists false)." },
				SetValueI = { Params = "KeyName, ValueName, NewValueInt, [CreateIfNotExists]", Return = "bool", Notes = "Overwrites the specified value with a new integer value. If CreateIfNotExists is true (default) and the value doesn't exist, it is first created. Returns true if the value was successfully set, false if not (didn't exists, CreateIfNotExists false)." },
				WriteFile = { Params = "FileName", Return = "bool", Notes = "Writes the current in-memory data into the specified file. Returns true if successful, false if not." },
			},
			Constants =
			{
				noID = { Notes = "" },
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
for k = 0, NumKeys do
	local NumValues = IniFile:GetNumValues(k);
	LOG("key \"" .. IniFile:GetKeyName(k) .. "\" has " .. NumValues .. " values:");
	for v = 0, NumValues do
		LOG("  value \"" .. IniFile:GetValueName(k, v) .. "\".");
	end
end
</pre>
					]],
				},
			},  -- AdditionalInfo
		},  -- cIniFile

		cInventory =
		{
			Desc = [[This object is used to store the items that a {{cPlayer|cPlayer}} has. It also keeps track of what item the player has currently selected in their hotbar.
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
				AddItem = { Params = "{{cItem|cItem}}, [AllowNewStacks]", Return = "number", Notes = "Adds an item to the storage; if AllowNewStacks is true (default), will also create new stacks in empty slots. Returns the number of items added" },
				AddItems = { Params = "{{cItems|cItems}}, [AllowNewStacks]", Return = "number", Notes = "Same as AddItem, but for several items at once" },
				ChangeSlotCount = { Params = "SlotNum, AddToCount", Return = "number", Notes = "Adds AddToCount to the count of items in the specified slot. If the slot was empty, ignores the call. Returns the new count in the slot, or -1 if invalid SlotNum" },
				Clear = { Params = "", Return = "", Notes = "Empties all slots" },
				CopyToItems = { Params = "{{cItems|cItems}}", Return = "", Notes = "Copies all non-empty slots into the cItems object provided; original cItems contents are preserved" },
				DamageEquippedItem = { Params = "[DamageAmount]", Return = "bool", Notes = "Adds the specified damage (1 by default) to the currently equipped it" },
				DamageItem = { Params = "SlotNum, [DamageAmount]", Return = "bool", Notes = "Adds the specified damage (1 by default) to the specified item, returns true if the item reached its max damage and should be destroyed" },
				GetArmorGrid = { Params = "", Return = "{{cItemGrid|cItemGrid}}", Notes = "Returns the ItemGrid representing the armor grid (1 x 4 slots)" },
				GetArmorSlot = { Params = "ArmorSlotNum", Return = "{{cItem|cItem}}", Notes = "Returns the specified armor slot contents. Note that the returned item is read-only" },
				GetEquippedBoots = { Params = "", Return = "{{cItem|cItem}}", Notes = "Returns the item in the \"boots\" slot of the armor grid. Note that the returned item is read-only" },
				GetEquippedChestplate = { Params = "", Return = "{{cItem|cItem}}", Notes = "Returns the item in the \"chestplate\" slot of the armor grid. Note that the returned item is read-only" },
				GetEquippedHelmet = { Params = "", Return = "{{cItem|cItem}}", Notes = "Returns the item in the \"helmet\" slot of the armor grid. Note that the returned item is read-only" },
				GetEquippedItem = { Params = "", Return = "{{cItem|cItem}}", Notes = "Returns the currently selected item from the hotbar. Note that the returned item is read-only" },
				GetEquippedLeggings = { Params = "", Return = "{{cItem|cItem}}", Notes = "Returns the item in the \"leggings\" slot of the armor grid. Note that the returned item is read-only" },
				GetEquippedSlotNum = { Params = "", Return = "number", Notes = "Returns the hotbar slot number for the currently selected item" },
				GetHotbarGrid = { Params = "", Return = "{{cItemGrid|cItemGrid}}", Notes = "Returns the ItemGrid representing the hotbar grid (9 x 1 slots)" },
				GetHotbarSlot = { Params = "HotBarSlotNum", Return = "{{cItem|cItem}}", Notes = "Returns the specified hotbar slot contents. Note that the returned item is read-only" },
				GetInventoryGrid = { Params = "", Return = "{{cItemGrid|cItemGrid}}", Notes = "Returns the ItemGrid representing the main inventory (9 x 3 slots)" },
				GetInventorySlot = { Params = "InventorySlotNum", Return = "{{cItem|cItem}}", Notes = "Returns the specified main inventory slot contents. Note that the returned item is read-only" },
				GetOwner = { Params = "", Return = "{{cPlayer|cPlayer}}", Notes = "Returns the player whose inventory this object represents" },
				GetSlot = { Params = "SlotNum", Return = "{{cItem|cItem}}", Notes = "Returns the contents of the specified slot. Note that the returned item is read-only" },
				HasItems = { Params = "{{cItem|cItem}}", Return = "bool", Notes = "Returns true if there are at least as many items of the specified type as in the parameter" },
				HowManyCanFit = { Params = "{{cItem|cItem}}", Return = "number", Notes = "Returns the number of the specified items that can fit in the storage, including empty slots" },
				HowManyItems = { Params = "{{cItem|cItem}}", Return = "number", Notes = "Returns the number of the specified items that are currently stored" },
				RemoveItem = { Params = "{{cItem}}", Return = "number", Notes = "Removes the specified item from the inventory, as many as possible, up to the item's m_ItemCount. Returns the number of items that were removed." },
				RemoveOneEquippedItem = { Params = "", Return = "", Notes = "Removes one item from the hotbar's currently selected slot" },
				SetArmorSlot = { Params = "ArmorSlotNum, {{cItem|cItem}}", Return = "", Notes = "Sets the specified armor slot contents" },
				SetEquippedSlotNum = { Params = "EquippedSlotNum", Return = "", Notes = "Sets the currently selected hotbar slot number" },
				SetHotbarSlot = { Params = "HotbarSlotNum, {{cItem|cItem}}", Return = "", Notes = "Sets the specified hotbar slot contents" },
				SetInventorySlot = { Params = "InventorySlotNum, {{cItem|cItem}}", Return = "", Notes = "Sets the specified main inventory slot contents" },
				SetSlot = { Params = "SlotNum, {{cItem|cItem}}", Return = "", Notes = "Sets the specified slot contents" },
			},
			Constants =
			{
				invArmorCount      = { Notes = "Number of slots in the Armor part" },
				invArmorOffset     = { Notes = "Starting slot number of the Armor part" },
				invInventoryCount  = { Notes = "Number of slots in the main inventory part" },
				invInventoryOffset = { Notes = "Starting slot number of the main inventory part" },
				invHotbarCount     = { Notes = "Number of slots in the Hotbar part" },
				invHotbarOffset    = { Notes = "Starting slot number of the Hotbar part" },
				invNumSlots        = { Notes = "Total number of slots in a cInventory" },
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
		},  -- cInventory

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
				constructor =
				{
					{ Params = "", Return = "cItem", Notes = "Creates a new empty cItem object" },
					{ Params = "ItemType, Count, Damage, EnchantmentString, CustomName, Lore", Return = "cItem", Notes = "Creates a new cItem object of the specified type, count (1 by default), damage (0 by default), enchantments (non-enchanted by default), CustomName (empty by default) and Lore (string, empty by default)" },
					{ Params = "cItem", Return = "cItem", Notes = "Creates an exact copy of the cItem object in the parameter" },
				} ,
				AddCount = { Params = "AmountToAdd", Return = "cItem", Notes = "Adds the specified amount to the item count. Returns self (useful for chaining)." },
				Clear = { Params = "", Return = "", Notes = "Resets the instance to an empty item" },
				CopyOne = { Params = "", Return = "cItem", Notes = "Creates a copy of this object, with its count set to 1" },
				DamageItem = { Params = "[Amount]", Return = "bool", Notes = "Adds the specified damage. Returns true when damage reaches max value and the item should be destroyed (but doesn't destroy the item)" },
				Empty = { Params = "", Return = "", Notes = "Resets the instance to an empty item" },
				GetMaxDamage = { Params = "", Return = "number", Notes = "Returns the maximum value for damage that this item can get before breaking; zero if damage is not accounted for for this item type" },
				GetMaxStackSize = { Params = "", Return = "number", Notes = "Returns the maximum stack size for this item." },
				IsDamageable = { Params = "", Return = "bool", Notes = "Returns true if this item does account for its damage" },
				IsEmpty = { Params = "", Return = "bool", Notes = "Returns true if this object represents an empty item (zero count or invalid ID)" },
				IsEqual = { Params = "cItem", Return = "bool", Notes = "Returns true if the item in the parameter is the same as the one stored in the object (type, damage, lore, name and enchantments)" },
				IsFullStack = { Params = "", Return = "bool", Notes = "Returns true if the item is stacked up to its maximum stacking" },
				IsSameType = { Params = "cItem", Return = "bool", Notes = "Returns true if the item in the parameter is of the same ItemType as the one stored in the object. This is true even if the two items have different enchantments" },
				IsBothNameAndLoreEmpty = { Params = "", Return = "bool", Notes = "Returns if both the custom name and lore are not set." },
				IsCustomNameEmpty = { Params = "", Return = "bool", Notes = "Returns if the custom name of the cItem is empty." },
				IsLoreEmpty = { Params = "", Return = "", Notes = "Returns if the lore of the cItem is empty." },
				GetEnchantability = { Params = "", Return = "number", Notes = "Returns the enchantability of the item. When the item hasn't a enchantability, it will returns 0" },
				EnchantByXPLevels = { Params = "NumXPLevels", Return = "bool", Notes = "Enchants the item using the specified number of XP levels. Returns true if item enchanted, false if not." },
				IsEnchantable = { Params = "ItemType, WithBook", Return = "bool", Notes = "(STATIC) Returns true if the specified item type is enchantable. If WithBook is true, the function is used in the anvil inventory with book enchantments. So it checks the \"only book enchantments\" too. Example: You can only enchant a hoe with a book." },
			},
			Variables =
			{
				m_Enchantments = { Type = "{{cEnchantments}}", Notes = "The enchantments that this item has" },
				m_ItemCount    = { Type = "number", Notes = "Number of items in this stack" },
				m_ItemDamage   = { Type = "number", Notes = "The damage of the item. Zero means no damage. Maximum damage can be queried with GetMaxDamage()" },
				m_ItemType     = { Type = "number", Notes = "The item type. One of E_ITEM_ or E_BLOCK_ constants" },
				m_CustomName   = { Type = "string", Notes = "The custom name for an item." },
				m_Lore         = { Type = "string", Notes = "The lore for an item. Line breaks are represented by the ` character." },
				m_RepairCost   = { Type = "number", Notes = "The repair cost of the item. The anvil need this value" },
				m_Enchantments = { Type = "{{cEnchantments|cEnchantments}}}", Notes = "The enchantments of the item." },
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
		},  -- cItem

		cObjective =
		{
			Desc = [[
				This class represents a single scoreboard objective.
			]],
			Functions =
			{
				AddScore = { Params = "string, number", Return = "Score", Notes = "Adds a value to the score of the specified player and returns the new value." },
				GetDisplayName = { Params = "", Return = "string", Notes = "Returns the display name of the objective. This name will be shown to the connected players." },
				GetName = { Params = "", Return = "string", Notes = "Returns the internal name of the objective." },
				GetScore = { Params = "string", Return = "Score", Notes = "Returns the score of the specified player." },
				GetType = { Params = "", Return = "eType", Notes = "Returns the type of the objective. (i.e what is being tracked)" },
				Reset = { Params = "", Return = "", Notes = "Resets the scores of the tracked players." },
				ResetScore = { Params = "string", Return = "", Notes = "Reset the score of the specified player." },
				SetDisplayName = { Params = "string", Return = "", Notes = "Sets the display name of the objective." },
				SetScore = { Params = "string, Score", Return = "", Notes = "Sets the score of the specified player." },
				SubScore = { Params = "string, number", Return = "Score", Notes = "Subtracts a value from the score of the specified player and returns the new value." },
			},
			Constants =
			{
				otAchievement = { Notes = "" },
				otDeathCount = { Notes = "" },
				otDummy = { Notes = "" },
				otHealth = { Notes = "" },
				otPlayerKillCount = { Notes = "" },
				otStat = { Notes = "" },
				otStatBlockMine = { Notes = "" },
				otStatEntityKill = { Notes = "" },
				otStatEntityKilledBy = { Notes = "" },
				otStatItemBreak = { Notes = "" },
				otStatItemCraft = { Notes = "" },
				otStatItemUse = { Notes = "" },
				otTotalKillCount = { Notes = "" },
			},
		}, -- cObjective

		cPainting =
		{
			Desc = "This class represents a painting in the world. These paintings are special and different from Vanilla in that they can be critical-hit.",
			Functions =
			{
				GetDirection = { Params = "", Return = "number", Notes = "Returns the direction the painting faces. Directions: ZP - 0, ZM - 2, XM - 1, XP - 3. Note that these are not the BLOCK_FACE constants." },
				GetName = { Params = "", Return = "string", Notes = "Returns the name of the painting" },
			},

		}, -- cPainting

		cItemGrid =
		{
			Desc = [[This class represents a 2D array of items. It is used as the underlying storage and API for all cases that use a grid of items:
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
				AddItem = { Params = "{{cItem|cItem}}, [AllowNewStacks]", Return = "number", Notes = "Adds an item to the storage; if AllowNewStacks is true (default), will also create new stacks in empty slots. Returns the number of items added" },
				AddItems = { Params = "{{cItems|cItems}}, [AllowNewStacks]", Return = "number", Notes = "Same as AddItem, but for several items at once" },
				ChangeSlotCount =
				{
					{ Params = "SlotNum, AddToCount", Return = "number", Notes = "Adds AddToCount to the count of items in the specified slot. If the slot was empty, ignores the call. Returns the new count in the slot, or -1 if invalid SlotNum" },
					{ Params = "X, Y, AddToCount", Return = "number", Notes = "Adds AddToCount to the count of items in the specified slot. If the slot was empty, ignores the call. Returns the new count in the slot, or -1 if invalid slot coords" },
				},
				Clear = { Params = "", Return = "", Notes = "Empties all slots" },
				CopyToItems = { Params = "{{cItems|cItems}}", Return = "", Notes = "Copies all non-empty slots into the cItems object provided; original cItems contents are preserved" },
				DamageItem =
				{
					{ Params = "SlotNum, [DamageAmount]", Return = "bool", Notes = "Adds the specified damage (1 by default) to the specified item, returns true if the item reached its max damage and should be destroyed" },
					{ Params = "X, Y, [DamageAmount]", Return = "bool", Notes = "Adds the specified damage (1 by default) to the specified item, returns true if the item reached its max damage and should be destroyed" },
				},
				EmptySlot =
				{
					{ Params = "SlotNum", Return = "", Notes = "Destroys the item in the specified slot" },
					{ Params = "X, Y", Return = "", Notes = "Destroys the item in the specified slot" },
				},
				GetFirstEmptySlot = { Params = "", Return = "number", Notes = "Returns the SlotNumber of the first empty slot, -1 if all slots are full" },
				GetFirstUsedSlot = { Params = "", Return = "number", Notes = "Returns the SlotNumber of the first non-empty slot, -1 if all slots are empty" },
				GetHeight = { Params = "", Return = "number", Notes = "Returns the Y dimension of the grid" },
				GetLastEmptySlot = { Params = "", Return = "number", Notes = "Returns the SlotNumber of the last empty slot, -1 if all slots are full" },
				GetLastUsedSlot = { Params = "", Return = "number", Notes = "Returns the SlotNumber of the last non-empty slot, -1 if all slots are empty" },
				GetNextEmptySlot = { Params = "StartFrom", Return = "number", Notes = "Returns the SlotNumber of the first empty slot following StartFrom, -1 if all the following slots are full" },
				GetNextUsedSlot = { Params = "StartFrom", Return = "number", Notes = "Returns the SlotNumber of the first non-empty slot following StartFrom, -1 if all the following slots are full" },
				GetNumSlots = { Params = "", Return = "number", Notes = "Returns the total number of slots in the grid (Width * Height)" },
				GetSlot =
				{
					{ Params = "SlotNumber", Return = "{{cItem|cItem}}", Notes = "Returns the item in the specified slot. Note that the item is read-only" },
					{ Params = "X, Y", Return = "{{cItem|cItem}}", Notes = "Returns the item in the specified slot. Note that the item is read-only" },
				},
				GetSlotCoords = { Params = "SlotNum", Return = "number, number", Notes = "Returns the X and Y coords for the specified SlotNumber. Returns \"-1, -1\" on invalid SlotNumber" },
				GetSlotNum = { Params = "X, Y", Return = "number", Notes = "Returns the SlotNumber for the specified slot coords. Returns -1 on invalid coords" },
				GetWidth = { Params = "", Return = "number", Notes = "Returns the X dimension of the grid" },
				HasItems = { Params = "{{cItem|cItem}}", Return = "bool", Notes = "Returns true if there are at least as many items of the specified type as in the parameter" },
				HowManyCanFit = { Params = "{{cItem|cItem}}", Return = "number", Notes = "Returns the number of the specified items that can fit in the storage, including empty slots" },
				HowManyItems = { Params = "{{cItem|cItem}}", Return = "number", Notes = "Returns the number of the specified items that are currently stored" },
				IsSlotEmpty =
				{
					{ Params = "SlotNum", Return = "bool", Notes = "Returns true if the specified slot is empty, or an invalid slot is specified" },
					{ Params = "X, Y", Return = "bool", Notes = "Returns true if the specified slot is empty, or an invalid slot is specified" },
				},
				RemoveItem = { Params = "{{cItem}}", Return = "number", Notes = "Removes the specified item from the grid, as many as possible, up to the item's m_ItemCount. Returns the number of items that were removed." },
				RemoveOneItem =
				{
					{ Params = "SlotNum", Return = "{{cItem|cItem}}", Notes = "Removes one item from the stack in the specified slot and returns it as a single cItem. Empty slots are skipped and an empty item is returned" },
					{ Params = "X, Y", Return = "{{cItem|cItem}}", Notes = "Removes one item from the stack in the specified slot and returns it as a single cItem. Empty slots are skipped and an empty item is returned" },
				},
				SetSlot =
				{
					{ Params = "SlotNum, {{cItem|cItem}}", Return = "", Notes = "Sets the specified slot to the specified item" },
					{ Params = "X, Y, {{cItem|cItem}}", Return = "", Notes = "Sets the specified slot to the specified item" },
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
			},  -- AdditionalInfo
		},  -- cItemGrid

		cItems =
		{
			Desc = [[
				This class represents a numbered collection (array) of {{cItem}} objects. The array indices start at
				zero, each consecutive item gets a consecutive index. This class is used for spawning multiple
				pickups or for mass manipulating an inventory.
				]],
			Functions =
			{
				constructor = { Params = "", Return = "cItems", Notes = "Creates a new cItems object" },
				Add =
				{
					{ Params = "{{cItem|cItem}}", Return = "", Notes = "Adds a new item to the end of the collection" },
					{ Params = "ItemType, ItemCount, ItemDamage", Return = "", Notes = "Adds a new item to the end of the collection" },
				},
				Clear = { Params = "", Return = "", Notes = "Removes all items from the collection" },
				Delete = { Params = "Index", Return = "", Notes = "Deletes item at the specified index" },
				Get = { Params = "Index", Return = "{{cItem|cItem}}", Notes = "Returns the item at the specified index" },
				Set =
				{
					{ Params = "Index, {{cItem|cItem}}", Return = "", Notes = "Sets the item at the specified index to the specified item" },
					{ Params = "Index, ItemType, ItemCount, ItemDamage", Return = "", Notes = "Sets the item at the specified index to the specified item" },
				},
				Size = { Params = "", Return = "number", Notes = "Returns the number of items in the collection" },
			},
		},  -- cItems

		cLuaWindow =
		{
			Desc = [[This class is used by plugins wishing to display a custom window to the player, unrelated to block entities or entities near the player. The window can be of any type and have any contents that the plugin defines. Callbacks for when the player modifies the window contents and when the player closes the window can be set.
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
				constructor = { Params = "WindowType, ContentsWidth, ContentsHeight, Title", Return = "", Notes = "Creates a new object of this class" },
				GetContents = { Params = "", Return = "{{cItemGrid|cItemGrid}}", Notes = "Returns the cItemGrid object representing the internal storage in this window" },
				SetOnClosing = { Params = "OnClosingCallback", Return = "", Notes = "Sets the function that the window will call when it is about to be closed by a player" },
				SetOnSlotChanged = { Params = "OnSlotChangedCallback", Return = "", Notes = "Sets the function that the window will call when a slot is changed by a player" },
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
local Window = cLuaWindow(cWindow.Hopper, 3, 3, "TestWnd");
Window:SetSlot(a_Player, 0, cItem(E_ITEM_DIAMOND, 64));
Window:SetOnClosing(OnClosing);
Window:SetOnSlotChanged(OnSlotChanged);

-- Open the window:
a_Player:OpenWindow(Window);
</pre>
					]],
				},
			},  -- AdditionalInfo
			Inherits = "cWindow",
		},  -- cLuaWindow

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
				EraseData = { Params = "", Return = "", Notes = "Erases all pixel data." },
				GetCenterX = { Params = "", Return = "number", Notes = "Returns the X coord of the map's center." },
				GetCenterZ = { Params = "", Return = "number", Notes = "Returns the Y coord of the map's center." },
				GetDimension = { Params = "", Return = "eDimension", Notes = "Returns the dimension of the associated world." },
				GetHeight = { Params = "", Return = "number", Notes = "Returns the height of the map." },
				GetID = { Params = "", Return = "number", Notes = "Returns the numerical ID of the map. (The item damage value)" },
				GetName = { Params = "", Return = "string", Notes = "Returns the name of the map." },
				GetNumPixels = { Params = "", Return = "number", Notes = "Returns the number of pixels in this map." },
				GetPixel = { Params = "PixelX, PixelZ", Return = "ColorID", Notes = "Returns the color of the specified pixel." },
				GetPixelWidth = { Params = "", Return = "number", Notes = "Returns the width of a single pixel in blocks." },
				GetScale = { Params = "", Return = "number", Notes = "Returns the scale of the map. Range: [0,4]" },
				GetWidth = { Params = "", Return = "number", Notes = "Returns the width of the map." },
				GetWorld = { Params = "", Return = "cWorld", Notes = "Returns the associated world." },
				Resize = { Params = "Width, Height", Return = "", Notes = "Resizes the map. WARNING: This will erase the pixel data." },
				SetPixel = { Params = "PixelX, PixelZ, ColorID", Return = "bool", Notes = "Sets the color of the specified pixel. Returns false on error (Out of range)." },
				SetPosition = { Params = "CenterX, CenterZ", Return = "", Notes = "Relocates the map. The pixel data will not be modified." },
				SetScale = { Params = "number", Return = "", Notes = "Rescales the map. The pixel data will not be modified." },
			},
			Constants =
			{
				E_BASE_COLOR_BLUE = { Notes = "" },
				E_BASE_COLOR_BROWN = { Notes = "" },
				E_BASE_COLOR_DARK_BROWN = { Notes = "" },
				E_BASE_COLOR_DARK_GRAY = { Notes = "" },
				E_BASE_COLOR_DARK_GREEN = { Notes = "" },
				E_BASE_COLOR_GRAY_1 = { Notes = "" },
				E_BASE_COLOR_GRAY_2 = { Notes = "" },
				E_BASE_COLOR_LIGHT_BROWN = { Notes = "" },
				E_BASE_COLOR_LIGHT_GRAY = { Notes = "" },
				E_BASE_COLOR_LIGHT_GREEN = { Notes = "" },
				E_BASE_COLOR_PALE_BLUE = { Notes = "" },
				E_BASE_COLOR_RED = { Notes = "" },
				E_BASE_COLOR_TRANSPARENT = { Notes = "" },
				E_BASE_COLOR_WHITE = { Notes = "" },
			},
		}, -- cMap

		cMapManager =
		{
			Desc = [[
				This class is associated with a single {{cWorld}} instance and manages a list of maps.
			]],
			Functions =
			{
				DoWithMap = { Params = "ID, CallbackFunction", Return = "bool", Notes = "If a map with the specified ID exists, calls the CallbackFunction for that map. The CallbackFunction has the following signature: <pre class=\"prettyprint lang-lua\">function Callback({{cMap|Map}})</pre> Returns true if the map was found and the callback called, false if map not found." },
				GetNumMaps = { Params = "", Return = "number", Notes = "Returns the number of registered maps." },
			},

		}, -- cMapManager

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
				AddPlayerNameToUUIDMapping = { Params = "PlayerName, UUID", Return = "", Notes = "(STATIC) Adds the specified PlayerName-to-UUID mapping into the cache, with current timestamp. Accepts both short or dashed UUIDs. " },
				GetPlayerNameFromUUID = { Params = "UUID, [UseOnlyCached]", Return = "PlayerName", Notes = "(STATIC) Returns the playername that corresponds to the given UUID, or an empty string on error. If UseOnlyCached is false (the default), queries the Mojang servers if the UUID is not in the cache. The UUID can be either short or dashed. <br /><b>WARNING</b>: Do NOT use this function with UseOnlyCached set to false while the server is running. Only use it when the server is starting up (inside the Initialize() method), otherwise you will lag the server severely." },
				GetUUIDFromPlayerName = { Params = "PlayerName, [UseOnlyCached]", Return = "UUID", Notes = "(STATIC) Returns the (short) UUID that corresponds to the given playername, or an empty string on error. If UseOnlyCached is false (the default), queries the Mojang servers if the playername is not in the cache. <br /><b>WARNING</b>: Do NOT use this function with UseOnlyCached set to false while the server is running. Only use it when the server is starting up (inside the Initialize() method), otherwise you will lag the server severely." },
				GetUUIDsFromPlayerNames = { Params = "PlayerNames, [UseOnlyCached]", Return = "table", Notes = "(STATIC) Returns a table that contains the map, 'PlayerName' -> '(short) UUID', for all valid playernames in the input array-table. PlayerNames not recognized will not be set in the returned map. If UseOnlyCached is false (the default), queries the Mojang servers for the results that are not in the cache. <br /><b>WARNING</b>: Do NOT use this function with UseOnlyCached set to false while the server is running. Only use it when the server is starting up (inside the Initialize() method), otherwise you will lag the server severely." },
				MakeUUIDDashed = { Params = "UUID", Return = "DashedUUID", Notes = "(STATIC) Converts the UUID to a dashed format (\"01234567-8901-2345-6789-012345678901\"). Accepts both dashed or short UUIDs. Logs a warning and returns an empty string if UUID format not recognized." },
				MakeUUIDShort = { Params = "UUID", Return = "ShortUUID", Notes = "(STATIC) Converts the UUID to a short format (without dashes, \"01234567890123456789012345678901\"). Accepts both dashed or short UUIDs. Logs a warning and returns an empty string if UUID format not recognized." },
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
				HasCustomName = { Params = "", Return = "bool", Notes = "Returns true if the monster has a custom name." },
				GetCustomName = { Params = "", Return = "string", Notes = "Gets the custom name of the monster. If no custom name is set, the function returns an empty string." },
				SetCustomName = { Params = "string", Return = "", Notes = "Sets the custom name of the monster. You see the name over the monster. If you want to disable the custom name, simply set an empty string." },
				IsCustomNameAlwaysVisible = { Params = "", Return = "bool", Notes = "Is the custom name of this monster always visible? If not, you only see the name when you sight the mob." },
				SetCustomNameAlwaysVisible = { Params = "bool", Return = "", Notes = "Sets the custom name visiblity of this monster. If it's false, you only see the name when you sight the mob. If it's true, you always see the custom name." },
				FamilyFromType = { Params = "{{Globals#MobType|MobType}}", Return = "{{cMonster#MobFamily|MobFamily}}", Notes = "(STATIC) Returns the mob family ({{cMonster#MobFamily|mfXXX}} constants) based on the mob type ({{Globals#MobType|mtXXX}} constants)" },
				GetMobFamily = { Params = "", Return = "{{cMonster#MobFamily|MobFamily}}", Notes = "Returns this mob's family ({{cMonster#MobFamily|mfXXX}} constant)" },
				GetMobType = { Params = "", Return = "{{Globals#MobType|MobType}}", Notes = "Returns the type of this mob ({{Globals#MobType|mtXXX}} constant)" },
				GetSpawnDelay = { Params = "{{cMonster#MobFamily|MobFamily}}", Return = "number", Notes = "(STATIC) Returns the spawn delay  - the number of game ticks between spawn attempts - for the specified mob family." },
				MobTypeToString = { Params = "{{Globals#MobType|MobType}}", Return = "string", Notes = "(STATIC) Returns the string representing the given mob type ({{Globals#MobType|mtXXX}} constant), or empty string if unknown type." },
				MobTypeToVanillaName = { Params = "{{Globals#MobType|MobType}}", Return = "string", Notes = "(STATIC) Returns the vanilla name of the given mob type, or empty string if unknown type." },
				MoveToPosition = { Params = "Position", Return = "", Notes = "Moves mob to the specified position" },
				StringToMobType = { Params = "string", Return = "{{Globals#MobType|MobType}}", Notes = "(STATIC) Returns the mob type ({{Globals#MobType|mtXXX}} constant) parsed from the string type (\"creeper\"), or mtInvalidType if unrecognized." },
				GetRelativeWalkSpeed = { Params = "", Return = "number", Notes = "Returns the relative walk speed of this mob. Standard is 1.0" },
				SetRelativeWalkSpeed = { Params = "number", Return = "", Notes = "Sets the relative walk speed of this mob. Standard is 1.0" },
				SetAge = { Params = "number", Return = "", Notes = "Sets the age of the monster" },
				GetAge = { Params = "", Return = "number", Notes = "Returns the age of the monster" },
				IsBaby = { Params = "", Return = "bool", Notes = "Returns true if the monster is a baby" },
			},
			Constants =
			{
				mfAmbient = { Notes = "Family: ambient (bat)" },
				mfHostile = { Notes = "Family: hostile (blaze, cavespider, creeper, enderdragon, enderman, ghast, giant, magmacube, silverfish, skeleton, slime, spider, witch, wither, zombie, zombiepigman)" },
				mfMaxplusone = { Notes = "The maximum family value, plus one. Returned when monster family not recognized." },
				mfPassive = { Notes = "Family: passive (chicken, cow, horse, irongolem, mooshroom, ocelot, pig, sheep, snowgolem, villager, wolf)" },
				mfWater = { Notes = "Family: water (squid)" },
				mtBat = { Notes = "" },
				mtBlaze = { Notes = "" },
				mtCaveSpider = { Notes = "" },
				mtChicken = { Notes = "" },
				mtCow = { Notes = "" },
				mtCreeper = { Notes = "" },
				mtEnderDragon = { Notes = "" },
				mtEnderman = { Notes = "" },
				mtGhast = { Notes = "" },
				mtGiant = { Notes = "" },
				mtHorse = { Notes = "" },
				mtInvalidType = { Notes = "Invalid monster type. Returned when monster type not recognized" },
				mtIronGolem = { Notes = "" },
				mtMagmaCube = { Notes = "" },
				mtMooshroom = { Notes = "" },
				mtOcelot = { Notes = "" },
				mtPig = { Notes = "" },
				mtSheep = { Notes = "" },
				mtSilverfish = { Notes = "" },
				mtSkeleton = { Notes = "" },
				mtSlime = { Notes = "" },
				mtSnowGolem = { Notes = "" },
				mtSpider = { Notes = "" },
				mtSquid = { Notes = "" },
				mtVillager = { Notes = "" },
				mtWitch = { Notes = "" },
				mtWither = { Notes = "" },
				mtWolf = { Notes = "" },
				mtZombie = { Notes = "" },
				mtZombiePigman = { Notes = "" },
			},
			ConstantGroups =
			{
				MobFamily =
				{
					Include = "mf.*",
					TextBefore = [[
						Mobs are divided into families. The following constants are used for individual family types:
					]],
				},
			},
			Inherits = "cPawn",
		},  -- cMonster

		cPawn =
		{
			Desc = [[cPawn is a controllable pawn object, controlled by either AI or a player. cPawn inherits all functions and members of {{cEntity}}
]],
			Functions =
			{
				TeleportToEntity = { Return = "" },
				TeleportTo = { Return = "" },
				Heal = { Return = "" },
				TakeDamage = { Return = "" },
				KilledBy = { Return = "" },
				GetHealth = { Return = "number" },
				AddEntityEffect = { Params = "{{cEntityEffect|EffectType}}", Return = "", Notes = "Applies an entity effect" },
				RemoveEntityEffect = { Params = "{{cEntityEffect|EffectType}}", Return = "", Notes = "Removes a currently applied entity effect" },
				HasEntityEffect = { Return = "bool", Params = "{{cEntityEffect|EffectType}}", Notes = "Returns true, if the supplied entity effect type is currently applied" },
				ClearEntityEffects = { Return = "", Notes = "Removes all currently applied entity effects" },
			},
			Inherits = "cEntity",
		},  -- cPawn

		cPickup =
		{
			Desc = [[
				This class represents a pickup entity (an item that the player or mobs can pick up). It is also
				commonly known as "drops". With this class you could create your own "drop" or modify those
				created automatically.
			]],
			Functions =
			{
				CollectedBy = { Params = "{{cPlayer}}", Return = "bool", Notes = "Tries to make the player collect the pickup. Returns true if the pickup was collected, at least partially." },
				GetAge = { Params = "", Return = "number", Notes = "Returns the number of ticks that the pickup has existed." },
				GetItem = { Params = "", Return = "{{cItem|cItem}}", Notes = "Returns the item represented by this pickup" },
				IsCollected = { Params = "", Return = "bool", Notes = "Returns true if this pickup has already been collected (is waiting to be destroyed)" },
				IsPlayerCreated = { Params = "", Return = "bool", Notes = "Returns true if the pickup was created by a player" },
				SetAge = { Params = "AgeTicks", Return = "", Notes = "Sets the pickup's age, in ticks." },
			},
			Inherits = "cEntity",
		},  -- cPickup

		cPlayer =
		{
			Desc = [[
				This class describes a player in the server. cPlayer inherits all functions and members of
				{{cPawn|cPawn}}. It handles all the aspects of the gameplay, such as hunger, sprinting, inventory
				etc.
			]],
			Functions =
			{
				AddFoodExhaustion = { Params = "Exhaustion", Return = "", Notes = "Adds the specified number to the food exhaustion. Only positive numbers expected." },
				CalcLevelFromXp = { Params = "XPAmount", Return = "number", Notes = "(STATIC) Returns the level which is reached with the specified amount of XP. Inverse of XpForLevel()." },
				CanFly = { Return = "bool", Notes = "Returns if the player is able to fly." },
				CloseWindow = { Params = "[CanRefuse]", Return = "", Notes = "Closes the currently open UI window. If CanRefuse is true (default), the window may refuse the closing." },
				CloseWindowIfID = { Params = "WindowID, [CanRefuse]", Return = "", Notes = "Closes the currently open UI window if its ID matches the given ID. If CanRefuse is true (default), the window may refuse the closing." },
				DeltaExperience = { Params = "DeltaXP", Return = "", Notes = "Adds or removes XP from the current XP amount. Won't allow XP to go negative. Returns the new experience, -1 on error (XP overflow)." },
				Feed = { Params = "AddFood, AddSaturation", Return = "bool", Notes = "Tries to add the specified amounts to food level and food saturation level (only positive amounts expected). Returns true if player was hungry and the food was consumed, false if too satiated." },
				FoodPoison = { Params = "NumTicks", Return = "", Notes = "Starts the food poisoning for the specified amount of ticks; if already foodpoisoned, sets FoodPoisonedTicksRemaining to the larger of the two" },
				ForceSetSpeed = { Params = "{{Vector3d|Direction}}", Notes = "Forces the player to move to the given direction." },
				GetClientHandle = { Params = "", Return = "{{cClientHandle}}", Notes = "Returns the client handle representing the player's connection. May be nil (AI players)." },
				GetColor = { Return = "string", Notes = "Returns the full color code to be used for this player's messages (based on their rank). Prefix player messages with this code." },
				GetCurrentXp = { Params = "", Return = "number", Notes = "Returns the current amount of XP" },
				GetCustomName = { Params = "", Return = "string", Notes = "Returns the custom name of this player. If the player hasn't a custom name, it will return an empty string." },
				GetEffectiveGameMode = { Params = "", Return = "{{Globals#GameMode|GameMode}}", Notes = "(OBSOLETE) Returns the current resolved game mode of the player. If the player is set to inherit the world's gamemode, returns that instead. See also GetGameMode() and IsGameModeXXX() functions. Note that this function is the same as GetGameMode(), use that function instead." },
				GetEquippedItem = { Params = "", Return = "{{cItem}}", Notes = "Returns the item that the player is currently holding; empty item if holding nothing." },
				GetEyeHeight = { Return = "number", Notes = "Returns the height of the player's eyes, in absolute coords" },
				GetEyePosition = { Return = "{{Vector3d|EyePositionVector}}", Notes = "Returns the position of the player's eyes, as a {{Vector3d}}" },
				GetFloaterID = { Params = "", Return = "number", Notes = "Returns the Entity ID of the fishing hook floater that belongs to the player. Returns -1 if no floater is associated with the player. FIXME: Undefined behavior when the player has used multiple fishing rods simultanously." },
				GetFlyingMaxSpeed = { Params = "", Return = "number", Notes = "Returns the maximum flying speed, relative to the default game flying speed. Defaults to 1, but plugins may modify it for faster or slower flying." },
				GetFoodExhaustionLevel = { Params = "", Return = "number", Notes = "Returns the food exhaustion level" },
				GetFoodLevel = { Params = "", Return = "number", Notes = "Returns the food level (number of half-drumsticks on-screen)" },
				GetFoodPoisonedTicksRemaining = { Params = "", Return = "", Notes = "Returns the number of ticks left for the food posoning effect" },
				GetFoodSaturationLevel = { Params = "", Return = "number", Notes = "Returns the food saturation (overcharge of the food level, is depleted before food level)" },
				GetFoodTickTimer = { Params = "", Return = "", Notes = "Returns the number of ticks past the last food-based heal or damage action; when this timer reaches 80, a new heal / damage is applied." },
				GetGameMode = { Return = "{{Globals#GameMode|GameMode}}", Notes = "Returns the player's gamemode. The player may have their gamemode unassigned, in which case they inherit the gamemode from the current {{cWorld|world}}.<br /> <b>NOTE:</b> Instead of comparing the value returned by this function to the gmXXX constants, use the IsGameModeXXX() functions. These functions handle the gamemode inheritance automatically."},
				GetIP = { Return = "string", Notes = "Returns the IP address of the player, if available. Returns an empty string if there's no IP to report."},
				GetInventory = { Return = "{{cInventory|Inventory}}", Notes = "Returns the player's inventory"},
				GetLastBedPos = { Params = "", Return = "{{Vector3i}}", Notes = "Returns the position of the last bed the player has slept in, or the world's spawn if no such position was recorded." },
				GetMaxSpeed = { Params = "", Return = "number", Notes = "Returns the player's current maximum speed, relative to the game default speed. Takes into account the sprinting / flying status." },
				GetName = { Return = "string", Notes = "Returns the player's name" },
				GetNormalMaxSpeed = { Params = "", Return = "number", Notes = "Returns the player's maximum walking speed, relative to the game default speed. Defaults to 1, but plugins may modify it for faster or slower walking." },
				GetPermissions = { Params = "", Return = "array-table of strings", Notes = "Returns the list of all permissions that the player has assigned to them through their rank." },
				GetPlayerListName = { Return = "string", Notes = "Returns the name that is used in the playerlist." },
				GetResolvedPermissions = { Return = "array-table of string", Notes = "Returns all the player's permissions, as a table. The permissions are stored in the array part of the table, beginning with index 1." },
				GetSprintingMaxSpeed = { Params = "", Return = "number", Notes = "Returns the player's maximum sprinting speed, relative to the game default speed. Defaults to 1.3, but plugins may modify it for faster or slower sprinting." },
				GetStance = { Return = "number", Notes = "Returns the player's stance (Y-pos of player's eyes)" },
				GetTeam = { Params = "", Return = "{{cTeam}}", Notes = "Returns the team that the player belongs to, or nil if none." },
				GetThrowSpeed = { Params = "SpeedCoeff", Return = "{{Vector3d}}", Notes = "Returns the speed vector for an object thrown with the specified speed coeff. Basically returns the normalized look vector multiplied by the coeff, with a slight random variation." },
				GetThrowStartPos = { Params = "", Return = "{{Vector3d}}", Notes = "Returns the position where the projectiles should start when thrown by this player." },
				GetUUID = { Params = "", Return = "string", Notes = "Returns the (short) UUID that the player is using. Could be empty string for players that don't have a Mojang account assigned to them (in the future, bots for example)." },
				GetWindow = { Params = "", Return = "{{cWindow}}", Notes = "Returns the currently open UI window. If the player doesn't have any UI window open, returns the inventory window." },
				GetXpLevel = { Params = "", Return = "number", Notes = "Returns the current XP level (based on current XP amount)." },
				GetXpLifetimeTotal = { Params = "", Return = "number", Notes = "Returns the amount of XP that has been accumulated throughout the player's lifetime." },
				GetXpPercentage = { Params = "", Return = "number", Notes = "Returns the percentage of the experience bar - the amount of XP towards the next XP level. Between 0 and 1." },
				HasCustomName = { Params = "", Return = "bool", Notes = "Returns true if the player has a custom name." },
				HasPermission = { Params = "PermissionString", Return = "bool", Notes = "Returns true if the player has the specified permission" },
				Heal = { Params = "HitPoints", Return = "", Notes = "Heals the player by the specified amount of HPs. Only positive amounts are expected. Sends a health update to the client." },
				IsEating = { Params = "", Return = "bool", Notes = "Returns true if the player is currently eating the item in their hand." },
				IsFishing = { Params = "", Return = "bool", Notes = "Returns true if the player is currently fishing" },
				IsFlying = { Return = "bool", Notes = "Returns true if the player is flying." },
				IsGameModeAdventure = { Params = "", Return = "bool", Notes = "Returns true if the player is in the gmAdventure gamemode, or has their gamemode unset and the world is a gmAdventure world." },
				IsGameModeCreative = { Params = "", Return = "bool", Notes = "Returns true if the player is in the gmCreative gamemode, or has their gamemode unset and the world is a gmCreative world." },
				IsGameModeSpectator = { Params = "", Return = "bool", Notes = "Returns true if the player is in the gmSpectator gamemode, or has their gamemode unset and the world is a gmSpectator world." },
				IsGameModeSurvival = { Params = "", Return = "bool", Notes = "Returns true if the player is in the gmSurvival gamemode, or has their gamemode unset and the world is a gmSurvival world." },
				IsInBed = { Params = "", Return = "bool", Notes = "Returns true if the player is currently lying in a bed." },
				IsSatiated = { Params = "", Return = "bool", Notes = "Returns true if the player is satiated (cannot eat)." },
				IsVisible = { Params = "", Return = "bool", Notes = "Returns true if the player is visible to other players" },
				LoadRank = { Params = "", Return = "", Notes = "Reloads the player's rank, message visuals and permissions from the {{cRankManager}}, based on the player's current rank." },
				MoveTo = { Params = "{{Vector3d|NewPosition}}", Return = "Tries to move the player into the specified position." },
				MoveToWorld = { Params = "WorldName", Return = "bool", Return = "Moves the player to the specified world. Returns true if successful." },
				OpenWindow = { Params = "{{cWindow|Window}}", Return = "", Notes = "Opens the specified UI window for the player." },
				PermissionMatches = { Params = "Permission, Template", Return = "bool", Notes = "(STATIC) Returns true if the specified permission matches the specified template. The template may contain wildcards." },
				PlaceBlock = { Params = "BlockX, BlockY, BlockZ, BlockType, BlockMeta", Return = "bool", Notes = "Places a block while impersonating the player. The {{OnPlayerPlacingBlock|HOOK_PLAYER_PLACING_BLOCK}} hook is called before the placement, and if it succeeds, the block is placed and the {{OnPlayerPlacedBlock|HOOK_PLAYER_PLACED_BLOCK}} hook is called. Returns true iff the block is successfully placed. Assumes that the block is in a currently loaded chunk." },
				Respawn = { Params = "", Return = "", Notes = "Restores the health, extinguishes fire, makes visible and sends the Respawn packet." },
				SendBlocksAround = { Params = "BlockX, BlockY, BlockZ, [Range]", Return = "", Notes = "Sends all the world's blocks in Range from the specified coords to the player, as a BlockChange packet. Range defaults to 1 (only one block sent)." },
				SendMessage = { Params = "Message", Return = "", Notes = "Sends the specified message to the player." },
				SendMessageFailure = { Params = "Message", Return = "", Notes = "Prepends Rose [INFO] / colours entire text (depending on ShouldUseChatPrefixes()) and sends message to player. For a command that failed to run because of insufficient permissions, etc." },
				SendMessageFatal = { Params = "Message", Return = "", Notes = "Prepends Red [FATAL] / colours entire text (depending on ShouldUseChatPrefixes()) and sends message to player. For something serious, such as a plugin crash, etc." },
				SendMessageInfo = { Params = "Message", Return = "", Notes = "Prepends Yellow [INFO] / colours entire text (depending on ShouldUseChatPrefixes()) and sends message to player. Informational message, such as command usage, etc." },
				SendMessagePrivateMsg = { Params = "Message, SenderName", Return = "", Notes = "Prepends Light Blue [MSG: *SenderName*] / prepends SenderName and colours entire text (depending on ShouldUseChatPrefixes()) and sends message to player. For private messaging." },
				SendMessageSuccess = { Params = "Message", Return = "", Notes = "Prepends Green [INFO] / colours entire text (depending on ShouldUseChatPrefixes()) and sends message to player. Success notification." },
				SendMessageWarning = { Params = "Message, Sender", Return = "", Notes = "Prepends Rose [WARN] / colours entire text (depending on ShouldUseChatPrefixes()) and sends message to player. Denotes that something concerning, such as plugin reload, is about to happen." },
				SendAboveActionBarMessage = { Params = "Message", Return = "", Notes = "Sends the specified message to the player (shows above action bar, doesn't show for < 1.8 clients)." },
				SendSystemMessage = { Params = "Message", Return = "", Notes = "Sends the specified message to the player (doesn't show for < 1.8 clients)." },
				SendRotation = { Params = "YawDegrees, PitchDegrees", Return = "", Notes = "Sends the specified rotation to the player, forcing them to look that way" },
				SetBedPos = { Params = "{{Vector3i|Position}}", Return = "", Notes = "Sets the internal representation of the last bed position the player has slept in. The player will respawn at this position if they die." },
				SetCanFly = { Params = "CanFly", Notes = "Sets if the player can fly or not." },
				SetCrouch = { Params = "IsCrouched", Return = "", Notes = "Sets the crouch state, broadcasts the change to other players." },
				SetCurrentExperience = { Params = "XPAmount", Return = "", Notes = "Sets the current amount of experience (and indirectly, the XP level)." },
				SetCustomName = { Params = "string", Return = "", Notes = "Sets the custom name of this player. If you want to disable the custom name, simply set an empty string. The custom name will be used in the tab-list, in the player nametag and in the tab-completion." },
				SetFlying = { Params = "IsFlying", Notes = "Sets if the player is flying or not." },
				SetFlyingMaxSpeed = { Params = "FlyingMaxSpeed", Return = "", Notes = "Sets the flying maximum speed, relative to the game default speed. The default value is 1. Sends the updated speed to the client." },
				SetFoodExhaustionLevel = { Params = "ExhaustionLevel", Return = "", Notes = "Sets the food exhaustion to the specified level." },
				SetFoodLevel = { Params = "FoodLevel", Return = "", Notes = "Sets the food level (number of half-drumsticks on-screen)" },
				SetFoodPoisonedTicksRemaining = { Params = "FoodPoisonedTicksRemaining", Return = "", Notes = "Sets the number of ticks remaining for food poisoning. Doesn't send foodpoisoning effect to the client, use FoodPoison() for that." },
				SetFoodSaturationLevel = { Params = "FoodSaturationLevel", Return = "", Notes = "Sets the food saturation (overcharge of the food level)." },
				SetFoodTickTimer = { Params = "FoodTickTimer", Return = "", Notes = "Sets the number of ticks past the last food-based heal or damage action; when this timer reaches 80, a new heal / damage is applied." },
				SetGameMode = { Params = "{{Globals#GameMode|NewGameMode}}", Return = "", Notes = "Sets the gamemode for the player. The new gamemode overrides the world's default gamemode, unless it is set to gmInherit." },
				SetIsFishing = { Params = "IsFishing, [FloaterEntityID]", Return = "", Notes = "Sets the 'IsFishing' flag for the player. The floater entity ID is expected for the true variant, it can be omitted when IsFishing is false. FIXME: Undefined behavior when multiple fishing rods are used simultanously" },
				SetName = { Params = "Name", Return = "", Notes = "Sets the player name. This rename will NOT be visible to any players already in the server who are close enough to see this player." },
				SetNormalMaxSpeed = { Params = "NormalMaxSpeed", Return = "", Notes = "Sets the normal (walking) maximum speed, relative to the game default speed. The default value is 1. Sends the updated speed to the client, if appropriate." },
				SetSprint = { Params = "IsSprinting", Return = "", Notes = "Sets whether the player is sprinting or not." },
				SetSprintingMaxSpeed = { Params = "SprintingMaxSpeed", Return = "", Notes = "Sets the sprinting maximum speed, relative to the game default speed. The default value is 1.3. Sends the updated speed to the client, if appropriate." },
				SetTeam = { Params = "{{cTeam|Team}}", Return = "", Notes = "Moves the player to the specified team." },
				SetVisible = { Params = "IsVisible", Return = "", Notes = "Sets the player visibility to other players" },
				TossEquippedItem = { Params = "[Amount]", Return = "", Notes = "Tosses the item that the player has selected in their hotbar. Amount defaults to 1." },
				TossHeldItem = { Params = "[Amount]", Return = "", Notes = "Tosses the item held by the cursor, then the player is in a UI window. Amount defaults to 1." },
				TossPickup = { Params = "{{cItem|Item}}", Return = "", Notes = "Tosses a pickup newly created from the specified item." },
				XpForLevel = { Params = "XPLevel", Return = "number", Notes = "(STATIC) Returns the total amount of XP needed for the specified XP level. Inverse of CalcLevelFromXp()." },
			},
			Constants =
			{
				EATING_TICKS   = { Notes = "Number of ticks required for consuming an item." },
				MAX_FOOD_LEVEL = { Notes = "The maximum food level value. When the food level is at this value, the player cannot eat." },
				MAX_HEALTH     = { Notes = "The maximum health value" },
			},
			Inherits = "cPawn",
		},  -- cPlayer

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
				AddGroup = { Params = "GroupName", Return = "", Notes = "Adds the group of the specified name. Logs a warning and does nothing if the group already exists." },
				AddGroupToRank = { Params = "GroupName, RankName", Return = "bool", Notes = "Adds the specified group to the specified rank. Returns true on success, false on failure - if the group name or the rank name is not found." },
				AddPermissionToGroup = { Params = "Permission, GroupName", Return = "bool", Notes = "Adds the specified permission to the specified group. Returns true on success, false on failure - if the group name is not found." },
				AddRank = { Params = "RankName, MsgPrefix, MsgSuffix, MsgNameColorCode", Return = "", Notes = "Adds a new rank of the specified name and with the specified message visuals. Logs an info message and does nothing if the rank already exists." },
				ClearPlayerRanks = { Params = "", Return = "", Notes = "Removes all player ranks from the database. Note that this doesn't change the cPlayer instances for the already connected players, you need to update all the instances manually." },
				GetAllGroups = { Params = "", Return = "array-table of groups' names", Notes = "Returns an array-table containing the names of all the groups that are known to the manager." },
				GetAllPermissions = { Params = "", Return = "array-table of permissions", Notes = "Returns an array-table containing all the permissions that are known to the manager." },
				GetAllPlayerUUIDs = { Params = "", Return = "array-table of uuids", Notes = "Returns the short uuids of all players stored in the rank DB, sorted by the players' names (case insensitive)." },
				GetAllRanks = { Params = "", Return = "array-table of ranks' names", Notes = "Returns an array-table containing the names of all the ranks that are known to the manager." },
				GetDefaultRank = { Params = "", Return = "string", Notes = "Returns the name of the default rank. " },
				GetGroupPermissions = { Params = "GroupName", Return = "array-table of permissions", Notes = "Returns an array-table containing the permissions that the specified group contains." },
				GetPlayerGroups = { Params = "PlayerUUID", Return = "array-table of groups' names", Notes = "Returns an array-table of the names of the groups that are assigned to the specified player through their rank. Returns an empty table if the player is not known or has no rank or groups assigned to them." },
				GetPlayerMsgVisuals = { Params = "PlayerUUID", Return = "MsgPrefix, MsgSuffix, MsgNameColorCode", Notes = "Returns the message visuals assigned to the player. If the player is not explicitly assigned a rank, the default rank's visuals are returned. If there is an error, no value is returned at all." },
				GetPlayerPermissions = { Params = "PlayerUUID", Return = "array-table of permissions", Notes = "Returns the permissions that the specified player is assigned through their rank. Returns the default rank's permissions if the player has no explicit rank assigned to them. Returns an empty array on error." },
				GetPlayerRankName = { Params = "PlayerUUID", Return = "RankName", Notes = "Returns the name of the rank that is assigned to the specified player. An empty string (NOT the default rank) is returned if the player has no rank assigned to them." },
				GetPlayerName = { Params = "PlayerUUID", Return = "PlayerName", Notes = "Returns the last name that the specified player has, for a player in the ranks database. An empty string is returned if the player isn't in the database." },
				GetRankGroups = { Params = "RankName", Return = "array-table of groups' names", Notes = "Returns an array-table of the names of all the groups that are assigned to the specified rank. Returns an empty table if there is no such rank." },
				GetRankPermissions = { Params = "RankName", Return = "array-table of permissions", Notes = "Returns an array-table of all the permissions that are assigned to the specified rank through its groups. Returns an empty table if there is no such rank." },
				GetRankVisuals = { Params = "RankName", Return = "MsgPrefix, MsgSuffix, MsgNameColorCode", Notes = "Returns the message visuals for the specified rank. Returns no value if the specified rank does not exist." },
				GroupExists = { Params = "GroupName", Return = "bool", Notes = "Returns true iff the specified group exists." },
				IsGroupInRank = { Params = "GroupName, RankName", Return = "bool", Notes = "Returns true iff the specified group is assigned to the specified rank." },
				IsPermissionInGroup = { Params = "Permission, GroupName", Return = "bool", Notes = "Returns true iff the specified permission is assigned to the specified group." },
				IsPlayerRankSet = { Params = "PlayerUUID", Return = "bool", Notes = "Returns true iff the specified player has a rank assigned to them." },
				RankExists = { Params = "RankName", Return = "bool", Notes = "Returns true iff the specified rank exists." },
				RemoveGroup = { Params = "GroupName", Return = "", Notes = "Removes the specified group completely. The group will be removed from all the ranks using it and then erased from the manager. Logs an info message and does nothing if the group doesn't exist." },
				RemoveGroupFromRank = { Params = "GroupName, RankName", Return = "", Notes = "Removes the specified group from the specified rank. The group will still exist, even if it isn't assigned to any rank. Logs an info message and does nothing if the group or rank doesn't exist." },
				RemovePermissionFromGroup = { Params = "Permission, GroupName", Return = "", Notes = "Removes the specified permission from the specified group. Logs an info message and does nothing if the group doesn't exist." },
				RemovePlayerRank = { Params = "PlayerUUID", Return = "", Notes = "Removes the player's rank; the player's left without a rank. Note that this doesn't change the {{cPlayer}} instances for the already connected players, you need to update all the instances manually. No action if the player has no rank assigned to them already." },
				RemoveRank = { Params = "RankName, [ReplacementRankName]", Return = "", Notes = "Removes the specified rank. If ReplacementRankName is given, the players that have RankName will get their rank set to ReplacementRankName. If it isn't given, or is an invalid rank, the players will be removed from the manager, their ranks will be unset completely. Logs an info message and does nothing if the rank is not found." },
				RenameGroup = { Params = "OldName, NewName", Return = "", Notes = "Renames the specified group. Logs an info message and does nothing if the group is not found or the new name is already used." },
				RenameRank = { Params = "OldName, NewName", Return = "", Notes = "Renames the specified rank. Logs an info message and does nothing if the rank is not found or the new name is already used." },
				SetDefaultRank = { Params = "RankName", Return = "bool", Notes = "Sets the specified rank as the default rank. Returns true on success, false on failure (rank doesn't exist)." },
				SetPlayerRank = { Params = "PlayerUUID, PlayerName, RankName", Return = "", Notes = "Updates the rank for the specified player. The player name is provided for reference, the UUID is used for identification. Logs a warning and does nothing if the rank is not found." },
				SetRankVisuals = { Params = "RankName, MsgPrefix, MsgSuffix, MsgNameColorCode", Return = "", Notes = "Updates the rank's message visuals. Logs an info message and does nothing if rank not found." },
			},
		},  -- cRankManager

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
					{ Params = "MessageText, MessageType", Return = "", Notes = "Broadcasts a message to all players, with its message type set to MessageType (default: mtCustom)." },
					{ Params = "{{cCompositeChat|CompositeChat}}", Return = "", Notes = "Broadcasts a {{cCompositeChat|composite chat message}} to all players." },
				},
				BroadcastChatDeath = { Params = "MessageText", Return = "", Notes = "Broadcasts the specified message to all players, with its message type set to mtDeath. Use for when a player has died." },
				BroadcastChatFailure = { Params = "MessageText", Return = "", Notes = "Broadcasts the specified message to all players, with its message type set to mtFailure. Use for a command that failed to run because of insufficient permissions, etc." },
				BroadcastChatFatal = { Params = "MessageText", Return = "", Notes = "Broadcasts the specified message to all players, with its message type set to mtFatal. Use for a plugin that crashed, or similar." },
				BroadcastChatInfo = { Params = "MessageText", Return = "", Notes = "Broadcasts the specified message to all players, with its message type set to mtInfo. Use for informational messages, such as command usage." },
				BroadcastChatJoin = { Params = "MessageText", Return = "", Notes = "Broadcasts the specified message to all players, with its message type set to mtJoin. Use for players joining the server." },
				BroadcastChatLeave = { Params = "MessageText", Return = "", Notes = "Broadcasts the specified message to all players, with its message type set to mtLeave. Use for players leaving the server." },
				BroadcastChatSuccess = { Params = "MessageText", Return = "", Notes = "Broadcasts the specified message to all players, with its message type set to mtSuccess. Use for success messages." },
				BroadcastChatWarning = { Params = "MessageText", Return = "", Notes = "Broadcasts the specified message to all players, with its message type set to mtWarning. Use for concerning events, such as plugin reload etc." },
				CreateAndInitializeWorld = { Params = "WorldName", Return = "{{cWorld|cWorld}}", Notes = "Creates a new world and initializes it. If there is a world whith the same name it returns nil.<br><br><b>NOTE:</b> This function is currently unsafe, do not use!" },
				FindAndDoWithPlayer = { Params = "PlayerName, CallbackFunction", Return = "bool", Notes = "Calls the given callback function for the player with the name best matching the name string provided.<br>This function is case-insensitive and will match partial names.<br>Returns false if player not found or there is ambiguity, true otherwise. The CallbackFunction has the following signature: <pre class=\"prettyprint lang-lua\">function Callback({{cPlayer|Player}})</pre>" },
				DoWithPlayerByUUID = { Params = "PlayerUUID, CallbackFunction", Return = "bool", Notes = "If there is the player with the uuid, calls the CallbackFunction with the {{cPlayer}} parameter representing the player. The CallbackFunction has the following signature: <pre class=\"prettyprint lang-lua\">function Callback({{cPlayer|Player}})</pre> The function returns false if the player was not found, or whatever bool value the callback returned if the player was found." },
				ForEachPlayer = { Params = "CallbackFunction", Return = "", Notes = "Calls the given callback function for each player. The callback function has the following signature: <pre class=\"prettyprint lang-lua\">function Callback({{cPlayer|cPlayer}})</pre>" },
				ForEachWorld = { Params = "CallbackFunction", Return = "", Notes = "Calls the given callback function for each world. The callback function has the following signature: <pre class=\"prettyprint lang-lua\">function Callback({{cWorld|cWorld}})</pre>" },
				Get = { Params = "", Return = "Root object", Notes = "(STATIC) This function returns the cRoot object." },
				GetBrewingRecipe = { Params = "{{cItem|cItem}}, {{cItem|cItem}}", Return = "{{cItem|cItem}}", Notes = "(STATIC) Returns the result item, if a recipe has been found. If no recipe is found, returns no value." },
				GetBuildCommitID = { Params = "", Return = "string", Notes = "(STATIC) For official builds (Travis CI / Jenkins) it returns the exact commit hash used for the build. For unofficial local builds, returns the approximate commit hash (since the true one cannot be determined), formatted as \"approx: &lt;CommitHash&gt;\"." },
				GetBuildDateTime = { Params = "", Return = "string", Notes = "(STATIC) For official builds (Travic CI / Jenkins) it returns the date and time of the build. For unofficial local builds, returns the approximate datetime of the commit (since the true one cannot be determined), formatted as \"approx: &lt;DateTime-iso8601&gt;\"." },
				GetBuildID = { Params = "", Return = "string", Notes = "(STATIC) For official builds (Travis CI / Jenkins) it returns the unique ID of the build, as recognized by the build system. For unofficial local builds, returns the string \"Unknown\"." },
				GetBuildSeriesName = { Params = "", Return = "string", Notes = "(STATIC) For official builds (Travis CI / Jenkins) it returns the series name of the build (for example \"Cuberite Windows x64 Master\"). For unofficial local builds, returns the string \"local build\"." },
				GetCraftingRecipes = { Params = "", Return = "{{cCraftingRecipe|cCraftingRecipe}}", Notes = "Returns the CraftingRecipes object" },
				GetDefaultWorld = { Params = "", Return = "{{cWorld|cWorld}}", Notes = "Returns the world object from the default world." },
				GetFurnaceFuelBurnTime = { Params = "{{cItem|Fuel}}", Return = "number", Notes = "(STATIC) Returns the number of ticks for how long the item would fuel a furnace. Returns zero if not a fuel." },
				GetFurnaceRecipe = { Params = "{{cItem|InItem}}", Return = "{{cItem|OutItem}}, NumTicks, {{cItem|InItem}}", Notes = "(STATIC) Returns the furnace recipe for smelting the specified input. If a recipe is found, returns the smelted result, the number of ticks required for the smelting operation, and the input consumed (note that Cuberite supports smelting M items into N items and different smelting rates). If no recipe is found, returns no value." },
				GetPhysicalRAMUsage = { Params = "", Return = "number", Notes = "Returns the amount of physical RAM that the entire Cuberite process is using, in KiB. Negative if the OS doesn't support this query." },
				GetPluginManager = { Params = "", Return = "{{cPluginManager|cPluginManager}}", Notes = "Returns the cPluginManager object." },
				GetPrimaryServerVersion = { Params = "", Return = "number", Notes = "Returns the servers primary server version." },
				GetProtocolVersionTextFromInt = { Params = "Protocol Version", Return = "string", Notes = "Returns the Minecraft version from the given Protocol. If there is no version found, it returns 'Unknown protocol(Parameter)'" },
				GetServer = { Params = "", Return = "{{cServer|cServer}}", Notes = "Returns the cServer object." },
				GetServerUpTime = { Params = "", Return = "number", Notes = "Returns the uptime of the server in seconds." },
				GetTotalChunkCount = { Params = "", Return = "number", Notes = "Returns the amount of loaded chunks." },
				GetVirtualRAMUsage = { Params = "", Return = "number", Notes = "Returns the amount of virtual RAM that the entire Cuberite process is using, in KiB. Negative if the OS doesn't support this query." },
				GetWebAdmin = { Params = "", Return = "{{cWebAdmin|cWebAdmin}}", Notes = "Returns the cWebAdmin object." },
				GetWorld = { Params = "WorldName", Return = "{{cWorld|cWorld}}", Notes = "Returns the cWorld object of the given world. It returns nil if there is no world with the given name." },
				QueueExecuteConsoleCommand = { Params = "Message", Return = "", Notes = "Queues a console command for execution through the cServer class. The command will be executed in the tick thread. The command's output will be sent to console." },
				SaveAllChunks = { Params = "", Return = "", Notes = "Saves all the chunks in all the worlds. Note that the saving is queued on each world's tick thread and this functions returns before the chunks are actually saved." },
				SetPrimaryServerVersion = { Params = "Protocol Version", Return = "", Notes = "Sets the servers PrimaryServerVersion to the given protocol number." }
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
		},  -- cRoot

		cScoreboard =
		{
			Desc = [[
				This class manages the objectives and teams of a single world.
			]],
			Functions =
			{
				AddPlayerScore = { Params = "Name, Type, Value", Return = "", Notes = "Adds a value to all player scores of the specified objective type." },
				ForEachObjective = { Params = "CallBackFunction", Return = "bool", Notes = "Calls the specified callback for each objective in the scoreboard. Returns true if all objectives have been processed (including when there are zero objectives), or false if the callback function has aborted the enumeration by returning true. The callback function has the following signature: <pre class=\"prettyprint lang-lua\">function Callback({{cObjective|Objective}})</pre> The callback should return false or no value to continue with the next objective, or true to abort the enumeration." },
				ForEachTeam = { Params = "CallBackFunction", Return = "bool", Notes = "Calls the specified callback for each team in the scoreboard. Returns true if all teams have been processed (including when there are zero teams), or false if the callback function has aborted the enumeration by returning true. The callback function has the following signature: <pre class=\"prettyprint lang-lua\">function Callback({{cObjective|Objective}})</pre> The callback should return false or no value to continue with the next team, or true to abort the enumeration." },
				GetNumObjectives = { Params = "", Return = "number", Notes = "Returns the nuber of registered objectives." },
				GetNumTeams = { Params = "", Return = "number", Notes = "Returns the number of registered teams." },
				GetObjective = { Params = "string", Return = "{{cObjective}}", Notes = "Returns the objective with the specified name." },
				GetObjectiveIn = { Params = "DisplaySlot", Return = "{{cObjective}}", Notes = "Returns the objective in the specified display slot. Can be nil." },
				GetTeam = { Params = "string", Return = "{{cTeam}}", Notes = "Returns the team with the specified name." },
				RegisterObjective = { Params = "Name, DisplayName, Type", Return = "{{cObjective}}", Notes = "Registers a new scoreboard objective. Returns the {{cObjective}} instance, nil on error." },
				RegisterTeam = { Params = "Name, DisplayName, Prefix, Suffix", Return = "{{cTeam}}", Notes = "Registers a new team. Returns the {{cTeam}} instance, nil on error." },
				RemoveObjective = { Params = "string", Return = "bool", Notes = "Removes the objective with the specified name. Returns true if operation was successful." },
				RemoveTeam = { Params = "string", Return = "bool", Notes = "Removes the team with the specified name. Returns true if operation was successful." },
				SetDisplay = { Params = "Name, DisplaySlot", Return = "", Notes = "Updates the currently displayed objective." },
			},
			Constants =
			{
				dsCount = { Notes = "" },
				dsList = { Notes = "" },
				dsName = { Notes = "" },
				dsSidebar = { Notes = "" },
			},
		}, -- cScoreboard

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
				GetDescription = { Return = "string", Notes = "Returns the server description set in the settings.ini." },
				GetMaxPlayers = { Return = "number", Notes = "Returns the max amount of players who can join the server." },
				GetNumPlayers = { Return = "number", Notes = "Returns the amount of players online." },
				GetServerID = { Return = "string", Notes = "Returns the ID of the server?" },
				IsHardcore = { Params = "", Return = "bool", Notes = "Returns true if the server is hardcore (players get banned on death)." },
				SetMaxPlayers = { Params = "number", Notes = "Sets the max amount of players who can join." },
				ShouldAuthenticate = { Params = "", Return = "bool", Notes = "Returns true iff the server is set to authenticate players (\"online mode\")." },
			},
		},  -- cServer

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
				CompressStringGZIP   = {Params = "string", Return = "string", Notes = "Compress a string using GZIP"},
				CompressStringZLIB   = {Params = "string, factor", Return = "string", Notes = "Compresses a string using ZLIB. Factor 0 is no compression and factor 9 is maximum compression"},
				InflateString        = {Params = "string", Return = "string", Notes = "Uncompresses a string using Inflate"},
				UncompressStringGZIP = {Params = "string", Return = "string", Notes = "Uncompress a string using GZIP"},
				UncompressStringZLIB = {Params = "string, uncompressed length", Return = "string", Notes = "Uncompresses a string using ZLIB"},
			},
		},

		cTeam =
		{
			Desc = [[
				This class manages a single player team.
			]],
			Functions =
			{
				AddPlayer = { Params = "string", Returns = "bool", Notes = "Adds a player to this team. Returns true if the operation was successful." },
				AllowsFriendlyFire = { Params = "", Return = "bool", Notes = "Returns whether team friendly fire is allowed." },
				CanSeeFriendlyInvisible = { Params = "", Return = "bool", Notes = "Returns whether players can see invisible teammates." },
				HasPlayer = { Params = "string", Returns = "bool", Notes = "Returns whether the specified player is a member of this team." },
				GetDisplayName = { Params = "", Return = "string", Notes = "Returns the display name of the team." },
				GetName = { Params = "", Return = "string", Notes = "Returns the internal name of the team." },
				GetNumPlayers = { Params = "", Return = "number", Notes = "Returns the number of registered players." },
				GetPrefix = { Params = "", Return = "string", Notes = "Returns the prefix prepended to the names of the members of this team." },
				RemovePlayer = { Params = "string", Returns = "bool", Notes = "Removes the player with the specified name from this team. Returns true if the operation was successful." },
				Reset = { Params = "", Returns = "", Notes = "Removes all players from this team." },
				GetSuffix = { Params = "", Return = "string", Notes = "Returns the suffix appended to the names of the members of this team." },
				SetCanSeeFriendlyInvisible = { Params = "bool", Return = "", Notes = "Set whether players can see invisible teammates." },
				SetDisplayName = { Params = "string", Return = "", Notes = "Sets the display name of this team. (i.e. what will be shown to the players)" },
				SetFriendlyFire = { Params = "bool", Return = "", Notes = "Sets whether team friendly fire is allowed." },
				SetPrefix = { Params = "string", Return = "", Notes = "Sets the prefix prepended to the names of the members of this team." },
				SetSuffix = { Params = "string", Return = "", Notes = "Sets the suffix appended to the names of the members of this team." },
			},
		}, -- cTeam

		cTNTEntity =
		{
			Desc = "This class manages a TNT entity.",
			Functions =
			{
				Explode = { Return = "", Notes = "Explode the tnt." },
				GetFuseTicks = { Return = "number", Notes = "Returns the fuse ticks until the tnt will explode." },
				SetFuseTicks = { Return = "number", Notes = "Set the fuse ticks until the tnt will explode." },
			},
			Inherits = "cEntity",
		},

		cWebPlugin =
		{
			Desc = "",
			Functions = {},
		},  -- cWebPlugin

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
				GetSlot = { Params = "{{cPlayer|Player}}, SlotNumber", Return = "{{cItem}}", Notes = "Returns the item at the specified slot for the specified player. Returns nil and logs to server console on error." },
				GetWindowID = { Params = "", Return = "number", Notes = "Returns the ID of the window, as used by the network protocol" },
				GetWindowTitle = { Params = "", Return = "string", Notes = "Returns the window title that will be displayed to the player" },
				GetWindowType = { Params = "", Return = "number", Notes = "Returns the type of the window, one of the constants in the table above" },
				IsSlotInPlayerHotbar = { Params = "SlotNum", Return = "bool", Notes = "Returns true if the specified slot number is in the player hotbar" },
				IsSlotInPlayerInventory = { Params = "SlotNum", Return = "bool", Notes = "Returns true if the specified slot number is in the player's main inventory or in the hotbar. Note that this returns false for armor slots!" },
				IsSlotInPlayerMainInventory = { Params = "SlotNum", Return = "bool", Notes = "Returns true if the specified slot number is in the player's main inventory" },
				SetProperty = { Params = "PropertyID, PropartyValue, {{cPlayer|Player}}", Return = "", Notes = "Sends the UpdateWindowProperty (0x69) packet to the specified player; or to all players who are viewing this window if Player is not specified or nil." },
				SetSlot = { Params = "{{cPlayer|Player}}, SlotNum, {{cItem|cItem}}", Return = "", Notes = "Sets the contents of the specified slot for the specified player. Ignored if the slot number is invalid" },
				SetWindowTitle = { Params = "string", Return = "", Notes = "Sets the window title that will be displayed to the player" },
			},
			Constants =
			{
				wtInventory = { Notes = "An inventory window" },
				wtChest = { Notes = "A {{cChestEntity|chest}} or doublechest window" },
				wtWorkbench = { Notes = "A workbench (crafting table) window" },
				wtFurnace = { Notes = "A {{cFurnaceEntity|furnace}} window" },
				wtDropSpenser = { Notes = "A {{cDropperEntity|dropper}} or a {{cDispenserEntity|dispenser}} window" },
				wtEnchantment = { Notes = "An enchantment table window" },
				wtBrewery = { Notes = "A brewing stand window" },
				wtNPCTrade = { Notes = "A villager trade window" },
				wtBeacon = { Notes = "A beacon window" },
				wtAnvil = { Notes = "An anvil window" },
				wtHopper = { Notes = "A {{cHopperEntity|hopper}} window" },
				wtAnimalChest = { Notes = "A horse or donkey window" },
			},
		},  -- cWindow

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
				AreCommandBlocksEnabled = { Params = "", Return = "bool", Notes = "Returns whether command blocks are enabled on the (entire) server" },
				BroadcastBlockAction = { Params = "BlockX, BlockY, BlockZ, ActionByte1, ActionByte2, BlockType, [{{cClientHandle|ExcludeClient}}]", Return = "", Notes = "Broadcasts the BlockAction packet to all clients who have the appropriate chunk loaded (except ExcludeClient). The contents of the packet are specified by the parameters for the call, the blocktype needn't match the actual block that is present in the world data at the specified location." },
				BroadcastChat = { Params = "Message, [{{cClientHandle|ExcludeClient}}]", Return = "", Notes = "Sends the Message to all players in this world, except the optional ExcludeClient. No formatting is done by the server." },
				BroadcastChatDeath = { Params = "Message, [{{cClientHandle|ExcludeClient}}]", Return = "", Notes = "Prepends Gray [DEATH] / colours entire text (depending on ShouldUseChatPrefixes()) and broadcasts message. For when a player dies." },
				BroadcastChatFailure = { Params = "Message, [{{cClientHandle|ExcludeClient}}]", Return = "", Notes = "Prepends Rose [INFO] / colours entire text (depending on ShouldUseChatPrefixes()) and broadcasts message. For a command that failed to run because of insufficient permissions, etc." },
				BroadcastChatFatal = { Params = "Message, [{{cClientHandle|ExcludeClient}}]", Return = "", Notes = "Prepends Red [FATAL] / colours entire text (depending on ShouldUseChatPrefixes()) and broadcasts message. For a plugin that crashed, or similar." },
				BroadcastChatInfo = { Params = "Message, [{{cClientHandle|ExcludeClient}}]", Return = "", Notes = "Prepends Yellow [INFO] / colours entire text (depending on ShouldUseChatPrefixes()) and broadcasts message. For informational messages, such as command usage." },
				BroadcastChatSuccess = { Params = "Message, [{{cClientHandle|ExcludeClient}}]", Return = "", Notes = "Prepends Green [INFO] / colours entire text (depending on ShouldUseChatPrefixes()) and broadcasts message. For success messages." },
				BroadcastChatWarning = { Params = "Message, [{{cClientHandle|ExcludeClient}}]", Return = "", Notes = "Prepends Rose [WARN] / colours entire text (depending on ShouldUseChatPrefixes()) and broadcasts message. For concerning events, such as plugin reload etc." },
				BroadcastEntityAnimation = { Params = "{{cEntity|TargetEntity}}, Animation, [{{cClientHandle|ExcludeClient}}]", Return = "", Notes = "Sends an animation of an entity to all clienthandles (except ExcludeClient if given)" },
				BroadcastParticleEffect = { Params = "ParticleName, X, Y, Z, OffSetX, OffSetY, OffSetZ, ParticleData, ParticleAmmount, [{{cClientHandle|ExcludeClient}}]", Return = "", Notes = "Spawns the specified particles to all players in the world exept the optional ExeptClient. A list of available particles by thinkofdeath can be found {{https://gist.github.com/thinkofdeath/5110835|Here}}" },
				BroadcastSoundEffect = { Params = "SoundName, X, Y, Z, Volume, Pitch, [{{cClientHandle|ExcludeClient}}]", Return = "", Notes = "Sends the specified sound effect to all players in this world, except the optional ExceptClient" },
				BroadcastSoundParticleEffect = { Params = "EffectID, X, Y, Z, EffectData, [{{cClientHandle|ExcludeClient}}]", Return = "", Notes = "Sends the specified effect to all players in this world, except the optional ExceptClient" },
				CastThunderbolt = { Params = "X, Y, Z", Return = "", Notes = "Creates a thunderbolt at the specified coords" },
				ChangeWeather = { Params = "", Return = "", Notes = "Forces the weather to change in the next game tick. Weather is changed according to the normal rules: wSunny <-> wRain <-> wStorm" },
				ChunkStay = { Params = "ChunkCoordTable, OnChunkAvailable, OnAllChunksAvailable", Return = "", Notes = "Queues the specified chunks to be loaded or generated and calls the specified callbacks once they are loaded. ChunkCoordTable is an arra-table of chunk coords, each coord being a table of 2 numbers: { {Chunk1x, Chunk1z}, {Chunk2x, Chunk2z}, ...}. When any of those chunks are made available (including being available at the start of this call), the OnChunkAvailable() callback is called. When all the chunks are available, the OnAllChunksAvailable() callback is called. The function signatures are: <pre class=\"prettyprint lang-lua\">function OnChunkAvailable(ChunkX, ChunkZ)\nfunction OnAllChunksAvailable()</pre> All return values from the callbacks are ignored." },
				CreateProjectile = { Params = "X, Y, Z, {{cProjectileEntity|ProjectileKind}}, {{cEntity|Creator}}, {{cItem|Originating Item}}, [{{Vector3d|Speed}}]", Return = "", Notes = "Creates a new projectile of the specified kind at the specified coords. The projectile's creator is set to Creator (may be nil). The item that created the projectile entity, commonly the {{cPlayer|player}}'s currently equipped item, is used at present for fireworks to correctly set their entity metadata. It is not used for any other projectile. Optional speed indicates the initial speed for the projectile." },
				DigBlock = { Params = "X, Y, Z", Return = "", Notes = "Replaces the specified block with air, without dropping the usual pickups for the block. Wakes up the simulators for the block and its neighbors." },
				DoExplosionAt = { Params = "Force, X, Y, Z, CanCauseFire, Source, SourceData", Return = "", Notes = "Creates an explosion of the specified relative force in the specified position. If CanCauseFire is set, the explosion will set blocks on fire, too. The Source parameter specifies the source of the explosion, one of the esXXX constants. The SourceData parameter is specific to each source type, usually it provides more info about the source." },
				DoWithBlockEntityAt = { Params = "BlockX, BlockY, BlockZ, CallbackFunction", Return = "bool", Notes = "If there is a block entity at the specified coords, calls the CallbackFunction with the {{cBlockEntity}} parameter representing the block entity. The CallbackFunction has the following signature: <pre class=\"prettyprint lang-lua\">function Callback({{cBlockEntity|BlockEntity}})</pre> The function returns false if there is no block entity, or if there is, it returns the bool value that the callback has returned. Use {{tolua}}.cast() to cast the Callback's BlockEntity parameter to the correct {{cBlockEntity}} descendant." },
				DoWithBrewingstandAt = { Params = "BlockX, BlockY, BlockZ, CallbackFunction", Return = "bool", Notes = "If there is a brewingstand at the specified coords, calls the CallbackFunction with the {{cBrewingstandEntity}} parameter representing the brewingstand. The CallbackFunction has the following signature: <pre class=\"prettyprint lang-lua\">function Callback({{cBrewingstandEntity|cBrewingstandEntity}})</pre> The function returns false if there is no brewingstand, or if there is, it returns the bool value that the callback has returned." },
				DoWithBeaconAt = { Params = "BlockX, BlockY, BlockZ, CallbackFunction", Return = "bool", Notes = "If there is a beacon at the specified coords, calls the CallbackFunction with the {{cBeaconEntity}} parameter representing the beacon. The CallbackFunction has the following signature: <pre class=\"prettyprint lang-lua\">function Callback({{cBeaconEntity|BeaconEntity}})</pre> The function returns false if there is no beacon, or if there is, it returns the bool value that the callback has returned." },
				DoWithChestAt = { Params = "BlockX, BlockY, BlockZ, CallbackFunction", Return = "bool", Notes = "If there is a chest at the specified coords, calls the CallbackFunction with the {{cChestEntity}} parameter representing the chest. The CallbackFunction has the following signature: <pre class=\"prettyprint lang-lua\">function Callback({{cChestEntity|ChestEntity}})</pre> The function returns false if there is no chest, or if there is, it returns the bool value that the callback has returned." },
				DoWithCommandBlockAt = { Params = "BlockX, BlockY, BlockZ, CallbackFunction", Return = "bool", Notes = "If there is a command block at the specified coords, calls the CallbackFunction with the {{cCommandBlockEntity}} parameter representing the command block. The CallbackFunction has the following signature: <pre class=\"prettyprint lang-lua\">function Callback({{cCommandBlockEntity|CommandBlockEntity}})</pre> The function returns false if there is no command block, or if there is, it returns the bool value that the callback has returned." },
				DoWithDispenserAt = { Params = "BlockX, BlockY, BlockZ, CallbackFunction", Return = "bool", Notes = "If there is a dispenser at the specified coords, calls the CallbackFunction with the {{cDispenserEntity}} parameter representing the dispenser. The CallbackFunction has the following signature: <pre class=\"prettyprint lang-lua\">function Callback({{cDispenserEntity|DispenserEntity}})</pre> The function returns false if there is no dispenser, or if there is, it returns the bool value that the callback has returned." },
				DoWithDropSpenserAt = { Params = "BlockX, BlockY, BlockZ, CallbackFunction", Return = "bool", Notes = "If there is a dropper or a dispenser at the specified coords, calls the CallbackFunction with the {{cDropSpenserEntity}} parameter representing the dropper or dispenser. The CallbackFunction has the following signature: <pre class=\"prettyprint lang-lua\">function Callback({{cDropSpenserEntity|DropSpenserEntity}})</pre> Note that this can be used to access both dispensers and droppers in a similar way. The function returns false if there is neither dispenser nor dropper, or if there is, it returns the bool value that the callback has returned." },
				DoWithDropperAt = { Params = "BlockX, BlockY, BlockZ, CallbackFunction", Return = "bool", Notes = "If there is a dropper at the specified coords, calls the CallbackFunction with the {{cDropperEntity}} parameter representing the dropper. The CallbackFunction has the following signature: <pre class=\"prettyprint lang-lua\">function Callback({{cDropperEntity|DropperEntity}})</pre> The function returns false if there is no dropper, or if there is, it returns the bool value that the callback has returned." },
				DoWithEntityByID = { Params = "EntityID, CallbackFunction", Return = "bool", Notes = "If an entity with the specified ID exists, calls the callback with the {{cEntity}} parameter representing the entity. The CallbackFunction has the following signature: <pre class=\"prettyprint lang-lua\">function Callback({{cEntity|Entity}})</pre> The function returns false if the entity was not found, and it returns the same bool value that the callback has returned if the entity was found." },
				DoWithFlowerPotAt = { Params = "BlockX, BlockY, BlockZ, CallbackFunction", Return = "bool", Notes = "If there is a flower pot at the specified coords, calls the CallbackFunction with the {{cFlowerPotEntity}} parameter representing the flower pot. The CallbackFunction has the following signature: <pre class=\"prettyprint lang-lua\">function Callback({{cFlowerPotEntity|FlowerPotEntity}})</pre> The function returns false if there is no flower pot, or if there is, it returns the bool value that the callback has returned." },
				DoWithFurnaceAt = { Params = "BlockX, BlockY, BlockZ, CallbackFunction", Return = "bool", Notes = "If there is a furnace at the specified coords, calls the CallbackFunction with the {{cFurnaceEntity}} parameter representing the furnace. The CallbackFunction has the following signature: <pre class=\"prettyprint lang-lua\">function Callback({{cFurnaceEntity|FurnaceEntity}})</pre> The function returns false if there is no furnace, or if there is, it returns the bool value that the callback has returned." },
				DoWithMobHeadAt = { Params = "BlockX, BlockY, BlockZ, CallbackFunction", Return = "bool", Notes = "If there is a mob head at the specified coords, calls the CallbackFunction with the {{cMobHeadEntity}} parameter representing the furnace. The CallbackFunction has the following signature: <pre class=\"prettyprint lang-lua\">function Callback({{cMobHeadEntity|MobHeadEntity}})</pre> The function returns false if there is no mob head, or if there is, it returns the bool value that the callback has returned." },
				DoWithNoteBlockAt = { Params = "BlockX, BlockY, BlockZ, CallbackFunction", Return = "bool", Notes = "If there is a note block at the specified coords, calls the CallbackFunction with the {{cNoteEntity}} parameter representing the note block. The CallbackFunction has the following signature: <pre class=\"prettyprint lang-lua\">function Callback({{cNoteEntity|NoteEntity}})</pre> The function returns false if there is no note block, or if there is, it returns the bool value that the callback has returned." },
				DoWithPlayer = { Params = "PlayerName, CallbackFunction", Return = "bool", Notes = "If there is a player of the specified name (exact match), calls the CallbackFunction with the {{cPlayer}} parameter representing the player. The CallbackFunction has the following signature: <pre class=\"prettyprint lang-lua\">function Callback({{cPlayer|Player}})</pre> The function returns false if the player was not found, or whatever bool value the callback returned if the player was found." },
				DoWithPlayerByUUID = { Params = "PlayerUUID, CallbackFunction", Return = "bool", Notes = "If there is the player with the uuid, calls the CallbackFunction with the {{cPlayer}} parameter representing the player. The CallbackFunction has the following signature: <pre class=\"prettyprint lang-lua\">function Callback({{cPlayer|Player}})</pre> The function returns false if the player was not found, or whatever bool value the callback returned if the player was found." },
				FastSetBlock =
				{
					{ Params = "BlockX, BlockY, BlockZ, BlockType, BlockMeta", Return = "", Notes = "Sets the block at the specified coords, without waking up the simulators or replacing the block entities for the previous block type. Do not use if the block being replaced has a block entity tied to it!" },
					{ Params = "{{Vector3i|BlockCoords}}, BlockType, BlockMeta", Return = "", Notes = "Sets the block at the specified coords, without waking up the simulators or replacing the block entities for the previous block type. Do not use if the block being replaced has a block entity tied to it!" },
				},
				FindAndDoWithPlayer = { Params = "PlayerName, CallbackFunction", Return = "bool", Notes = "Calls the given callback function for the player with the name best matching the name string provided.<br>This function is case-insensitive and will match partial names.<br>Returns false if player not found or there is ambiguity, true otherwise. The CallbackFunction has the following signature: <pre class=\"prettyprint lang-lua\">function Callback({{cPlayer|Player}})</pre>" },
				ForEachBlockEntityInChunk = { Params = "ChunkX, ChunkZ, CallbackFunction", Return = "bool", Notes = "Calls the specified callback for each block entity in the chunk. Returns true if all block entities in the chunk have been processed (including when there are zero block entities), or false if the callback has aborted the enumeration by returning true. The CallbackFunction has the following signature: <pre class=\"prettyprint lang-lua\">function Callback({{cBlockEntity|BlockEntity}})</pre> The callback should return false or no value to continue with the next block entity, or true to abort the enumeration. Use {{tolua}}.cast() to cast the Callback's BlockEntity parameter to the correct {{cBlockEntity}} descendant." },
				ForEachBrewingstandInChunk = { Params = "ChunkX, ChunkZ, CallbackFunction", Return = "bool", Notes = "Calls the specified callback for each brewingstand in the chunk. Returns true if all brewingstands in the chunk have been processed (including when there are zero brewingstands), or false if the callback has aborted the enumeration by returning true. The CallbackFunction has the following signature: <pre class=\"prettyprint lang-lua\">function Callback({{cBrewingstandEntity|cBrewingstandEntity}})</pre> The callback should return false or no value to continue with the next brewingstand, or true to abort the enumeration." },
				ForEachChestInChunk = { Params = "ChunkX, ChunkZ, CallbackFunction", Return = "bool", Notes = "Calls the specified callback for each chest in the chunk. Returns true if all chests in the chunk have been processed (including when there are zero chests), or false if the callback has aborted the enumeration by returning true. The CallbackFunction has the following signature: <pre class=\"prettyprint lang-lua\">function Callback({{cChestEntity|ChestEntity}})</pre> The callback should return false or no value to continue with the next chest, or true to abort the enumeration." },
				ForEachEntity = { Params = "CallbackFunction", Return = "bool", Notes = "Calls the specified callback for each entity in the loaded world. Returns true if all the entities have been processed (including when there are zero entities), or false if the callback function has aborted the enumeration by returning true. The callback function has the following signature: <pre class=\"prettyprint lang-lua\">function Callback({{cEntity|Entity}})</pre> The callback should return false or no value to continue with the next entity, or true to abort the enumeration." },
				ForEachEntityInBox = { Params = "{{cBoundingBox|Box}}, CallbackFunction", Return = "bool", Notes = "Calls the specified callback for each entity in the specified bounding box. Returns true if all the entities have been processed (including when there are zero entities), or false if the callback function has aborted the enumeration by returning true. If any chunk within the bounding box is not valid, it is silently skipped without any notification. The callback function has the following signature: <pre class=\"prettyprint lang-lua\">function Callback({{cEntity|Entity}})</pre> The callback should return false or no value to continue with the next entity, or true to abort the enumeration." },
				ForEachEntityInChunk = { Params = "ChunkX, ChunkZ, CallbackFunction", Return = "bool", Notes = "Calls the specified callback for each entity in the specified chunk. Returns true if all the entities have been processed (including when there are zero entities), or false if the chunk is not loaded or the callback function has aborted the enumeration by returning true. The callback function has the following signature: <pre class=\"prettyprint lang-lua\">function Callback({{cEntity|Entity}})</pre> The callback should return false or no value to continue with the next entity, or true to abort the enumeration." },
				ForEachFurnaceInChunk = { Params = "ChunkX, ChunkZ, CallbackFunction", Return = "bool", Notes = "Calls the specified callback for each furnace in the chunk. Returns true if all furnaces in the chunk have been processed (including when there are zero furnaces), or false if the callback has aborted the enumeration by returning true. The CallbackFunction has the following signature: <pre class=\"prettyprint lang-lua\">function Callback({{cFurnaceEntity|FurnaceEntity}})</pre> The callback should return false or no value to continue with the next furnace, or true to abort the enumeration." },
				ForEachPlayer = { Params = "CallbackFunction", Return = "bool", Notes = "Calls the specified callback for each player in the loaded world. Returns true if all the players have been processed (including when there are zero players), or false if the callback function has aborted the enumeration by returning true. The callback function has the following signature: <pre class=\"prettyprint lang-lua\">function Callback({{cPlayer|Player}})</pre> The callback should return false or no value to continue with the next player, or true to abort the enumeration." },
				GenerateChunk = { Params = "ChunkX, ChunkZ", Return = "", Notes = "Queues the specified chunk in the chunk generator. Ignored if the chunk is already generated (use RegenerateChunk() to force chunk re-generation)." },
				GetBiomeAt = { Params = "BlockX, BlockZ", Return = "eBiome", Notes = "Returns the biome at the specified coords. Reads the biome from the chunk, if it is loaded, otherwise it uses the chunk generator to provide the biome value." },
				GetBlock =
				{
					{ Params = "BlockX, BlockY, BlockZ", Return = "BLOCKTYPE", Notes = "Returns the block type of the block at the specified coords, or 0 if the appropriate chunk is not loaded." },
					{ Params = "{{Vector3i|BlockCoords}}", Return = "BLOCKTYPE", Notes = "Returns the block type of the block at the specified coords, or 0 if the appropriate chunk is not loaded." },
				},
				GetBlockBlockLight = { Params = "BlockX, BlockY, BlockZ", Return = "number", Notes = "Returns the amount of block light at the specified coords, or 0 if the appropriate chunk is not loaded." },
				GetBlockInfo = { Params = "BlockX, BlockY, BlockZ", Return = "BlockValid, BlockType, BlockMeta, BlockSkyLight, BlockBlockLight", Notes = "Returns the complete block info for the block at the specified coords. The first value specifies if the block is in a valid loaded chunk, the other values are valid only if BlockValid is true." },
				GetBlockMeta =
				{
					{ Params = "BlockX, BlockY, BlockZ", Return = "number", Notes = "Returns the block metadata of the block at the specified coords, or 0 if the appropriate chunk is not loaded." },
					{ Params = "{{Vector3i|BlockCoords}}", Return = "number", Notes = "Returns the block metadata of the block at the specified coords, or 0 if the appropriate chunk is not loaded." },
				},
				GetBlockSkyLight = { Params = "BlockX, BlockY, BlockZ", Return = "number", Notes = "Returns the block skylight of the block at the specified coords, or 0 if the appropriate chunk is not loaded." },
				GetBlockTypeMeta = { Params = "BlockX, BlockY, BlockZ", Return = "BlockValid, BlockType, BlockMeta", Notes = "Returns the block type and metadata for the block at the specified coords. The first value specifies if the block is in a valid loaded chunk, the other values are valid only if BlockValid is true." },
				GetDefaultWeatherInterval = { Params = "eWeather", Return = "", Notes = "Returns the default weather interval for the specific weather type. Returns -1 for any unknown weather." },
				GetDimension = { Params = "", Return = "eDimension", Notes = "Returns the dimension of the world - dimOverworld, dimNether or dimEnd." },
				GetGameMode = { Params = "", Return = "eGameMode", Notes = "Returns the gamemode of the world - gmSurvival, gmCreative or gmAdventure." },
				GetGeneratorQueueLength = { Params = "", Return = "number", Notes = "Returns the number of chunks that are queued in the chunk generator." },
				GetHeight = { Params = "BlockX, BlockZ", Return = "number", Notes = "Returns the maximum height of the particula block column in the world. If the chunk is not loaded, it waits for it to load / generate. <b>WARNING</b>: Do not use, Use TryGetHeight() instead for a non-waiting version, otherwise you run the risk of a deadlock!" },
				GetIniFileName = { Params = "", Return = "string", Notes = "Returns the name of the world.ini file that the world uses to store the information." },
				GetLightingQueueLength = { Params = "", Return = "number", Notes = "Returns the number of chunks in the lighting thread's queue." },
				GetLinkedEndWorldName = { Params = "", Return = "string", Notes = "Returns the name of the end world this world is linked to." },
				GetLinkedNetherWorldName = { Params = "", Return = "string", Notes = "Returns the name of the Netherworld linked to this world." },
				GetLinkedOverworldName = { Params = "", Return = "string", Notes = "Returns the name of the world this world is linked to." },
				GetMapManager = { Params = "", Return = "{{cMapManager}}", Notes = "Returns the {{cMapManager|MapManager}} object used by this world." },
				GetMaxCactusHeight = { Params = "", Return = "number", Notes = "Returns the configured maximum height to which cacti will grow naturally." },
				GetMaxNetherPortalHeight = { Params = "", Return = "number", Notes = "Returns the maximum height for a nether portal" },
				GetMaxNetherPortalWidth = { Params = "", Return = "number", Notes = "Returns the maximum width for a nether portal" },
				GetMaxSugarcaneHeight = { Params = "", Return = "number", Notes = "Returns the configured maximum height to which sugarcane will grow naturally." },
				GetMaxViewDistance = { Params = "", Return = "number", Notes = "Returns the maximum viewdistance that players can see in this world. The view distance is the amount of chunks around the player that the player can see." },
				GetMinNetherPortalHeight = { Params = "", Return = "number", Notes = "Returns the minimum height for a nether portal" },
				GetMinNetherPortalWidth = { Params = "", Return = "number", Notes = "Returns the minimum width for a nether portal" },
				GetName = { Params = "", Return = "string", Notes = "Returns the name of the world, as specified in the settings.ini file." },
				GetNumChunks = { Params = "", Return = "number", Notes = "Returns the number of chunks currently loaded." },
				GetScoreBoard = { Params = "", Return = "{{cScoreBoard}}", Notes = "Returns the {{cScoreBoard|ScoreBoard}} object used by this world. " },
				GetSignLines = { Params = "BlockX, BlockY, BlockZ", Return = "IsValid, [Line1, Line2, Line3, Line4]", Notes = "Returns true and the lines of a sign at the specified coords, or false if there is no sign at the coords." },
				GetSpawnX = { Params = "", Return = "number", Notes = "Returns the X coord of the default spawn" },
				GetSpawnY = { Params = "", Return = "number", Notes = "Returns the Y coord of the default spawn" },
				GetSpawnZ = { Params = "", Return = "number", Notes = "Returns the Z coord of the default spawn" },
				GetStorageLoadQueueLength = { Params = "", Return = "number", Notes = "Returns the number of chunks queued up for loading" },
				GetStorageSaveQueueLength = { Params = "", Return = "number", Notes = "Returns the number of chunks queued up for saving" },
				GetTicksUntilWeatherChange = { Params = "", Return = "number", Notes = "Returns the number of ticks that will pass before the weather is changed" },
				GetTimeOfDay = { Params = "", Return = "number", Notes = "Returns the number of ticks that have passed from the sunrise, 0 .. 24000." },
				GetTNTShrapnelLevel = { Params = "", Return = "{{Globals#ShrapnelLevel|ShrapnelLevel}}", Notes = "Returns the shrapnel level, representing the block types that are propelled outwards following an explosion. Based on this value and a random picker, blocks are selectively converted to physics entities (FallingSand) and flung outwards." },
				GetWeather = { Params = "", Return = "eWeather", Notes = "Returns the current weather in the world (wSunny, wRain, wStorm). To check for weather, use IsWeatherXXX() functions instead." },
				GetWorldAge = { Params = "", Return = "number", Notes = "Returns the total age of the world, in ticks. The age always grows, cannot be set by plugins and is unrelated to TimeOfDay." },
				GrowCactus = { Params = "BlockX, BlockY, BlockZ, NumBlocksToGrow", Return = "", Notes = "Grows a cactus block at the specified coords, by up to the specified number of blocks. Adheres to the world's maximum cactus growth (GetMaxCactusHeight())." },
				GrowMelonPumpkin = { Params = "BlockX, BlockY, BlockZ, StemType", Return = "", Notes = "Grows a melon or pumpkin, based on the stem type specified (assumed to be in the coords provided). Checks for normal melon / pumpkin growth conditions - stem not having another produce next to it and suitable ground below." },
				GrowRipePlant = { Params = "BlockX, BlockY, BlockZ, IsByBonemeal", Return = "bool", Notes = "Grows the plant at the specified coords. If IsByBonemeal is true, checks first if the specified plant type is bonemealable in the settings. Returns true if the plant was grown, false if not." },
				GrowSugarcane = { Params = "BlockX, BlockY, BlockZ, NumBlocksToGrow", Return = "", Notes = "Grows a sugarcane block at the specified coords, by up to the specified number of blocks. Adheres to the world's maximum sugarcane growth (GetMaxSugarcaneHeight())." },
				GrowTree = { Params = "BlockX, BlockY, BlockZ", Return = "", Notes = "Grows a tree based at the specified coords. If there is a sapling there, grows the tree based on that sapling, otherwise chooses a tree image based on the biome." },
				GrowTreeByBiome = { Params = "BlockX, BlockY, BlockZ", Return = "", Notes = "Grows a tree based at the specified coords. The tree type is picked from types available for the biome at those coords." },
				GrowTreeFromSapling = { Params = "BlockX, BlockY, BlockZ, SaplingMeta", Return = "", Notes = "Grows a tree based at the specified coords. The tree type is determined from the sapling meta (the sapling itself needn't be present)." },
				IsBlockDirectlyWatered = { Params = "BlockX, BlockY, BlockZ", Return = "bool", Notes = "Returns true if the specified block has a water block right next to it (on the X/Z axes)" },
				IsDaylightCycleEnabled = { Params = "", Return = "bool", Notes = "Returns true if the daylight cycle is enabled." },
				IsDeepSnowEnabled = { Params = "", Return = "bool", Notes = "Returns whether the configuration has DeepSnow enabled." },
				IsGameModeAdventure = { Params = "", Return = "bool", Notes = "Returns true if the current gamemode is gmAdventure." },
				IsGameModeCreative = { Params = "", Return = "bool", Notes = "Returns true if the current gamemode is gmCreative." },
				IsGameModeSpectator = { Params = "", Return = "bool", Notes = "Returns true if the current gamemode is gmSpectator." },
				IsGameModeSurvival = { Params = "", Return = "bool", Notes = "Returns true if the current gamemode is gmSurvival." },
				IsPVPEnabled = { Params = "", Return = "bool", Notes = "Returns whether PVP is enabled in the world settings." },
				IsTrapdoorOpen = { Params = "BlockX, BlockY, BlockZ", Return = "bool", Notes = "Returns false if there is no trapdoor there or if the block isn't a trapdoor or if the chunk wasn't loaded. Returns true if trapdoor is open." },
				IsWeatherRain = { Params = "", Return = "bool", Notes = "Returns true if the current world is raining." },
				IsWeatherRainAt = { Params = "BlockX, BlockZ", Return = "bool", Notes = "Returns true if the specified location is raining (takes into account biomes)." },
				IsWeatherStorm = { Params = "", Return = "bool", Notes = "Returns true if the current world is stormy." },
				IsWeatherStormAt = { Params = "BlockX, BlockZ", Return = "bool", Notes = "Returns true if the specified location is stormy (takes into account biomes)." },
				IsWeatherSunny = { Params = "", Return = "bool", Notes = "Returns true if the current weather is sunny." },
				IsWeatherSunnyAt = { Params = "BlockX, BlockZ", Return = "bool", Notes = "Returns true if the current weather is sunny at the specified location (takes into account biomes)." },
				IsWeatherWet = { Params = "", Return = "bool", Notes = "Returns true if the current world has any precipitation (rain or storm)." },
				IsWeatherWetAt = { Params = "BlockX, BlockZ", Return = "bool", Notes = "Returns true if the specified location has any precipitation (rain or storm) (takes into account biomes)." },
				PrepareChunk = { Params = "ChunkX, ChunkZ, [Callback]", Return = "", Notes = "Queues the chunk for preparing - making sure that it's generated and lit. It is legal to call with no callback. The callback function has the following signature: <pre class=\"prettyprint lang-lua\">function Callback(ChunkX, ChunkZ)</pre>" },
				QueueBlockForTick = { Params = "BlockX, BlockY, BlockZ, TicksToWait", Return = "", Notes = "Queues the specified block to be ticked after the specified number of gameticks." },
				QueueSaveAllChunks = { Params = "", Return = "", Notes = "Queues all chunks to be saved in the world storage thread" },
				QueueSetBlock = { Params = "BlockX, BlockY, BlockZ, BlockType, BlockMeta, TickDelay", Return = "", Notes = "Queues the block to be set to the specified blocktype and meta after the specified amount of game ticks. Uses SetBlock() for the actual setting, so simulators are woken up and block entities are handled correctly." },
				QueueTask = { Params = "TaskFunction", Return = "", Notes = "Queues the specified function to be executed in the tick thread. This is the primary means of interaction with a cWorld from the WebAdmin page handlers (see {{WebWorldThreads}}). The function signature is <pre class=\"pretty-print lang-lua\">function()</pre>All return values from the function are ignored. Note that this function is actually called *after* the QueueTask() function returns. Note that it is unsafe to store references to Cuberite objects, such as entities, across from the caller to the task handler function; store the EntityID instead." },
				QueueUnloadUnusedChunks = { Params = "", Return = "", Notes = "Queues a cTask that unloads chunks that are no longer needed and are saved." },
				RegenerateChunk = { Params = "ChunkX, ChunkZ", Return = "", Notes = "Queues the specified chunk to be re-generated, overwriting the current data. To queue a chunk for generating only if it doesn't exist, use the GenerateChunk() instead." },
				ScheduleTask = { Params = "DelayTicks, TaskFunction", Return = "", Notes = "Queues the specified function to be executed in the world's tick thread after a the specified number of ticks. This enables operations to be queued for execution in the future. The function signature is <pre class=\"pretty-print lang-lua\">function({{cWorld|World}})</pre>All return values from the function are ignored. Note that it is unsafe to store references to Cuberite objects, such as entities, across from the caller to the task handler function; store the EntityID instead." },
				SendBlockTo = { Params = "BlockX, BlockY, BlockZ, {{cPlayer|Player}}", Return = "", Notes = "Sends the block at the specified coords to the specified player's client, as an UpdateBlock packet." },
				SetAreaBiome = {
					{ Params = "MinX, MaxX, MinZ, MaxZ, EMCSBiome", Return = "bool", Notes = "Sets the biome in the rectangular area specified. Returns true if successful, false if any of the chunks were unloaded." },
					{ Params = "{{cCuboid|Cuboid}}, EMCSBiome", Return = "bool", Notes = "Sets the biome in the cuboid specified. Returns true if successful, false if any of the chunks were unloaded. The cuboid needn't be sorted." },
				},
				SetBiomeAt = { Params = "BlockX, BlockZ, EMCSBiome", Return = "bool", Notes = "Sets the biome at the specified block coords. Returns true if successful, false otherwise." },
				SetBlock = { Params = "BlockX, BlockY, BlockZ, BlockType, BlockMeta", Return = "", Notes = "Sets the block at the specified coords, replaces the block entities for the previous block type, creates a new block entity for the new block, if appropriate, and wakes up the simulators. This is the preferred way to set blocks, as opposed to FastSetBlock(), which is only to be used under special circumstances." },
				SetBlockMeta =
				{
					{ Params = "BlockX, BlockY, BlockZ, BlockMeta", Return = "", Notes = "Sets the meta for the block at the specified coords." },
					{ Params = "{{Vector3i|BlockCoords}}, BlockMeta", Return = "", Notes = "Sets the meta for the block at the specified coords." },
				},
				SetChunkAlwaysTicked = { Params = "ChunkX, ChunkZ, IsAlwaysTicked", Return = "", Notes = "Sets the chunk to always be ticked even when it doesn't contain any clients. IsAlwaysTicked set to true turns forced ticking on, set to false turns it off. Every call with 'true' should be paired with a later call with 'false', otherwise the ticking won't stop. Multiple actions can request ticking independently, the ticking will continue until the last call with 'false'. Note that when the chunk unloads, it loses the value of this flag." },
				SetNextBlockTick = { Params = "BlockX, BlockY, BlockZ", Return = "", Notes = "Sets the blockticking to start at the specified block in the next tick." },
				SetCommandBlockCommand = { Params = "BlockX, BlockY, BlockZ, Command", Return = "bool", Notes = "Sets the command to be executed in a command block at the specified coordinates. Returns if command was changed." },
				SetCommandBlocksEnabled = { Params = "IsEnabled (bool)", Return = "", Notes = "Sets whether command blocks should be enabled on the (entire) server." },
				SetDaylightCycleEnabled = { Params = "bool", Return = "", Notes = "Starts or stops the daylight cycle." },
				SetLinkedEndWorldName = { Params = "string", Return = "", Notes = "Sets the name of the world that the end portal should link to." },
				SetLinkedNetherWorldName = { Params = "string", Return = "", Notes = "Sets the name of the world that the nether portal should link to." },
				SetLinkedOverworldName = { Params = "string", Return = "", Notes = "Sets the name of the world that the nether portal should link to?" },
				SetMaxViewDistance = { Params = "number", Return = "", Notes = "Sets the maximum viewdistance of the players in the world." },
				SetMaxNetherPortalHeight = { Params = "number", Return = "", Notes = "Sets the maximum height for a nether portal" },
				SetMaxNetherPortalWidth = { Params = "number", Return = "", Notes = "Sets the maximum width for a nether portal" },
				SetMinNetherPortalHeight = { Params = "number", Return = "", Notes = "Sets the minimum height for a nether portal" },
				SetMinNetherPortalWidth = { Params = "number", Return = "", Notes = "Sets the minimum width for a nether portal" },
				SetShouldUseChatPrefixes = { Params = "", Return = "ShouldUse (bool)", Notes = "Sets whether coloured chat prefixes such as [INFO] is used with the SendMessageXXX() or BroadcastChatXXX(), or simply the entire message is coloured in the respective colour." },
				SetSignLines = { Params = "X, Y, Z, Line1, Line2, Line3, Line4, [{{cPlayer|Player}}]", Return = "", Notes = "Sets the sign text at the specified coords. The sign-updating hooks are called for the change. The Player parameter is used to indicate the player from whom the change has come, it may be nil." },
				SetTicksUntilWeatherChange = { Params = "NumTicks", Return = "", Notes = "Sets the number of ticks after which the weather will be changed." },
				SetTimeOfDay = { Params = "TimeOfDayTicks", Return = "", Notes = "Sets the time of day, expressed as number of ticks past sunrise, in the range 0 .. 24000." },
				SetTNTShrapnelLevel = { Params = "{{Globals#ShrapnelLevel|ShrapnelLevel}}", Return = "", Notes = "Sets the Shrampel level of the world." },
				SetTrapdoorOpen = { Params = "BlockX, BlockY, BlockZ, bool", Return = "", Notes = "Opens or closes a trapdoor at the specific coordinates." },
				SetWeather = { Params = "Weather", Return = "", Notes = "Sets the current weather (wSunny, wRain, wStorm) and resets the TicksUntilWeatherChange to the default value for the new weather. The normal weather-changing hooks are called for the change." },
				ShouldBroadcastAchievementMessages = { Params = "", Return = "bool", Notes = "Returns true if the server should broadcast achievement messages in this world." },
				ShouldBroadcastDeathMessages = { Params = "", Return = "bool", Notes = "Returns true if the server should broadcast death messages in this world." },
				ShouldUseChatPrefixes = { Params = "", Return = "bool", Notes = "Returns whether coloured chat prefixes are prepended to chat messages or the entire message is simply coloured." },
				ShouldLavaSpawnFire = { Params = "", Return = "bool", Notes = "Returns true if the world is configured to spawn fires near lava (world.ini: [Physics].ShouldLavaSpawnFire value)" },
				SpawnItemPickups =
				{
					{ Params = "{{cItems|Pickups}}, X, Y, Z, FlyAwaySpeed", Return = "", Notes = "Spawns the specified pickups at the position specified. The FlyAway speed is used to initialize the random speed in which the pickups fly away from the spawn position." },
					{ Params = "{{cItems|Pickups}}, X, Y, Z, SpeedX, SpeedY, SpeedZ", Return = "", Notes = "Spawns the specified pickups at the position specified. All the pickups fly away from the spawn position using the specified speed." },
				},
				SpawnMinecart = { Params = "X, Y, Z, MinecartType, Item, BlockHeight", Return = "number", Notes = "Spawns a minecart at the specific coordinates. MinecartType is the item type of the minecart. If the minecart is an empty minecart then the given item is the block inside the minecart, and blockheight is the distance of the block and the minecart." },
				SpawnMob = { Params = "X, Y, Z, {{cMonster|MonsterType}}, [Baby]", Return = "EntityID", Notes = "Spawns the specified type of mob at the specified coords. If the Baby parameter is true, the mob will be a baby. Returns the EntityID of the creates entity, or -1 on failure. " },
				SpawnFallingBlock = { Params = "X, Y, Z, BlockType, BlockMeta", Return = "EntityID", Notes = "Spawns an {{cFallingBlock|Falling Block}} entity at the specified coords with the given block type/meta" },
				SpawnExperienceOrb = { Params = "X, Y, Z, Reward", Return = "EntityID", Notes = "Spawns an {{cExpOrb|experience orb}} at the specified coords, with the given reward" },
				SpawnPrimedTNT = { Params = "X, Y, Z, FuseTicks, InitialVelocityCoeff", Return = "", Notes = "Spawns a {{cTNTEntity|primed TNT entity}} at the specified coords, with the given fuse ticks. The entity gets a random speed multiplied by the InitialVelocityCoeff, 1 being the default value." },
				TryGetHeight = { Params = "BlockX, BlockZ", Return = "IsValid, Height", Notes = "Returns true and height of the highest non-air block if the chunk is loaded, or false otherwise." },
				UpdateSign = { Params = "X, Y, Z, Line1, Line2, Line3, Line4, [{{cPlayer|Player}}]", Return = "", Notes = "(<b>DEPRECATED</b>) Please use SetSignLines()." },
				UseBlockEntity = { Params = "{{cPlayer|Player}}, BlockX, BlockY, BlockZ", Return = "", Notes = "Makes the specified Player use the block entity at the specified coords (open chest UI, etc.) If the cords are in an unloaded chunk or there's no block entity, ignores the call." },
				VillagersShouldHarvestCrops = { Params = "", Return = "", Notes = "Returns true if villagers can harvest crops." },
				WakeUpSimulators = { Params = "BlockX, BlockY, BlockZ", Return = "", Notes = "Wakes up the simulators for the specified block." },
				WakeUpSimulatorsInArea = { Params = "MinBlockX, MaxBlockX, MinBlockY, MaxBlockY, MinBlockZ, MaxBlockZ", Return = "", Notes = "Wakes up the simulators for all the blocks in the specified area (edges inclusive)." },
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
			},  -- AdditionalInfo
		},  -- cWorld

		ItemCategory =
		{
			Desc = [[
				This class contains static functions for determining item categories. All of the functions are
				called directly on the class table, unlike most other object, which require an instance first.
			]],
			Functions =
			{
				IsArmor      = { Params = "ItemType", Return = "bool", Notes = "(STATIC) Returns true if the specified item type is any kind of an armor." },
				IsAxe        = { Params = "ItemType", Return = "bool", Notes = "(STATIC) Returns true if the specified item type is any kind of an axe." },
				IsBoots      = { Params = "ItemType", Return = "bool", Notes = "(STATIC) Returns true if the specified item type is any kind of boots." },
				IsChestPlate = { Params = "ItemType", Return = "bool", Notes = "(STATIC) Returns true if the specified item type is any kind of a chestplate." },
				IsHelmet     = { Params = "ItemType", Return = "bool", Notes = "(STATIC) Returns true if the specified item type is any kind of a helmet." },
				IsHoe        = { Params = "ItemType", Return = "bool", Notes = "(STATIC) Returns true if the specified item type is any kind of a hoe." },
				IsLeggings   = { Params = "ItemType", Return = "bool", Notes = "(STATIC) Returns true if the specified item type is any kind of a leggings." },
				IsPickaxe    = { Params = "ItemType", Return = "bool", Notes = "(STATIC) Returns true if the specified item type is any kind of a pickaxe." },
				IsShovel     = { Params = "ItemType", Return = "bool", Notes = "(STATIC) Returns true if the specified item type is any kind of a shovel." },
				IsSword      = { Params = "ItemType", Return = "bool", Notes = "(STATIC) Returns true if the specified item type is any kind of a sword." },
				IsTool       = { Params = "ItemType", Return = "bool", Notes = "(STATIC) Returns true if the specified item type is any kind of a tool (axe, hoe, pickaxe, shovel or FIXME: sword)" },
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
				}
			},
		},  -- ItemCategory

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
				new = {Params = "CallbacksTable, [SeparatorChar]", Return = "XMLParser object", Notes = "Creates a new XML parser object, with the specified callbacks table and optional separator character."},
			},
			Constants =
			{
				_COPYRIGHT = { Notes = "" },
				_DESCRIPTION = { Notes = "" },
				_VERSION = { Notes = "" },
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
			},  -- AdditionalInfo
		},  -- lxp

		sqlite3 =
		{
			Desc = [[
			]],

			Functions =
			{
				complete = { Params = "string", Return = "bool", Notes = "Returns true if the string sql comprises one or more complete SQL statements and false otherwise." },
				open = { Params = "FileName", Return = "DBClass", Notes = [[
					Opens (or creates if it does not exist) an SQLite database with name filename and returns its
					handle as userdata (the returned object should be used for all further method calls in connection
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
				]], },
				open_memory = { Return = "DBClass", Notes = "Opens an SQLite database in memory and returns its handle as userdata. In case of an error, the function returns nil, an error code and an error message. (In-memory databases are volatile as they are never stored on disk.)" },
				version = { Return = "string", Notes = "Returns a string with SQLite version information, in the form 'x.y[.z]'." },
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
				Attacker = { Type = "{{cEntity}}", Notes = "The entity who is attacking. Only valid if dtAttack." },
				DamageType = { Type = "eDamageType", Notes = "Source of the damage. One of the dtXXX constants." },
				FinalDamage = { Type = "number", Notes = "	The final amount of damage that will be applied to the Receiver. It is the RawDamage minus any Receiver's armor-protection " },
				Knockback = { Type = "{{Vector3d}}", Notes = "Vector specifying the amount and direction of knockback that will be applied to the Receiver " },
				RawDamage = { Type = "number", Notes = "Amount of damage that the attack produces on the Receiver, including the Attacker's equipped weapon, but excluding the Receiver's armor." },
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
			},  -- AdditionalInfo
		},  -- TakeDamageInfo

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
				cast = { Params = "Object, TypeStr", Return = "Object", Notes = "Casts the object to the specified type.<br/><b>Note:</b> This is a potentially unsafe operation and it could crash the server. There is normally no need to use this function at all, so don't use it unless you know exactly what you're doing." },
				getpeer = { Params = "", Return = "", Notes = "" },
				inherit = { Params = "", Return = "", Notes = "" },
				releaseownership = { Params = "", Return = "", Notes = "" },
				setpeer = { Params = "", Return = "", Notes = "" },
				takeownership = { Params = "", Return = "", Notes = "" },
				type = { Params = "Object", Return = "TypeStr", Notes = "Returns a string representing the type of the object. This works similar to Lua's built-in type() function, but recognizes the underlying C++ classes, too." },
			},
		},  -- tolua

		Globals =
		{
			Desc = [[
				These functions are available directly, without a class instance. Any plugin can call them at any
				time.
			]],
			Functions =
			{
				AddFaceDirection = {Params = "BlockX, BlockY, BlockZ, BlockFace, [IsInverse]", Return = "BlockX, BlockY, BlockZ", Notes = "Returns the coords of a block adjacent to the specified block through the specified {{Globals#BlockFaces|face}}"},
				BlockFaceToString = {Params = "{{Globals#BlockFaces|eBlockFace}}", Return = "string", Notes = "Returns the string representation of the {{Globals#BlockFaces|eBlockFace}} constant. Uses the axis-direction-based names, such as BLOCK_FACE_XP." },
				BlockStringToType = {Params = "BlockTypeString", Return = "BLOCKTYPE", Notes = "Returns the block type parsed from the given string"},
				Clamp = {Params = "Number, Min, Max", Return = "number", Notes = "Clamp the number to the specified range."},
				ClickActionToString = {Params = "{{Globals#ClickAction|ClickAction}}", Return = "string", Notes = "Returns a string description of the ClickAction enumerated value"},
				DamageTypeToString = {Params = "{{Globals#DamageType|DamageType}}", Return = "string", Notes = "Converts the {{Globals#DamageType|DamageType}} enumerated value to a string representation "},
				EscapeString = {Params = "string", Return = "string", Notes = "Returns a copy of the string with all quotes and backslashes escaped by a backslash"},
				GetChar = {Params = "String, Pos", Return = "string", Notes = "Returns one character from the string, specified by position "},
				GetIniItemSet = { Params = "IniFile, SectionName, KeyName, DefaultValue", Return = "{{cItem}}", Notes = "Returns the item that has been read from the specified INI file value. If the value is not present in the INI file, the DefaultValue is stored in the file and parsed as the result. Returns empty item if the value cannot be parsed. " },
				GetTime = {Return = "number", Notes = "Returns the current OS time, as a unix time stamp (number of seconds since Jan 1, 1970)"},
				IsBiomeNoDownfall = {Params = "Biome", Return = "bool", Notes = "Returns true if the biome is 'dry', that is, there is no precipitation during rains and storms." },
				IsValidBlock = {Params = "BlockType", Return = "bool", Notes = "Returns true if BlockType is a known block type"},
				IsValidItem = {Params = "ItemType", Return = "bool", Notes = "Returns true if ItemType is a known item type"},
				ItemToFullString = {Params = "{{cItem|cItem}}", Return = "string", Notes = "Returns the string representation of the item, in the format 'ItemTypeText:ItemDamage * Count'"},
				ItemToString = {Params = "{{cItem|cItem}}", Return = "string", Notes = "Returns the string representation of the item type"},
				ItemTypeToString = {Params = "ItemType", Return = "string", Notes = "Returns the string representation of ItemType "},
				LOG =
				{
					{Params = "string", Notes = "Logs a text into the server console using 'normal' severity (gray text)"},
					{Params = "{{cCompositeChat|CompositeChat}}", Notes = "Logs the {{cCompositeChat}}'s human-readable text into the server console. The severity is converted from the CompositeChat's MessageType."},
				},
				LOGERROR =
				{
					{Params = "string", Notes = "Logs a text into the server console using 'error' severity (black text on red background)"},
					{Params = "{{cCompositeChat|CompositeChat}}", Notes = "Logs the {{cCompositeChat}}'s human-readable text into the server console using 'error' severity (black text on red background)"},
				},
				LOGINFO =
				{
					{Params = "string", Notes = "Logs a text into the server console using 'info' severity (yellow text)"},
					{Params = "{{cCompositeChat|CompositeChat}}", Notes = "Logs the {{cCompositeChat}}'s human-readable text into the server console using 'info' severity (yellow text)"},
				},
				LOGWARN =
				{
					{Params = "string", Notes = "Logs a text into the server console using 'warning' severity (red text); OBSOLETE, use LOGWARNING() instead"},
					{Params = "{{cCompositeChat|CompositeChat}}", Notes = "Logs the {{cCompositeChat}}'s human-readable text into the server console using 'warning' severity (red text); OBSOLETE, use LOGWARNING() instead"},
				},
				LOGWARNING =
				{
					{Params = "string", Notes = "Logs a text into the server console using 'warning' severity (red text)"},
					{Params = "{{cCompositeChat|CompositeChat}}", Notes = "Logs the {{cCompositeChat}}'s human-readable text into the server console using 'warning' severity (red text)"},
				},
				MirrorBlockFaceY = { Params = "{{Globals#BlockFaces|eBlockFace}}", Return = "{{Globals#BlockFaces|eBlockFace}}", Notes = "Returns the {{Globals#BlockFaces|eBlockFace}} that corresponds to the given {{Globals#BlockFaces|eBlockFace}} after mirroring it around the Y axis (or rotating 180 degrees around it)." },
				NoCaseCompare = {Params = "string, string", Return = "number", Notes = "Case-insensitive string comparison; returns 0 if the strings are the same"},
				NormalizeAngleDegrees = { Params = "AngleDegrees", Return = "AngleDegrees", Notes = "Returns the angle, wrapped into the [-180, +180) range." },
				ReplaceString = {Params = "full-string, to-be-replaced-string, to-replace-string", Return = "string", Notes = "Replaces *each* occurence of to-be-replaced-string in full-string with to-replace-string"},
				RotateBlockFaceCCW = { Params = "{{Globals#BlockFaces|eBlockFace}}", Return = "{{Globals#BlockFaces|eBlockFace}}", Notes = "Returns the {{Globals#BlockFaces|eBlockFace}} that corresponds to the given {{Globals#BlockFaces|eBlockFace}} after rotating it around the Y axis 90 degrees counter-clockwise." },
				RotateBlockFaceCW = { Params = "{{Globals#BlockFaces|eBlockFace}}", Return = "{{Globals#BlockFaces|eBlockFace}}", Notes = "Returns the {{Globals#BlockFaces|eBlockFace}} that corresponds to the given {{Globals#BlockFaces|eBlockFace}} after rotating it around the Y axis 90 degrees clockwise." },
				StringSplit = {Params = "string, SeperatorsString", Return = "array table of strings", Notes = "Seperates string into multiple by splitting every time any of the characters in SeperatorsString is encountered."},
				StringSplitAndTrim = {Params = "string, SeperatorsString", Return = "array table of strings", Notes = "Seperates string into multiple by splitting every time any of the characters in SeperatorsString is encountered. Each of the separate strings is trimmed (whitespace removed from the beginning and end of the string)"},
				StringSplitWithQuotes = {Params = "string, SeperatorsString", Return = "array table of strings", Notes = "Seperates string into multiple by splitting every time any of the characters in SeperatorsString is encountered. Whitespace wrapped with single or double quotes will be ignored"},
				StringToBiome = {Params = "string", Return = "{{Globals#BiomeTypes|BiomeType}}", Notes = "Converts a string representation to a {{Globals#BiomeTypes|BiomeType}} enumerated value"},
				StringToDamageType = {Params = "string", Return = "{{Globals#DamageType|DamageType}}", Notes = "Converts a string representation to a {{Globals#DamageType|DamageType}} enumerated value."},
				StringToDimension = {Params = "string", Return = "{{Globals#WorldDimension|Dimension}}", Notes = "Converts a string representation to a {{Globals#WorldDimension|Dimension}} enumerated value"},
				StringToItem = {Params = "string, {{cItem|cItem}}", Return = "bool", Notes = "Parses the given string and sets the item; returns true if successful"},
				StringToMobType = {Params = "string", Return = "{{Globals#MobType|MobType}}", Notes = "<b>DEPRECATED!</b> Please use cMonster:StringToMobType(). Converts a string representation to a {{Globals#MobType|MobType}} enumerated value"},
				StripColorCodes = {Params = "string", Return = "string", Notes = "Removes all control codes used by MC for colors and styles"},
				TrimString = {Params = "string", Return = "string", Notes = "Trims whitespace at both ends of the string"},
				md5 = {Params = "string", Return = "string", Notes = "<b>OBSOLETE</b>, use the {{cCryptoHash}} functions instead.<br>Converts a string to a raw binary md5 hash."},
			},
			ConstantGroups =
			{
				BlockTypes =
				{
					Include = "^E_BLOCK_.*",
					TextBefore = [[
						These constants are used for block types. They correspond directly with MineCraft's data values
						for blocks.
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
				BiomeTypes =
				{
					Include = "^bi.*",
					TextBefore = [[
						These constants represent the biomes that the server understands. Note that there is a global
						StringToBiome() function that can convert a string into one of these constants.
					]],
				},
				BlockFaces =
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
				ClickAction =
				{
					Include = "^ca.*",
					TextBefore = [[
						These constants are used to signalize various interactions that the user can do with the
						{{cWindow|UI windows}}. The server translates the protocol events into these constants. Note
						that there is a global ClickActionToString() function that can translate these constants into
						their textual representation.
					]],
				},
				WorldDimension =
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
				DamageType =
				{
					Include = "^dt.*",
					TextBefore = [[
						These constants are used for specifying the cause of damage to entities. They are used in the
						{{TakeDamageInfo}} structure, as well as in {{cEntity}}'s damage-related API functions.
					]],
				},
				GameMode =
				{
					Include = { "^gm.*", "^eGameMode_.*" },
					TextBefore = [[
						The following constants are used for the gamemode - survival, creative or adventure. Use the
						gmXXX constants, the eGameMode_ constants are deprecated and will be removed from the API.
					]],
				},
				MobType =
				{
					Include = { "^mt.*" },
					TextBefore = [[
						The following constants are used for distinguishing between the individual mob types:
					]],
				},
				Weather =
				{
					Include = { "^eWeather_.*", "wSunny", "wRain", "wStorm", "wThunderstorm" },
					TextBefore = [[
						These constants represent the weather in the world. Note that unlike vanilla, Cuberite allows
						different weathers even in non-overworld {{Globals#WorldDimension|dimensions}}.
					]],
				},
				ExplosionSource =
				{
					Include = "^es.*",
					TextBefore = [[
						These constants are used to differentiate the various sources of explosions. They are used in
						the {{OnExploded|HOOK_EXPLODED}} hook, {{OnExploding|HOOK_EXPLODING}} hook and in the
						{{cWorld}}:DoExplosionAt() function. These constants also dictate the type of the additional
						data provided with the explosions, such as the exploding {{cCreeper|creeper}} entity or the
						{{Vector3i|coords}} of the exploding bed.
					]],
				},
				SpreadSource =
				{
					Include = "^ss.*",
					TextBefore = [[
						These constants are used to differentiate the various sources of spreads, such as grass growing.
						They are used in the {{OnBlockSpread|HOOK_BLOCK_SPREAD}} hook.
					]],
				},
				ShrapnelLevel =
				{
					Include = "^sl.*",
					TextBefore = [[
						The following constants define the block types  that are propelled outwards after an explosion.
					]],
				},
			},
		},  -- Globals
	},


	IgnoreClasses =
	{
		"^coroutine$",
		"^debug$",
		"^io$",
		"^math$",
		"^package$",
		"^os$",
		"^string$",
		"^table$",
		"^g_Stats$",
		"^g_TrackedPages$",
	},

	IgnoreFunctions =
	{
		"Globals.assert",
		"Globals.collectgarbage",
		"Globals.xpcall",
		"Globals.decoda_output",  -- When running under Decoda, this function gets added to the global namespace
		"sqlite3.__newindex",
		"%a+%.__%a+",        -- AnyClass.__Anything
		"%a+%.%.collector",  -- AnyClass..collector
		"%a+%.new",          -- AnyClass.new
		"%a+%.new_local",    -- AnyClass.new_local
		"%a+%.delete",       -- AnyClass.delete

		-- Functions global in the APIDump plugin:
		"CreateAPITables",
		"DumpAPIHtml",
		"DumpAPITxt",
		"Initialize",
		"LinkifyString",
		"ListMissingPages",
		"ListUndocumentedObjects",
		"ListUnexportedObjects",
		"LoadAPIFiles",
		"ReadDescriptions",
		"ReadHooks",
		"WriteHtmlClass",
		"WriteHtmlHook",
		"WriteStats",
	},

	IgnoreConstants =
	{
		"cChestEntity.__cBlockEntityWindowOwner__",
		"cDropSpenserEntity.__cBlockEntityWindowOwner__",
		"cFurnaceEntity.__cBlockEntityWindowOwner__",
		"cHopperEntity.__cBlockEntityWindowOwner__",
		"cLuaWindow.__cItemGrid__cListener__",
		"Globals._CuberiteInternal_.*",  -- Ignore all internal Cuberite constants
	},

	IgnoreVariables =
	{
		"__.*__",  -- tolua exports multiple inheritance this way
	} ,

	ExtraPages =
	{
		-- No sorting is provided for these, they will be output in the same order as defined here
		{ FileName = "Writing-a-Cuberite-plugin.html", Title = "Writing a Cuberite plugin" },
		{ FileName = "InfoFile.html",                  Title = "Using the Info.lua file" },
		{ FileName = "SettingUpDecoda.html",           Title = "Setting up the Decoda Lua IDE" },
		{ FileName = "SettingUpZeroBrane.html",        Title = "Setting up the ZeroBrane Studio Lua IDE" },
		{ FileName = "UsingChunkStays.html",           Title = "Using ChunkStays" },
		{ FileName = "WebWorldThreads.html",           Title = "Webserver vs World threads" },
	}
} ;
