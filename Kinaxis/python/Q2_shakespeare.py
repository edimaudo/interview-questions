import sys
import csv
import io

def main():
	try:
		even_list = []
		odd_list = []
		both_list = []
		count = 1
		with open('shakespeare.txt', 'r') as txtfile:
			for row in txtfile:
				row = row.rstrip("\r\n")
				if (count % 2 == 0):
					even_list.extend(row.split())
				else:
					odd_list.extend(row.split())
				count+=1
		
		even_line_set = set(even_list)
		both_list= list(even_line_set.intersection(odd_list))
		even_list = list(set(even_list))
		odd_list = list(set(odd_list))
		both_list.sort()
		even_list.sort()
		odd_list.sort()
		print("All row items")
		print("")
		print(both_list)
		print("")
		print("Even row Items")
		print("")
		print(even_list)
		print("")
		print("Odd row Items")
		print("")
		print(odd_list)
		


				
	except:
		e = sys.exc_info()
		print(e)
		sys.exit(1)

if __name__ == "__main__":
	main()