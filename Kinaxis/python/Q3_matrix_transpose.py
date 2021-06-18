## Matrix Transpose
def matrix_transpose(m):
	if len(m) < 1:
		return []
	return [[m[j][i] for j in range(len(m))] for i in range(len(m[0]))]

def matrix_output(m):
	for row in m:
		print(row)


m = [[1,2,3]]
print("Matrix Input")           
matrix_output(m)
print("")
print("Matrix Output")
matrix_output(matrix_transpose(m))






