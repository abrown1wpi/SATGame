extends Node2D

@export var float_speed := 30.0
@export var lifespan := 2.0

var time_alive := 0.0

func _ready():
	# Start bounce animation using create_tween
	scale = Vector2(1, 1) 
	var tween := create_tween()
	tween.tween_property(self, "scale", Vector2(3, 3), 0.2).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)


func _process(delta):
	time_alive += delta
	position.y -= float_speed * delta
	modulate.a = lerp(1.0, 0.0, time_alive / lifespan)
	if time_alive >= lifespan:
		queue_free()

func set_text(text: String, color: Color = Color.WHITE):
	$TextLabel.text = text
	$TextLabel.modulate = color
