extends Spatial

var identity_sound



# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func set_identity_sound(stream):
	$AudioStreamPlayer3D.set_stream(stream)
	

