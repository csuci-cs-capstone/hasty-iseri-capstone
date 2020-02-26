extends Node

# Options: none
var type
var has_examine = false
var has_consume = false
var has_craft = false

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

func deselect():
	if $IdentitySound.is_playing():
		$IdentitySound.stop()
	if $NameToSpeech.is_playing():
		$NameToSpeech.stop()

func issue_audio_id():
	$IdentitySound.play()
	
func speak_name():
	if not $NameToSpeech.is_playing():
		$NameToSpeech.play()

func select():
	issue_audio_id()
	speak_name()
	
func whisper_name_left():
	pass

func whisper_name_right():
	pass
	
