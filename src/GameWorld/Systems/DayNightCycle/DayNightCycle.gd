extends Node

signal day_to_night
signal night_to_day
signal halfway_interval_alert
signal nearing_end_interval_alert

var time_of_day
var states = ["day","night"]
var alert_intervals_and_signals
var current_state
var length_of_day
var length_of_night
var current_interval_length

var halfway_alert_issued = false
var ending_alert_issued = false

var debug_test_alerts = false
var debug_print_state = true

# Called when the node enters the scene tree for the first time.
func _ready():
	time_of_day = get_node("TimeOfDay")
	
	time_of_day.connect("timeout",self,"on_Timer_timeout")
	# TODO: initial day/night state needs to be loaded from somewhere
	current_state = "day"
	# TODO: initial time of day needs to be loaded from somewhere
	length_of_day = 4
	length_of_night = 4
	
	if current_state == "day":
		time_of_day.wait_time = length_of_day
		current_interval_length = length_of_day
	elif current_state == "night":
		time_of_day.wait_time = length_of_night
		current_interval_length = length_of_night
		
	time_of_day.start()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if time_of_day.time_left < .5*current_interval_length and not halfway_alert_issued:
		if debug_test_alerts: #DEBUG
			issue_interval_alert("halfway")
		emit_signal("halfway_interval_alert")
	elif time_of_day.time_left < .1*current_interval_length:
		if debug_test_alerts: #DEBUG
			issue_interval_alert("halfway")
		emit_signal("nearing_end_interval_alert")

func issue_interval_alert(interval):
	print(interval)
	var audio_feedback = get_node("AudioAlert")
	if interval == "halfway":
		if not audio_feedback.is_playing():
			audio_feedback.play()
		halfway_alert_issued = true
	elif interval == "ending":
		if not audio_feedback.is_playing():
			audio_feedback.play()
		
func on_Timer_timeout():
	halfway_alert_issued = false
	if current_state == "day":
		emit_signal("day_to_night")
		current_state = "night"
		current_interval_length = length_of_night
	elif current_state == "night":
		emit_signal("night_to_day")
		current_state = "day"
		current_interval_length = length_of_day
	if debug_print_state: # DEBUG
		print(current_state)
