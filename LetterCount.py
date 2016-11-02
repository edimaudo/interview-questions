# Letter count
import math
def count_word(alist):
    count = 0
    for value in alist:
        count+=len(value)
    return count


def num2words(num):        
    units =  ["", "one", "two", "three", "four", "five", "six", "seven",
            "eight", "nine", "ten", "eleven", "twelve", "thirteen", "fourteen",
            "fifteen", "sixteen", "seventeen", "eighteen", "nineteen"]
    tens = ["","","twenty","thirty", "forty","fifty","sixty","seventy","eighty","ninety"]
    if num < 0:
        return "minus " + num2words(-num)
    elif num == 0:
        return "zero"
    elif num < 20:
        return units[num]
    elif num < 100:
        if num % 10 != 0:
            return tens[num // 10] + " " + units[num % 10] 
        return tens[num // 10]           
    elif num < 1000:
        if num % 100 != 0:
            return units[num // 100] + " hundred" + " " + num2words(num % 100)  
        return units[num // 100] + " hundred"   

    elif num < 1000000:
        if num % 1000 != 0:
            return num2words(num // 1000) + " thousand" + " " + num2words(num % 1000)
        return num2words(num // 1000) + " thousand" 
        



def main():
    words = [num2words(value) for value in range(1,1001)]
    #print(words)
    print(count_word(words))
   


if __name__ == "__main__":
    main()




