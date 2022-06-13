import numpy as np
import statistics
import glob
import os

bin_size=##bin_size##

arr = os.listdir()

name_bin='bin_'+str(bin_size)

try:
    os.mkdir(name_bin)
except FileExistsError:
    pass

for rdf in arr:

	num_rdf=rdf[3:].split('.')[0]
	ver_rdf=rdf[0:3]

	name_rdf_bin='bin_'+str(bin_size)+'/rdf'+str(num_rdf)+'_bin'+str(bin_size)+'.dat'

	if ver_rdf == 'rdf':

		rdf_bin=open(name_rdf_bin, 'w+')
		
		rdf_x=np.loadtxt(rdf)[:, 0]
		rdf_y=np.loadtxt(rdf)[:, 1]
		list_x=[]
		list_y=[]
		i=0
		b=1

        # loop for lines of pfm
		while i < len(rdf_x):

			if b == bin_size:

				list_x.append(rdf_x[i])
				list_y.append(rdf_y[i])

				new_x=statistics.mean(list_x)
				new_y=statistics.mean(list_y)
				rdf_bin.write(f"{new_x}\t{round(new_y,10)}\n")

				list_x=[]
				list_y=[]

				b=1
				#i-=bin_size-1

			else:

				list_x.append(rdf_x[i])
				list_y.append(rdf_y[i])

				b+=1

			i+=1

	rdf_bin.close()
