##Given an array of numbers, find the subset of the array with the most consecutive increasing numbers. 
##For example, in the array [2, 4, 3, 5, 6], 
##the answer would be [3, 5, 6].

from operator import itemgetter

def computeConsecutiveIncrease(alist):
    if len(alist) == 0:
        return []
    elif len(alist) == 1:
        return alist
    elif len(alist) == 2:
        if alist[0] <= alist[1]:
            return alist
        else:
            return alist[1]
    else:
        totalList = []
        temp = []
        temp.append(alist[0])
        endCheck = False
        count = 0
        while(not endCheck):
            if(count == len(alist)-1):
                totalList.append(temp)
                endCheck = True
                break
            else:
                if alist[count] <= alist[count+1]:
                    temp.append(alist[count+1])
                elif alist[count] > alist[count + 1]:
                    totalList.append(temp)
                    temp = []
                    temp.append(alist[count+1])
            count+=1
    output = []
    for value in totalList:
        output.append([value,len(value)])
    sorted_a = sorted(output, key = itemgetter(1))
    return sorted_a[len(sorted_a)-1][0]
    
                
def main():

    print(computeConsecutiveIncrease([4,3,5,6]))
    print(computeConsecutiveIncrease([3,4,5,6]))
    print(computeConsecutiveIncrease([3,4,5,2]))
    print(computeConsecutiveIncrease([2, 4, 3, 5, 6]))
    print(computeConsecutiveIncrease([8,9,7,2,3,6,5,1]))
    print(computeConsecutiveIncrease([4, 2]))

if __name__ == "__main__":
    main()