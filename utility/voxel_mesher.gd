class_name VoxelMesher
extends RefCounted

func new_quad() -> Array:
	var arrays : Array = []
	arrays.resize(Mesh.ARRAY_MAX)
	
	var vertices = PackedVector3Array()
	vertices.push_back(Vector3(-1, 0, -1))
	vertices.push_back(Vector3(-1, 0, 1))
	vertices.push_back(Vector3(1, 0, -1))
	vertices.push_back(Vector3(1, 0, 1))
	
	#	0	2
	#	1	3
	#
	#
	
	var indices = PackedInt32Array()
	indices.push_back(0)
	indices.push_back(2)
	indices.push_back(1)
	
	indices.push_back(2)
	indices.push_back(3)
	indices.push_back(1)
	
	var uvs = PackedVector2Array()
	uvs.push_back(Vector2(0, 0))
	uvs.push_back(Vector2(0, 1))
	uvs.push_back(Vector2(1, 0))
	uvs.push_back(Vector2(1, 1))
	
	arrays[Mesh.ARRAY_VERTEX] = vertices
	arrays[Mesh.ARRAY_TEX_UV] = uvs
	arrays[Mesh.ARRAY_INDEX] = indices
	
	return arrays

## Generates a mesh from chunk data
func generate_chunk_mesh(_chunkData) -> ArrayMesh:
	var newMesh = ArrayMesh.new()
	
	var array = new_quad()
	newMesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, array)
	
	return newMesh
