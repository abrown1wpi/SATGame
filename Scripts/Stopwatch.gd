#artifact of unimplemented feature
extends Node

class_name Stopwatch

var time = 0.0
var is_counting = true

func _process(delta: float) -> void:
	if (!is_counting):
		return
		
	time += delta
	
func reset():
	time = 0.0
	
func time_to_string() -> String:
	var ret_stringform = "%02d"
	var tet_string = ret_stringform % [fmod(time, 60)]
	return tet_string
