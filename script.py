
with open('notifs.txt') as file , open('notifs_corrected.csv','w') as write_in:
	write_in.write('notif_id,day_of_week,hour,minute,category,text\n')
	for line in file:
		sr = line[:-1].split(' ')
		write_in.write(','.join([sr[0],sr[1],sr[2],sr[3],sr[4],' '.join(sr[5:])])+'\n')
