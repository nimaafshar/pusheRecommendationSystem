
import numpy as np
import matplotlib.pyplot as plt
import pandas as pd
from apyori import apriori


data=pd.read_csv("/Users/amirhossein/Desktop/all/Uni/MS/rahnama/recommander/data/data1/recommender/mycsv.csv",nrows=6071101)

#print(data)
df = data.groupby('user_id')['notif_id'].unique()

print(len(df))

data2 = pd.read_csv("baskets.csv")
'''df1=pd.DataFrame()
i=0
for rows in df:
    i=i+1
    new_series = pd.Series(rows)
    df1.append(new_series,ignore_index=True)
    print(i)

'''
# print(type(df[11197438]))


print((data2.head(5)))
print(len(data2))
#print((len)(df1.iloc[100000][0]))
#df1=df.to_frame(name=None)
#print(type(df))


#df1.to_csv('/Users/amirhossein/Desktop/all/Uni/MS/rahnama/recommander/data/data1/recommender/baskets.csv')
print((type)(data2.iloc[10000][1]))
records = []

for i in range(0, len(data2)):
    records.append(data2.iloc[i][1])

print(records[4])

association_rules = apriori(records, min_support=0.1, min_confidence=0.1, min_lift=0, min_length=2)
association_results = list(association_rules)

print(association_results)

