extends Area2D
class_name Marker

<<<<<<< HEAD
var associated_object
var can_detect = true
=======
var marker_type
var name_to_speech
>>>>>>> origin/master
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

<<<<<<< HEAD
=======

>>>>>>> origin/master
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

<<<<<<< HEAD
func get_associated_object():
	return associated_object

func get_can_detect():
	return can_detect

func set_associated_object(arg_object):
	associated_object = arg_object

func set_can_detect(arg):
	can_detect = arg
=======
func get_name_to_speech():
	return name_to_speech

func issue_audio_id():
	if not $IdentitySound.is_playing():
		$IdentitySound.play()
		
func set_feedback_sound(sound):
	$IdentitySound.set_stream(sound)
	
func set_name_to_speech(p_name_to_speech):
	self.name_to_speech = p_name_to_speech

func set_type(type):
	marker_type = type
	
func speak_name():
	#if not $NameToSpeech.is_playing():
	$NameToSpeech.play()

func stop_all_audio():
	if $IdentitySound.is_playing():
		$IdentitySound.stop()
	if $NameToSpeech.is_playing():
		$NameToSpeech.stop()
>>>>>>> origin/master
