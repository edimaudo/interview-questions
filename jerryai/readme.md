# Jerry AI data analyst interview questions
***

## Objective
Assess your analytical and coding skills. You can use any language and method of your choosing.


## Data analyst question
***
In order to push existing users to refer their friends, we're running a special reward program, in which the user is given an instant $10 discount for posting a referral message as their Facebook status. 
The message looks something like this:
"Check out this company Jerry.ai --they automatically checks if you’re paying the lowest price for insurance and they will also find the best quote for you. As a friend of mine, you can get $20 off your insurance purchase. Click here to get the $20 gift credit: ​jerry.ai​"
The user is given the option to post this message on his/her Facebook account during the purchase. Once they post this message, they instantly get the $10 discount on their purchase. In other words, we don't wait for any of their referred friends to actually signup with us before giving them the discount. We feel that doing this would make the users more likely to post the referral message.
Assume that this reward program has been running for a couple of months, and we have some data collected in our database. We want to know if running this program has been a good idea or not, i.e., are we acquiring new customers with it, or are we just losing money by giving out $10 discounts.
Assume that you have the following database tables: 'User' and Purchase'
Table User
id, name, referring_user_id
Table Purchase
id, user_id, date, total, discounts
In the Purchase table, the 'total' field contains the dollar amount of the job. The 'discounts' field consists of the total discounts given for the appointment (including rewards, coupon redemptions, etc.). Therefore, the customer pays: 'total' - 'discounts' as their final bill.

Given this data:
1) 'What' information would you derive from it, and 'how' will you derive it (you can give SQL queries, pseudo code, ... whatever you're comfortable with)
2) Using the information from Step 1), how would you make a recommendation on whether this rewards program should be continued or discontinued


## Coding Question
***
This is not a very simple problem, please take your time and try to get the code bug free if you can. You can use any programming language.

We are looking for a program that manages disjointed intervals of integers. E.g.: [[1, 3], [4, 6]] is a valid object gives two intervals. [[1, 3], [3, 6]] is not a valid object because it is not disjoint. [[1, 6]] is the intended result.
Empty array [] means no interval, it is the default/start state. We want you to implement two functions:
add(from, to) remove(from, to)
Here is an example sequence:
Start: []
Call: add(1, 5) => [[1, 5]]
Call: remove(2, 3) => [[1, 2], [3, 5]]
Call: add(6, 8) => [[1, 2], [3, 5], [6, 8]] Call: remove(4, 7) => [[1, 2], [3, 4], [7, 8]] Call: add(2, 7) => [[1, 8]] etc.


## Approach

- Understand problem from business and data perspective
- Outline assumptions
- Will use a combination of programming languages: R and python
- Will create toy data and have visualizations to explore data analysis aspect