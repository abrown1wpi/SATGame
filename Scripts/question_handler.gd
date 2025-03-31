extends Resource

var questionDataPath = "res://Data/gamespread.json"

func fight_start():
	var json_data = UtilFuncs.load_json_from_path(questionDataPath)
	
