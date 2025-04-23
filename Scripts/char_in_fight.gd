extends Node2D

var stats : Char_Fight
var sprite_path : String
var cur_ani : String
@onready var char_ani = $"Control/CharAni"

func _ready():
	cur_ani = "idle"
	
func _process(delta):
	char_ani.play(cur_ani)

func init(attack_strength : int, health: int, sprite_path_in: String) -> void:
	stats = Char_Fight.new()
	stats.attack_mult = attack_strength
	stats.health = health
	
	sprite_path = sprite_path_in
	var frames_resource = load(sprite_path) as SpriteFrames
	char_ani.frames = frames_resource

func play_death():
	cur_ani = "death"
