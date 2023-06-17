extends Control

@onready var container = $VBoxContainer


func _on_solve_btn_pressed():
	solve_algorithm()

func solve_algorithm():
	for c in container.get_children():
		if c is MatchNumber:
			var counter_column_data = 0
			for column_data in c.data:
				var counter_bit = 0
				for bit in column_data:
					if bit == 1:
						c.data[counter_column_data][counter_bit] = 0
						for c2 in container.get_children():
							if c2 is MatchNumber:
								var counter_column_data2 = 0
								for column_data2 in c2.data:
									var counter_bit2 = 0
									for bit2 in column_data2:
										if bit2 == 0:
											c2.data[counter_column_data2][counter_bit2] = 1
											solve_eq()
											c2.data[counter_column_data2][counter_bit2] = 0
										counter_bit2 += 1
									counter_column_data2 += 1
						c.data[counter_column_data][counter_bit] = 1
					counter_bit += 1
				counter_column_data += 1

func solve_eq():
	var eq = ""
	var expected_result = container.get_child(container.get_child_count()-1).number
	var ex = Expression.new()
	
	var counter = 0
	for c in container.get_children():
		if counter == container.get_child_count()-2:
			break
		if c is MatchNumber:
			var num = c.get_number_from_data()
			if num == null:
				return
			eq += str(num)
		elif c is MatchOperator:
			var op = c.get_operator_from_data()
			if op == null:
				return
			eq += op
		counter += 1
	
	if ex.parse(eq) == OK:
		var result = ex.execute()
		if result == container.get_child(container.get_child_count()-1).get_number_from_data():
			print("found the solution")
			print(eq)
