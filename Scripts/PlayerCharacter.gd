#artifact of unimplemented feature
# movement script for player

extends CharacterBody2D

const speed = 250

var current_dir = "none"

func _ready():
	$AnimatedSprite2D.play("Idle")

# moves the player character
func _physics_process(delta: float) -> void:
	player_movement(delta)

# sets the players movement. Currently only works for one direction at a time	
func player_movement(delta):
	
	if Input.is_action_pressed("ui_right"):
		play_animation(1)
		current_dir = "right"
		velocity.x = speed
		velocity.y = 0
	elif Input.is_action_pressed("ui_left"):
		play_animation(1)
		current_dir = "left"
		velocity.x = -speed
		velocity.y = 0
	elif Input.is_action_pressed("ui_up"):
		play_animation(1)
		current_dir = "up"
		velocity.y = -speed
		velocity.x = 0
	elif Input.is_action_pressed("ui_down"):
		play_animation(1)
		current_dir = "down"
		velocity.y = speed
		velocity.x = 0
	else:
		play_animation(0)
		velocity.y = 0
		velocity.x = 0
	
	move_and_slide()

func play_animation(movement):
	var dir = current_dir
	var anim = $AnimatedSprite2D
	
	if dir == "right":
		anim.flip_h = false
		if movement == 1:
			anim.play("Walk")
		elif movement == 0:
			anim.play("Idle")

	if dir == "left":
		anim.flip_h = true
		if movement == 1:
			anim.play("Walk")
		elif movement == 0:
			anim.play("Idle")		
