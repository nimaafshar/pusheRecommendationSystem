
from pyspark.sql import SparkSession

spark = SparkSession \
    .builder \
    .appName("Python Spark SQL basic example") \
    .config("spark.some.config.option", "some-value") \
    .getOrCreate()


df = spark.read.csv("/Users/amirhossein/Desktop/all/Uni/MS/rahnama/recommander/data/data1/recommender/test.csv",
                    header="true")


df.show()

print(df.count())
#print(df.select('notif_id').distinct().count())

print(df.select('notif_id').distinct())

this=df.groupby('notif_id').count()

print(this.show(100))

df1 = spark.read.csv("/Users/amirhossein/Desktop/all/Uni/MS/rahnama/recommander/data/data1/recommender/train_interactions.csv",
                    header="true")

print(df1.count())

print(df1.select('notif_id').distinct().count())

this1=df1.groupby('notif_id').count()

print(this1.show(4000))

a=(df1.select('notif_id').distinct())

import numpy as np

a = np.array(df.select('notif_id').distinct().collect())


print(len(a))

a1=np.array(df1.select('notif_id').distinct().collect())


print(len(a1))

for i in range(0,189):
    if(a[i] in a1):
        print("salam")

this1=df1.groupby('user_id').count()

a=np.array(df1.groupby('user_id').count().collect())