extends Area2D
class_name Marker

var marker_type
var name_to_speech
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

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
