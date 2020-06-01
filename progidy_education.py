# Function for nth Fibonacci number 
  
FibArray = [0,1] 
  
def fibonacci(n): 
    a = 0
    b = 1
    if n < 0: 
        print("Incorrect input") 
    elif n == 0: 
        return a 
    elif n == 1: 
        return b 
    else: 
        for i in range(2,n): 
            c = a + b 
            a = b 
            b = c 
        return b 
  
# Driver Program 
  


def main():
	print(fibonacci(7777))


if __name__ == "__main__":
	main()