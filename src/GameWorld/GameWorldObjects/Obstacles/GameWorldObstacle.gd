extends Spatial

var identity_sound
<<<<<<< HEAD
export(String, "tree", "boulder", "bush") var type: String = "tree"
var resource

var Marker = load("res://src/GameWorld/MenuInterfaces/MapMenu/Marker.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group("obstacles")

func set_identity_sound(stream):
	identity_sound = stream
=======
export(String, "tree", "boulder", "bush") var type
var resource

# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group("obstacles")
	add_to_group("harvestable")

func set_identity_sound(stream):
	$AudioStreamPlayer3D.set_stream(stream)
>>>>>>> origin/master
	
func get_identity_sound():
	return identity_sound
	
func set_type(arg_type):
	type = arg_type

func get_type():
	return type

func set_resource(arg_resource):
	resource = arg_resource

func get_resource():
	return resource
