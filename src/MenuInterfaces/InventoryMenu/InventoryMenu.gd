extends Control

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var current_index
var inventory_items
var max_capacity
var selected_for_craft

var debug_cycle_menu = false
# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if Input.is_action_pressed("menu_ui_right"):
		select_next_item()
	elif Input.is_action_pressed("menu_ui_left"):
		select_next_item()

func accept_current_item():
	pass

func alert_left_end_reached():
	pass
	
func alert_right_end_reached():
	pass

func load_inventory_items(items):
	inventory_items = items
	
func select_next_item():
	if current_index == max_capacity - 1:
		if not debug_cycle_menu:
			alert_right_end_reached()
		else:
			current_index = 0
	else:
		current_index = current_index + 1
		#TODO: modify this code so that the audio feedback methods of the current menu item
		# are invoked in every case where a menu edge has not been hit 
		
func select_previous_item():
	if current_index == 0:
		if not debug_cycle_menu:
			alert_left_end_reached()
		else:
			current_index = max_capacity - 1
	else:
		current_index = current_index - 1
