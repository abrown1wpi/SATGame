extends Node2D

signal died
var heal
var attack
var sprite_path : String
var cur_ani : String
var char_id
@onready var char_ani = $"Control/CharAni"
@onready var h_bar = $"Control/ProgressBar"

func _ready():
	cur_ani = "idle"

func do_dmg(change : int):
	heal -= change
	h_bar.value = heal
	if (heal <= 0):
		died.emit()

func do_heal(change : int):
	heal += change
	h_bar.value = heal

func get_health() -> int:
	return heal
	
func _process(_delta):
	char_ani.play(cur_ani)

func init(attack_strength : int, health: int, sprite_path_in: String, is_char_num : int) -> void:
	heal = health
	attack = attack_strength
	
	char_id = is_char_num
	
	sprite_path = sprite_path_in
	var frames_resource = load(sprite_path) as SpriteFrames
	char_ani.frames = frames_resource

func play_death():
	cur_ani = "death"
	
func play_walk():
	cur_ani = "walk"
	
func play_side_fight():
	cur_ani = "side_fight"
	
func play_front_fight():
	cur_ani = "front_fight"

func play_idle():
	cur_ani = "idle"

func _on_char_ani_animation_looped() -> void:
	if (cur_ani == "side_fight"):
		play_idle()
