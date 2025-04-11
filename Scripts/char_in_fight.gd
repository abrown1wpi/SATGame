extends Node2D

var stats : Char_Fight
var sprite_path : String
@onready var char_ani = $"Control/CharAni"

func init(attack_strength, health, sprite_path_in) -> void:
	stats = Char_Fight.new()
	stats.attack_mult = attack_strength
	stats.health = health
	
	sprite_path = sprite_path_in
	
#func _ready() -> void:
#	char_ani.sprite_frames = load(sprite_path)
	
