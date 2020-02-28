extends Control

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var current_index
var current_capacity
var inventory_items = []
var selected_for_craft

const DEBUG_WHISPER_VOLUME = -42
const DEBUG_WHISPER_DELAY_LEFT = .22
const DEBUG_WHISPER_DELAY_RIGHT = .28

# options: items_list_menu, item_popup_menu, items_craft_menu
var substate

var debug_cycle_menu = false
# Called when the node enters the scene tree for the first time.
func _ready():
	
	#DEBUG: loading here for testing
	current_index = 0
	debug_configure_audio_bus()
	debug_load_name_to_speech()
	current_capacity = len(inventory_items)
	substate = "items_list_menu"
	current_item_selected()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if substate == "items_list_menu":
		if Input.is_action_just_pressed("menu_ui_right"):
			navigate_to_next_item()
		elif Input.is_action_just_pressed("menu_ui_left"):
			navigate_to_previous_item()
	elif substate == "item_popup_menu":
		pass
	elif substate == "item_craft_menu":
		pass
	else:
		print("ERROR: InventoryMenu has invalid substate")

func accept_current_item():
	pass

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
	var speech_blue = load("res://src/MenuInterfaces/InventoryMenu/speech_blue.wav")
	var speech_green = load("res://src/MenuInterfaces/InventoryMenu/speech_green.wav")
	var speech_red = load("res://src/MenuInterfaces/InventoryMenu/speech_red.wav")
	
	var names = [speech_blue,speech_green,speech_red]
	for name in names:
		add_inventory_item(name)
	
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

func add_inventory_item(name):
	var InventoryItem = load("res://src/MenuInterfaces/InventoryMenu/InventoryItem.tscn")
	inventory_items.append(InventoryItem.instance())
	current_capacity = len(inventory_items)
	add_child(inventory_items[current_capacity-1])
	inventory_items[current_capacity-1].set_name_to_speech(name)
	inventory_items[current_capacity-1].set_whisper_delay_left(DEBUG_WHISPER_DELAY_LEFT)
	inventory_items[current_capacity-1].set_whisper_delay_left(DEBUG_WHISPER_DELAY_RIGHT)
	inventory_items[current_capacity-1].get_node("WhisperDelayLeft").connect("timeout",self,"on_WhisperDelayLeft_timeout")
	inventory_items[current_capacity-1].get_node("WhisperDelayRight").connect("timeout",self,"on_WhisperDelayRight_timeout")
