extends Node

var inventory_items
var max_capacity

# TODO: define and load all inventory_item sounds in this interface
# GameWorld will populate the inventory menu with inventory items
var speech_blue
var speech_green
var speech_red
# Called when the node enters the scene tree for the first time.
func _ready():
	speech_blue = load("res://src/MenuInterfaces/InventoryMenu/speech_blue.wav")
	speech_green = load("res://src/MenuInterfaces/InventoryMenu/speech_green.wav")
	speech_red = load("res://src/MenuInterfaces/InventoryMenu/speech_red.wav")

func add_item_to_inventory():
	pass

func load_item_inventory():
	# TODO: load player inventory from serialized data in file system
	# (this logic can possibly move somewhere else but for now keep it here)
	pass

func remove_item_from_inventory():
	pass

