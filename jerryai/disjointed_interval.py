def add(value1, value2):
	print(value1)

def remove(value1, value2):
	print(value1)


def main():
	print("program")



Call: add(1, 5) => [[1, 5]]
Call: remove(2, 3) => [[1, 2], [3, 5]]
Call: add(6, 8) => [[1, 2], [3, 5], [6, 8]] Call: remove(4, 7) => [[1, 2], [3, 4], [7, 8]] Call: add(2, 7) => [[1, 8]] etc.

if __name__ == "__main__":
	main()
