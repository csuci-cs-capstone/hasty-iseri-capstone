extends Control
<<<<<<< HEAD
class_name MapMenu

signal waypoint_placed
signal closed
=======

signal waypoint_placed
signal waypoint_removed
>>>>>>> origin/master

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

<<<<<<< HEAD
=======
var HorizontalGridline
var VerticalGridline
var Marker

>>>>>>> origin/master
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
<<<<<<< HEAD
var markers = {"player": [], "resources":[], "waypoints":[]}
var map_dimensions = {"x": 100, "y": 100}
=======
var markers = {"player": player_marker,"resources":[],"waypoints":[]}
>>>>>>> origin/master

var current_waypoint_index = 0
var waypoint_just_placed = false
var marker_detected_by_sweepline = false
<<<<<<< HEAD
var snapped_to = false

#DEBUG
var speech_map_menu = load("res://src/GameWorld/MenuInterfaces/MapMenu/speech_map_menu.wav")
var speech_placed = load("res://src/GameWorld/MenuInterfaces/MapMenu/speech_placed.wav")
var speech_position = load("res://src/GameWorld/MenuInterfaces/MapMenu/speech_position.wav")
var speech_selected = load("res://src/GameWorld/MenuInterfaces/MapMenu/speech_selected.wav")
var speech_player = load("res://src/GameWorld/MenuInterfaces/MapMenu/speech_player.wav")

var HorizontalGridline = load("res://src/GameWorld/MenuInterfaces/MapMenu/HorizontalGridline.tscn")
var VerticalGridline = load("res://src/GameWorld/MenuInterfaces/MapMenu/VerticalGridline.tscn")
var Marker = load("res://src/GameWorld/MenuInterfaces/MapMenu/Marker.tscn")
=======

#DEBUG
var speech_placed = load("res://src/MenuInterfaces/MapMenu/speech_placed.wav")
var speech_player = load("res://src/MenuInterfaces/MapMenu/speech_player.wav")
var speech_position = load("res://src/MenuInterfaces/MapMenu/speech_position.wav")
var speech_selected = load("res://src/MenuInterfaces/MapMenu/speech_selected.wav")
var speech_waypoint1 = load("res://src/speech_waypoint1.wav")
var speech_waypoint2 = load("res://src/speech_waypoint2.wav")
var speech_waypoint3 = load("res://src/speech_waypoint3.wav")
var speech_waypoint4 = load("res://src/speech_waypoint4.wav")
var speech_blue = load("res://src/MenuInterfaces/InventoryMenu/speech_blue.wav")
var speech_green = load("res://src/MenuInterfaces/InventoryMenu/speech_green.wav")
var speech_red = load("res://src/MenuInterfaces/InventoryMenu/speech_red.wav")
>>>>>>> origin/master

# Called when the node enters the scene tree for the first time.
func _ready():
	# TODO: this needs to be abstracted to load screen resolution
	x_min = 0
	x_max = 1280
	y_min = 0
	y_max = 720

<<<<<<< HEAD
	$CloseMenuSound.connect("finished",self,"on_CloseMenuSound_finished")
=======
>>>>>>> origin/master
	sweepline_x = get_node("HorizontalSweepline")
	sweepline_y = get_node("VerticalSweepline")
	crosshair = get_node("Crosshair")
	
<<<<<<< HEAD
	sweep_velocity = Vector2(x_max/SWEEP_CONST, y_max/SWEEP_CONST)
	
	$MarkerAudioQueue.add(speech_map_menu)
	
	spawn_horizontal_gridlines()
	spawn_vertical_gridlines()
	
	load_marker_data()
	current_waypoint_selected()
	
	if markers["player"]:
		sweepline_x.position.y = markers["player"][0].position.y 
		sweepline_y.position.x = markers["player"][0].position.x 
	else:
		sweepline_x.position.y = y_min+1
		sweepline_y.position.x = x_min+1
	
	snapped_to = true
	
=======
	sweepline_x.position.y = y_min+1
	sweepline_y.position.x = x_min+1
	sweep_velocity = Vector2(x_max/SWEEP_CONST, y_max/SWEEP_CONST)
	
	spawn_horizontal_gridlines()
	spawn_vertical_gridlines()
	
	if not player_marker:
		player_marker = Marker.instance()
		player_marker.position.x = 20
		player_marker.position.y = 20
	
	load_marker_data()
	current_waypoint_selected()
			
>>>>>>> origin/master
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
	
	elif Input.is_action_just_pressed("map_menu_select_next_waypoint"):
		navigate_to_waypoint("next")
	elif Input.is_action_just_pressed("map_menu_select_previous_waypoint"):
		navigate_to_waypoint("previous")
	elif Input.is_action_just_pressed("map_menu_update_waypoint"):
		update_selected_waypoint()
	elif Input.is_action_just_pressed("map_menu_snap_to_player"):
		snap_to_player_marker_position()
	elif Input.is_action_just_pressed("map_menu_snap_to_waypoint"):
		snap_to_waypoint_marker_position()
	elif Input.is_action_just_pressed("menu_ui_cancel"):
<<<<<<< HEAD
		close()
=======
		pass
>>>>>>> origin/master
	
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

<<<<<<< HEAD
func close():
	$CloseMenuSound.play()

func current_waypoint_selected():
	if markers["waypoints"]:
		$MarkerAudioQueue.add(markers['waypoints'][current_waypoint_index].get_associated_object() \
			.get_name_to_speech())
		$MarkerAudioQueue.add(speech_selected)

func load_marker_data():
	var marker_types = ["player", "resources", "waypoints"]
	for marker_type in marker_types:
		if get_tree().has_group(marker_type):
			for object in get_tree().get_nodes_in_group(marker_type):
				var marker = make_marker_type_from_object(marker_type, object)
				markers[marker_type].append(marker)
		else:
			markers[marker_type] = null
			print("ERROR: could not load marker")
=======
func current_waypoint_selected():
	#markers['waypoints'][current_waypoint_index].speak_name()
	$MarkerAudioQueue.add_to_queue(markers['waypoints'][current_waypoint_index].get_name_to_speech())
	$MarkerAudioQueue.add_to_queue(speech_selected)

# DEBUG
func debug_load_player_marker_data():
	markers["player"] = Marker.instance()
	add_child(markers["player"])
	markers["player"].set_name_to_speech(speech_player)
	markers['player'].connect("area_entered",self,"_on_ResourceMarker_area_entered", [markers['player']])
	randomize()
	markers["player"].position.x = rand_range(0,1280)
	markers["player"].position.y = rand_range(0,720)

# DEBUG
func debug_load_resource_marker_data():
	var resource_types_to_generate = [speech_red, speech_green, speech_blue]
	var index = 0
	var index2 = 0
	while index < 5:
		markers["resources"].append(Marker.instance())
		add_child(markers["resources"][index])
		markers["resources"][index].set_name_to_speech(resource_types_to_generate[index2])
		markers["resources"][index].connect("area_entered",self,"_on_ResourceMarker_area_entered", [markers["resources"][index]])
		randomize()
		markers["resources"][index].position.x = rand_range(0,1280)
		markers["resources"][index].position.y = rand_range(0,720)
		index = index + 1
		index2 = (index2 + 1)%3

# DEBUG
func debug_load_waypoint_marker_data():
	var waypoint_name_to_speech = [speech_waypoint1, speech_waypoint2, speech_waypoint3, speech_waypoint4]
	var waypoints_to_generate = ['waypoint1', 'waypoint2', 'waypoint3', 'waypoint4']
	
	var index = 0
	while index < len(waypoints_to_generate):
		markers['waypoints'].append(Marker.instance())
		markers['waypoints'][len(markers['waypoints'])-1].set_type(waypoints_to_generate[index])
		markers['waypoints'][len(markers['waypoints'])-1].set_name_to_speech(waypoint_name_to_speech[index])
		markers['waypoints'][len(markers['waypoints'])-1].connect("area_entered",self,"_on_ResourceMarker_area_entered", [markers['waypoints'][len(markers['waypoints'])-1]])
		markers['waypoints'][len(markers['waypoints'])-1].connect("area_exited",self,"_on_ResourceMarker_area_exited")
		add_child(markers['waypoints'][len(markers['waypoints'])-1])
		index = index + 1

func load_marker_data():
	load_player_marker_data()
	load_resource_marker_data()
	load_waypoint_marker_data()
	
func load_player_marker_data():
	debug_load_player_marker_data() 

func load_resource_marker_data():
	debug_load_resource_marker_data()

func load_waypoint_marker_data():
	debug_load_waypoint_marker_data()
>>>>>>> origin/master

func issue_horizontal_border_feedback():
	var audio_feedback = sweepline_x.get_node("HorizontalAudioBorder")
	if ui_feedback_vibrate_borders == true:
		Input.start_joy_vibration (0, 0, .8, .2)
	if not audio_feedback.is_playing():
		audio_feedback.play()

func issue_vertical_border_feedback():
	var audio_feedback = sweepline_y.get_node("VerticalAudioBorder")
	if ui_feedback_vibrate_borders == true:
		Input.start_joy_vibration (0, 0, .8, .2)
	if not audio_feedback.is_playing():
		audio_feedback.play()

<<<<<<< HEAD
func make_marker_type_from_object(marker_type, object):
	var new_marker = Marker.instance()
	new_marker.set_associated_object(object)
	new_marker.connect("area_entered",self,"on_Marker_area_entered", [new_marker, object])
	new_marker.connect("area_exited",self,"on_Marker_area_exited", [new_marker, object])
	new_marker.position.x = ((object.get_translation().x + 30) / 52) * 1280  # TODO: replace with screen resolution
	new_marker.position.y = ((object.get_translation().z + 36) / 58) * 720  # TODO: replace with screen resolution
	if marker_type == "player":
		new_marker.get_node("DeveloperVisual").texture = load("res://src/GameWorld/MenuInterfaces/blue.png")  # DEBUG
	elif marker_type == "waypoints":
		new_marker.get_node("DeveloperVisual").texture = load("res://src/GameWorld/MenuInterfaces/green.png")  # DEBUG
		if not object.get_spawned():
			new_marker.position.x = -50  # TODO
			new_marker.position.y = -50  # TODO
			new_marker.set_can_detect(false)
		
	add_child(new_marker)
	return new_marker

func navigate_to_waypoint(direction):
	if markers["waypoints"]:
		var previous_waypoint_index = current_waypoint_index
		if len(markers['waypoints']) > 0:
			if direction == "next":
				current_waypoint_index = (current_waypoint_index + 1)%len(markers['waypoints'])
			elif direction == "previous":
				current_waypoint_index = (current_waypoint_index - 1)
				if current_waypoint_index < 0:
					current_waypoint_index = len(markers['waypoints']) - 1
			if len(markers['waypoints']) > 1:
				$MarkerAudioQueue.stop_and_clear()
			current_waypoint_selected()
			print("Current waypoint: " + str(current_waypoint_index))
	else:
		print("ERROR: no waypoint markers loaded")

func on_CloseMenuSound_finished():
	emit_signal("closed")
=======
func navigate_to_waypoint(direction):
	var previous_waypoint_index = current_waypoint_index
	if len(markers['waypoints']) > 0:
		if direction == "next":
			current_waypoint_index = (current_waypoint_index + 1)%len(markers['waypoints'])
		elif direction == "previous":
			current_waypoint_index = (current_waypoint_index - 1)
			if current_waypoint_index < 0:
				current_waypoint_index = len(markers['waypoints']) - 1
		if len(markers['waypoints']) > 1:
			$MarkerAudioQueue.stop_and_clear()
		current_waypoint_selected()
		print("Current waypoint: " + str(current_waypoint_index))
>>>>>>> origin/master

func on_HorizontalGridline_entered(area_id, source):
	if area_id == sweepline_x:
		if ui_feedback_vibrate_gridlines == true:
			Input.start_joy_vibration (0, .4, 0, .1)
		source.get_node("AudioMidline").play()

func on_VerticalGridline_entered(area_id, source):
	if area_id == sweepline_y:
<<<<<<< HEAD
=======
		debug+=1 #DEBUG: this is to assist with detecting bug where collisions randomly not detected
		print('hit' + str(debug))
>>>>>>> origin/master
		if ui_feedback_vibrate_gridlines == true:
			Input.start_joy_vibration (0, .4, 0, .1)
		source.get_node("AudioMidline").play()
	
<<<<<<< HEAD
func on_Marker_area_entered(area_id, marker, object):
	if marker.get_can_detect():  # TODO: can detect check may not be needed
		if area_id == crosshair:
			if not waypoint_just_placed and not snapped_to:
				$MarkerAudioQueue.add(object.get_name_to_speech())
				Input.start_joy_vibration (0, 1, .4, .16)
		elif area_id == sweepline_x:
			Input.start_joy_vibration (0, .4, 0, .16)
		elif area_id == sweepline_y:
			Input.start_joy_vibration (0, .4, 0, .16)
	
func on_Marker_area_exited(area_id, marker, object):
	if area_id == crosshair:
		waypoint_just_placed = false
		snapped_to = false

func set_map_dimensions(arg_dim):
	map_dimensions = arg_dim

#TODO: add functionality
func snap_to_player_marker_position():
	snapped_to = true
	$MarkerAudioQueue.add(markers["player"][0].get_associated_object().get_name_to_speech())
	$MarkerAudioQueue.add(speech_position)
	$VerticalSweepline.position.x = markers["player"][0].get_position().x
	$HorizontalSweepline.position.y = markers["player"][0].get_position().y

#TODO: add functionality
func snap_to_waypoint_marker_position():
	snapped_to = true
	if markers["waypoints"][current_waypoint_index].get_can_detect():
		$MarkerAudioQueue.add(markers["waypoints"][current_waypoint_index].get_associated_object() \
		  .get_name_to_speech())
		$MarkerAudioQueue.add(speech_position)
		$VerticalSweepline.position.x = markers["waypoints"][current_waypoint_index].position.x
		$HorizontalSweepline.position.y = markers["waypoints"][current_waypoint_index].position.y
=======
func _on_ResourceMarker_area_entered(area_id, source):
	if area_id == crosshair and not waypoint_just_placed:
		$MarkerAudioQueue.add_to_queue(source.get_name_to_speech())
		Input.start_joy_vibration (0, 1, .4, .16)
	elif area_id == sweepline_x:
		Input.start_joy_vibration (0, .4, 0, .16)
	elif area_id == sweepline_y:
		Input.start_joy_vibration (0, .4, 0, .16)
	
func _on_ResourceMarker_area_exited(area_id):
	if area_id == crosshair:
		waypoint_just_placed = false

#TODO: add functionality
func snap_to_player_marker_position():
	##$MarkerAudioQueue.add_to_queue(speech_player)
	##$MarkerAudioQueue.add_to_queue(speech_position)
	$VerticalSweepline.position.x = markers["player"].position.x
	$HorizontalSweepline.position.y = markers["player"].position.y

#TODO: add functionality
func snap_to_waypoint_marker_position():
	##$MarkerAudioQueue.add_to_queue(markers["waypoints"][current_waypoint_index].get_name_to_speech())
	##$MarkerAudioQueue.add_to_queue(speech_position)
	$VerticalSweepline.position.x = markers["waypoints"][current_waypoint_index].position.x
	$HorizontalSweepline.position.y = markers["waypoints"][current_waypoint_index].position.y
>>>>>>> origin/master

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

# TODO: add functionality, pass waypoint data through signal so corresponding object can be created/ updated
func update_selected_waypoint():
<<<<<<< HEAD
	if markers["waypoints"]:
		emit_signal("waypoint_placed", $Crosshair.position)
		var waypoint = markers["waypoints"][current_waypoint_index].get_associated_object()
		$MarkerAudioQueue.stop_and_clear()
		$MarkerAudioQueue.add(waypoint.get_name_to_speech())
		$MarkerAudioQueue.add(speech_placed)
		if not markers["waypoints"][current_waypoint_index].get_can_detect():
			markers["waypoints"][current_waypoint_index].set_can_detect(true)
			waypoint.set_spawned(true)
		waypoint.translation.x = ($Crosshair.position.x / 1280) * 52 - 30  # TODO
		waypoint.translation.z = ($Crosshair.position.y /720) * 58 - 36  # TODO
		markers["waypoints"][current_waypoint_index].position = $Crosshair.position
		waypoint_just_placed = true
	else:
		print("ERROR: no waypoint markers loaded")
=======
	emit_signal("waypoint_placed")
	$MarkerAudioQueue.stop_and_clear()
	$MarkerAudioQueue.add_to_queue(markers["waypoints"][current_waypoint_index].get_name_to_speech())
	$MarkerAudioQueue.add_to_queue(speech_placed)
	markers["waypoints"][current_waypoint_index].position = $Crosshair.position
	waypoint_just_placed = true
>>>>>>> origin/master
	
