extends Control

@onready var container = $VBoxContainer

func _on_generate_pressed():
	var solutions = []
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	var counter = 0
	while solutions.is_empty():
		for c in container.get_children():
			if c is MatchNumber:
				var rnd_num = rng.randi_range(0,9)
				c.set_number(rnd_num)
			if c is MatchOperator and c.operator != MatchOperator.OPERATIONS.EQUAL:
				var rnd_num = rng.randi_range(0,3)
				c.set_operator(3)
		
		if solve_eq().is_empty():
			solutions.append_array(solve_algorithm())
		counter += 1
	print(solutions)

func _on_solve_btn_pressed():
	var solutions = solve_algorithm()
	print("found the solution")
	if solutions.is_empty():return
	for s in solutions:
		print(s)

func solve_algorithm():
	var solutions = []
	for c in container.get_children():
		if c is MatchNumber:
			var counter_column_data = 0
			for column_data in c.data:
				var counter_bit = 0
				for bit in column_data:
					if bit == 1:
						c.data[counter_column_data][counter_bit] = 0
						solutions.append_array(try_putting_one_match())
						c.data[counter_column_data][counter_bit] = 1
					counter_bit += 1
				counter_column_data += 1
		elif c is MatchOperator:
			var counter_bit = 0
			for bit in c.data:
				if bit == 1:
					c.data[counter_bit] = 0
					solutions.append_array(try_putting_one_match())
					c.data[counter_bit] = 1
				counter_bit += 1
	return solutions

func try_putting_one_match():
	var solutions = []
	for c2 in container.get_children():
		if c2 is MatchNumber:
			var counter_column_data2 = 0
			for column_data2 in c2.data:
				var counter_bit2 = 0
				for bit2 in column_data2:
					if bit2 == 0:
						c2.data[counter_column_data2][counter_bit2] = 1
						solutions.append_array(solve_eq())
						c2.data[counter_column_data2][counter_bit2] = 0
					counter_bit2 += 1
				counter_column_data2 += 1
		elif c2 is MatchOperator:
			var counter_bit2 = 0
			for bit2 in c2.data:
				if bit2 == 0:
					c2.data[counter_bit2] = 1
					solutions.append_array(solve_eq())
					c2.data[counter_bit2] = 0
				counter_bit2 += 1
	return solutions

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
				return []
			eq += str(num)+".0"
		elif c is MatchOperator:
			var op = c.get_operator_from_data()
			if op == null:
				return []
			eq += op
		counter += 1
	
	if ex.parse(eq) == OK:
		var result = ex.execute()
		var ex_result = container.get_child(container.get_child_count()-1).get_number_from_data()
		if ex_result and result == ex_result:
			var solution = eq+"="+str(ex_result)
			return [solution]
		else:
			return []
	else:
		return []
