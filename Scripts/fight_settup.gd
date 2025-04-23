extends Node2D

var questions : q_Handler = q_Handler.new()
var rng = RandomNumberGenerator.new()

@onready var q_popup = $"Window"
@onready var option_container = $"CanvasLayer/VBoxContainer"

@onready var congrat_label = $"Window/Control/Congrat_Label"
@onready var answer_choices = [$Window/Control/VBoxContainer/Answer_1, $Window/Control/VBoxContainer/Answer_2, $Window/Control/VBoxContainer/Answer_3, $Window/Control/VBoxContainer/Answer_4]

@onready var handler = $"Fight_Handler"

@export var stopwatch_label : Label

var stopwatch : Stopwatch

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("reached")
	handler.Create_Char("res://Art/Characters/Monkey_Fight_Sprites.tres", Vector2(40, 450))
	option_container.show()
	stopwatch = get_tree().get_first_node_in_group("stopwatch")
	
	questions.fight_start()
	q_popup.hide()
	congrat_label.hide()
	
	for i in range (0, answer_choices.size()):
		var button = answer_choices[i]
		button.pressed.connect(Callable(handler.answer_choice).bind(button))

#func _process(delta: float) -> void:
#	stopwatch_label.text = stopwatch.time_to_string()
	
func _on_attack_pressed() -> void:
	handler.On_Question(questions, rng)

func _on_window_close_requested() -> void:
	q_popup.hide()




	


	
	
