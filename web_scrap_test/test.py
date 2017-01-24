"""
goal: scrap data from website and get info from 100 most popular threads and output to csv
csv headers - link_to_thread, name_of_thread, views, replies, last_post_time, last_post_date
link - http://www.f150ecoboost.net/forum/42-2015-ford-f150-ecoboost-chat
build using python 2.7 Anaconda package on MacOS Sierra
The chrome driver is attached as part of the solution
It should be reconfigured before running if it placed in a differ
Assumption -  popularity is  based on the number of views, the higher the number of views, the more popular the post is
"""

from selenium import webdriver
from selenium.webdriver.support.ui import WebDriverWait
from selenium.common.exceptions import NoSuchElementException
import sys
import csv
import os
from datetime import datetime, timedelta

path = "/Users/Edima/Desktop/web_scrap_test/" #change as needed
path_to_chromedriver = path  + 'chromedriver' 
driver = webdriver.Chrome(path_to_chromedriver)
BASE_URL = "http://www.f150ecoboost.net/forum/42-2015-ford-f150-ecoboost-chat"
driver.get(BASE_URL)
driver.maximize_window()
driver.wait = WebDriverWait(driver, 1)
try:
	count = 0
	output = []

	#sort by views in descending order
	sort_info = "?sort=views&amp;order=desc"
	BASE_URL  = BASE_URL + sort_info
	driver.get(BASE_URL)
	driver.implicitly_wait(1)
	countCheck = True

	while(countCheck):
		if count==5:
			countCheck = False
			break
		else:
			#thread_data = thread_info.find_elements_by_tag_name("li")
			thread_form = driver.find_element_by_id("thread_inlinemod_form")
			thread_info = thread_form.find_element_by_id("threads")
			thread_data = thread_info.find_elements_by_css_selector(".threadbit.hot")
			for thread in thread_data:
				try:
					temp_output = ["","","","","",""]
					#data_level = thread.find_element_by_css_selector(".rating0.nonsticky")
					data_level = thread.find_element_by_class_name("nonsticky")
			 		
			 		#get links
				 	title_link_1 = data_level.find_element_by_class_name("threadinfo")
			 		title_link_2 = title_link_1.find_element_by_class_name("inner")
			 		title_link_3 = title_link_2.find_element_by_class_name("threadtitle")

				 	temp_output[0] = title_link_3.find_element_by_css_selector('a').get_attribute('href')
				 	temp_output[1] = title_link_3.find_element_by_css_selector('a').text	

					#get views and replies
					stat_link_1 = data_level.find_element_by_class_name("threadstats")
					stat_link_2 =  stat_link_1.find_elements_by_tag_name("li")
					metrics_temp = [stat.text for stat in stat_link_2]
						
					temp_output[2] = metrics_temp[0][8:]
					temp_output[3] = metrics_temp[1][7:]
					
					# #thread date and time
					date_link_1 = data_level.find_element_by_class_name("threadlastpost")
					date_link_2 = date_link_1.find_elements_by_tag_name("dd")
					date_temp = [dd.text for dd in date_link_2]
					date_temp_2 = date_temp[1].split(",")

					
					if date_temp_2[0] == "Yesterday":
						d = datetime.today() - timedelta(1)
						temp_output[4] = d.strftime("%m-%d-%Y")
					elif date_temp_2 == "Today":
						d = datetime.today()
						temp_output[4] = d.strftime("%m-%d-%Y")
					else:
						temp_output[4] = date_temp_2[0]

					temp_output[5] = date_temp_2[1]	

					output.append(temp_output)
					
				except NoSuchElementException:
					continue
			count+=1
			next_link_1 = driver.find_element_by_id("below_threadlist")
			next_link_2 = next_link_1.find_element_by_id("yui-gen36")
			next_link_3 = next_link_2.find_elements_by_class_name("prev_next")
		 	next_url = [link.find_element_by_css_selector('a').get_attribute('href') for link in next_link_3]

		 	BASE_URL = next_url[-1]
			driver.get(BASE_URL)
			driver.implicitly_wait(1)	
	
	#delete old csv if it exists
	try:
		fileinfo = os.listdir(path)
		for filename in fileinfo:
			if filename[-3:] == "csv":
				os.remove(path+"/"+filename)
	except IOError:
		pass

	#output to csv
	header = ['link_to_thread', 'name_of_thread', 'views', 'replies', 'last_post_time', 'last_post_date']
	with open(path + 'thread.csv', 'a') as csv_file:
		w = csv.writer(csv_file)
		w.writerow(header)
		for data in output:
			w.writerow(data)
	driver.quit()

except:
	e = sys.exc_info()
	print(e)
	driver.quit()
	sys.exit(1)