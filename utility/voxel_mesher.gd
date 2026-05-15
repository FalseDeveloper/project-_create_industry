class_name VoxelMesher
extends RefCounted

func generate_face(center : Vector3, dir : Vector3) -> PackedVector3Array:
	var vertices = PackedVector3Array()
	
	var arbitrary_vector = Vector3.UP if abs(dir.y) != 1 else Vector3.FORWARD
	
	var perpendicular_u = arbitrary_vector.cross(dir).normalized()
	var perpendicular_v = dir.cross(perpendicular_u)
	
	var half_size = 0.5
	
	vertices.append(center - (half_size * perpendicular_u) + (half_size * perpendicular_v))
	vertices.append(center - (half_size * perpendicular_u) - (half_size * perpendicular_v))
	vertices.append(center + (half_size * perpendicular_u) + (half_size * perpendicular_v))
	vertices.append(center + (half_size * perpendicular_u) - (half_size * perpendicular_v))
	
	return vertices

func new_quad(position : Vector3, direction : Vector3) -> Array:
	var arrays : Array = []
	arrays.resize(Mesh.ARRAY_MAX)
	
	var vertices = generate_face(position, direction)
	
	#   	L   R
	#	U	0	2
	#	D	1	3
	
	var indices = PackedInt32Array()
	if direction.length() == 1:
		indices.append(0)
		indices.append(2)
		indices.append(1)
		
		indices.append(2)
		indices.append(3)
		indices.append(1)
	else:
		indices.append(1)
		indices.append(2)
		indices.append(0)
		
		indices.append(1)
		indices.append(3)
		indices.append(2)
	
	var uvs = PackedVector2Array()
	uvs.append(Vector2(0, 0))
	uvs.append(Vector2(0, 1))
	uvs.append(Vector2(1, 0))
	uvs.append(Vector2(1, 1))
	
	arrays[Mesh.ARRAY_VERTEX] = vertices
	arrays[Mesh.ARRAY_TEX_UV] = uvs
	arrays[Mesh.ARRAY_INDEX] = indices
	
	return arrays

## Generates a mesh from chunk data
func generate_chunk_mesh(chunkData : ChunkData) -> ArrayMesh:
	var newMesh = ArrayMesh.new()
	
	#TODO: Greedy meshing,, scawyyy
	var _quadsToRender : Dictionary[Vector3, Vector3] = {}
	
	for pos in chunkData.voxels:
		for direction in Utils.AXIS_DIRECTIONS.values():
			if chunkData.voxels.get(pos + Vector3i(direction)) != null:
				continue
			
			var quadArrays = new_quad(Vector3(pos) + direction/2, direction)
			
			newMesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, quadArrays)
			
	
	return newMesh

func generate_chunk_multimesh(chunkData : ChunkData) -> Dictionary[Vector3, Vector3]:
	var instances : Dictionary[Vector3, Vector3] = {}
	
	for pos in chunkData.voxels:
		for direction in Utils.AXIS_DIRECTIONS.values():
			if chunkData.voxels.get(pos + Vector3i(direction)) != null:
				continue
			
			instances[Vector3(pos) + direction/2] = direction
			
	
	return instances
	
