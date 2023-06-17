@tool
extends Control

enum OPERATIONS {
	ADD,
	SUBTRACT,
	MULTIPLAY,
	DIVIDE,
	EQUAL
}

@export_enum("Add", "Subtract", "Multiply", "Divide", "Equal") var operator: int : set = set_operator

var operator_data:Array

func set_operator(v):
	operator = v
	operator_data = get_operator_data()[operator]
	adjust_textures()

func adjust_textures():
	var counter = 0
	
	for c in $TexturesContainer.get_children():
		c.hide()
	
	if operator_data.is_empty():
		var s = $TexturesContainer.get_child_count()-1
		$TexturesContainer.get_child(s).visible = true
		$TexturesContainer.get_child(s-1).visible = true
		return
	
	for i in operator_data:
		$TexturesContainer.get_child(counter).visible = i == 1
		counter += 1

func get_operator_data():
	var file = FileAccess.open("res://operator_data.json", FileAccess.READ)
	var data = JSON.parse_string(file.get_as_text())
	return data
