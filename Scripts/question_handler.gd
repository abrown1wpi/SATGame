extends Resource
class_name q_Handler

# hardcodes question data location
var question_data_path = "res://Data/questionsJSON.json"

var questions : Dictionary

# triggered by fight_settup.gd and grabs and parses data into a dictionary
func fight_start():
	var json_data = UtilFuncs.load_json_from_path(question_data_path)
	
	if json_data != null:
		var question_data = json_data.get("Questions")
		if question_data != null:
			for i in range(0, question_data.size()):
				questions[i] = parse_question_data(i, question_data[str(i)])
	else:
		print("No data")
			
			

# parses the data
func parse_question_data(_id, json_data : Dictionary):
	var question_data : QuestionData = QuestionData.new()
	
	question_data.answer = str(json_data["C_ANSWER"])
	question_data.question = json_data["QUESTION"]
	question_data.incorrect_answers = [str(json_data["ANSWER_1"]), str(json_data["ANSWER_2"]), str(json_data["ANSWER_3"])]
	#question_data.explanation = str(json_data["EXPLANATION"])
	
	return question_data
	
