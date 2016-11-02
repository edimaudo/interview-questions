#Fizz Buzz Chanllenge


for value in range(1,101):
    if value % 15 == 0:
        print(str(value) + ": FizzBuzz")
    elif value % 3 == 0:
        print(str(value) + ": Fizz")
    elif value % 5 == 0:
        print(str(value) + ": Buzz")
    else:
        print(str(value) + ": Not FizzBuzz or Fizz or Buzz ")
