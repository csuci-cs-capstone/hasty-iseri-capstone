extends Spatial

var name_to_speech
var spawned
# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group("waypoints")
	spawned = false

func get_name_to_speech():
	return name_to_speech

func set_name_to_speech(stream):
	name_to_speech = stream
	
func set_spawned(arg_spawned):
	spawned = arg_spawned

