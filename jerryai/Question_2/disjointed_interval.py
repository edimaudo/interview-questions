# We are looking for a program that manages disjointed intervals of integers. E.g.: [[1, 3], [4, 6]] is a valid object 
# gives two intervals. [[1, 3], [3, 6]] is not a valid object because it is not disjoint. [[1, 6]] is the intended result.
# Empty array [] means no interval, it is the default/start state. We want you to implement two functions:
# add(from, to) remove(from, to)
# Here is an example sequence:
# Start: []
# Call: add(1, 5) => [[1, 5]]
# Call: remove(2, 3) => [[1, 2], [3, 5]]
# Call: add(6, 8) => [[1, 2], [3, 5], [6, 8]] Call: remove(4, 7) => [[1, 2], [3, 4], [7, 8]] Call: add(2, 7) => [[1, 8]] etc.


def add(value1, value2):
	print(value1)

def remove(value1, value2):
	print(value1)


def main():
	disjointed_interval = []
	add(1,5)
	print(disjointed_interval)
	remove(2,3)
	print(disjointed_interval)
	add(6,8)
	remove(4,7)
	add(2,7)


if __name__ == "__main__":
	main()
