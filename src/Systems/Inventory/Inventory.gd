extends Node
class_name Inventory

var inventory_items
var max_capacity = 8

# TODO: define and load all inventory_item sounds in this interface
# GameWorld will populate the inventory menu with inventory items

# Define all GameWorld Resource Sounds
var speech_blue
var speech_green
var speech_red
# Called when the node enters the scene tree for the first time.
func _ready():
	speech_blue = load("res://src/MenuInterfaces/InventoryMenu/speech_blue.wav")
	speech_green = load("res://src/MenuInterfaces/InventoryMenu/speech_green.wav")
	speech_red = load("res://src/MenuInterfaces/InventoryMenu/speech_red.wav")

# DEBUG
func debug_load_inventory_items():
	var types = ["blue", "green", "red"]
	for type in types:
		add_inventory_item(type)

# TODO: determine how to migrate this method to the Inventory scene
func add_inventory_item(type):
	#var item_definition = gameworld_object_definitions["resources"][type]
	var pwd_path = "res://src/MenuInterfaces/InventoryMenu/"
	inventory_items.append(InventoryItem.instance())
	var current_capacity = len(inventory_items)
	add_child(inventory_items[current_capacity-1])
	inventory_items[current_capacity-1].set_type(type)
	#inventory_items[current_capacity-1].set_name_to_speech(load(pwd_path + item_definition["name"]))
	#inventory_items[current_capacity-1].set_description_to_speech(load(pwd_path + item_definition["description"]))
	#marked_for_craft.append(false)

func add_item_by_type():
	pass

func get_description_to_speech_at_index(index):
	if len(inventory_items) - 1 >= index:
		inventory_items[index].get_description_to_speech()
	return null

func get_free_spaces_count():
	return  max_capacity - len(inventory_items)

func get_item_at_index(index):
	if len(inventory_items) - 1 >= index:
		return inventory_items[index]
	return null
	
func get_name_to_speech_at_index(index):
	if len(inventory_items) - 1 >= index:
		inventory_items[index].get_name_to_speech()
	return null

func get_largest_index():
	return max(len(inventory_items)-1,0)

func get_item_count():
	return len(inventory_items)

func get_type_at_index(index):
	if len(inventory_items) - 1 >= index:
		inventory_items[index].get_type()
	return null

func has_multiple_items():
	if len(inventory_items) > 1:
		return true
	return false

func is_empty():
	if len(inventory_items) == 0:
		return true
	return false

func load_inventory():
	# TODO: load player inventory from serialized data in file system
	inventory_items = []

func remove_item_by_index(item_index):
	pass

