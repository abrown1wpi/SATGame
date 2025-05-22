class_name UtilFuncs

# grabs and parses JSON data
static func load_json_from_path(path : String):
	var file_string = FileAccess.get_file_as_string(path)
	var json_data
	
	if file_string != null:
		json_data = JSON.parse_string(file_string)
	
	else:
		push_error("Failed to parse JSON data. Null ", path)
		
	return json_data
