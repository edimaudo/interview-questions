# WMAPE, OC and UC calculations
# Using python 2.7

import pandas as pd
df = pd.read_csv("measurement.csv")

# WMAPE, OC and UC for Item Week level
df_item_week = df.groupby(['item','week']).aggregate({'units': 'sum',
                             'forecast': 'sum'}).reset_index()
df_item_week = df.groupby(['item','week']).aggregate({'units': 'sum',
                             'forecast': 'sum'}).reset_index()
df_item_week ['WMAPE'] = df_item_week ['units'] - df_item_week ['forecast']
df_item_week ['WMAPE'] = df_item_week ['WMAPE'].abs()
df_item_week ['WMAPE'] = df_item_week ['WMAPE'] / df_item_week ['units']*100*df_item_week ['units']
WMAPE = df_item_week['WMAPE'].sum()/df_item_week ['units'].sum()                   


# WMAPE FOR STORE CATEGORY WEEK LEVEL
df_store_category_week = df.groupby(['store','category','week']).aggregate({'units': 'sum',
                             'forecast': 'sum'}).reset_index()
df_store_category_week ['WMAPE'] = df_store_category_week ['units'] - df_store_category_week ['forecast']
df_store_category_week ['WMAPE'] = df_store_category_week ['WMAPE'].abs()
df_store_category_week ['WMAPE'] = df_store_category_week ['WMAPE'] / df_store_category_week ['units']*100*df_store_category_week ['units']
WMAPE = df_store_category_week['WMAPE'].sum()/df_store_category_week ['units'].sum()