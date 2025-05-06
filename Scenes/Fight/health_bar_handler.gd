extends Control
@onready var hearts_parent = $CanvasLayer/HBoxContainer
@onready var heart_node = hearts_parent.get_child(0)

# Called when the node enters the scene tree for the first time.
var health : int
	
func init(h : int, pc : int):
	hearts_parent.scale = Vector2(5, 5)
	health = h
	for i in range(health):
		heart_node = hearts_parent.get_child(i)
		var dupe_heart = heart_node.duplicate()
		hearts_parent.add_child(dupe_heart)
	
	if (pc == 1):
		var last_heart = hearts_parent.get_child(health - 1)
		
		
