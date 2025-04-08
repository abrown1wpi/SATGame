class_name QuestionData

var question : String
var answer : String
var incorrect_answers : Array[String]

func print_stuff():
	print("Question: " + question + ", Answer: " + answer + " Wrong answers: " + incorrect_answers[0])
