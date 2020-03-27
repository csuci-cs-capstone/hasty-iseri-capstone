extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var stream_queue = []
var current_stream_data = {}
var next_stream_data = {}
var current_stream_complete
var whisper_delay_left_timer_active
var whisper_delay_right_timer_active
# Called when the node enters the scene tree for the first time.
func _ready():
	current_stream_complete = true
	next_stream_data = get_default_stream_data()
	$PrimaryAudioStreamPlayer.connect("finished",self,"on_PrimaryAudioStreamPlayer_finished")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if len(stream_queue) > 0 and current_stream_complete:
		current_stream_complete = false
		if stream_queue[0]["stream"]:
			$PrimaryAudioStreamPlayer.set_stream(stream_queue[0]["stream"])
			$PrimaryAudioStreamPlayer.set_bus(stream_queue[0]["bus"])
			$PrimaryAudioStreamPlayer.play()
			if stream_queue[0]["whisper_left"]:
				$WhisperLeftAudioPlayer.set_stream(stream_queue[0]["whisper_left"])
				$WhisperLeftAudioPlayer.play()
				$WhisperDelayLeft.wait_time = stream_queue[0]["delay_left"]
				$WhisperDelayLeft.start()
				whisper_delay_left_timer_active = true
			if stream_queue[0]["whisper_right"]:
				$WhisperRightAudioPlayer.set_stream(stream_queue[0]["whisper_right"])
				$WhisperRightAudioPlayer.play()
				$WhisperDelayRight.wait_time = stream_queue[0]["delay_right"]
				$WhisperDelayRight.start()
				whisper_delay_right_timer_active = true
			stream_queue.pop_front()
			
	elif not current_stream_complete:
		if whisper_delay_left_timer_active:
			$WhisperLeftAudioPlayer.play()
			whisper_delay_left_timer_active = false
		if whisper_delay_right_timer_active:
			$WhisperRightAudioPlayer.play()
			whisper_delay_right_timer_active = false

func add_primary_stream(stream):
	next_stream_data["stream"] = stream

func add_whisper_left_stream(stream, delay=0):
	next_stream_data["whisper_left"] = stream
	next_stream_data["delay_left"] = delay

func add_whisper_right_stream(stream, delay=0):
	next_stream_data["whisper_right"] = stream
	next_stream_data["delay_right"] = delay

func commit_to_queue():
	if "stream" in next_stream_data.keys():
		stream_queue.append(next_stream_data)
	else:
		print("ERROR: No stream queued")
	
func get_default_stream_data():
	var default_stream_data = {}
	default_stream_data["stream"] = false
	default_stream_data["whisper_left"] = false
	default_stream_data["whisper_right"] = false
	default_stream_data["delay_left"] = 0
	default_stream_data["delay_right"] = 0
	return default_stream_data
		
func init_whisper_delay_left_timer(delay):
	$WhisperDelayLeft.wait_time = delay
	$WhisperDelayLeft.start()

func init_whisper_delay_right_timer(delay):
	$WhisperDelayRight.wait_time = delay
	$WhisperDelayRight.start()

func on_PrimaryAudioStreamPlayer_finished():
	current_stream_complete = true
	
func reset_stage():
	next_stream_data = get_default_stream_data()

func stop_and_clear():
	if $AudioStreamPlayer.is_playing():
		$AudioStreamPlayer.stop()
	stream_queue = []
	
