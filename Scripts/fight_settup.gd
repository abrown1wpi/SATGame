extends Node2D

var questions : q_Handler = q_Handler.new()
var rng = RandomNumberGenerator.new()

# path to screen elements
@onready var q_popup = $"Window"
@onready var option_container = $"CanvasLayer/VBoxContainer"
@onready var death_window = $"Death_Window"
@onready var death_label = $"Death_Window/Control/Death"
@onready var play_again = $"Death_Window/Control/Play_Again"
@onready var congrat_label = $"Window/Control/Congrat_Label"
@onready var answer_choices = [$Window/Control/VBoxContainer/Answer_1, $Window/Control/VBoxContainer/Answer_2, $Window/Control/VBoxContainer/Answer_3, $Window/Control/VBoxContainer/Answer_4]
@onready var handler = $"Fight_Handler"

# artifact - see stopwatch.gd
@export var stopwatch_label : Label

var stopwatch : Stopwatch

# Called when the node enters the scene tree for the first time.
# Initializes the handler and creates the characters
# Initializes questions and sets the default state for all screen elements
# Connects buttons to answer choice in handler
func _ready() -> void:
	handler.Create_Char("res://Art/Characters/Monkey_Fight_Sprites.tres", Vector2(40, 450),0, 5)
	handler.Create_Char("res://Art/Characters/Gorilla.tres", Vector2(1050, 450), 1, 5)
	option_container.show()
	stopwatch = get_tree().get_first_node_in_group("stopwatch")
	
	questions.fight_start()
	q_popup.hide()
	congrat_label.hide()
	death_label.hide()
	death_window.hide()
	play_again.hide()
	
	for i in range (0, answer_choices.size()):
		var button = answer_choices[i]
		button.pressed.connect(Callable(handler.answer_choice).bind(button))
	play_again.pressed.connect(handler.load_scene)
	
# The following functions bind option buttons to handler on question
func _on_attack_pressed() -> void:
	handler.On_Question(questions, "a")
	
func _on_heal_pressed() -> void:
	handler.On_Question(questions, "h")
	
func _on_escape_pressed() -> void:
	handler.end_fight(0)
	
