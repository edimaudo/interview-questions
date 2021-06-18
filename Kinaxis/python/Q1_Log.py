## Log

import sys
import csv
import io
import pandas as pd

def main():
	try:
		row_info = []
		time_info = []
		stats = {}
		with open('access_log.log', 'r') as logfile:
			for row in logfile:
				row = row.rstrip("\r\n")
				row_info.append(row.split())
		for info in row_info:
			time_info.append(info[3][13:15])
		for timedata in time_info:
			if timedata in stats:
				stats[timedata]+=1
			else:
				stats[timedata]=1
		time_output = pd.DataFrame(stats.items(), columns=['Hour', 'Count'])
		print(time_output)

	except:
		e = sys.exc_info()
		print(e)
		sys.exit(1)


if __name__ == "__main__":
	main()