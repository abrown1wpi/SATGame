extends Node

var rng = RandomNumberGenerator.new()
var type_choice : String
var fight_over = false

@onready var char_base =  load("res://Scenes/Fight/Char_In_Fight.tscn")
@onready var health_bar_base = load("res://Scenes/Fight/Heart_Bar.tscn")
@onready var death_window = $"/root/Fight/Death_Window"
@onready var death_label = $"/root/Fight/Death_Window/Control/Death"
@onready var play_again = $"/root/Fight/Death_Window/Control/Play_Again"
@onready var q_popup = $"/root/Fight/Window"
@onready var option_container = $"/root/Fight/CanvasLayer/VBoxContainer"
@onready var question_label = $"/root/Fight/Window/Control/Question_Label"
@onready var congrat_label = $"/root/Fight/Window/Control/Congrat_Label"
@onready var answer_choices = [$/root/Fight/Window/Control/VBoxContainer/Answer_1, $/root/Fight/Window/Control/VBoxContainer/Answer_2, $/root/Fight/Window/Control/VBoxContainer/Answer_3, $/root/Fight/Window/Control/VBoxContainer/Answer_4]
@onready var correct_answer

var turn = true

# 0 is pc, 1 is enemy
var char_list = []
var health_list = []

func Calc_DMG(character : int) -> int:
	return char_list[character].attack
	
func Create_Char(path : String, vector : Vector2, is_char : int):
	var player_instance = char_base.instantiate()
	player_instance.call_deferred("init", 10, 10, path, is_char)
	add_child(player_instance)
	player_instance.position = vector
	player_instance.scale = Vector2(6,6)
	
	var health_bar = health_bar_base.instantiate()
	health_bar.call_deferred("init", 5, is_char)
	add_child(health_bar)
	
	char_list.append(player_instance)
	player_instance.died.connect(Callable(end_fight.bind(is_char)))
	
func On_Question(questions, type : String):	
	for i in range (0, answer_choices.size()):
		answer_choices[i].show()
	congrat_label.hide()
	
	type_choice = type
		
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
	var heal = 0
	for i in range (0, answer_choices.size()):
		answer_choices[i].hide()
	char_list[0].play_side_fight()
	
	if button.text == correct_answer:
		congrat_label.set_text("Congrats! That is right")
		dmg = Calc_DMG(0)
		if (type_choice == "a"):
			dmg = Calc_DMG(0)
		if (type_choice == "h"):
			heal = 10
	else:
		congrat_label.set_text("Womp womp")
			
	congrat_label.show()
	char_list[1].do_dmg(dmg)
	char_list[0].do_heal(heal)
	
	await get_tree().create_timer(1.5).timeout
	
	q_popup.hide()
	option_container.hide()
	
	if (fight_over):
		return
	
	enemy_turn()
	
func enemy_turn():
	if (fight_over):
		return
	var dmg = 0
	var hit = rng.randi_range(0,1)
	await get_tree().create_timer(1.5).timeout
	if (hit == 1):
		dmg = Calc_DMG(1)
		print("hit")
	
	char_list[0].do_dmg(dmg)
	char_list[1].play_side_fight()
	
	option_container.show()
	
func end_fight(id):
	fight_over = true
	q_popup.hide()
	option_container.hide()
	
	if (id == 0):
		death_label.set_text("You Lost")
		char_list[0].play_death()
	if (id == 1):
		death_label.set_text("Won")
		char_list[1].play_death()
	
	await get_tree().create_timer(1).timeout
	death_label.show()
	death_window.show()
	play_again.show()

func load_scene():
	call_deferred("_deferred_load_scene")

func _deferred_load_scene():
	get_tree().change_scene_to_file("res://Scenes/fight.tscn")
	
		
	
