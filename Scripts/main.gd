extends Node3D

@onready var player: Camera3D = %Camera3D

@onready var terrain_gen: Node3D = %TerrainGen

const CHUNK_SIZE = 20
const RENDER_RAD = 4

var cur_chunk 
var prev_chunk

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	cur_chunk = get_chunk_from_pos(player.global_position)
	if cur_chunk == prev_chunk:
		return
	#$ChunkDebug.global_position = cur_chunk * 20 + Vector3(10,10,10)
	print(cur_chunk)
	#terrain_gen.RequestLoadChunksAround(cur_chunk)
	
	var thred = Thread.new()
	thred.start(terrain_gen.BenchmarkGen)
	
	prev_chunk = cur_chunk


func get_chunk_from_pos(position:Vector3):
	return floor(position / 20.0)
