extends Control

signal waypoint_placed

var gridline_x_delta
var gridline_y_delta

var number_of_gridlines = Vector2(15,15)

var x_max
var x_min
var y_max
var y_min

var crosshair
var sweepline_x 
var sweepline_y

var HorizontalGridline
var VerticalGridline
var Marker

var vertical_gridline_instance
var sweep_velocity
var debug = 0
var ui_feedback_vibrate_borders = true
var ui_feedback_vibrate_gridlines = false
const SWEEP_CONST = 8

var initial_horizontal_border_up_collision = false
var initial_horizontal_border_down_collision = false
var initial_vertical_border_left_collision = false
var initial_vertical_border_right_collision = false

var player_marker = false
var markers = {"player": player_marker,"resource":[],"waypoint":[]}

# Called when the node enters the scene tree for the first time.
func _ready():
	# TODO: this needs to be abstracted to load screen resolution
	x_min = 0
	x_max = 1280
	y_min = 0
	y_max = 720
	
	get_node("SampleResourceMarker").connect("area_entered",self,"_on_ResourceMarker_area_entered")
	get_node("SampleResourceMarker").connect("area_exited",self,"_on_ResourceMarker_area_exited")
	
	VerticalGridline = load("res://src/MenuInterfaces/TactileMap/VerticalGridline.tscn")
	HorizontalGridline = load("res://src/MenuInterfaces/TactileMap/HorizontalGridline.tscn")
	Marker = load("res://src/MenuInterfaces/TactileMap/Marker.tscn")
	
	sweepline_x = get_node("HorizontalSweepline")
	sweepline_y = get_node("VerticalSweepline")
	crosshair = get_node("Crosshair")
	
	sweepline_x.position.y = y_min+1
	sweepline_y.position.x = x_min+1
	sweep_velocity = Vector2(x_max/SWEEP_CONST, y_max/SWEEP_CONST)
	
	spawn_horizontal_gridlines()
	spawn_vertical_gridlines()
	
	if not player_marker:
		player_marker = Marker.instance()
		player_marker.position.x = 20
		player_marker.position.y = 20
			
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):

	if Input.is_action_pressed("menu_ui_right") and sweepline_y.position.x < x_max:
		sweepline_y.position.x += sweep_velocity.x*delta
	elif Input.is_action_pressed("menu_ui_left") and sweepline_y.position.x > x_min:
		sweepline_y.position.x -= sweep_velocity.x*delta
	elif Input.is_action_pressed("menu_ui_up") and sweepline_x.position.y > y_min:
		sweepline_x.position.y -= sweep_velocity.y*delta
	elif Input.is_action_pressed("menu_ui_down") and sweepline_x.position.y < y_max:
		sweepline_x.position.y += sweep_velocity.y*delta
		
	elif Input.is_action_just_pressed("menu_ui_right") and sweepline_y.position.x >= x_max:
		issue_vertical_border_feedback()
	elif Input.is_action_just_pressed("menu_ui_left") and sweepline_y.position.x <= x_min:
		issue_vertical_border_feedback()
	elif Input.is_action_just_pressed("menu_ui_up") and sweepline_x.position.y <= y_min:
		issue_horizontal_border_feedback()
	elif Input.is_action_just_pressed("menu_ui_down") and sweepline_x.position.y >= y_max:
		issue_horizontal_border_feedback()
		
	if sweepline_y.position.x >= x_max and not initial_vertical_border_right_collision:
		initial_vertical_border_right_collision = true
		issue_vertical_border_feedback()
	elif sweepline_y.position.x <= x_min and not initial_vertical_border_left_collision:
		initial_vertical_border_left_collision = true
		issue_vertical_border_feedback()
	elif sweepline_x.position.y >= y_max and not initial_horizontal_border_up_collision:
		initial_horizontal_border_up_collision = true
		issue_horizontal_border_feedback()
	elif sweepline_x.position.y <= y_min and not initial_horizontal_border_down_collision:
		initial_horizontal_border_down_collision = true
		issue_horizontal_border_feedback()
		
	if sweepline_y.position.x < x_max:
		initial_vertical_border_right_collision = false
	if sweepline_y.position.x > x_min:
		initial_vertical_border_left_collision = false
	if sweepline_x.position.y < y_max:
		initial_horizontal_border_up_collision = false
	if sweepline_x.position.y > y_min:
		initial_horizontal_border_down_collision = false
	
	crosshair.position.x = sweepline_y.position.x
	crosshair.position.y = sweepline_x.position.y

func _physics_process(delta):
	var sweepline_x_collision_sources
	sweepline_x_collision_sources = sweepline_x.get_overlapping_areas()

func issue_horizontal_border_feedback():
	var audio_feedback = sweepline_x.get_node("Audio_Border")
	if ui_feedback_vibrate_borders == true:
		Input.start_joy_vibration (0, 0, .8, .2)
	if not audio_feedback.is_playing():
		audio_feedback.play()

func issue_vertical_border_feedback():
	var audio_feedback = sweepline_y.get_node("Audio_Border")
	if ui_feedback_vibrate_borders == true:
		Input.start_joy_vibration (0, 0, .8, .2)
	if not audio_feedback.is_playing():
		audio_feedback.play()

func on_HorizontalGridline_entered(area_id, source):
	if area_id == sweepline_x:
		if ui_feedback_vibrate_gridlines == true:
			Input.start_joy_vibration (0, .4, 0, .1)
		source.get_node("Audio_Midline").play()
	
func on_VerticalGridline_entered(area_id, source):
	if area_id == sweepline_y:
		debug+=1 #DEBUG: this is to assist with detecting bug where collisions randomly not detected
		print('hit' + str(debug))
		if ui_feedback_vibrate_gridlines == true:
			Input.start_joy_vibration (0, .4, 0, .1)
		source.get_node("Audio_Midline").play()

# TODO: add functionality, pass waypoint data through signal so corresponding object can be created/ updated
func place_waypoint():
	emit_signal("waypoint_placed")
	
# TODO: add functionality
func snap_to_player_marker_position():
	pass
	
func spawn_horizontal_gridlines():
	gridline_y_delta = y_max / number_of_gridlines.y
	for gridline in (number_of_gridlines.y-1):
		var next_horizontal_gridline = HorizontalGridline.instance()
		next_horizontal_gridline.position.y = (gridline+1)*gridline_y_delta
		next_horizontal_gridline.connect("area_entered_modified",self,"on_HorizontalGridline_entered")
		add_child(next_horizontal_gridline)
	
func spawn_vertical_gridlines():
	gridline_x_delta = x_max / number_of_gridlines.x
	for gridline in (number_of_gridlines.x-1):
		var next_vertical_gridline = VerticalGridline.instance()
		next_vertical_gridline.position.x = (gridline+1)*gridline_x_delta
		next_vertical_gridline.connect("area_entered_modified",self,"on_VerticalGridline_entered")
		add_child(next_vertical_gridline)
		
func _on_ResourceMarker_area_entered(area_id):
	if area_id == sweepline_x:
		Input.start_joy_vibration (0, .6, 0, .16)
		print("collide") #TODO
	elif area_id == sweepline_y:
		Input.start_joy_vibration (0, .6, 0, .16)
		print("collide")
	elif area_id == crosshair:
		Input.start_joy_vibration (0, 1, .4, .16)
		
func _on_ResourceMarker_area_exited(area_id):
	if area_id == sweepline_x:
		pass #TODO
	elif area_id == sweepline_y:
		pass #TODO


	
