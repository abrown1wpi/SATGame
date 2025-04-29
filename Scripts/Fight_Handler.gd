extends Node

var rng = RandomNumberGenerator.new()
@onready var char_base =  load("res://Scenes/Fight/Char_In_Fight.tscn")

@onready var q_popup = $"/root/Fight/Window"
@onready var option_container = $"/root/Fight/CanvasLayer/VBoxContainer"
@onready var question_label = $"/root/Fight/Window/Control/Question_Label"
@onready var congrat_label = $"/root/Fight/Window/Control/Congrat_Label"
@onready var answer_choices = [$/root/Fight/Window/Control/VBoxContainer/Answer_1, $/root/Fight/Window/Control/VBoxContainer/Answer_2, $/root/Fight/Window/Control/VBoxContainer/Answer_3, $/root/Fight/Window/Control/VBoxContainer/Answer_4]
@onready var correct_answer

var turn = true

# 0 is pc, 1 is enemy
var char_list = []

func Calc_DMG(character : int) -> int:
	return char_list[character].attack
	
func Create_Char(path : String, vector : Vector2):
	var player_instance = char_base.instantiate()
	player_instance.call_deferred("init", 10, 100, path)
	add_child(player_instance)
	player_instance.position = vector
	player_instance.scale = Vector2(6,6)
	
	char_list.append(player_instance)
	
func On_Question(questions):	
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
		
func answer_choice(button) -> void:
	var dmg = 0
	for i in range (0, answer_choices.size()):
		answer_choices[i].hide()
	
	if button.text == correct_answer:
		congrat_label.set_text("Congrats! That is right")
		dmg = Calc_DMG(0)
	else:
		congrat_label.set_text("Womp womp")
			
	congrat_label.show()
	char_list[1].set_health(dmg)
	
	await get_tree().create_timer(1.5).timeout
	
	q_popup.hide()
	option_container.hide()
	char_list[0].play_side_fight()
	enemy_turn()
	
func enemy_turn():
	var dmg = 0
	var hit = rng.randi_range(0,1)
	if (hit == 1):
		dmg = Calc_DMG(1)
	
	char_list[0].set_health(dmg)
	
	option_container.show()
		
	
