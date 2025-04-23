extends Node
@onready var char_base =  load("res://Scenes/Fight/Char_In_Fight.tscn")

@onready var q_popup = $"/root/Fight/Window"
@onready var option_container = $"/root/Fight/CanvasLayer/VBoxContainer"
@onready var question_label = $"/root/Fight/Window/Control/Question_Label"
@onready var congrat_label = $"/root/Fight/Window/Control/Congrat_Label"
@onready var answer_choices = [$/root/Fight/Window/Control/VBoxContainer/Answer_1, $/root/Fight/Window/Control/VBoxContainer/Answer_2, $/root/Fight/Window/Control/VBoxContainer/Answer_3, $/root/Fight/Window/Control/VBoxContainer/Answer_4]
@onready var correct_answer

var turn = true

func Calc_DMG():
	pass
	
func Create_Char(path : String, vector : Vector2):
	var player_instance = char_base.instantiate()
	player_instance.call_deferred("init", 10, 100, path)
	add_child(player_instance)
	player_instance.position = vector
	player_instance.scale = Vector2(6,6)

func Pass_Turn():
	turn = !turn
	
func On_Question(questions, rng):	
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
	for i in range (0, answer_choices.size()):
		answer_choices[i].hide()
	
	if button.text == correct_answer:
		congrat_label.set_text("Gongrats. That is right")
		Calc_DMG()
	else:
		congrat_label.set_text("Womp womp")
			
	congrat_label.show()
	
	await get_tree().create_timer(1.5).timeout
	
	q_popup.hide()
	option_container.hide()

	
