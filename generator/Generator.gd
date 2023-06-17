extends Control

@onready var container = $VBoxContainer


func _on_solve_btn_pressed():
	solve_algorithm()

func solve_algorithm():
	for c in container.get_children():
		var org_arr = c.data.duplicate()
		var counter_i = 0
		
		#Take each match one by one
		for i in c.data:
			if i is Array:
				var counter_j = 0
				for j in i:
					if j == 1:
						c.data[counter_i][counter_j] = 0
					counter_j += 1
			else:
				if i == 1:
					c.data[counter_i] = 0
			
			#If no match, place the one take in that place and try to solve the eq
			for c2 in container.get_children():
				var counter_j = 0
				var org_arr2 = c2.data.duplicate()
				for j in c2.data:
					if j is Array:
						var counter_k = 0
						for k in j:
							if k == 0:
								c2.data[counter_j][counter_k] = 1
								print(c2.data)
								solve_eq()
							counter_k += 1
					else:
						if j == 0:
							c2.data[counter_j] = 1
							solve_eq()
					counter_j +=1
				c2.data = org_arr2
			counter_i += 1
		
		c.data = org_arr

func solve_eq():
	return
	var eq = ""
	var expected_result = container.get_child(container.get_child_count()-1).number
	var ex = Expression.new()
	
	var counter = 0
	for c in container.get_children():
		if counter == container.get_child_count()-2:
			break
		if c is MatchNumber:
			var num = c.get_number_from_data()
			print(num)
			if not num:
				print("Invalid eq")
				return
			eq += str(num)
		elif c is MatchOperator:
			var op = c.get_operator_from_data()
			if not op:
				print("Invalid eq")
				return
			eq += op
		counter += 1
	
	print(eq)
	if ex.parse(eq) == OK:
		print(ex.execute())
