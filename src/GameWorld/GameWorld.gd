extends Node

var paused = false
var gameworld_object_configurations
var gameworld_resource_craft_mappings = {}
var inventory
# Called when the node enters the scene tree for the first time.
func _ready():
	load_object_configurations()
	load_inventory()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if not paused:
		if Input.is_action_just_pressed("gameworld_open_inventory_menu"):
			open_inventory_menu()

func configure_gameworld_artifact(gameworld_object):
	pass # TODO

func configure_gameworld_objects():
	var gameworld_objects = $Objects.get_children()
	for gameworld_object in gameworld_objects:
		if gameworld_object.is_in_group("artifacts"):
			configure_gameworld_artifact(gameworld_object)
		elif gameworld_object.is_in_group("obstacles"):
			configure_gameworld_obstacle(gameworld_object)
		elif gameworld_object.is_in_group("resources"):
			configure_gameworld_resource(gameworld_object)
		elif gameworld_object.is_in_group("waypoints"):
			configure_gameworld_waypoint(gameworld_object)

func configure_gameworld_obstacle(gameworld_object):
	pass # TODO
	
func configure_gameworld_resource(gameworld_object):
	pass # TODO

func configure_gameworld_waypoint(gameworld_object):
	pass # TODO

func load_inventory():
	inventory = Inventory.new()
	inventory.load_gameworld_resource_configurations(gameworld_object_configurations['resources'])
	inventory.load_items()
	self.add_child(inventory)

func load_object_configurations():
	var gameworld_object_configurations_data = File.new()
	var file_name = "res://src/GameWorld/gameworld_object_definitions.json"
	if not gameworld_object_configurations_data.file_exists(file_name):
		print("ERROR: could not load %s" % file_name)
		return 
		
	gameworld_object_configurations_data.open(file_name, File.READ)
	gameworld_object_configurations_data = gameworld_object_configurations_data.get_as_text()
	
	gameworld_object_configurations = parse_json(gameworld_object_configurations_data)
	if not typeof(gameworld_object_configurations) == TYPE_DICTIONARY:
		print("ERROR: gameworld_object_definitions parse result invalid; is type " + str(typeof(gameworld_object_configurations)))
		return

	for resource_type in gameworld_object_configurations["resources"].keys():
		gameworld_resource_craft_mappings[resource_type] = gameworld_object_configurations["resources"][resource_type]["craft_mappings"]

func open_map_menu():
	# TODO: load tactile map scene and configure data for:
	# player position, waypoint(s), resources
	populate_tactile_map_with_marker_data()
	pass

func open_inventory_menu():
	var inventory_menu = InventoryMenu.new()
	inventory_menu.load_craft_mappings(gameworld_resource_craft_mappings)
	inventory_menu.load_inventory(inventory)
	add_child(inventory_menu)
	paused = true

func populate_tactile_map_with_marker_data():
	pass
