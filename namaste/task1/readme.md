## Task 1: Python. Data Manipulation and usage of external APIs
In your first task, we would like you to consolidate your orders along with an exchange rate for the date of the order creations. This way, orders prices can be unified in Canadian Dollars (CAD), the currency that the Finance department of Namaste uses to report on.

For this purpose, we suggest you to use the free currency exchange rate API provided by: https://exchangeratesapi.io/

Your task is to implement a Python script that loads the orders, loads the exchange rate on the date of the order (via the Exchange Rate API) so each order contains a "currency rate" property from USD to CAD.

## Approach
- understand the orderjson file
- understand the currency exchange rate api
- write code in jupyter notebook