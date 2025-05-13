extends Node2D

# sets up signals for Fight_Handler.gd
signal died
signal health_changed
# sets up class variables
var heal
var attack
var sprite_path : String
var cur_ani : String
var char_id
var prev_ani = ""
@onready var char_ani = $"Control/CharAni"

# automatically plays idle animation on start up
func _ready():
	cur_ani = "idle"

# calculates current health based on damage done
func do_dmg(change : int):
	heal -= change
	health_changed.emit()
	if (heal <= 0):
		died.emit()

# calculates current health based on healing done
func do_heal(change : int):
	heal += change
	health_changed.emit()

# returns the current health
func get_health() -> int:
	return heal
	
# makes sure an animation is playing every frame
func _process(_delta):
	if(cur_ani != prev_ani):
		char_ani.play(cur_ani)
		prev_ani=cur_ani

# sets class variables based on itialization parameters
func init(attack_strength : int, health: int, sprite_path_in: String, is_char_num : int) -> void:
	heal = health
	attack = attack_strength
	
	char_id = is_char_num
	
	sprite_path = sprite_path_in
	var frames_resource = load(sprite_path) as SpriteFrames
	char_ani.frames = frames_resource
	if (char_id == 1):
		char_ani.get_parent().scale.x = -1

# the following functions play the animation listed in the func title
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

# ensures that death animation only plays once
func _on_char_ani_animation_looped() -> void:
	if (cur_ani == "side_fight"):
		play_idle()
