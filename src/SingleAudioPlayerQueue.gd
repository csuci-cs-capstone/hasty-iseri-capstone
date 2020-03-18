extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var stream_queue = []

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if len(stream_queue) > 0 and not $AudioStreamPlayer.is_playing():
		$AudioStreamPlayer.set_stream(stream_queue[0]["stream"])
		$AudioStreamPlayer.set_bus(stream_queue[0]["bus"])
		if stream_queue[0]["stream2"]:
			$AudioStreamPlayer2.set_stream(stream_queue[0]["stream2"])
			$AudioStreamPlayer2.set_bus(stream_queue[0]["bus"])
			$AudioStreamPlayer2.play()
		$AudioStreamPlayer.play()
		stream_queue.pop_front()
	
func add_to_queue(stream, stream2 = null, bus = "master"):
	var stream_data = {"stream": stream, "stream2": stream2, "bus": bus}
	stream_queue.append(stream_data)
