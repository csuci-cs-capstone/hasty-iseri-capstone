extends Control

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var current_index
var inventory_items = []
var marked_for_craft = []
var max_capacity = 8 # TODO: this value should be loaded from the Inventory scene system

var audio_craft_success_sound = load("res://src/MenuInterfaces/InventoryMenu/441812__fst180081__180081-hammer-on-anvil-01.wav")
var audio_craft_failed_sound = load("res://src/MenuInterfaces/InventoryMenu/141334__lluiset7__error-2.wav")
var audio_close_craft_alert = load("res://src/MenuInterfaces/InventoryMenu/141334__lluiset7__error-2.wav")
var audio_free_space = load("res://src/MenuInterfaces/InventoryMenu/411221__andersholm__rustling-of-chips-bag.wav")
var audio_mark_for_craft = load("res://src/MenuInterfaces/InventoryMenu/418850__kierankeegan__rachet-click.wav")
var audio_navigate_sound = load("res://src/MenuInterfaces/213148__complex-waveform__click.wav")
var audio_occupied_space = load("res://src/MenuInterfaces/InventoryMenu/TylerHasty_key01.wav")
var audio_unmark_for_craft = load("res://src/MenuInterfaces/419494__plasterbrain__high-tech-ui-cancel.wav")

var speech_assist_examine = load("res://src/MenuInterfaces/InventoryMenu/speech_assist_examine.wav")
var speech_assist_consume = load("res://src/MenuInterfaces/InventoryMenu/speech_assist_consume.wav")
var speech_assist_craft = load("res://src/MenuInterfaces/InventoryMenu/speech_assist_craft.wav")
var speech_assist_cancel = load("res://src/MenuInterfaces/InventoryMenu/speech_assist_cancel.wav")
var speech_assist_cancel_craft = load("res://src/MenuInterfaces/InventoryMenu/speech_assist_cancel_craft_1.wav")
var speech_free_spaces = load("res://src/MenuInterfaces/InventoryMenu/speech_free_spaces.wav")
var speech_marked_for_craft = load("res://src/MenuInterfaces/InventoryMenu/speech_marked_for_craft.wav")
var speech_none = load("res://src/MenuInterfaces/InventoryMenu/speech_none.wav")
var speech_occupied_spaces = load("res://src/MenuInterfaces/InventoryMenu/speech_occupied_spaces.wav")

# DEBUG
var craft_mappings = {}
var gameworld_object_definitions
var InventoryItem
const DEBUG_WHISPER_VOLUME = -33
const DEBUG_WHISPER_DELAY_LEFT = .22
const DEBUG_WHISPER_DELAY_RIGHT = .32

var whisper_delay_left_timer_active = false
var whisper_delay_right_timer_active = false

# Called when the node enters the scene tree for the first time.
func _ready():
	InventoryItem = load("res://src/MenuInterfaces/InventoryMenu/InventoryItem.tscn")
	current_index = 0
	debug_configure_audio_bus()
	debug_load_item_definitions()
	debug_load_inventory_items()
	current_item_selected()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Input.is_action_pressed("menu_ui_assist"):
		describe_input_option_to_user()
	else:
		if Input.is_action_just_pressed("menu_ui_right"):
			stop_all_audio()
			navigate_to_item("next")
		elif Input.is_action_just_pressed("menu_ui_left"):
			stop_all_audio()
			navigate_to_item("previous")
		elif Input.is_action_just_pressed("menu_ui_repeat"):
			stop_all_audio()
			current_item_selected()
		elif Input.is_action_just_pressed("inventory_menu_craft"):
			stop_all_audio()
			toggle_current_item_craft_mark()
		elif Input.is_action_just_pressed("inventory_menu_examine"):
			stop_all_audio()
			examine_selected_item()
		elif Input.is_action_just_pressed("inventory_menu_consume"):
			stop_all_audio()
			consume_selected_item()
		elif Input.is_action_just_pressed("inventory_menu_confirm_craft"):
			stop_all_audio()
			attempt_craft_with_marked_items()
		elif Input.is_action_just_pressed("inventory_menu_get_status"):
			stop_all_audio()
			read_status()

# TODO: determine how to migrate this method to the Inventory scene
func add_inventory_item(type):
	var item_definition = gameworld_object_definitions["resources"][type]
	var pwd_path = "res://src/MenuInterfaces/InventoryMenu/"
	inventory_items.append(InventoryItem.instance())
	var current_capacity = len(inventory_items)
	add_child(inventory_items[current_capacity-1])
	inventory_items[current_capacity-1].set_type(type)
	inventory_items[current_capacity-1].set_name_to_speech(load(pwd_path + item_definition["name"]))
	inventory_items[current_capacity-1].set_description_to_speech(load(pwd_path + item_definition["description"]))
	marked_for_craft.append(false)

func alert_left_end_reached():
	if not $AlertLeftEndReached.is_playing():
		$AlertLeftEndReached.play()
		Input.start_joy_vibration (0, 0, .8, .2)
		
func alert_is_marked_for_craft():
	Input.start_joy_vibration (0, 1, 0, .08)
	
func alert_right_end_reached():
	if not $AlertRightEndReached.is_playing():
		$AlertRightEndReached.play()
		Input.start_joy_vibration (0, 0, .8, .2)

func attempt_craft_with_marked_items():
	var items_to_craft_indecies = get_items_to_craft_indecies()
	var item_index = 0
	var craft_result = get_craft_result(items_to_craft_indecies)
	if craft_result:
		issue_craft_success_feedback()
		remove_crafted_items_from_inventory()
		add_inventory_item(craft_result)
		current_index= max(len(inventory_items) - 1, 0)
		current_item_selected()
	else:
		issue_craft_failed_feedback()
			
	clear_marked_for_craft_via_indecies(items_to_craft_indecies)
	
func clear_marked_for_craft_via_indecies(item_indecies):
	for item_index in item_indecies:
		marked_for_craft[item_index] = false

# TODO: initialize consumption mechanic
func consume_selected_item():
	pass

func current_item_selected(end_reached=false):
	if len(inventory_items) > 0:
		$WhisperAudioPlayerQueue.add_primary_stream(inventory_items[current_index].get_name_to_speech())
		if len(inventory_items) > 1:
			if current_index > 0:
				$WhisperAudioPlayerQueue.add_whisper_left_stream(inventory_items[current_index-1].get_name_to_speech(), 
						DEBUG_WHISPER_DELAY_LEFT)
			if current_index < len(inventory_items) - 1:
				$WhisperAudioPlayerQueue.add_whisper_right_stream(inventory_items[current_index+1].get_name_to_speech(), 
						DEBUG_WHISPER_DELAY_RIGHT)
		$WhisperAudioPlayerQueue.commit()
		if marked_for_craft[current_index] and not end_reached:
			alert_is_marked_for_craft()
		
#DEBUG
func debug_configure_audio_bus():
	AudioServer.set_bus_volume_db (1, DEBUG_WHISPER_VOLUME)
	AudioServer.set_bus_volume_db (2, DEBUG_WHISPER_VOLUME)

#DEBUG
func debug_load_item_definitions():
	var gameworld_object_definitions_data = File.new()
	var file_name = "res://src/gameworld_object_definitions.json"
	if not gameworld_object_definitions_data.file_exists(file_name):
		print("ERROR: could not load %s" % file_name)
		return 
		
	gameworld_object_definitions_data.open(file_name, File.READ)
	gameworld_object_definitions_data = gameworld_object_definitions_data.get_as_text()
	
	gameworld_object_definitions = parse_json(gameworld_object_definitions_data)
	if not typeof(gameworld_object_definitions) == TYPE_DICTIONARY:
		print("ERROR: gameworld_object_definitions parse result invalid; is type " + str(typeof(gameworld_object_definitions)))
		return

	for resource_type in gameworld_object_definitions["resources"].keys():
		craft_mappings[resource_type] = gameworld_object_definitions["resources"][resource_type]["craft_mappings"]

#DEBUG
func debug_load_inventory_items():
	var types = ["blue", "green", "red"]
	for type in types:
		add_inventory_item(type)

func describe_input_option_to_user():
	#TODO: determine how to structure this, and whether a singleton would be better

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

func examine_selected_item():
	$WhisperAudioPlayerQueue.add_primary_stream(inventory_items[current_index].get_name_to_speech())
	$WhisperAudioPlayerQueue.commit()
	$WhisperAudioPlayerQueue.add_primary_stream(inventory_items[current_index].get_description_to_speech())
	$WhisperAudioPlayerQueue.commit()

func get_craft_result(items_to_craft_indecies):
	if items_to_craft_indecies:
		var items_to_craft = get_items_to_craft(items_to_craft_indecies)

		for craft_result in craft_mappings.keys():
			for craft_mapping in craft_mappings[craft_result]:
				print("craft mapping: " + str(craft_mapping))
				craft_mapping.sort()
				if craft_mapping == items_to_craft:
					return craft_result
	return false

func get_items_to_craft(items_to_craft_indecies):
	var items_to_craft = []
	for item_index in items_to_craft_indecies:
		items_to_craft.append(inventory_items[item_index].get_type())
	items_to_craft.sort()
	return items_to_craft

func get_items_to_craft_indecies():
	var items_to_craft_indecies = []
	var item_index = 0
	while item_index < len(inventory_items):
		if marked_for_craft[item_index]:
			items_to_craft_indecies.append(item_index)
		item_index = item_index + 1
	return items_to_craft_indecies

func issue_craft_failed_feedback():
	$SimpleSFXQueue.add(audio_craft_failed_sound)

func issue_craft_success_feedback():
	$SimpleSFXQueue.add(audio_craft_success_sound)

func list_free_spaces():
	var index = 0
	var number_of_free_spaces = max_capacity - len(inventory_items)
	$WhisperAudioPlayerQueue.add_primary_stream(speech_free_spaces)
	$WhisperAudioPlayerQueue.commit()
	if number_of_free_spaces > 0:
		while index < number_of_free_spaces:
			$WhisperAudioPlayerQueue.add_primary_stream(audio_free_space)
			$WhisperAudioPlayerQueue.commit()
			index = index + 1
	else:
		$WhisperAudioPlayerQueue.add_primary_stream(speech_none)
		$WhisperAudioPlayerQueue.commit()
			
func list_items_marked_for_craft():
	var index = 0
	var items_marked_for_craft = false
	
	for item in marked_for_craft:
		if item:
			items_marked_for_craft = true
			break

	$WhisperAudioPlayerQueue.add_primary_stream(speech_marked_for_craft)
	$WhisperAudioPlayerQueue.commit()
	
	if items_marked_for_craft:
		while index < len(inventory_items):
			if marked_for_craft[index]:
				$WhisperAudioPlayerQueue.add_primary_stream(inventory_items[index].get_name_to_speech())
				$WhisperAudioPlayerQueue.commit()
			index = index + 1
	else:
		$WhisperAudioPlayerQueue.add_primary_stream(speech_none)
		$WhisperAudioPlayerQueue.commit()

func list_occupied_spaces():
	var index = 0
	$WhisperAudioPlayerQueue.add_primary_stream(speech_occupied_spaces)
	$WhisperAudioPlayerQueue.commit()
	if len(inventory_items) > 0:
		while index < len(inventory_items):
			$WhisperAudioPlayerQueue.add_primary_stream(audio_occupied_space)
			$WhisperAudioPlayerQueue.commit()
			index = index + 1
	else:
		$WhisperAudioPlayerQueue.add_primary_stream(speech_none)
		$WhisperAudioPlayerQueue.commit()

func load_menu_end_alert_positions():
	# TODO: use screen resolution to position 2D Audio alert nodes for reaching menu end
	pass

func navigate_to_item(direction):
	var end_reached = false
	var add_val = 0
	Input.stop_joy_vibration(0)
	stop_all_audio()
	if direction == "next":
		if current_index == max(len(inventory_items) - 1, 0):
			alert_right_end_reached()
			end_reached = true
		else:
			add_val = 1
	elif direction == "previous":
		if current_index == 0:
			alert_left_end_reached()
			end_reached = true
		else:
			add_val = -1
			
	current_index = current_index + add_val
	if len(inventory_items) > 1:
		$WhisperAudioPlayerQueue.add_primary_stream(audio_navigate_sound)
		$WhisperAudioPlayerQueue.commit()
	current_item_selected(end_reached)

func on_WhisperDelayLeft_timeout():	
	if current_index > 0:
		inventory_items[current_index-1].whisper_name_left()

func on_WhisperDelayRight_timeout():
	if current_index < len(inventory_items) - 1:
		inventory_items[current_index+1].whisper_name_right()

func queue_whisper_left_stream(stream):
	$WhisperLeftAudioPlayer.set_stream(stream)

func queue_whisper_right_stream(stream):
	$WhisperRightAudioPlayer.set_stream(stream)

func read_status():
	list_occupied_spaces()
	list_free_spaces()
	list_items_marked_for_craft()

func remove_crafted_items_from_inventory():
	var updated_inventory_items = []
	var item_index = 0
	while item_index < len(inventory_items):
		if not marked_for_craft[item_index]:
			updated_inventory_items.append(inventory_items[item_index])
		item_index = item_index + 1
	inventory_items = updated_inventory_items

func set_whisper_delay_left(delay):
	$WhisperDelayLeft.wait_time = delay
	
func set_whisper_delay_right(delay):
	$WhisperDelayRight.wait_time = delay

func stop_all_audio():
	$WhisperAudioPlayerQueue.stop_and_clear()
	$SimpleSFXQueue.stop_and_clear()

func stop_all_feedback():
	stop_all_audio()
	Input.stop_joy_vibration(0)

func toggle_current_item_craft_mark():
	var audio_alert = false
	if not marked_for_craft[current_index]:
		$SimpleSFXQueue.add(audio_mark_for_craft)
		#$WhisperAudioPlayerQueue.add_primary_stream(audio_mark_for_craft)
		#$WhisperAudioPlayerQueue.commit()
		alert_is_marked_for_craft()
	else:
		$SimpleSFXQueue.add(audio_unmark_for_craft)
		#$WhisperAudioPlayerQueue.add_primary_stream(audio_unmark_for_craft)
		#$WhisperAudioPlayerQueue.commit()

	$WhisperAudioPlayerQueue.add_primary_stream(inventory_items[current_index].get_name_to_speech())
	$WhisperAudioPlayerQueue.commit()
	marked_for_craft[current_index] = not marked_for_craft[current_index]

	
