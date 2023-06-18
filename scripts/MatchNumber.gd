@tool
extends Control
class_name MatchNumber

@export var number:int = 0 : set = set_number

@onready var textures_container = $TexturesContainer

var data = []

func _ready():
	set_number(number)

func set_number(num):
	number = num
	update_number_data()
	update_textures()

func update_number_data():
	data = get_numbers_data()[number]

func get_number_from_data():
	var numbers_data = get_numbers_data()
	var counter = 0
	for number_data in numbers_data: 
		if arrays_equal(number_data, data):
			return counter
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

func update_textures():
	var counter = 0
	
	for i in data:
		for j in i:
			$TexturesContainer.get_child(counter).visible = j == 1
			counter += 1

func get_numbers_data():
	var file = FileAccess.open("res://number_data.json", FileAccess.READ)
	var numbers_data = JSON.parse_string(file.get_as_text())
	return numbers_data
