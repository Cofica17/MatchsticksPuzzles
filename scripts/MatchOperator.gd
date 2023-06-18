@tool
extends Control
class_name MatchOperator

enum OPERATIONS {
	ADD,
	SUBTRACT,
	MULTIPLAY,
	DIVIDE,
	EQUAL
}

@export_enum("Add", "Subtract", "Multiply", "Divide", "Equal") var operator: int : set = set_operator

var data:Array
var operator_str:String

func _ready():
	set_operator(operator)

func set_operator(v):
	operator = v
	data = get_operator_data()[operator]
	adjust_textures()
	operator_str = get_operator_str()

func get_operator_str(op = operator):
	match op:
		OPERATIONS.ADD:
			return "+"
		OPERATIONS.SUBTRACT:
			return "-"
		OPERATIONS.MULTIPLAY:
			return "*"
		OPERATIONS.DIVIDE:
			return "/"
		OPERATIONS.EQUAL:
			return "="

func get_operator_from_data():
	var operator_data = get_operator_data()
	var counter = 0
	for op_data in operator_data:
		if arrays_equal(op_data, data):
			return get_operator_str(counter)
		counter += 1

func arrays_equal(arr1, arr2):
	for i in arr1.size():
		if arr1[i] is Array and arr2[i] is Array:
			if not arrays_equal(arr1[i], arr2[i]):
				return false
		else:
			if arr1[i] != arr2[i]:
				return false
	
	return true

func adjust_textures():
	var counter = 0
	
	for c in $TexturesContainer.get_children():
		c.hide()
	
	if data.is_empty():
		var s = $TexturesContainer.get_child_count()-1
		$TexturesContainer.get_child(s).visible = true
		$TexturesContainer.get_child(s-1).visible = true
		return
	
	for i in data:
		$TexturesContainer.get_child(counter).visible = i == 1
		counter += 1

func get_operator_data():
	var file = FileAccess.open("res://operator_data.json", FileAccess.READ)
	var data = JSON.parse_string(file.get_as_text())
	return data
