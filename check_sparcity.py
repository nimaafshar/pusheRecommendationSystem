with open('user_sparse_2.csv') as user_file,open('user_sparse_2_cols','w') as wfile:
	cols = user_file.readline()[:-1].split(',')
	nan_count = [0]*len(cols)
	lines = 0
	for line in user_file:
		for i,item in enumerate(line[:-1].split(',')):
			if item == '':
				nan_count[i]+=1
			lines+=1
	for i in range(len(cols)):
		wfile.write(f'{cols[i]},{nan_count[i]}\n')