extends Control

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var current_index
var current_capacity
var inventory_items = []
var selected_for_crafting = []

const DEBUG_WHISPER_VOLUME = -35
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

var speech_assist_examine = load("res://src/MenuInterfaces/InventoryMenu/speech_assist_examine.wav")
var speech_assist_consume = load("res://src/MenuInterfaces/InventoryMenu/speech_assist_consume.wav")
var speech_assist_craft = load("res://src/MenuInterfaces/InventoryMenu/speech_assist_craft.wav")
var speech_assist_cancel = load("res://src/MenuInterfaces/InventoryMenu/speech_assist_cancel.wav")
var speech_assist_cancel_craft = load("res://src/MenuInterfaces/InventoryMenu/speech_assist_cancel_craft_1.wav")

# DEBUG
var craft_mappings

# Called when the node enters the scene tree for the first time.
func _ready():

	current_index = 0
	debug_configure_audio_bus()
	debug_load_name_to_speech()
	debug_setup_craft_compatibility()
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
			add_selected_item_to_craft_list()
			substate = "items_craft_menu"
		elif Input.is_action_just_pressed("inventory_menu_examine"):
			examine_selected_item()
		elif Input.is_action_just_pressed("inventory_menu_consume"):
			pass #TODO: initialize consumption mechanic
	elif substate == "items_popup_menu":
		if Input.is_action_just_pressed("menu_ui_cancel"):
			pass #TODO
	elif substate == "items_craft_menu":
		if Input.is_action_just_pressed("menu_ui_cancel"):
			cancel_craft()
			substate = "items_list_menu"
		if Input.is_action_just_pressed("menu_ui_right"):
			navigate_to_next_item()
		elif Input.is_action_just_pressed("menu_ui_left"):
			navigate_to_previous_item()
		elif Input.is_action_just_pressed("menu_ui_repeat"):
			current_item_selected()
		elif Input.is_action_just_pressed("inventory_menu_craft"):
			add_selected_item_to_craft_list()
		elif Input.is_action_just_pressed("inventory_menu_confirm_craft"):
			add_selected_item_to_craft_list()
		elif Input.is_action_just_pressed("inventory_menu_examine"):
			examine_selected_item()
	else:
		print("ERROR: InventoryMenu has invalid substate")

func accept_current_item():
	#TODO
	pass

func add_selected_item_to_craft_list():
	if current_capacity > 0:
		selected_for_crafting.append(inventory_items[current_index])
		inventory_items.remove(current_index)
		current_index = 0
		current_capacity = len(inventory_items)
		current_item_selected()

# TODO: determine how to migrate this method to the Inventory scene
func add_inventory_item(type, name, description):
	var InventoryItem = load("res://src/MenuInterfaces/InventoryMenu/InventoryItem.tscn")
	inventory_items.append(InventoryItem.instance())
	current_capacity = len(inventory_items)
	add_child(inventory_items[current_capacity-1])
	inventory_items[current_capacity-1].set_type(type)
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

func cancel_craft():
	if len(selected_for_crafting) > 0:
		for item in selected_for_crafting:
			inventory_items.append(item)
			selected_for_crafting.erase(item)
			current_capacity = len(inventory_items)
		current_item_selected()

func current_item_selected():
	if current_capacity > 0:
		inventory_items[current_index].select()

#DEBUG
func debug_configure_audio_bus():
	AudioServer.set_bus_volume_db (1, DEBUG_WHISPER_VOLUME)
	AudioServer.set_bus_volume_db (2, DEBUG_WHISPER_VOLUME)

#DEBUG
func debug_load_name_to_speech():
	var names_to_speech = {"blue": speech_blue,"green": speech_green,"red": speech_red}
	var descriptions = {"blue": speech_blue_description,"green": speech_green_description, "red": speech_red_description}
	var types = ["blue", "green", "red"]
	for type in types:
		add_inventory_item(type,names_to_speech[type], descriptions[type])

#DEBUG
func debug_setup_craft_compatibility():
	var craft_mapping_data = File.new()
	if not craft_mapping_data.file_exists("res://src/MenuInterfaces/InventoryMenu/craft_mappings.json"):
		print("ERROR: could not load craft_mappings.json")
		return 
	
	craft_mapping_data.open("res://src/MenuInterfaces/InventoryMenu/craft_mappings.json", File.READ)
	craft_mapping_data = craft_mapping_data.get_as_text()
	
	craft_mappings = parse_json(craft_mapping_data)
	if not typeof(craft_mappings) == TYPE_DICTIONARY:
		print("ERROR: craft mappings parse result invalid")
		return
	print(str(craft_mappings))
	
	for item in craft_mappings:
		pass

func describe_input_option_to_user():
	#TODO: determine how to structure this, and whether a singleton would be better
	if substate == "items_list_menu":
		if Input.is_action_just_pressed("menu_ui_right"):
			pass
		elif Input.is_action_just_pressed("menu_ui_left"):
			pass
		elif Input.is_action_just_pressed("menu_ui_repeat"):
			pass
		elif Input.is_action_just_pressed("inventory_menu_craft"):
			$InputAssistAudio.set_stream(speech_assist_craft)
			$InputAssistAudio.play()
		elif Input.is_action_just_pressed("inventory_menu_examine"):
			$InputAssistAudio.set_stream(speech_assist_examine)
			$InputAssistAudio.play()
		elif Input.is_action_just_pressed("menu_ui_cancel"):
			$InputAssistAudio.set_stream(speech_assist_cancel)
			$InputAssistAudio.play()
		elif Input.is_action_just_pressed("inventory_menu_consume"):
			$InputAssistAudio.set_stream(speech_assist_consume)
			$InputAssistAudio.play()
	elif substate == "items_craft_menu": # TODO: find a design pattern to eliminate this redundancy
		if Input.is_action_just_pressed("menu_ui_right"):
			pass
		elif Input.is_action_just_pressed("menu_ui_left"):
			pass
		elif Input.is_action_just_pressed("menu_ui_repeat"):
			pass
		elif Input.is_action_just_pressed("inventory_menu_craft"):
			$InputAssistAudio.set_stream(speech_assist_craft)
			$InputAssistAudio.play()
		elif Input.is_action_just_pressed("inventory_menu_examine"):
			$InputAssistAudio.set_stream(speech_assist_examine)
			$InputAssistAudio.play()
		elif Input.is_action_just_pressed("menu_ui_cancel"):
			$InputAssistAudio.set_stream(speech_assist_cancel_craft)
			$InputAssistAudio.play()
		elif Input.is_action_just_pressed("inventory_menu_consume"):
			$InputAssistAudio.set_stream(speech_assist_consume)
			$InputAssistAudio.play()

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
	if current_index == current_capacity - 1 or current_capacity == 0:
		if not debug_cycle_menu:
			alert_right_end_reached()
		else:
			inventory_items[0].stop_all_audio()
			current_index = 0	
	else:
		current_index = current_index + 1
	if current_capacity > 1:
		inventory_items[current_index-1].stop_all_audio()
	if current_capacity > 0:
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
	if current_capacity > 1:
		inventory_items[current_index+1].stop_all_audio()
	if current_capacity > 0:
		inventory_items[current_index].stop_all_audio()
	current_item_selected()

