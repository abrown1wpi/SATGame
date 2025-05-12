extends Control
@onready var hearts_parent = $CanvasLayer/Control/HBoxContainer
@onready var heart_node = hearts_parent.get_child(0)

# Called when the node enters the scene tree for the first time.
var cur_health : int
var og_health : int
	
func init(h : int, pc : int):
	hearts_parent.scale = Vector2(5, 5)
	cur_health = h
	og_health = cur_health
	for i in range(cur_health - 1):
		heart_node = hearts_parent.get_child(i)
		var dupe_heart = heart_node.duplicate()
		hearts_parent.add_child(dupe_heart)
	
	if (pc == 1):
		var wrapper = hearts_parent.get_parent()
		wrapper.anchor_right = 1
		wrapper.anchor_left = 1
		wrapper.offset_right = -20
		wrapper.offset_left = -290
		
func change_health(h : int):
	var num_change = og_health - h
	if (h > cur_health):
		hearts_parent.get_child(og_health - h).show()
	if (h < cur_health):
		for i in range (num_change):
			hearts_parent.get_child(i).hide()
	
	cur_health = h
	
