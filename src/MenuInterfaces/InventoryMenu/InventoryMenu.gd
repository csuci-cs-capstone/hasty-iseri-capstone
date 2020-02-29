extends Control

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var current_index
var current_capacity
var inventory_items = []
var selected_for_craft = []

const DEBUG_WHISPER_VOLUME = -42
const DEBUG_WHISPER_DELAY_LEFT = .22
const DEBUG_WHISPER_DELAY_RIGHT = .28

# options: items_list_menu, item_popup_menu, items_craft_menu
var substate

var debug_cycle_menu = false

#DEBUG: loading here for testing
var speech_blue = load("res://src/MenuInterfaces/InventoryMenu/speech_blue.wav")
var speech_green = load("res://src/MenuInterfaces/InventoryMenu/speech_green.wav")
var speech_red = load("res://src/MenuInterfaces/InventoryMenu/speech_red.wav")
var speech_yellow = load("res://src/MenuInterfaces/InventoryMenu/speech_yellow.wav")
var speech_cyan = load("res://src/MenuInterfaces/InventoryMenu/speech_cyan.wav")
var speech_magenta = load("res://src/MenuInterfaces/InventoryMenu/speech_magenta.wav")
var speech_white = load("res://src/MenuInterfaces/InventoryMenu/speech_white.wav")

var speech_blue_description = load("res://src/MenuInterfaces/InventoryMenu/speech_blue_description.wav")
var speech_green_description = load("res://src/MenuInterfaces/InventoryMenu/speech_green_description.wav")
var speech_red_description = load("res://src/MenuInterfaces/InventoryMenu/speech_red_description.wav")
var speech_yellow_description = load("res://src/MenuInterfaces/InventoryMenu/speech_yellow_description.wav")
var speech_cyan_description = load("res://src/MenuInterfaces/InventoryMenu/speech_cyan_description.wav")
var speech_magenta_description = load("res://src/MenuInterfaces/InventoryMenu/speech_magenta_description.wav")
var speech_white_description = load("res://src/MenuInterfaces/InventoryMenu/speech_white_description.wav")

# Called when the node enters the scene tree for the first time.
func _ready():

	current_index = 0
	debug_configure_audio_bus()
	debug_load_name_to_speech()
	current_capacity = len(inventory_items)
	substate = "items_list_menu"
	current_item_selected()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	
	if Input.is_action_pressed("menu_ui_assist"):
		describe_input_option_to_user()
	elif substate == "items_list_menu":
		if Input.is_action_just_pressed("menu_ui_right"):
			navigate_to_next_item()
		elif Input.is_action_just_pressed("menu_ui_left"):
			navigate_to_previous_item()
		elif Input.is_action_just_pressed("menu_ui_repeat"):
			current_item_selected()
		elif Input.is_action_just_pressed("inventory_menu_craft"):
			pass #TODO: initialize crafting system, use color mixing as example
		elif Input.is_action_just_pressed("inventory_menu_examine"):
			examine_selected_item()
	elif substate == "item_popup_menu":
		if Input.is_action_just_pressed("menu_ui_cancel"):
			pass #TODO
	elif substate == "item_craft_menu":
		if Input.is_action_just_pressed("menu_ui_cancel"):
			pass #TODO
	else:
		print("ERROR: InventoryMenu has invalid substate")

func accept_current_item():
	#TODO
	pass

# TODO: determine how to migrate this method to the Inventory scene
func add_inventory_item(name, description):
	var InventoryItem = load("res://src/MenuInterfaces/InventoryMenu/InventoryItem.tscn")
	inventory_items.append(InventoryItem.instance())
	current_capacity = len(inventory_items)
	add_child(inventory_items[current_capacity-1])
	inventory_items[current_capacity-1].set_name_to_speech(name)
	inventory_items[current_capacity-1].set_description_to_speech(description)
	inventory_items[current_capacity-1].set_whisper_delay_left(DEBUG_WHISPER_DELAY_LEFT)
	inventory_items[current_capacity-1].set_whisper_delay_left(DEBUG_WHISPER_DELAY_RIGHT)
	inventory_items[current_capacity-1].get_node("WhisperDelayLeft").connect("timeout",self,"on_WhisperDelayLeft_timeout")
	inventory_items[current_capacity-1].get_node("WhisperDelayRight").connect("timeout",self,"on_WhisperDelayRight_timeout")

func alert_left_end_reached():
	if not $AlertLeftEndReached.is_playing():
		$AlertLeftEndReached.play()
		Input.start_joy_vibration (0, 0, .8, .2)
	
func alert_right_end_reached():
	if not $AlertRightEndReached.is_playing():
		$AlertRightEndReached.play()
		Input.start_joy_vibration (0, 0, .8, .2)

func current_item_selected():
	inventory_items[current_index].select()

#DEBUG
func debug_configure_audio_bus():
	AudioServer.set_bus_volume_db (1, DEBUG_WHISPER_VOLUME)
	AudioServer.set_bus_volume_db (2, DEBUG_WHISPER_VOLUME)

#DEBUG
func debug_load_name_to_speech():
	var names = [speech_blue,speech_green,speech_red]
	var descriptions = {speech_blue: speech_blue_description,speech_green: speech_green_description, speech_red: speech_red_description}
	for name in names:
		add_inventory_item(name, descriptions[name])

func describe_input_option_to_user():
	#TODO: determine how to structure this, and whether a singleton would be better
	pass

func examine_selected_item():
	inventory_items[current_index].read_description()

func load_menu_end_alert_positions():
	# TODO: use screen resolution to position 2D Audio alert nodes for reaching menu end
	pass

func on_WhisperDelayLeft_timeout():	
	if current_index > 0:
		inventory_items[current_index-1].whisper_name_left()

func on_WhisperDelayRight_timeout():
	if current_index < current_capacity - 1:
		inventory_items[current_index+1].whisper_name_right()
			
func navigate_to_next_item():
	if current_index == current_capacity - 1:
		if not debug_cycle_menu:
			alert_right_end_reached()
		else:
			inventory_items[0].stop_all_audio()
			current_index = 0	
	else:
		current_index = current_index + 1
	inventory_items[current_index-1].stop_all_audio()
	inventory_items[current_index].stop_all_audio()
	current_item_selected()
		
func navigate_to_previous_item():
	if current_index == 0:
		if not debug_cycle_menu:
			alert_left_end_reached()
		else:
			inventory_items[current_capacity - 1].stop_all_audio()
			current_index = current_capacity - 1
	else:
		current_index = current_index - 1
	inventory_items[current_index+1].stop_all_audio()
	inventory_items[current_index].stop_all_audio()
	current_item_selected()

