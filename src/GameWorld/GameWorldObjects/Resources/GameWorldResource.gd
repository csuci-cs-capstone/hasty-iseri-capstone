extends Spatial

<<<<<<< HEAD
var consume_sound
var consume_value
var identity_sound
var name_to_speech
var description_to_speech
export(String, "apple", "sticks", "stones") var type: String = "apple"

# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group("resources")

func get_consume_sound():
	return consume_sound
	
func get_consume_value():
	return consume_value

func get_description_to_speech():
	return description_to_speech

func get_identity_sound():
	return identity_sound

func get_name_to_speech():
	return name_to_speech
	
func get_type():
	return type

func set_consume_sound(arg_consume_sound):
	consume_sound = arg_consume_sound

func set_consume_value(arg_consume_value):
	consume_value = arg_consume_value

func set_description_to_speech(arg_description_to_speech):
	description_to_speech = arg_description_to_speech

func set_identity_sound(arg_identity_sound):
	identity_sound = arg_identity_sound

func set_name_to_speech(arg_name_to_speech):
	name_to_speech = arg_name_to_speech
	
func set_type(arg_type=null):
	self.type = arg_type

=======
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
>>>>>>> origin/master
