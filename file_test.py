import numpy as np
with open('user_sparse_2.csv') as iconfile:
	names = iconfile.readline()
	feture_names = np.array(names[:-1].split(','))
	print(len(feture_names))
	line = iconfile.readline()
	fs = np.array(line[:-1].split(','))
	print(fs)