extends Node2D

var questions : Question_Handler = Question_Handler.new()
var rng = RandomNumberGenerator.new()

@onready var q_popup = $"Window"
@onready var question_label = $"Window/Control/Question_Label"
@onready var congrat_label = $"Window/Control/Congrat_Label"
@onready var answer_choices = [$Window/Control/VBoxContainer/Answer_1, $Window/Control/VBoxContainer/Answer_2, $Window/Control/VBoxContainer/Answer_3, $Window/Control/VBoxContainer/Answer_4]
@onready var correct_answer
@onready var char_base =  load("res://Scenes/Fight/Char_In_Fight.tscn")

@export var stopwatch_label : Label

var stopwatch : Stopwatch

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	stopwatch = get_tree().get_first_node_in_group("stopwatch")
	
	questions.fight_start()
	q_popup.hide()
	congrat_label.hide()
	
	for i in range (0, answer_choices.size()):
		var button = answer_choices[i]
		button.pressed.connect(Callable(_on_answer_choice).bind(button))
	
	var player_instance = char_base.instantiate()
	player_instance.init(10, 10, "res://Art/Characters/Monkey_Fight_Sprites.tres")
	add_child(player_instance)
	player_instance.position = Vector2(300, 200)

func _process(delta: float) -> void:
	stopwatch_label.text = stopwatch.time_to_string()
	
func _on_attack_pressed() -> void:
	On_Question()

func _on_window_close_requested() -> void:
	q_popup.hide()

func On_Question():	
	for i in range (0, answer_choices.size()):
		answer_choices[i].show()
	congrat_label.hide()
		
	var rand_question = rng.randi_range(0, questions.questions.size()-1)
	correct_answer = questions.questions.get(rand_question).answer
	var q_answer_list = [questions.questions.get(rand_question).answer]
	q_answer_list.append_array(questions.questions.get(rand_question).incorrect_answers)
	
	q_answer_list.shuffle()


	q_popup.show()
	question_label.set_text(questions.questions.get(rand_question).question)
	for i in range (0, answer_choices.size()):
		answer_choices[i].set_text(q_answer_list[i])


func _on_answer_choice(button) -> void:
	for i in range (0, answer_choices.size()):
		answer_choices[i].hide()
	
	if button.text == correct_answer:
		congrat_label.set_text("Gongrats. That is right")
	else:
		congrat_label.set_text("Womp womp")
			
	congrat_label.show()


	
	
