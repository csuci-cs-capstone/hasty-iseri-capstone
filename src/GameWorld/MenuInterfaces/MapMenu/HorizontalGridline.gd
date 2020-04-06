extends Area2D

signal area_entered_modified
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	self.connect("area_entered",self,"on_Area_entered")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func on_Area_entered(area_id):
	emit_signal("area_entered_modified", area_id, self)
