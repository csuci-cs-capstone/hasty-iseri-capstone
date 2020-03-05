extends Node


var paused_state = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func load_inventory_items():
	pass

func open_map_menu_interface():
	# TODO: load tactile map scene and configure data for:
	# player position, waypoint(s), resources
	populate_tactile_map_with_marker_data()
	pass

func open_inventory_menu_interface():
	# TODO: load inventory menu scene and configure data for:
	# TODO: define data that needs to be injected into InventoryMenu
	populate_tactile_map_with_marker_data()
	pass

func populate_tactile_map_with_marker_data():
	pass

