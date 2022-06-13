from itertools import repeat
import numpy as np
import copy
import os

print('verifying bin rdfs')

entries = os.listdir()

############# Creating index #############

list_x=[]
for f in entries:

	if f[0:3] == 'rdf':

		rdf_x=np.loadtxt(f)[:, 0]
		rdf_y=np.loadtxt(f)[:, 1]
		list_x.extend(rdf_x)
		list_x=sorted(list_x)

min_x=min(list_x)
mod_min_x=min_x%2
max_x=max(list_x)+0.5

if not any(d in [mod_min_x] for d in [0,1]):
	min_x=min_x-0.5

print("minimum distance = ", min_x)
file1="index_rdf.txt"
list_range=np.arange(min_x, max_x, 0.5)

list_list=repeat('', len(list_range))
dict_range_aux = dict(zip(list_range,list_list))	# Aux dict
np.savetxt(file1,np.c_[list_range],fmt='%1.1f')


############# Making corrections #############

for f in entries:

	if f[0:3] == 'rdf':

		rdf_x=np.loadtxt(f)[:, 0]
		rdf_y=np.loadtxt(f)[:, 1]
		dict_range = copy.deepcopy(dict_range_aux) 
		
		r=0
		for d in dict_range.keys():
			
			if d == rdf_x[r]:
				dict_range[d]=rdf_y[r]
				r+=1
			else:
				dict_range[d]=0.0000000001

		rdf_new_x=list(dict_range.keys())
		rdf_new_y=list(dict_range.values())
		file2=f
		file2=open(file2)
		name_file2=f
		header_name=file2.readline()
		file2.close()

		with open(name_file2, 'wb') as fnp:
			np.savetxt(fnp,np.c_[rdf_new_x,rdf_new_y],fmt='%1.1f' '\t' '%7.10f' '\t',header=header_name)
		fnp.close()


print('correction rdfs done!')

