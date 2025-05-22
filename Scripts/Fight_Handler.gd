extends Node

# importing rng
var rng = RandomNumberGenerator.new()

# initianting class variables
var type_choice : String
var fight_over = false

# Connects a variable to each node in the scene to allow for control
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
@onready var congrat_texture = $"../Window/Control/TextureRect"
@onready var correct_answer
@onready var hitmiss_scene = load("res://Scenes/hitmiss.tscn")

# starts on players turn
var turn = true

# 0 is pc, 1 is enemy
var char_list = []
var health_list = []

# will calculate the damage based on the characters attack variable
func Calc_DMG(character : int) -> int:
	return char_list[character].attack
	
# creates a character within the tree
func Create_Char(path : String, vector : Vector2, is_char : int, health : int):
	#initiation the character and initiating parameters
	var player_instance = char_base.instantiate()
	player_instance.call_deferred("init", 1, health, path, is_char)
	
	#adding the character to the screen
	add_child(player_instance)
	player_instance.position = vector
	player_instance.scale = Vector2(6,6)
	
	# adding the health bar
	var health_bar = health_bar_base.instantiate()
	health_bar.call_deferred("init", health, is_char)
	add_child(health_bar)
	
	# connecting buttons to functions and the character/health to lists for easy access
	char_list.append(player_instance)
	health_list.append(health_bar)
	player_instance.died.connect(Callable(end_fight.bind(is_char)))
	player_instance.health_changed.connect(Callable(_on_health_changed.bind(is_char)))
	
# called when the player requests a question
func On_Question(questions, type : String):	
	
	# setting up the screen (hiding question request buttons)
	for i in range (0, answer_choices.size()):
		answer_choices[i].show()
	congrat_label.hide()
	
	# attack or heal (a or h)
	type_choice = type
	
	# getting a question and placing the answers in a list
	var rand_question = rng.randi_range(0, questions.questions.size()-1)
	correct_answer = questions.questions.get(rand_question).answer
	var q_answer_list = [questions.questions.get(rand_question).answer]
	q_answer_list.append_array(questions.questions.get(rand_question).incorrect_answers)
	
	# shuffleing the answer list
	q_answer_list.shuffle()

	# showing the question pop up and setting the answers to text in buttons
	q_popup.show()
	question_label.set_text(questions.questions.get(rand_question).question)
	for i in range (0, answer_choices.size()):
		answer_choices[i].set_text(q_answer_list[i])
	
# called when character makes a choice with the button they clicked as a param
func answer_choice(button) -> void:
	var dmg = 0
	var heal = 0
	
	# hides choices
	for i in range (0, answer_choices.size()):
		answer_choices[i].hide()
	char_list[0].play_side_fight()
	
	# prints result of submitted answer
	if button.text == correct_answer:
		congrat_label.set_text("Congrats! That is right")
		if (type_choice == "a"):
			dmg = 1
			show_floating_text("Hit", Color.GREEN, char_list[0])
		if (type_choice == "h"):
			heal = 1
			show_floating_text("+1 Health", Color.GREEN, char_list[0])
	else:
		if (type_choice == "a"):
			show_floating_text("Miss", Color.RED, char_list[0])
		if (type_choice == "h"):
			show_floating_text("Heal Failed", Color.RED, char_list[0])
		congrat_label.set_text("Womp womp")
	
	# shows the label and does the damage to the 
	congrat_label.show()
	char_list[1].do_dmg(dmg)
	char_list[0].do_heal(heal)
	
	# cretes timer so user can read response
	await get_tree().create_timer(1.5).timeout
	
	# hides question pop up
	q_popup.hide()
	option_container.hide()
	
	if (fight_over):
		return
	
	# allows the enemy to fight
	enemy_turn()

# does the enemy's turn
func enemy_turn():
	# checks if the fight is alreadt over
	if (fight_over):
		return
		
	# calculates if hits or no (50% chance)
	var dmg = 0
	var hit = rng.randi_range(0,1)
	await get_tree().create_timer(1.5).timeout
	if (hit == 1):
		dmg = Calc_DMG(1)
		show_floating_text("Hit", Color.GREEN, char_list[1])
	else:
		show_floating_text("Miss", Color.RED, char_list[1])
	
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
	
func show_floating_text(text: String, color: Color, target_node: Node2D):
	var text_instance = hitmiss_scene.instantiate()
	text_instance.set_text(text, color)
	text_instance.global_position = target_node.global_position + Vector2(0, -40)
	get_tree().current_scene.add_child(text_instance)


# gets health change from the character and sends it to the hearts
#detects when health is changed inside char list and changes the number of hearts shown using the hearts list
func _on_health_changed(id : int):
	var cur_health = char_list[id].get_health()
	
	health_list[id].change_health(cur_health)

#reloads the scene
func load_scene():
	call_deferred("_deferred_load_scene")

#defers all from load scene and ensures it doesn't run on start up
func _deferred_load_scene():
	get_tree().change_scene_to_file("res://Scenes/fight.tscn")
	
		
	
