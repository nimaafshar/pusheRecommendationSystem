library(dplyr)
library(data.table)
library(magrittr)
library(ggplot2)
library(SparkR)
# Set Spark Home

spark_path <- '/usr/local/Cellar/apache-spark/2.4.0/libexec/'
if (nchar(Sys.getenv("SPARK_HOME")) < 1) {
  Sys.setenv(SPARK_HOME = spark_path)
}
java_home = '/Library/Java/JavaVirtualMachines/jdk1.8.0_202.jdk/Contents/Home'
Sys.setenv(JAVA_HOME = java_home)
# Start
sparkR.session(master = "local[*]", sparkConfig = list(spark.driver.memory = "2g", spark.executor.memory = "6g"))



#########---------------- Codes-----------
# reading data
#df = read.df( 'file:///Users/anahita/Desktop/rahnama/recommender/train_interactions.csv', source = "csv", header = TRUE )
#write.parquet( df, '/Users/anahita/Desktop/rahnama/recommender/train_interactions.parquet' )
df_train_interaction = read.parquet( '/Users/anahita/Desktop/rahnama/recommender/train_interactions.parquet' )
df_notifs = read.df('/Users/anahita/Desktop/rahnama/recommender/notifs_corrected.csv',source = "csv",header = TRUE)

# merging notifs and train_interaction
df_new = merge(df_train_interaction,df_notifs,by = "notif_id",by.x = "notif_id",by.y = "notif_id",all.x = TRUE,all.y = FALSE)

df_train_interaction %>% 
  head(10) %>% 
  View
# Head View
df_new %>% 
  head( 10 ) %>% 
  View

# notifs category and interaction
df_notif_cat_interaction = df_new %>% 
  group_by("notif_id_x","interaction","category") %>% 
  count() %>% 
  collect()

ggplot( data = df_notif_cat_interaction, aes( x = interaction, y = count, fill = category ) ) +
  geom_col() 

# notifs hour and interaction
df_notif_hour_interaction = df_new %>% 
  group_by("interaction","hour") %>% 
  count() %>% 
  collect()

ggplot( data = df_notif_hour_interaction, aes( x = interaction, y = count, fill = hour ) ) +
  geom_col(position = "dodge")

# notifs day and interaction
df_notif_hour_interaction = df_new %>% 
  group_by("interaction","day_of_week") %>% 
  count() %>% 
  collect()

ggplot( data = df_notif_hour_interaction, aes( x = interaction, y = count, fill = day_of_week ) ) +
  geom_col(position = "dodge")



# Interaction Counts
## Calculate
df_interaction_counts =  df_train_interaction %>% 
  group_by("interaction") %>% 
  count() %>% 
  collect()
## Plotting barplot of interaction
ggplot( data = df_interaction_counts, aes( x = interaction, y = count, fill = interaction ) ) +
  geom_col()

# DOW_Interaction Data
df_dow_interaction = df_train_interaction %>% 
  group_by( "interaction_dow", "interaction" ) %>% 
  count() %>% 
  collect()

ggplot( data = df_dow_interaction, aes( x = interaction_dow, y = count, fill = interaction ) ) +
  geom_col( position = "dodge" )


# hour
df_hour_interaction = df_train_interaction %>% 
  group_by( "interaction_hour", "interaction" ) %>% 
  count() %>% 
  collect()
df_hour_interaction$interaction_hour = as.numeric( df_hour_interaction$interaction_hour )

ggplot(
  data = df_hour_interaction,
  aes( x = interaction_hour, y = count, fill = interaction )
) +
  geom_col( position = "dodge" )



# Notification Interactions
df_notif_interaction = df_train_interaction %>% 
  withColumn( "interaction_num", cast( df_train_interaction$interaction, "double" ) ) %>% 
  group_by( "notif_id" ) %>% 
  mean( "interaction_num" ) %>% 
  collect()
df_notif_interaction$notif_id = as.numeric( df_notif_interaction$notif_id )

df_notif_interaction %>% 
  ggplot( aes( x = notif_id, y = `avg(interaction_num)` ) ) + 
  geom_point()

df_notif_interaction %>% 
  ggplot( aes( x = `avg(interaction_num)`, fill = 'red' ) ) +
  geom_histogram( bins = 100 ) +
  ggtitle( "Notification Interaction Rate Histogram" ) +
  xlab( "Interaction Rate" ) +
  ylab( "Frequency" ) +
  theme( legend.position = "none" )

# each notif is sent at different hour
df_notif_delivery_hour = df_train_interaction %>% 
  group_by("notif_id","delivery_hour") %>% 
  count() %>% 
  collect()

View(df_notif_delivery_hour)
# filter_by interaction = 0
df_count_no_interaction = df_train_interaction %>% 
  group_by("user_id","notif_id") %>% 
  filter("interaction == 0") %>% 
  count() %>% 
  collect()




# STOP IT!!!
sparkR.session.stop()
sparkR.stop()
