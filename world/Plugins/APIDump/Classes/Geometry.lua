
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
			constructor =
			{
				{ Params = "MinX, MaxX, MinY, MaxY, MinZ, MaxZ", Return = "cBoundingBox", Notes = "Creates a new bounding box with the specified edges" },
				{ Params = "{{Vector3d|Min}}, {{Vector3d|Max}}", Return = "cBoundingBox", Notes = "Creates a new bounding box with the coords specified as two vectors" },
				{ Params = "{{Vector3d|Pos}}, Radius, Height", Return = "cBoundingBox", Notes = "Creates a new bounding box from the position given and radius (X/Z) and height. Radius is added from X/Z to calculate the maximum coords and subtracted from X/Z to get the minimum; minimum Y is set to Pos.y and maxumim Y to Pos.y plus Height. This corresponds with how {{cEntity|entities}} are represented in Minecraft." },
				{ Params = "OtherBoundingBox", Return = "cBoundingBox", Notes = "Creates a new copy of the given bounding box. Same result can be achieved by using a simple assignment." },
			},
			CalcLineIntersection = { Params = "{{Vector3d|LineStart}}, {{Vector3d|LinePt2}}", Return = "DoesIntersect, LineCoeff, Face", Notes = "Calculates the intersection of a ray (half-line), given by two of its points, with the bounding box. Returns false if the line doesn't intersect the bounding box, or true, together with coefficient of the intersection (how much of the difference between the two ray points is needed to reach the intersection), and the face of the box which is intersected.<br /><b>TODO</b>: Lua binding for this function is wrong atm." },
			DoesIntersect = { Params = "OtherBoundingBox", Return = "bool", Notes = "Returns true if the two bounding boxes have an intersection of nonzero volume." },
			Expand = { Params = "ExpandX, ExpandY, ExpandZ", Return = "", Notes = "Expands this bounding box by the specified amount in each direction (so the box becomes larger by 2 * Expand in each axis)." },
			IsInside =
			{
				{ Params = "{{Vector3d|Point}}", Return = "bool", Notes = "Returns true if the specified point is inside (including on the edge) of the box." },
				{ Params = "PointX, PointY, PointZ", Return = "bool", Notes = "Returns true if the specified point is inside (including on the edge) of the box." },
				{ Params = "OtherBoundingBox", Return = "bool", Notes = "Returns true if OtherBoundingBox is inside of this box." },
				{ Params = "{{Vector3d|OtherBoxMin}}, {{Vector3d|OtherBoxMax}}", Return = "bool", Notes = "Returns true if the other bounding box, specified by its 2 corners, is inside of this box." },
			},
			Move =
			{
				{ Params = "OffsetX, OffsetY, OffsetZ", Return = "", Notes = "Moves the bounding box by the specified offset in each axis" },
				{ Params = "{{Vector3d|Offset}}", Return = "", Notes = "Moves the bounding box by the specified offset in each axis" },
			},
			Union = { Params = "OtherBoundingBox", Return = "cBoundingBox", Notes = "Returns the smallest bounding box that contains both OtherBoundingBox and this bounding box. Note that unlike the strict geometrical meaning of \"union\", this operation actually returns a cBoundingBox." },
		},
	},  -- cBoundingBox


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
			constructor =
			{
				{ Params = "", Return = "cCuboid", Notes = "Creates a new Cuboid object with all-zero coords" },
				{ Params = "OtherCuboid", Return = "cCuboid", Notes = "Creates a new Cuboid object as a copy of OtherCuboid" },
				{ Params = "{{Vector3i|Point1}}, {{Vector3i|Point2}}", Return = "cCuboid", Notes = "Creates a new Cuboid object with the specified points as its corners." },
				{ Params = "X, Y, Z", Return = "cCuboid", Notes = "Creates a new Cuboid object with the specified point as both its corners (the cuboid has a size of 1 in each direction)." },
				{ Params = "X1, Y1, Z1, X2, Y2, Z2", Return = "cCuboid", Notes = "Creates a new Cuboid object with the specified points as its corners." },
			},
			Assign =
			{
				{ Params = "SrcCuboid", Return = "", Notes = "Copies all the coords from the src cuboid to this cuboid. Sort-state is ignored." },
				{ Params = "X1, Y1, Z1, X2, Y2, Z2", Return = "", Notes = "Assigns all the coords to the specified values. Sort-state is ignored." },
			},
			ClampX = { Params = "MinX, MaxX", Return = "", Notes = "Clamps both X coords into the range provided. Sortedness-agnostic." },
			ClampY = { Params = "MinY, MaxY", Return = "", Notes = "Clamps both Y coords into the range provided. Sortedness-agnostic." },
			ClampZ = { Params = "MinZ, MaxZ", Return = "", Notes = "Clamps both Z coords into the range provided. Sortedness-agnostic." },
			DifX = { Params = "", Return = "number", Notes = "Returns the difference between the two X coords (X-size minus 1). Assumes sorted." },
			DifY = { Params = "", Return = "number", Notes = "Returns the difference between the two Y coords (Y-size minus 1). Assumes sorted." },
			DifZ = { Params = "", Return = "number", Notes = "Returns the difference between the two Z coords (Z-size minus 1). Assumes sorted." },
			DoesIntersect = { Params = "OtherCuboid", Return = "bool", Notes = "Returns true if this cuboid has at least one voxel in common with OtherCuboid. Note that edges are considered inclusive. Assumes both sorted." },
			Engulf = { Params = "{{Vector3i|Point}}", Return = "", Notes = "If needed, expands the cuboid to include the specified point. Doesn't shrink. Assumes sorted. " },
			Expand = { Params = "SubMinX, AddMaxX, SubMinY, AddMaxY, SubMinZ, AddMaxZ", Return = "", Notes = "Expands the cuboid by the specified amount in each direction. Works on unsorted cuboids as well. NOTE: this function doesn't check for underflows." },
			GetVolume = { Params = "", Return = "number", Notes = "Returns the volume of the cuboid, in blocks. Note that the volume considers both coords inclusive. Works on unsorted cuboids, too." },
			IsCompletelyInside = { Params = "OuterCuboid", Return = "bool", Notes = "Returns true if this cuboid is completely inside (in all directions) in OuterCuboid. Assumes both sorted." },
			IsInside =
			{
				{ Params = "X, Y, Z", Return = "bool", Notes = "Returns true if the specified point (integral coords) is inside this cuboid. Assumes sorted." },
				{ Params = "{{Vector3i|Point}}", Return = "bool", Notes = "Returns true if the specified point (integral coords) is inside this cuboid. Assumes sorted." },
				{ Params = "{{Vector3d|Point}}", Return = "bool", Notes = "Returns true if the specified point (floating-point coords) is inside this cuboid. Assumes sorted." },
			},
			IsSorted = { Params = "", Return = "bool", Notes = "Returns true if this cuboid is sorted" },
			Move = { Params = "OffsetX, OffsetY, OffsetZ", Return = "", Notes = "Adds the specified offsets to each respective coord, effectively moving the Cuboid. Sort-state is ignored and preserved." },
			Sort = { Params = "", Return = "" , Notes = "Sorts the internal representation so that p1 contains the lesser coords and p2 contains the greater coords." },
		},
		Variables =
		{
			p1 = { Type = "{{Vector3i}}", Notes = "The first corner. Usually the lesser of the two coords in each set" },
			p2 = { Type = "{{Vector3i}}", Notes = "The second corner. Usually the larger of the two coords in each set" },
		},
	},  -- cCuboid


	cLineBlockTracer =
	{
		Desc = [[This class provides an easy-to-use interface for tracing lines through individual
blocks in the world. It will call the provided callbacks according to what events it encounters along the
way.</p>
<p>
For the Lua API, there's only one static function exported that takes all the parameters necessary to do
the tracing. The Callbacks parameter is a table containing all the functions that will be called upon the
various events. See below for further information.
		]],
		Functions =
		{
			Trace = { Params = "{{cWorld}}, Callbacks, StartX, StartY, StartZ, EndX, EndY, EndZ", Return = "bool", Notes = "(STATIC) Performs the trace on the specified line. Returns true if the entire trace was processed (no callback returned true)" },
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
		},  -- AdditionalInfo
	},  -- cLineBlockTracer


	cTracer =
	{
		Desc = [[
			A cTracer object is used to trace lines in the world. One thing you can use the cTracer for, is
			tracing what block a player is looking at, but you can do more with it if you want.</p>
			<p>
			The cTracer is still a work in progress.</p>
			<p>
			See also the {{cLineBlockTracer}} class for an alternative approach using callbacks.
		]],
		Functions =
		{
		},
	},  -- cTracer


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
			constructor =
			{
				{ Params = "{{Vector3f}}", Return = "Vector3d", Notes = "Creates a new Vector3d object by copying the coords from the given Vector3f." },
				{ Params = "", Return = "Vector3d", Notes = "Creates a new Vector3d object with all its coords set to 0." },
				{ Params = "X, Y, Z", Return = "Vector3d", Notes = "Creates a new Vector3d object with its coords set to the specified values." },
			},
			operator_div = { Params = "number", Return = "Vector3d", Notes = "Returns a new Vector3d with each coord divided by the specified number." },
			operator_mul = { Params = "number", Return = "Vector3d", Notes = "Returns a new Vector3d with each coord multiplied." },
			operator_sub = { Params = "Vector3d", Return = "Vector3d", Notes = "Returns a new Vector3d containing the difference between this object and the specified vector." },
			operator_plus = {Params = "Vector3d", Return = "Vector3d", Notes = "Returns a new Vector3d containing the sum of this vector and the specified vector" },
			Cross = { Params = "Vector3d", Return = "Vector3d", Notes = "Returns a new Vector3d that is a {{http://en.wikipedia.org/wiki/Cross_product|cross product}} of this vector and the specified vector." },
			Dot = { Params = "Vector3d", Return = "number", Notes = "Returns the dot product of this vector and the specified vector." },
			Equals = { Params = "Vector3d", Return = "bool", Notes = "Returns true if this vector is exactly equal to the specified vector." },
			Length = { Params = "", Return = "number", Notes = "Returns the (euclidean) length of the vector." },
			LineCoeffToXYPlane = { Params = "Vector3d, Z", Return = "number", Notes = "Returns the coefficient for the line from the specified vector through this vector to reach the specified Z coord. The result satisfies the following equation: (this + Result * (Param - this)).z = Z. Returns the NO_INTERSECTION constant if there's no intersection." },
			LineCoeffToXZPlane = { Params = "Vector3d, Y", Return = "number", Notes = "Returns the coefficient for the line from the specified vector through this vector to reach the specified Y coord. The result satisfies the following equation: (this + Result * (Param - this)).y = Y. Returns the NO_INTERSECTION constant if there's no intersection." },
			LineCoeffToYZPlane = { Params = "Vector3d, X", Return = "number", Notes = "Returns the coefficient for the line from the specified vector through this vector to reach the specified X coord. The result satisfies the following equation: (this + Result * (Param - this)).x = X. Returns the NO_INTERSECTION constant if there's no intersection." },
			Normalize = { Params = "", Return = "", Notes = "Changes this vector so that it keeps current direction but is exactly 1 unit long. FIXME: Fails for a zero vector." },
			NormalizeCopy = { Params = "", Return = "Vector3d", Notes = "Returns a new vector that has the same directino as this but is exactly 1 unit long. FIXME: Fails for a zero vector." },
			Set = { Params = "X, Y, Z", Return = "", Notes = "Sets all the coords in this object." },
			SqrLength = { Params = "", Return = "number", Notes = "Returns the (euclidean) length of this vector, squared. This operation is slightly less computationally expensive than Length(), while it conserves some properties of Length(), such as comparison. " },
		},
		Constants =
		{
			EPS = { Notes = "The max difference between two coords for which the coords are assumed equal (in LineCoeffToXYPlane() et al)." },
			NO_INTERSECTION = { Notes = "Special return value for the LineCoeffToXYPlane() et al meaning that there's no intersectino with the plane." },
		},
		Variables =
		{
			x = { Type = "number", Notes = "The X coord of the vector." },
			y = { Type = "number", Notes = "The Y coord of the vector." },
			z = { Type = "number", Notes = "The Z coord of the vector." },
		},
	},  -- Vector3d

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
			constructor =
			{
				{ Params = "", Return = "Vector3f", Notes = "Creates a new Vector3f object with zero coords" },
				{ Params = "x, y, z", Return = "Vector3f", Notes = "Creates a new Vector3f object with the specified coords" },
				{ Params = "Vector3f", Return = "Vector3f", Notes = "Creates a new Vector3f object as a copy of the specified vector" },
				{ Params = "{{Vector3d}}", Return = "Vector3f", Notes = "Creates a new Vector3f object as a copy of the specified {{Vector3d}}" },
				{ Params = "{{Vector3i}}", Return = "Vector3f", Notes = "Creates a new Vector3f object as a copy of the specified {{Vector3i}}" },
			},
			operator_mul =
			{
				{ Params = "number", Return = "Vector3f", Notes = "Returns a new Vector3f object that has each of its coords multiplied by the specified number" },
				{ Params = "Vector3f", Return = "Vector3f", Notes = "Returns a new Vector3f object that has each of its coords multiplied by the respective coord of the specified vector." },
			},
			operator_plus = { Params = "Vector3f", Return = "Vector3f", Notes = "Returns a new Vector3f object that holds the vector sum of this vector and the specified vector." },
			operator_sub = { Params = "Vector3f", Return = "Vector3f", Notes = "Returns a new Vector3f object that holds the vector differrence between this vector and the specified vector." },
			Cross = { Params = "Vector3f", Return = "Vector3f", Notes = "Returns a new Vector3f object that holds the cross product of this vector and the specified vector." },
			Dot = { Params = "Vector3f", Return = "number", Notes = "Returns the dot product of this vector and the specified vector." },
			Equals = { Params = "Vector3f", Return = "bool", Notes = "Returns true if the specified vector is exactly equal to this vector." },
			Length = { Params = "", Return = "number", Notes = "Returns the (euclidean) length of this vector" },
			Normalize = { Params = "", Return = "", Notes = "Normalizes this vector (makes it 1 unit long while keeping the direction). FIXME: Fails for zero vectors." },
			NormalizeCopy = { Params = "", Return = "Vector3f", Notes = "Returns a copy of this vector that is normalized (1 unit long while keeping the same direction). FIXME: Fails for zero vectors." },
			Set = { Params = "x, y, z", Return = "", Notes = "Sets all the coords of the vector at once." },
			SqrLength = { Params = "", Return = "number", Notes = "Returns the (euclidean) length of this vector, squared. This operation is slightly less computationally expensive than Length(), while it conserves some properties of Length(), such as comparison." },
		},
		Variables =
		{
			x = { Type = "number", Notes = "The X coord of the vector." },
			y = { Type = "number", Notes = "The Y coord of the vector." },
			z = { Type = "number", Notes = "The Z coord of the vector." },
		},
	},  -- Vector3f

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
			constructor =
			{
				{ Params = "", Return = "Vector3i", Notes = "Creates a new Vector3i object with zero coords." },
				{ Params = "x, y, z", Return = "Vector3i", Notes = "Creates a new Vector3i object with the specified coords." },
				{ Params = "{{Vector3d}}", Return = "Vector3i", Notes = "Creates a new Vector3i object with coords copied and floor()-ed from the specified {{Vector3d}}." },
			},
			Equals = { Params = "Vector3i", Return = "bool", Notes = "Returns true if this vector is exactly the same as the specified vector." },
			Length = { Params = "", Return = "number", Notes = "Returns the (euclidean) length of this vector." },
			Move = { Params = "X, Y, Z", Return = "", Notes = "Moves the vector by the specified amount in each axis direction." },
			Set = { Params = "x, y, z", Return = "", Notes = "Sets all the coords of the vector at once" },
			SqrLength = { Params = "", Return = "number", Notes = "Returns the (euclidean) length of this vector, squared. This operation is slightly less computationally expensive than Length(), while it conserves some properties of Length(), such as comparison." },
		},
		Variables =
		{
			x = { Type = "number", Notes = "The X coord of the vector." },
			y = { Type = "number", Notes = "The Y coord of the vector." },
			z = { Type = "number", Notes = "The Z coord of the vector." },
		},
	},  -- Vector3i
}




