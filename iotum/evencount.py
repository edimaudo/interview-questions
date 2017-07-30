def is_even(num):
	output = 0
	if num % 2 == 0:
		output = num/2
	else:
		output = (num+1)/2
	return output 


def main():
	print(is_even(3))
	print(is_even(10))
	print(is_even(55))

if __name__ == "__main__":
	main()