import random

def random_num_gen(n):
	return random.randint(1,n)

def main():
	arange = []
	for i in range(1,10001):
		x = random_num_gen(6)
		y = random_num_gen(6)
		z = random_num_gen(6)
		a = x + y + z
		arange.append(a)
	print(min(arange), max(arange), set(arange))

if __name__ == "__main__":
	main()