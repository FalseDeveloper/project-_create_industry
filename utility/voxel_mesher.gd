## Creates the mesh data for a chunk's decorative voxels.
class_name VoxelMesher
extends RefCounted

#TODO: Greedy meshing, how scary.

class ChunkMeshResult:
	var mesh_instance_to_voxel : Dictionary[Types.VoxelSurface, VoxelInstance]
	var mesh_instances : Array[Types.VoxelSurface]
	var vertices : PackedVector3Array

## Generates a quad face's vertices, intended for collision.
func generate_face(center : Vector3, dir : Vector3) -> PackedVector3Array:
	var vertices = PackedVector3Array()
	
	var arbitrary_vector = Vector3.UP if abs(dir.y) != 1 else Vector3.FORWARD
	
	var perpendicular_u = dir.cross(arbitrary_vector).normalized()
	var perpendicular_v = perpendicular_u.cross(dir).normalized()
	
	var half_size = 0.5
	
	var vertex0 = (center - (half_size * perpendicular_u) + (half_size * perpendicular_v))
	var vertex1 = (center - (half_size * perpendicular_u) - (half_size * perpendicular_v))
	var vertex2 = (center + (half_size * perpendicular_u) + (half_size * perpendicular_v))
	var vertex3 = (center + (half_size * perpendicular_u) - (half_size * perpendicular_v))
	
	#	0	2
	#	1	3
	
	# Create tris
	vertices.append_array([
		vertex0, vertex1, vertex2,
		vertex2, vertex1, vertex3
	])
	
	return vertices

## Generates a multi-mesh and a collider from chunk data
func generate_chunk_multimesh(chunk_data : ChunkData, world : GameWorld) -> ChunkMeshResult:
	var result := ChunkMeshResult.new()
	
	result.mesh_instances = []
	result.mesh_instance_to_voxel = {}
	result.vertices = PackedVector3Array()
	
	for pos in chunk_data.voxels:
		var current_voxel := chunk_data.voxels[pos]
		if not current_voxel.data is DecorativeVoxelData:
			continue
		
		for direction in Utils.AXIS_DIRECTIONS.values():
			if world.is_voxel_solid(chunk_data.chunk_to_grid_position(pos + Vector3i(direction))) == true:
				continue
			
			var center : Vector3 = Vector3(pos) + direction/2
			var surface := Types.VoxelSurface.new(pos, Vector3i(direction))
			
			result.mesh_instances.append(surface)
			result.mesh_instance_to_voxel.set(surface, chunk_data.voxels[pos])
			
			var quad_vertices = generate_face(center, direction)
			result.vertices.append_array(quad_vertices)
			
	
	return result
	
