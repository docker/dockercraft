
-- Geometry.lua

-- Defines the documentation for geometry-related classes:
-- cBoundingBox, cCuboid, cLineBlockTracer, cTracer, Vector3X




return
{
	cBoundingBox =
	{
		Desc = [[
		Represents two sets of coordinates, minimum and maximum for each direction; thus defining an
		axis-aligned cuboid with floating-point boundaries. It supports operations changing the size and
		position of the box, as well as querying whether a point or another BoundingBox is inside the box.</p>
		<p>
		All the points within the coordinate limits (inclusive the edges) are considered "inside" the box.
		However, for intersection purposes, if the intersection is "sharp" in any coord (min1 == max2, i. e.
		zero volume), the boxes are considered non-intersecting.</p>
		]],
		Functions =
		{
			CalcLineIntersection =
			{
				{
					Params =
					{
						{
							Name = "LineStart",
							Type = "Vector3d",
						},
						{
							Name = "LinePt2",
							Type = "Vector3d",
						},
					},
					Returns =
					{
						{
							Name = "DoesIntersect",
							Type = "boolean",
						},
						{
							Name = "LineCoeff",
							Type = "number",
							IsOptional = true,
						},
						{
							Name = "Face",
							Type = "eBlockFace",
							IsOptional = true,
						},
					},
					Notes = "Calculates the intersection of a ray (half-line), given by two of its points, with the bounding box. Returns false if the line doesn't intersect the bounding box, or true, together with coefficient of the intersection (how much of the difference between the two ray points is needed to reach the intersection), and the face of the box which is intersected.",
				},
				{
					IsStatic = true,
					Params =
					{
						{
							Name = "BoxMin",
							Type = "number",
						},
						{
							Name = "BoxMax",
							Type = "number",
						},
						{
							Name = "LineStart",
							Type = "Vector3d",
						},
						{
							Name = "LinePt2",
							Type = "Vector3d",
						},
					},
					Returns =
					{
						{
							Name = "DoesIntersect",
							Type = "boolean",
						},
						{
							Name = "LineCoeff",
							Type = "number",
							IsOptional = true,
						},
						{
							Name = "Face",
							Type = "eBlockFace",
							IsOptional = true,
						},
					},
					Notes = "Calculates the intersection of a ray (half-line), given by two of its points, with the bounding box specified as its minimum and maximum coords. Returns false if the line doesn't intersect the bounding box, or true, together with coefficient of the intersection (how much of the difference between the two ray points is needed to reach the intersection), and the face of the box which is intersected.",
				},
			},
			constructor =
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
							Type = "cBoundingBox",
						},
					},
					Notes = "Creates a new bounding box with the specified edges",
				},
				{
					Params =
					{
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
							Type = "cBoundingBox",
						},
					},
					Notes = "Creates a new bounding box with the coords specified as two vectors",
				},
				{
					Params =
					{
						{
							Name = "Pos",
							Type = "Vector3d",
						},
						{
							Name = "Radius",
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
							Type = "cBoundingBox",
						},
					},
					Notes = "Creates a new bounding box from the position given and radius (X/Z) and height. Radius is added from X/Z to calculate the maximum coords and subtracted from X/Z to get the minimum; minimum Y is set to Pos.y and maxumim Y to Pos.y plus Height. This corresponds with how {{cEntity|entities}} are represented in Minecraft.",
				},
				{
					Params =
					{
						{
							Name = "OtherBoundingBox",
							Type = "cBoundingBox",
						},
					},
					Returns =
					{
						{
							Type = "cBoundingBox",
						},
					},
					Notes = "Creates a new copy of the given bounding box. Same result can be achieved by using a simple assignment.",
				},
				{
					Params =
					{
						{
							Name = "Pos",
							Type = "Vector3d",
						},
						{
							Name = "CubeSideLength",
							Type = "number",
						},
					},
					Returns =
					{
						{
							Type = "cBoundingBox",
						},
					},
					Notes = "Creates a new bounding box as a cube with the specified side length centered around the specified point.",
				},
			},
			DoesIntersect =
			{
				Params =
				{
					{
						Name = "OtherBoundingBox",
						Type = "cBoundingBox",
					},
				},
				Returns =
				{
					{
						Type = "boolean",
					},
				},
				Notes = "Returns true if the two bounding boxes have an intersection of nonzero volume.",
			},
			Expand =
			{
				Params =
				{
					{
						Name = "ExpandX",
						Type = "number",
					},
					{
						Name = "ExpandY",
						Type = "number",
					},
					{
						Name = "ExpandZ",
						Type = "number",
					},
				},
				Notes = "Expands this bounding box by the specified amount in each direction (so the box becomes larger by 2 * Expand in each axis).",
			},
			GetMax =
			{
				Returns =
				{
					{
						Name = "Point",
						Type = "Vector3d",
					},
				},
				Notes = "Returns the boundary point with the maximum coords",
			},
			GetMaxX =
			{
				Returns =
				{
					{
						Type = "number",
					},
				},
				Notes = "Returns the maximum X coord of the bounding box",
			},
			GetMaxY =
			{
				Returns =
				{
					{
						Type = "number",
					},
				},
				Notes = "Returns the maximum Y coord of the bounding box",
			},
			GetMaxZ =
			{
				Returns =
				{
					{
						Type = "number",
					},
				},
				Notes = "Returns the maximum Z coord of the bounding box",
			},
			GetMin =
			{
				Returns =
				{
					{
						Name = "Point",
						Type = "Vector3d",
					},
				},
				Notes = "Returns the boundary point with the minimum coords",
			},
			GetMinX =
			{
				Returns =
				{
					{
						Type = "number",
					},
				},
				Notes = "Returns the minimum X coord of the bounding box",
			},
			GetMinY =
			{
				Returns =
				{
					{
						Type = "number",
					},
				},
				Notes = "Returns the minimum Y coord of the bounding box",
			},
			GetMinZ =
			{
				Returns =
				{
					{
						Type = "number",
					},
				},
				Notes = "Returns the minimum Z coord of the bounding box",
			},
			Intersect =
			{
				Params =
				{
					{
						Name = "OtherBbox",
						Type = "cBoundingBox",
					},
				},
				Returns =
				{
					{
						Type = "boolean",
					},
					{
						Name = "Intersection",
						Type = "cBoundingBox",
						IsOptional = true,
					},
				},
				Notes = "Checks if the intersection between this bounding box and another one is non-empty. Returns false if the intersection is empty, true and a new cBoundingBox representing the intersection of the two boxes.",
			},
			IsInside =
			{
				{
					Params =
					{
						{
							Name = "Point",
							Type = "Vector3d",
						},
					},
					Returns =
					{
						{
							Type = "boolean",
						},
					},
					Notes = "Returns true if the specified point is inside (including on the edge) of the box.",
				},
				{
					Params =
					{
						{
							Name = "PointX",
							Type = "number",
						},
						{
							Name = "PointY",
							Type = "number",
						},
						{
							Name = "PointZ",
							Type = "number",
						},
					},
					Returns =
					{
						{
							Type = "boolean",
						},
					},
					Notes = "Returns true if the specified point is inside (including on the edge) of the box.",
				},
				{
					Params =
					{
						{
							Name = "OtherBoundingBox",
							Type = "cBoundingBox",
						},
					},
					Returns =
					{
						{
							Type = "boolean",
						},
					},
					Notes = "Returns true if OtherBoundingBox is inside of this box.",
				},
				{
					Params =
					{
						{
							Name = "OtherBoxMin",
							Type = "number",
						},
						{
							Name = "OtherBoxMax",
							Type = "number",
						},
					},
					Returns =
					{
						{
							Type = "boolean",
						},
					},
					Notes = "Returns true if the other bounding box, specified by its 2 corners, is inside of this box.",
				},
				{
					IsStatic = true,
					Params =
					{
						{
							Name = "Min",
							Type = "number",
						},
						{
							Name = "Max",
							Type = "number",
						},
						{
							Name = "Point",
							Type = "Vector3d",
						},
					},
					Returns =
					{
						{
							Type = "boolean",
						},
					},
					Notes = "Returns true if the specified point is inside the bounding box specified by its min / max corners",
				},
				{
					IsStatic = true,
					Params =
					{
						{
							Name = "Min",
							Type = "number",
						},
						{
							Name = "Max",
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
					},
					Returns =
					{
						{
							Type = "boolean",
						},
					},
					Notes = "Returns true if the specified point is inside the bounding box specified by its min / max corners",
				},
			},
			Move =
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
					Notes = "Moves the bounding box by the specified offset in each axis",
				},
				{
					Params =
					{
						{
							Name = "Offset",
							Type = "Vector3d",
						},
					},
					Notes = "Moves the bounding box by the specified offset in each axis",
				},
			},
			Union =
			{
				Params =
				{
					{
						Name = "OtherBoundingBox",
						Type = "cBoundingBox",
					},
				},
				Returns =
				{
					{
						Type = "cBoundingBox",
					},
				},
				Notes = "Returns the smallest bounding box that contains both OtherBoundingBox and this bounding box. Note that unlike the strict geometrical meaning of \"union\", this operation actually returns a cBoundingBox.",
			},
		},
	},
	cCuboid =
	{
		Desc = [[
			cCuboid offers some native support for integral-boundary cuboids. A cuboid internally consists of
			two {{Vector3i}}-s. By default the cuboid doesn't make any assumptions about the defining points,
			but for most of the operations in the cCuboid class, the p1 member variable is expected to be the
			minima and the p2 variable the maxima. The Sort() function guarantees this condition.</p>
			<p>
			The Cuboid considers both its edges inclusive.</p>
		]],
		Functions =
		{
			Assign =
			{
				{
					Params =
					{
						{
							Name = "SrcCuboid",
							Type = "cCuboid",
						},
					},
					Notes = "Copies all the coords from the src cuboid to this cuboid. Sort-state is ignored.",
				},
				{
					Params =
					{
						{
							Name = "X1",
							Type = "number",
						},
						{
							Name = "Y1",
							Type = "number",
						},
						{
							Name = "Z1",
							Type = "number",
						},
						{
							Name = "X2",
							Type = "number",
						},
						{
							Name = "Y2",
							Type = "number",
						},
						{
							Name = "Z2",
							Type = "number",
						},
					},
					Notes = "Assigns all the coords to the specified values. Sort-state is ignored.",
				},
			},
			ClampX =
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
				},
				Notes = "Clamps both X coords into the range provided. Sortedness-agnostic.",
			},
			ClampY =
			{
				Params =
				{
					{
						Name = "MinY",
						Type = "number",
					},
					{
						Name = "MaxY",
						Type = "number",
					},
				},
				Notes = "Clamps both Y coords into the range provided. Sortedness-agnostic.",
			},
			ClampZ =
			{
				Params =
				{
					{
						Name = "MinZ",
						Type = "number",
					},
					{
						Name = "MaxZ",
						Type = "number",
					},
				},
				Notes = "Clamps both Z coords into the range provided. Sortedness-agnostic.",
			},
			constructor =
			{
				{
					Returns =
					{
						{
							Type = "cCuboid",
						},
					},
					Notes = "Creates a new Cuboid object with all-zero coords",
				},
				{
					Params =
					{
						{
							Name = "OtherCuboid",
							Type = "cCuboid",
						},
					},
					Returns =
					{
						{
							Type = "cCuboid",
						},
					},
					Notes = "Creates a new Cuboid object as a copy of OtherCuboid",
				},
				{
					Params =
					{
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
							Type = "cCuboid",
						},
					},
					Notes = "Creates a new Cuboid object with the specified points as its corners.",
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
							Name = "Z",
							Type = "number",
						},
					},
					Returns =
					{
						{
							Type = "cCuboid",
						},
					},
					Notes = "Creates a new Cuboid object with the specified point as both its corners (the cuboid has a size of 1 in each direction).",
				},
				{
					Params =
					{
						{
							Name = "X1",
							Type = "number",
						},
						{
							Name = "Y1",
							Type = "number",
						},
						{
							Name = "Z1",
							Type = "number",
						},
						{
							Name = "X2",
							Type = "number",
						},
						{
							Name = "Y2",
							Type = "number",
						},
						{
							Name = "Z2",
							Type = "number",
						},
					},
					Returns =
					{
						{
							Type = "cCuboid",
						},
					},
					Notes = "Creates a new Cuboid object with the specified points as its corners.",
				},
			},
			DifX =
			{
				Returns =
				{
					{
						Type = "number",
					},
				},
				Notes = "Returns the difference between the two X coords (X-size minus 1). Assumes sorted.",
			},
			DifY =
			{
				Returns =
				{
					{
						Type = "number",
					},
				},
				Notes = "Returns the difference between the two Y coords (Y-size minus 1). Assumes sorted.",
			},
			DifZ =
			{
				Returns =
				{
					{
						Type = "number",
					},
				},
				Notes = "Returns the difference between the two Z coords (Z-size minus 1). Assumes sorted.",
			},
			DoesIntersect =
			{
				Params =
				{
					{
						Name = "OtherCuboid",
						Type = "cCuboid",
					},
				},
				Returns =
				{
					{
						Type = "boolean",
					},
				},
				Notes = "Returns true if this cuboid has at least one voxel in common with OtherCuboid. Note that edges are considered inclusive. Assumes both sorted.",
			},
			Engulf =
			{
				Params =
				{
					{
						Name = "Point",
						Type = "Vector3i",
					},
				},
				Notes = "If needed, expands the cuboid to include the specified point. Doesn't shrink. Assumes sorted. ",
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
				Notes = "Expands the cuboid by the specified amount in each direction. Works on unsorted cuboids as well. NOTE: this function doesn't check for underflows.",
			},
			GetVolume =
			{
				Returns =
				{
					{
						Type = "number",
					},
				},
				Notes = "Returns the volume of the cuboid, in blocks. Note that the volume considers both coords inclusive. Works on unsorted cuboids, too.",
			},
			IsCompletelyInside =
			{
				Params =
				{
					{
						Name = "OuterCuboid",
						Type = "cCuboid",
					},
				},
				Returns =
				{
					{
						Type = "boolean",
					},
				},
				Notes = "Returns true if this cuboid is completely inside (in all directions) in OuterCuboid. Assumes both sorted.",
			},
			IsInside =
			{
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
					Notes = "Returns true if the specified point (integral coords) is inside this cuboid. Assumes sorted.",
				},
				{
					Params =
					{
						{
							Name = "Point",
							Type = "Vector3i",
						},
					},
					Returns =
					{
						{
							Type = "boolean",
						},
					},
					Notes = "Returns true if the specified point (integral coords) is inside this cuboid. Assumes sorted.",
				},
				{
					Params =
					{
						{
							Name = "Point",
							Type = "Vector3d",
						},
					},
					Returns =
					{
						{
							Type = "boolean",
						},
					},
					Notes = "Returns true if the specified point (floating-point coords) is inside this cuboid. Assumes sorted.",
				},
			},
			IsSorted =
			{
				Returns =
				{
					{
						Type = "boolean",
					},
				},
				Notes = "Returns true if this cuboid is sorted",
			},
			Move =
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
				Notes = "Adds the specified offsets to each respective coord, effectively moving the Cuboid. Sort-state is ignored and preserved.",
			},
			Sort =
			{
				Notes = "Sorts the internal representation so that p1 contains the lesser coords and p2 contains the greater coords.",
			},
		},
		Variables =
		{
			p1 =
			{
				Type = "{{Vector3i}}",
				Notes = "The first corner. Usually the lesser of the two coords in each set",
			},
			p2 =
			{
				Type = "{{Vector3i}}",
				Notes = "The second corner. Usually the larger of the two coords in each set",
			},
		},
	},
	cLineBlockTracer =
	{
		Desc = [[
This class provides an easy-to-use interface for tracing lines through individual
blocks in the world. It will call the provided callbacks according to what events it encounters along the
way.</p>
<p>
For the Lua API, there's only one static function exported that takes all the parameters necessary to do
the tracing. The Callbacks parameter is a table containing all the functions that will be called upon the
various events. See below for further information.
		]],
		Functions =
		{
			Trace =
			{
				IsStatic = true,
				Params =
				{
					{
						Name = "World",
						Type = "cWorld",
					},
					{
						Name = "Callbacks",
						Type = "table",
					},
					{
						Name = "StartX",
						Type = "number",
					},
					{
						Name = "StartY",
						Type = "number",
					},
					{
						Name = "StartZ",
						Type = "number",
					},
					{
						Name = "EndX",
						Type = "number",
					},
					{
						Name = "EndY",
						Type = "number",
					},
					{
						Name = "EndZ",
						Type = "number",
					},
				},
				Returns =
				{
					{
						Type = "boolean",
					},
				},
				Notes = "Performs the trace on the specified line. Returns true if the entire trace was processed (no callback returned true)",
			},
		},
		AdditionalInfo =
		{
			{
				Header = "Callbacks",
				Contents = [[
The Callbacks in the Trace() function is a table that contains named functions. Cuberite will call
individual functions from that table for the events that occur on the line - hitting a block, going out of
valid world data etc. The following table lists all the available callbacks. If the callback function is
not defined, Cuberite skips it. Each function can return a bool value, if it returns true, the tracing is
aborted and Trace() returns false.</p>
<p>
<table><tr><th>Name</th><th>Parameters</th><th>Notes</th></tr>
<tr><td>OnNextBlock</td><td>BlockX, BlockY, BlockZ, BlockType, BlockMeta, EntryFace</td>
	<td>Called when the ray hits a new valid block. The block type and meta is given. EntryFace is one of the
	BLOCK_FACE_ constants indicating which "side" of the block got hit by the ray.</td></tr>
<tr><td>OnNextBlockNoData</td><td>BlockX, BlockY, BlockZ, EntryFace</td>
	<td>Called when the ray hits a new block, but the block is in an unloaded chunk - no valid data is
	available. Only the coords and the entry face are given.</td></tr>
<tr><td>OnOutOfWorld</td><td>X, Y, Z</td>
	<td>Called when the ray goes outside of the world (Y-wise); the coords specify the exact exit point. Note
	that for other paths than lines (considered for future implementations) the path may leave the world and
	go back in again later, in such a case this callback is followed by OnIntoWorld() and further
	OnNextBlock() calls.</td></tr>
<tr><td>OnIntoWorld</td><td>X, Y, Z</td>
	<td>Called when the ray enters the world (Y-wise); the coords specify the exact entry point.</td></tr>
<tr><td>OnNoMoreHits</td><td>&nbsp;</td>
	<td>Called when the path is sure not to hit any more blocks. This is the final callback, no more
	callbacks are called after this function. Unlike the other callbacks, this function doesn't have a return
	value.</td></tr>
<tr><td>OnNoChunk</td><td>&nbsp;</td>
	<td>Called when the ray enters a chunk that is not loaded. This usually means that the tracing is aborted.
	Unlike the other callbacks, this function doesn't have a return value.</td></tr>
</table>
				]],
			},
			{
				Header = "Example",
				Contents = [[
<p>The following example is taken from the Debuggers plugin. It is a command handler function for the
"/spidey" command that creates a line of cobweb blocks from the player's eyes up to 50 blocks away in
the direction they're looking, but only through the air.
<pre class="prettyprint lang-lua">
function HandleSpideyCmd(a_Split, a_Player)
	local World = a_Player:GetWorld();

	local Callbacks = {
		OnNextBlock = function(a_BlockX, a_BlockY, a_BlockZ, a_BlockType, a_BlockMeta)
			if (a_BlockType ~= E_BLOCK_AIR) then
				-- abort the trace
				return true;
			end
			World:SetBlock(a_BlockX, a_BlockY, a_BlockZ, E_BLOCK_COBWEB, 0);
		end
	};

	local EyePos = a_Player:GetEyePosition();
	local LookVector = a_Player:GetLookVector();
	LookVector:Normalize();  -- Make the vector 1 m long

	-- Start cca 2 blocks away from the eyes
	local Start = EyePos + LookVector + LookVector;
	local End = EyePos + LookVector * 50;

	cLineBlockTracer.Trace(World, Callbacks, Start.x, Start.y, Start.z, End.x, End.y, End.z);

	return true;
end
</pre>
</p>
				]],
			},
		},
	},
	cTracer =
	{
		Desc = [[
			A cTracer object is used to trace lines in the world. One thing you can use the cTracer for, is
			tracing what block a player is looking at, but you can do more with it if you want.</p>
			<p>
			The cTracer is still a work in progress and is not documented at all.</p>
			<p>
			See also the {{cLineBlockTracer}} class for an alternative approach using callbacks.
		]],
		Functions =
		{

		},
	},
	Vector3d =
	{
		Desc = [[
			A Vector3d object uses double precision floating point values to describe a point in 3D space.</p>
			<p>
			See also {{Vector3f}} for single-precision floating point 3D coords and {{Vector3i}} for integer
			3D coords.
		]],
		Functions =
		{
			Abs =
			{
				Notes = "Updates each coord to its absolute value.",
			},
			abs =
			{
				Notes = "<b>OBSOLETE</b>, use Abs() instead.",
			},
			Clamp =
			{
				Params =
				{
					{
						Name = "min",
						Type = "number",
					},
					{
						Name = "max",
						Type = "number",
					},
				},
				Notes = "Clamps each coord into the specified range.",
			},
			clamp =
			{
				Params =
				{
					{
						Name = "min",
						Type = "number",
					},
					{
						Name = "max",
						Type = "number",
					},
				},
				Notes = "<b>OBSOLETE</b>, use Clamp() instead.",
			},
			constructor =
			{
				{
					Params =
					{
						{
							Name = "Vector",
							Type = "Vector3f",
						},
					},
					Returns =
					{
						{
							Type = "Vector3d",
						},
					},
					Notes = "Creates a new Vector3d object by copying the coords from the given Vector3f.",
				},
				{
					Returns =
					{
						{
							Type = "Vector3d",
						},
					},
					Notes = "Creates a new Vector3d object with all its coords set to 0.",
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
							Name = "Z",
							Type = "number",
						},
					},
					Returns =
					{
						{
							Type = "Vector3d",
						},
					},
					Notes = "Creates a new Vector3d object with its coords set to the specified values.",
				},
			},
			Cross =
			{
				Params =
				{
					{
						Name = "Other",
						Type = "Vector3d",
					},
				},
				Returns =
				{
					{
						Type = "Vector3d",
					},
				},
				Notes = "Returns a new Vector3d that is a {{http://en.wikipedia.org/wiki/Cross_product|cross product}} of this vector and the specified vector.",
			},
			Dot =
			{
				Params =
				{
					{
						Name = "Other",
						Type = "Vector3d",
					},
				},
				Returns =
				{
					{
						Type = "number",
					},
				},
				Notes = "Returns the dot product of this vector and the specified vector.",
			},
			Equals =
			{
				Params =
				{
					{
						Name = "AnotherVector",
						Type = "Vector3d",
					},
				},
				Returns =
				{
					{
						Type = "boolean",
					},
				},
				Notes = "Returns true if this vector is exactly equal to the specified vector. Note that this is subject to (possibly imprecise) floating point math.",
			},
			EqualsEps =
			{
				Params =
				{
					{
						Name = "AnotherVector",
						Type = "Vector3d",
					},
					{
						Name = "Eps",
						Type = "number",
					},
				},
				Returns =
				{
					{
						Type = "boolean",
					},
				},
				Notes = "Returns true if the differences between each corresponding coords of this vector and the one specified are less than the specified Eps.",
			},
			Floor =
			{
				Returns =
				{
					{
						Type = "Vector3i",
					},
				},
				Notes = "Returns a new {{Vector3i}} object with coords set to math.floor of this vector's coords.",
			},
			HasNonZeroLength =
			{
				Returns =
				{
					{
						Type = "boolean",
					},
				},
				Notes = "Returns true if the vector has at least one coord non-zero. Note that this is subject to (possibly imprecise) floating point math.",
			},
			Length =
			{
				Returns =
				{
					{
						Type = "number",
					},
				},
				Notes = "Returns the (euclidean) length of the vector.",
			},
			LineCoeffToXYPlane =
			{
				Params =
				{
					{
						Name = "Vector3d",
						Type = "Vector3d",
					},
					{
						Name = "Z",
						Type = "number",
					},
				},
				Returns =
				{
					{
						Type = "number",
					},
				},
				Notes = "Returns the coefficient for the line from the specified vector through this vector to reach the specified Z coord. The result satisfies the following equation: (this + Result * (Param - this)).z = Z. Returns the NO_INTERSECTION constant if there's no intersection.",
			},
			LineCoeffToXZPlane =
			{
				Params =
				{
					{
						Name = "Vector3d",
						Type = "Vector3d",
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
				Notes = "Returns the coefficient for the line from the specified vector through this vector to reach the specified Y coord. The result satisfies the following equation: (this + Result * (Param - this)).y = Y. Returns the NO_INTERSECTION constant if there's no intersection.",
			},
			LineCoeffToYZPlane =
			{
				Params =
				{
					{
						Name = "Vector3d",
						Type = "Vector3d",
					},
					{
						Name = "X",
						Type = "number",
					},
				},
				Returns =
				{
					{
						Type = "number",
					},
				},
				Notes = "Returns the coefficient for the line from the specified vector through this vector to reach the specified X coord. The result satisfies the following equation: (this + Result * (Param - this)).x = X. Returns the NO_INTERSECTION constant if there's no intersection.",
			},
			Move =
			{
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
					Notes = "Adds the specified offsets to each coord, effectively moving the vector by the specified coord offsets.",
				},
				{
					Params =
					{
						{
							Name = "Diff",
							Type = "Vector3d",
						},
					},
					Notes = "Adds the specified vector to this vector. Is slightly better performant than adding with a \"+\" because this doesn't create a new object for the result.",
				},
			},
			Normalize =
			{
				Notes = "Changes this vector so that it keeps current direction but is exactly 1 unit long. FIXME: Fails for a zero vector.",
			},
			NormalizeCopy =
			{
				Returns =
				{
					{
						Type = "Vector3d",
					},
				},
				Notes = "Returns a new vector that has the same direction as this but is exactly 1 unit long. FIXME: Fails for a zero vector.",
			},
			operator_div =
			{
				{
					Params =
					{
						{
							Name = "ParCoordDivisors",
							Type = "Vector3d",
						},
					},
					Returns =
					{
						{
							Type = "Vector3d",
						},
					},
					Notes = "Returns a new Vector3d object with each coord divided by the corresponding coord from the given vector.",
				},
				{
					Params =
					{
						{
							Name = "Divisor",
							Type = "number",
						},
					},
					Returns =
					{
						{
							Type = "Vector3d",
						},
					},
					Notes = "Returns a new Vector3d object with each coord divided by the specified number.",
				},
			},
			operator_mul =
			{
				{
					Params =
					{
						{
							Name = "PerCoordMultiplier",
							Type = "Vector3d",
						},
					},
					Returns =
					{
						{
							Type = "Vector3d",
						},
					},
					Notes = "Returns a new Vector3d object with each coord multiplied by the corresponding coord from the given vector.",
				},
				{
					Params =
					{
						{
							Name = "Multiplier",
							Type = "number",
						},
					},
					Returns =
					{
						{
							Type = "Vector3d",
						},
					},
					Notes = "Returns a new Vector3d object with each coord multiplied.",
				},
			},
			operator_plus =
			{
				Params =
				{
					{
						Name = "Addend",
						Type = "Vector3d",
					},
				},
				Returns =
				{
					{
						Type = "Vector3d",
					},
				},
				Notes = "Returns a new Vector3d containing the sum of this vector and the specified vector",
			},
			operator_sub =
			{
				{
					Params =
					{
						{
							Name = "Subtrahend",
							Type = "Vector3d",
						},
					},
					Returns =
					{
						{
							Type = "Vector3d",
						},
					},
					Notes = "Returns a new Vector3d object containing the difference between this object and the specified vector.",
				},
				{
					Returns =
					{
						{
							Type = "Vector3d",
						},
					},
					Notes = "Returns a new Vector3d object that is a negative of this vector (all coords multiplied by -1).",
				},
			},
			Set =
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
				Notes = "Sets all the coords in this object.",
			},
			SqrLength =
			{
				Returns =
				{
					{
						Type = "number",
					},
				},
				Notes = "Returns the (euclidean) length of this vector, squared. This operation is slightly less computationally expensive than Length(), while it conserves some properties of Length(), such as comparison. ",
			},
			TurnCCW =
			{
				Notes = "Rotates the vector 90 degrees counterclockwise around the vertical axis. Note that this is specific to minecraft's axis ordering, which is X+ left, Z+ down.",
			},
			TurnCW =
			{
				Notes = "Rotates the vector 90 degrees clockwise around the vertical axis. Note that this is specific to minecraft's axis ordering, which is X+ left, Z+ down.",
			},
		},
		Constants =
		{
			EPS =
			{
				Notes = "The max difference between two coords for which the coords are assumed equal (in LineCoeffToXYPlane() et al).",
			},
			NO_INTERSECTION =
			{
				Notes = "Special return value for the LineCoeffToXYPlane() et al meaning that there's no intersection with the plane.",
			},
		},
		Variables =
		{
			x =
			{
				Type = "number",
				Notes = "The X coord of the vector.",
			},
			y =
			{
				Type = "number",
				Notes = "The Y coord of the vector.",
			},
			z =
			{
				Type = "number",
				Notes = "The Z coord of the vector.",
			},
		},
	},
	Vector3f =
	{
		Desc = [[
			A Vector3f object uses floating point values to describe a point in space.</p>
			<p>
			See also {{Vector3d}} for double-precision floating point 3D coords and {{Vector3i}} for integer
			3D coords.
		]],
		Functions =
		{
			Abs =
			{
				Notes = "Updates each coord to its absolute value.",
			},
			abs =
			{
				Notes = "<b>OBSOLETE</b>, use Abs() instead.",
			},
			Clamp =
			{
				Params =
				{
					{
						Name = "min",
						Type = "number",
					},
					{
						Name = "max",
						Type = "number",
					},
				},
				Notes = "Clamps each coord into the specified range.",
			},
			clamp =
			{
				Params =
				{
					{
						Name = "min",
						Type = "number",
					},
					{
						Name = "max",
						Type = "number",
					},
				},
				Notes = "<b>OBSOLETE</b>, use Clamp() instead.",
			},
			constructor =
			{
				{
					Returns =
					{
						{
							Type = "Vector3f",
						},
					},
					Notes = "Creates a new Vector3f object with zero coords",
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
							Name = "z",
							Type = "number",
						},
					},
					Returns =
					{
						{
							Type = "Vector3f",
						},
					},
					Notes = "Creates a new Vector3f object with the specified coords",
				},
				{
					Params =
					{
						{
							Name = "Vector3f",
							Type = "Vector3f",
						},
					},
					Returns =
					{
						{
							Type = "Vector3f",
						},
					},
					Notes = "Creates a new Vector3f object as a copy of the specified vector",
				},
				{
					Params =
					{
						{
							Name = "Vector3d",
							Type = "Vector3d",
						},
					},
					Returns =
					{
						{
							Type = "Vector3f",
						},
					},
					Notes = "Creates a new Vector3f object as a copy of the specified {{Vector3d}}",
				},
				{
					Params =
					{
						{
							Name = "Vector3i",
							Type = "Vector3i",
						},
					},
					Returns =
					{
						{
							Type = "Vector3f",
						},
					},
					Notes = "Creates a new Vector3f object as a copy of the specified {{Vector3i}}",
				},
			},
			Cross =
			{
				Params =
				{
					{
						Name = "Other",
						Type = "Vector3f",
					},
				},
				Returns =
				{
					{
						Type = "Vector3f",
					},
				},
				Notes = "Returns a new Vector3f object that holds the cross product of this vector and the specified vector.",
			},
			Dot =
			{
				Params =
				{
					{
						Name = "Other",
						Type = "Vector3f",
					},
				},
				Returns =
				{
					{
						Type = "number",
					},
				},
				Notes = "Returns the dot product of this vector and the specified vector.",
			},
			Equals =
			{
				Params =
				{
					{
						Name = "Other",
						Type = "Vector3f",
					},
				},
				Returns =
				{
					{
						Type = "boolean",
					},
				},
				Notes = "Returns true if the specified vector is exactly equal to this vector. Note that this is subject to (possibly imprecise) floating point math.",
			},
			EqualsEps =
			{
				Params =
				{
					{
						Name = "Other",
						Type = "Vector3f",
					},
					{
						Name = "Eps",
						Type = "number",
					},
				},
				Returns =
				{
					{
						Type = "boolean",
					},
				},
				Notes = "Returns true if the differences between each corresponding coords of this vector and the one specified, are less than the specified Eps.",
			},
			Floor =
			{
				Returns =
				{
					{
						Type = "Vector3i",
					},
				},
				Notes = "Returns a new {{Vector3i}} object with coords set to math.floor of this vector's coords.",
			},
			HasNonZeroLength =
			{
				Returns =
				{
					{
						Type = "boolean",
					},
				},
				Notes = "Returns true if the vector has at least one coord non-zero. Note that this is subject to (possibly imprecise) floating point math.",
			},
			Length =
			{
				Returns =
				{
					{
						Type = "number",
					},
				},
				Notes = "Returns the (euclidean) length of this vector",
			},
			LineCoeffToXYPlane =
			{
				Params =
				{
					{
						Name = "Vector3f",
						Type = "Vector3f",
					},
					{
						Name = "Z",
						Type = "number",
					},
				},
				Returns =
				{
					{
						Type = "number",
					},
				},
				Notes = "Returns the coefficient for the line from the specified vector through this vector to reach the specified Z coord. The result satisfies the following equation: (this + Result * (Param - this)).z = Z. Returns the NO_INTERSECTION constant if there's no intersection.",
			},
			LineCoeffToXZPlane =
			{
				Params =
				{
					{
						Name = "Vector3f",
						Type = "Vector3f",
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
				Notes = "Returns the coefficient for the line from the specified vector through this vector to reach the specified Y coord. The result satisfies the following equation: (this + Result * (Param - this)).y = Y. Returns the NO_INTERSECTION constant if there's no intersection.",
			},
			LineCoeffToYZPlane =
			{
				Params =
				{
					{
						Name = "Vector3f",
						Type = "Vector3f",
					},
					{
						Name = "X",
						Type = "number",
					},
				},
				Returns =
				{
					{
						Type = "number",
					},
				},
				Notes = "Returns the coefficient for the line from the specified vector through this vector to reach the specified X coord. The result satisfies the following equation: (this + Result * (Param - this)).x = X. Returns the NO_INTERSECTION constant if there's no intersection.",
			},
			Move =
			{
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
					Notes = "Adds the specified offsets to each coord, effectively moving the vector by the specified coord offsets.",
				},
				{
					Params =
					{
						{
							Name = "Diff",
							Type = "Vector3f",
						},
					},
					Notes = "Adds the specified vector to this vector. Is slightly better performant than adding with a \"+\" because this doesn't create a new object for the result.",
				},
			},
			Normalize =
			{
				Notes = "Normalizes this vector (makes it 1 unit long while keeping the direction). FIXME: Fails for zero vectors.",
			},
			NormalizeCopy =
			{
				Returns =
				{
					{
						Type = "Vector3f",
					},
				},
				Notes = "Returns a copy of this vector that is normalized (1 unit long while keeping the same direction). FIXME: Fails for zero vectors.",
			},
			operator_div =
			{
				{
					Params =
					{
						{
							Name = "PerCoordDivisor",
							Type = "Vector3f",
						},
					},
					Returns =
					{
						{
							Type = "Vector3f",
						},
					},
					Notes = "Returns a new Vector3f object with each coord divided by the corresponding coord from the given vector.",
				},
				{
					Params =
					{
						{
							Name = "Divisor",
							Type = "number",
						},
					},
					Returns =
					{
						{
							Type = "Vector3f",
						},
					},
					Notes = "Returns a new Vector3f object with each coord divided by the specified number.",
				},
			},
			operator_mul =
			{
				{
					Params =
					{
						{
							Name = "PerCoordMultiplier",
							Type = "number",
						},
					},
					Returns =
					{
						{
							Type = "Vector3f",
						},
					},
					Notes = "Returns a new Vector3f object that has each of its coords multiplied by the specified number",
				},
				{
					Params =
					{
						{
							Name = "Multiplier",
							Type = "Vector3f",
						},
					},
					Returns =
					{
						{
							Type = "Vector3f",
						},
					},
					Notes = "Returns a new Vector3f object that has each of its coords multiplied by the respective coord of the specified vector.",
				},
			},
			operator_plus =
			{
				Params =
				{
					{
						Name = "Other",
						Type = "Vector3f",
					},
				},
				Returns =
				{
					{
						Type = "Vector3f",
					},
				},
				Notes = "Returns a new Vector3f object that holds the vector sum of this vector and the specified vector.",
			},
			operator_sub =
			{
				{
					Params =
					{
						{
							Name = "Subtrahend",
							Type = "Vector3f",
						},
					},
					Returns =
					{
						{
							Type = "Vector3f",
						},
					},
					Notes = "Returns a new Vector3f object that holds the vector differrence between this vector and the specified vector.",
				},
				{
					Returns =
					{
						{
							Type = "Vector3f",
						},
					},
					Notes = "Returns a new Vector3f that is a negative of this vector (all coords multiplied by -1).",
				},
			},
			Set =
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
						Name = "z",
						Type = "number",
					},
				},
				Notes = "Sets all the coords of the vector at once.",
			},
			SqrLength =
			{
				Returns =
				{
					{
						Type = "number",
					},
				},
				Notes = "Returns the (euclidean) length of this vector, squared. This operation is slightly less computationally expensive than Length(), while it conserves some properties of Length(), such as comparison.",
			},
			TurnCCW =
			{
				Notes = "Rotates the vector 90 degrees counterclockwise around the vertical axis. Note that this is specific to minecraft's axis ordering, which is X+ left, Z+ down.",
			},
			TurnCW =
			{
				Notes = "Rotates the vector 90 degrees clockwise around the vertical axis. Note that this is specific to minecraft's axis ordering, which is X+ left, Z+ down.",
			},
		},
		Constants =
		{
			EPS =
			{
				Notes = "The max difference between two coords for which the coords are assumed equal (in LineCoeffToXYPlane() et al).",
			},
			NO_INTERSECTION =
			{
				Notes = "Special return value for the LineCoeffToXYPlane() et al meaning that there's no intersection with the plane.",
			},
		},
		Variables =
		{
			x =
			{
				Type = "number",
				Notes = "The X coord of the vector.",
			},
			y =
			{
				Type = "number",
				Notes = "The Y coord of the vector.",
			},
			z =
			{
				Type = "number",
				Notes = "The Z coord of the vector.",
			},
		},
	},
	Vector3i =
	{
		Desc = [[
			A Vector3i object uses integer values to describe a point in space.</p>
			<p>
			See also {{Vector3d}} for double-precision floating point 3D coords and {{Vector3f}} for
			single-precision floating point 3D coords.
		]],
		Functions =
		{
			Abs =
			{
				Notes = "Updates each coord to its absolute value.",
			},
			abs =
			{
				Notes = "<b>OBSOLETE</b>, use Abs() instead.",
			},
			Clamp =
			{
				Params =
				{
					{
						Name = "min",
						Type = "number",
					},
					{
						Name = "max",
						Type = "number",
					},
				},
				Notes = "Clamps each coord into the specified range.",
			},
			clamp =
			{
				Params =
				{
					{
						Name = "min",
						Type = "number",
					},
					{
						Name = "max",
						Type = "number",
					},
				},
				Notes = "<b>OBSOLETE</b>, use Clamp() instead.",
			},
			constructor =
			{
				{
					Returns =
					{
						{
							Type = "Vector3i",
						},
					},
					Notes = "Creates a new Vector3i object with zero coords.",
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
							Name = "z",
							Type = "number",
						},
					},
					Returns =
					{
						{
							Type = "Vector3i",
						},
					},
					Notes = "Creates a new Vector3i object with the specified coords.",
				},
				{
					Params =
					{
						{
							Name = "Vector3d",
							Type = "Vector3d",
						},
					},
					Returns =
					{
						{
							Type = "Vector3i",
						},
					},
					Notes = "Creates a new Vector3i object with coords copied and floor()-ed from the specified {{Vector3d}}.",
				},
			},
			Cross =
			{
				Params =
				{
					{
						Name = "Other",
						Type = "Vector3d",
					},
				},
				Returns =
				{
					{
						Type = "Vector3d",
					},
				},
				Notes = "Returns a new Vector3d that is a {{http://en.wikipedia.org/wiki/Cross_product|cross product}} of this vector and the specified vector.",
			},
			Dot =
			{
				Params =
				{
					{
						Name = "Other",
						Type = "Vector3d",
					},
				},
				Returns =
				{
					{
						Type = "number",
					},
				},
				Notes = "Returns the dot product of this vector and the specified vector.",
			},
			Equals =
			{
				Params =
				{
					{
						Name = "Other",
						Type = "Vector3i",
					},
				},
				Returns =
				{
					{
						Type = "boolean",
					},
				},
				Notes = "Returns true if this vector is exactly the same as the specified vector.",
			},
			EqualsEps =
			{
				Params =
				{
					{
						Name = "Other",
						Type = "Vector3i",
					},
					{
						Name = "Eps",
						Type = "number",
					},
				},
				Returns =
				{
					{
						Type = "boolean",
					},
				},
				Notes = "Returns true if the differences between each corresponding coords of this vector and the one specified, are less than the specified Eps. Normally not too useful for integer-only vectors, but still included for API completeness.",
			},
			Floor =
			{
				Returns =
				{
					{
						Type = "Vector3i",
					},
				},
				Notes = "Returns a new {{Vector3i}} object with coords set to math.floor of this vector's coords. Normally not too useful with integer-only vectors, but still included for API completeness.",
			},
			HasNonZeroLength =
			{
				Returns =
				{
					{
						Type = "boolean",
					},
				},
				Notes = "Returns true if the vector has at least one coord non-zero.",
			},
			Length =
			{
				Returns =
				{
					{
						Type = "number",
					},
				},
				Notes = "Returns the (euclidean) length of this vector.",
			},
			LineCoeffToXYPlane =
			{
				Params =
				{
					{
						Name = "Vector3i",
						Type = "Vector3i",
					},
					{
						Name = "Z",
						Type = "number",
					},
				},
				Returns =
				{
					{
						Type = "number",
					},
				},
				Notes = "Returns the coefficient for the line from the specified vector through this vector to reach the specified Z coord. The result satisfies the following equation: (this + Result * (Param - this)).z = Z. Returns the NO_INTERSECTION constant if there's no intersection.",
			},
			LineCoeffToXZPlane =
			{
				Params =
				{
					{
						Name = "Vector3i",
						Type = "Vector3i",
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
				Notes = "Returns the coefficient for the line from the specified vector through this vector to reach the specified Y coord. The result satisfies the following equation: (this + Result * (Param - this)).y = Y. Returns the NO_INTERSECTION constant if there's no intersection.",
			},
			LineCoeffToYZPlane =
			{
				Params =
				{
					{
						Name = "Vector3i",
						Type = "Vector3i",
					},
					{
						Name = "X",
						Type = "number",
					},
				},
				Returns =
				{
					{
						Type = "number",
					},
				},
				Notes = "Returns the coefficient for the line from the specified vector through this vector to reach the specified X coord. The result satisfies the following equation: (this + Result * (Param - this)).x = X. Returns the NO_INTERSECTION constant if there's no intersection.",
			},
			Move =
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
							Name = "z",
							Type = "number",
						},
					},
					Notes = "Moves the vector by the specified amount in each axis direction.",
				},
				{
					Params =
					{
						{
							Name = "Diff",
							Type = "Vector3i",
						},
					},
					Notes = "Adds the specified vector to this vector. Is slightly better performant than adding with a \"+\" because this doesn't create a new object for the result.",
				},
			},
			Normalize =
			{
				Notes = "Normalizes this vector (makes it 1 unit long while keeping the direction). Quite useless for integer-only vectors, since the normalized vector will almost always truncate to zero vector. FIXME: Fails for zero vectors.",
			},
			NormalizeCopy =
			{
				Returns =
				{
					{
						Type = "Vector3f",
					},
				},
				Notes = "Returns a copy of this vector that is normalized (1 unit long while keeping the same direction). Quite useless for integer-only vectors, since the normalized vector will almost always truncate to zero vector. FIXME: Fails for zero vectors.",
			},
			operator_div =
			{
				{
					Params =
					{
						{
							Name = "Divisor",
							Type = "number",
						},
					},
					Returns =
					{
						{
							Type = "Vector3i",
						},
					},
					Notes = "Returns a new Vector3i object that has each of its coords divided by the specified number",
				},
				{
					Params =
					{
						{
							Name = "PerCoordDivisors",
							Type = "Vector3i",
						},
					},
					Returns =
					{
						{
							Type = "Vector3i",
						},
					},
					Notes = "Returns a new Vector3i object that has each of its coords divided by the respective coord of the specified vector.",
				},
			},
			operator_mul =
			{
				{
					Params =
					{
						{
							Name = "Multiplier",
							Type = "number",
						},
					},
					Returns =
					{
						{
							Type = "Vector3i",
						},
					},
					Notes = "Returns a new Vector3i object that has each of its coords multiplied by the specified number",
				},
				{
					Params =
					{
						{
							Name = "PerCoordMultipliers",
							Type = "Vector3i",
						},
					},
					Returns =
					{
						{
							Type = "Vector3i",
						},
					},
					Notes = "Returns a new Vector3i object that has each of its coords multiplied by the respective coord of the specified vector.",
				},
			},
			operator_plus =
			{
				Params =
				{
					{
						Name = "Addend",
						Type = "Vector3i",
					},
				},
				Returns =
				{
					{
						Type = "Vector3i",
					},
				},
				Notes = "Returns a new Vector3f object that holds the vector sum of this vector and the specified vector.",
			},
			operator_sub =
			{
				{
					Params =
					{
						{
							Name = "Subtrahend",
							Type = "Vector3i",
						},
					},
					Returns =
					{
						{
							Type = "Vector3i",
						},
					},
					Notes = "Returns a new Vector3i object that holds the vector differrence between this vector and the specified vector.",
				},
				{
					Returns =
					{
						{
							Type = "Vector3i",
						},
					},
					Notes = "Returns a new Vector3i that is a negative of this vector (all coords multiplied by -1).",
				},
			},
			Set =
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
						Name = "z",
						Type = "number",
					},
				},
				Notes = "Sets all the coords of the vector at once",
			},
			SqrLength =
			{
				Returns =
				{
					{
						Type = "number",
					},
				},
				Notes = "Returns the (euclidean) length of this vector, squared. This operation is slightly less computationally expensive than Length(), while it conserves some properties of Length(), such as comparison.",
			},
			TurnCCW =
			{
				Notes = "Rotates the vector 90 degrees counterclockwise around the vertical axis. Note that this is specific to minecraft's axis ordering, which is X+ left, Z+ down.",
			},
			TurnCW =
			{
				Notes = "Rotates the vector 90 degrees clockwise around the vertical axis. Note that this is specific to minecraft's axis ordering, which is X+ left, Z+ down.",
			},
		},
		Constants =
		{
			EPS =
			{
				Notes = "The max difference between two coords for which the coords are assumed equal (in LineCoeffToXYPlane() et al). Quite useless with integer-only vector.",
			},
			NO_INTERSECTION =
			{
				Notes = "Special return value for the LineCoeffToXYPlane() et al meaning that there's no intersection with the plane.",
			},
		},
		Variables =
		{
			x =
			{
				Type = "number",
				Notes = "The X coord of the vector.",
			},
			y =
			{
				Type = "number",
				Notes = "The Y coord of the vector.",
			},
			z =
			{
				Type = "number",
				Notes = "The Z coord of the vector.",
			},
		},
	},
}
