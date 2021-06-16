# Python Problem

This question will test some basic knowledge of Python programming.  These
questions should not take more than one hour to complete.

## Python

Python can be downloaded at https://www.python.org/downloads/ .  You may use
any version of Python (2 or 3) but please specify which version you are using.
You shouldn't need to use any other packages except for the ones included in
the standard Python distribution.  However if you are using an external
library, please be sure to include which packages you are using.

## Problems

Provide a separate `.py` file for each question unless otherwise specified.

1. Please refer to `access_log.log`, which contains a text file with a sample
   of a website's access log.  Write a Python script to find the top 10 most
   common hours of access and how many access requests that hour had.  For
   example these are some sample input lines from the access log file:

        64.242.88.10 - - [07/Mar/2004:16:05:49 -0800] "GET /twiki/bin/edit/Main/Double_bounce_sender?topicparent=Main.ConfigurationVariables HTTP/1.1" 401 12846
        64.242.88.10 - - [07/Mar/2004:19:03:58 -0800] "GET /twiki/bin/edit/Main/Message_size_limit?topicparent=Main.ConfigurationVariables HTTP/1.1" 401 12846
        206-15-133-154.dialup.ziplink.net - - [11/Mar/2004:16:33:23 -0800] "HEAD /twiki/bin/view/Main/SpamAssassinDeleting HTTP/1.1" 200 0

   The access date is specified in the `[ ]` brackets.  The access hours for
   this example are `16`, `19`, and `16` respectively.  In this case, your
   script should output:

        Hour    Count
        16      2
        19      1

2. Please refer to `shakespeare.txt`, which contains some text that has been
   cleaned of punctuation and upper case letters.  Write a Python script to
   find and return the list of unique words in sorted order as follows:

   both_list = Common to both even and odd lines.
   even_list = Only on even lines.
   odd_list = Only on odd lines.

   Here is a sample of the expected output (`...` denote text that was omitted
   from the sample output for brevity):

        both_list returns:
        ['a', 'all', 'am', 'and', 'as', 'bear', ...]

        odd_list returns:
        ['abuses', 'action', 'after', 'amaze', 'arrows', ...]

        even_list returns:
        ['about', 'across', 'acursing', 'against', 'an', 'appal', ...]

3. Write a Python script to find and return the transpose of a given matrix. Recall the transpose of a   
   matrix is when a matrix is flipped over its diagonal. In other words, the row and column indices are switched.

   The input should be a list of lists, where each list represents a row in the matrix.

   Example: 

   Input: [[1,2,3],
           [4,5,6],
           [7,8,9]]
   
   Output: [[1,4,7],
            [2,5,8],
            [3,6,9]] 

4. Please refer to `measurement.csv`, which contains daily forecast data.
   
   The file contains a table with the following columns:
      - `category`: Category data for the item
      - `item`: Item key
      - `store`: Store key
      - `date`: Date
      - `week`: Week
      - `units`: Actual Units
      - `forecast`: Forecasted Units

   In this question, you will be measuring forecast accuracy. You may use libraries such as `pandas` to do the calculations.

   Write a Python script that calculates the WMAPE, UC (underforecast contribution) and OC (overforecast contribution) for the following roll up levels:
 
   1. Item and Week
   2. Store and Category and Week

   Example:

   To calculate the WMAPE at the "Store and Category and Week" level, group the data at that level and sum up the forecast and unit values for each group. For example:

         store    category    week           units        forecast                          
         1680     Juices      2018-07-26  712.415872   519.690890
                              2018-08-02  5515.617022  4211.349235
                              2018-08-09  5512.416409  4574.719692
                              2018-08-16  5132.237881  4285.263385
                              2018-08-23  5640.101169  4615.695825
                              2018-08-30  1387.234042  1387.903876
                  Salads      2018-07-26  510.543357   512.327636
                              2018-08-02  3523.618312  3238.820970
                              2018-08-09  3884.939404  3463.462373
                              2018-08-16  4288.129004  4113.773500
                              2018-08-23  3693.539500  3852.151081
                              2018-08-30  941.315767   1007.889452
         99280    Juices      2018-07-26  680.000000   649.642916
                              2018-08-02  5879.577492  5103.340383
                              2018-08-09  6021.760187  5938.118760

   After the roll up is performed, WMAPE, OC and UC can be calculated.

   Your script should only output the WMAPE, OC, UC for each roll up level:

         WMAPE    OC       UC 
         0.096    0.075    0.021