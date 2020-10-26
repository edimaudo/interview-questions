# We are looking for a program that manages disjointed disjointed_intervals of integers. E.g.: [[1, 3], [4, 6]] is a valid object 
# gives two disjointed_intervals. [[1, 3], [3, 6]] is not a valid object because it is not disjoint. [[1, 6]] is the intended result.
# Empty array [] means no disjointed_interval, it is the default/start state. We want you to implement two functions:
# disjointed_interval = add(from, to,disjointed_interval) disjointed_interval = remove(from, to,disjointed_interval)
# Here is an example sequence:
# Start: []
# Call: disjointed_interval = add(1, 5,disjointed_interval) => [[1, 5]]
# Call: disjointed_interval = remove(2, 3,disjointed_interval) => [[1, 2], [3, 5]]
# Call: disjointed_interval = add(6, 8,disjointed_interval) => [[1, 2], [3, 5], [6, 8]] 
# Call: disjointed_interval = remove(4, 7,disjointed_interval) => [[1, 2], [3, 4], [7, 8]] 
# Call: disjointed_interval = add(2, 7,disjointed_interval) => [[1, 8]] etc.


def add(value1, value2,interval):
	if (type(value1) != int) or (type(value2) != int): 
		return (interval)
	elif (len(interval) < 1):
		interval.append([value1,value2])
		return (interval)
	else: #update
		min_value = interval[0][0]
		max_value = interval[len(interval)-1][1]
		if (value1 > min_value) and (value1 > max_value):
			interval.append([value1,value2])
		elif (value1 < min_value) and (value1 < max_value):
			interval.insert(0,[value1,value2])


		return interval



def remove(value1, value2,interval):
	print(interval)

def main():
	disjointed_interval = []
	disjointed_interval = add(1,5,disjointed_interval)
	disjointed_interval = add(10,20,disjointed_interval)
	disjointed_interval = add(-10, -2,disjointed_interval)
	print(disjointed_interval)

	
	# disjointed_interval = add(20,100,disjointed_interval)
	# disjointed_interval = add(20, 21,disjointed_interval)
	# disjointed_interval = add(2, 4,disjointed_interval)
	# disjointed_interval = add(3, 8,disjointed_interval)
	# #disjointed_interval = remove(10, 10,disjointed_interval)
	# #disjointed_interval = remove(10, 26,disjointed_interval)
	# #disjointed_interval = remove(35, 47,disjointed_interval)
	# #disjointed_interval = remove(3, 19,disjointed_interval)
	# #disjointed_interval = remove(3, 200,disjointed_interval)
	# disjointed_interval = add(5, 200,disjointed_interval)
	# #disjointed_interval = remove(0, 5,disjointed_interval)
	# disjointed_interval = add(-10, 5,disjointed_interval)
	# #disjointed_interval = remove(-5, 2,disjointed_interval)
	# #disjointed_interval = remove(-15, 50,disjointed_interval)
	# #disjointed_interval = remove(40, 51,disjointed_interval)



if __name__ == "__main__":
	main()
