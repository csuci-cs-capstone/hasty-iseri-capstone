extends Spatial

var identity_sound
var type
var has_consume = false
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func get_type():
	return type

func set_identity_sound(stream):
	$AudioStreamPlayer3D.set_stream(stream)
	
func set_type(arg_type):
	type = arg_type

func set_has_consume(arg_consume):
	has_consume = arg_consume


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
