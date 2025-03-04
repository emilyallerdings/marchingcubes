extends Node3D
class_name Terrain

@export var noise:FastNoiseLite
@onready var player: Camera3D = %Camera3D

var timer:float = 0

var loaded_chunks:Dictionary[Vector3,MeshInstance3D] = {}

var cur_chunk:Vector3
var prev_chunk:Vector3

func _ready() -> void:
	
	cur_chunk = get_chunk_at_pos(player.global_position)
	
	#mesh = MCUtils.GenerateMarchingCubes(grid_size, noise)
				
	pass

func load_chunks(middle_chunk_vec:Vector3):
	for x in range(-GVars.RENDER_RAD, GVars.RENDER_RAD+1):
		for y in range(-GVars.RENDER_RAD, GVars.RENDER_RAD+1):
			for z in range(-GVars.RENDER_RAD, GVars.RENDER_RAD+1):
				var vec:Vector3 = Vector3(x,y,z) + middle_chunk_vec
				if !loaded_chunks.has(vec):
					load_chunk(vec)

func load_chunk(chunk_vec:Vector3):
		
	var new_chunk = MeshInstance3D.new()
	add_child(new_chunk)
	var offset = chunk_vec * GVars.CHUNK_SIZE
	new_chunk.mesh = MCUtils.GenerateMarchingCubes(GVars.CHUNK_SIZE, offset, noise)
	new_chunk.global_position = offset
	loaded_chunks[chunk_vec] = new_chunk
	
	pass

func _process(delta: float) -> void:
	
	cur_chunk = get_chunk_at_pos(player.global_position)
	%ChunkDebug.global_position = (cur_chunk * GVars.CHUNK_SIZE) + Vector3(10,10,10)
	if prev_chunk == cur_chunk:
		return
	
	print(cur_chunk)
	
	prev_chunk = cur_chunk
	load_chunks(cur_chunk)
	

	return


func get_chunk_at_pos(pos:Vector3) -> Vector3:
	return floor(pos / GVars.CHUNK_SIZE)
