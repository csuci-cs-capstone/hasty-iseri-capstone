extends Node

# Options: none
var type
var has_consume = false

var consume_sound
var identity_sound
var name_to_speech
var description_to_speech

# Called when the node enters the scene tree for the first time.
func _ready():
	# TODO: implement audio resource loading; load all inventory item sounds here?
	type = "empty"

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
	
func consume():
	if not $ConsumeSound.is_playing():
		$ConsumeSound.play()

func get_consume_sound():
	return consume_sound

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

func set_description_to_speech(arg_description_to_speech):
	description_to_speech = arg_description_to_speech

func set_identity_sound(arg_identity_sound):
	identity_sound = arg_identity_sound

func set_name_to_speech(arg_name_to_speech):
	name_to_speech = arg_name_to_speech
	
func set_type(arg_type="empty"):
	self.type = arg_type
	
func whisper_name_left():	
	$NameToSpeech.set_bus("L_UI_Whisper")

func whisper_name_right():
	$NameToSpeech.set_bus("R_UI_Whisper")
	
	
