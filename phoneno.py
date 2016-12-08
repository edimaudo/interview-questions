import sys
import numpy


def generate_number(phone_info):
	try:
		info = [c for c in phone_info if c in '0123456789']
		if len(info) <= 3:
			return ''.join(info)
		elif len(info) % 3 == 0:
			output = [info[i:i+3] for i  in range(0, len(info), 3)]
			temp_output = ""
			for value in output:
				temp_output += "-" + "".join(value)
		else:
			output = []
			count = 0
			while (len(info) > 1):
				if len(info) > 4:
					count = 3
				else:
					count = 2
				output.append("-" + ''.join(info[:count]))
				info = info[count:]
			temp_output = "".join(output)
		return temp_output[1:]

	except:
		output = ""
		e = sys.exc_info()
		print(e)
		return output

def main():
	try:
		#test cases
		print(generate_number("00-44   48  55558361"))
		print(generate_number("0  -  22  1985--324"))
		print(generate_number("0  -  22"))
		print(generate_number("555372654"))
	except:
		e = sys.exc_info()
		print(e)
		sys.exit(1)

if __name__ == "__main__":
	main()