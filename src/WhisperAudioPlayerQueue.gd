extends Node

var stream_queue = []
var current_stream_data = {}
var next_stream_data = {}
var current_stream_complete
var whisper_left_finished
var whisper_right_finished
# Called when the node enters the scene tree for the first time.
func _ready():
	current_stream_complete = true
	whisper_left_finished = true
	whisper_right_finished = true
	next_stream_data = get_default_stream_data()
	$PrimaryAudioStreamPlayer.connect("finished",self,"on_PrimaryAudioStreamPlayer_finished")
	$WhisperDelayLeft.connect("timeout",self,"on_WhisperDelayLeft_timeout")
	$WhisperDelayRight.connect("timeout",self,"on_WhisperDelayRight_timeout")
	$WhisperLeftAudioPlayer.connect("finished",self,"on_WhisperLeftAudioPlayer_finished")
	$WhisperRightAudioPlayer.connect("finished",self,"on_WhisperRightAudioPlayer_finished")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if len(stream_queue) > 0 and current_stream_complete and whisper_left_finished and whisper_right_finished:
		current_stream_complete = false
		if stream_queue[0]["stream"]:
			$PrimaryAudioStreamPlayer.set_stream(stream_queue[0]["stream"])
			$PrimaryAudioStreamPlayer.set_bus(stream_queue[0]["bus"])
			$PrimaryAudioStreamPlayer.play()
			if stream_queue[0]["whisper_left"]:
				$WhisperLeftAudioPlayer.set_stream(stream_queue[0]["whisper_left"])
				$WhisperDelayLeft.wait_time = stream_queue[0]["delay_left"]
				$WhisperDelayLeft.start()
				whisper_left_finished = false
			if stream_queue[0]["whisper_right"]:
				$WhisperRightAudioPlayer.set_stream(stream_queue[0]["whisper_right"])
				$WhisperDelayRight.wait_time = stream_queue[0]["delay_right"]
				$WhisperDelayRight.start()
				whisper_right_finished = false
			stream_queue.pop_front()

func add_primary_stream(stream, bus="master"):
	next_stream_data["stream"] = stream
	next_stream_data["bus"] = bus

func add_whisper_left_stream(stream, delay=0):
	next_stream_data["whisper_left"] = stream
	next_stream_data["delay_left"] = delay

func add_whisper_right_stream(stream, delay=0):
	next_stream_data["whisper_right"] = stream
	next_stream_data["delay_right"] = delay

func commit():
	if "stream" in next_stream_data.keys():
		stream_queue.append(next_stream_data)
		reset_stage()
	else:
		print("ERROR: No stream queued")
	
func get_default_stream_data():
	var default_stream_data = {}
	default_stream_data["stream"] = false
	default_stream_data["whisper_left"] = false
	default_stream_data["whisper_right"] = false
	default_stream_data["bus"] = "master"
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

func on_WhisperDelayLeft_timeout():
	$WhisperLeftAudioPlayer.play()

func on_WhisperDelayRight_timeout():
	$WhisperRightAudioPlayer.play()

func on_WhisperLeftAudioPlayer_finished():
	whisper_left_finished = true

func on_WhisperRightAudioPlayer_finished():
	whisper_right_finished = true

func reset_stage():
	next_stream_data = get_default_stream_data()

func stop_and_clear():
	if $PrimaryAudioStreamPlayer.is_playing():
		$PrimaryAudioStreamPlayer.stop()
	if $WhisperLeftAudioPlayer.is_playing():
		$WhisperLeftAudioPlayer.stop()
	if $WhisperRightAudioPlayer.is_playing():
		$WhisperRightAudioPlayer.stop()
	stream_queue = []
	
