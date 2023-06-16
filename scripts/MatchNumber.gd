@tool
extends Control

@export var number:int = 0 : set = set_number

@onready var textures_container = $TexturesContainer

var number_data = []

func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func set_number(num):
	number = num
	update_number_data()
	adjust_textures()
	print("yep2")
	print($TexturesContainer)

func update_number_data():
	number_data = get_numbers_data()[number]

func adjust_textures():
	var counter = 0
	
	for i in number_data:
		for j in i:
			$TexturesContainer.get_child(counter).visible = j == 1
			counter += 1

func get_numbers_data():
	var file = FileAccess.open("res://number_data.json", FileAccess.READ)
	var numbers_data = JSON.parse_string(file.get_as_text())
	return numbers_data
