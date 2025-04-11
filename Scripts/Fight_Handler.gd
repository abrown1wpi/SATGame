extends Node
@onready var char_base =  load("res://Scenes/Fight/Char_In_Fight.tscn")
var turn = true

func Calc_DMG():
	pass
	
func Create_Char():
	var player_instance = char_base.instantiate()
	player_instance.init(10, 10, "res://Art/Characters/Default.tres")
	add_child(player_instance)
	player_instance.position = Vector2(40, 450)
	player_instance.scale = Vector2(6,6)

func Pass_Turn():
	turn = !turn
