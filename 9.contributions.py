import numpy as np
import statistics
import matplotlib.pyplot as plt
from itertools import repeat
import os

show=##show##
division=##div##

condition1='../##file_pmf##'
arr1 = os.listdir(condition1)
arr1=sorted(arr1)
condition2='../##file_pmf_vdw##'
arr2 = os.listdir(condition2)
arr2=sorted(arr2)

arr=arr1+arr2

#######################################################################################

def make_substraction(common, reference_x, reference_y, target_x, target_y, dd, name, show):

	# Making a new dict
	dict_output={}
	for i in common:
		dict_output[i]=[]

	for d in dict_output.keys():
		cc=0
		for t in reference_x:
			if t == d:
				dict_output[d].append(reference_y[cc])
			cc+=1

	for d in dict_output.keys():
		cc=0
		for t in target_x:
			if t == d:
				dict_output[d].append(target_y[cc])
			cc+=1

	# Making substraction
	list_x=[]
	list_y=[]
	for i in dict_output.items():
		x=i[0]
		y=i[1][0]-i[1][1]
		list_x.append(x)
		list_y.append(y)

	list_0=[]
	list_0.extend(repeat(0,len(list_x)))
	# Making plot

	file1="0.average_"+name+"_div"+str(dd)+".pmf"
	np.savetxt(file1,np.c_[list_x,list_y,list_0],fmt='%1.1f' '\t' '%1.5f' '\t' '%1.0f',header=name)
	plt.plot(list_x,list_y)
	plt.xlabel('Distance ($\AA$)')
	plt.ylabel('Free energy ($k_B$$T$)')

	if show == 1:
		plt.show()

	return list_x, list_y

#######################################################################################

for d in range(1,division+1):

	main_target='div'+str(d)+'.pfm'
	
	for f in arr:

		if len(f.split('_')) > 1:

			target=f.split('_')[-1]
			condition=f.split('_')[0]

			f1=condition1+'/'+f
			f2=condition2+'/'+f

			if target == main_target and condition == '0.average':
				total_x=np.loadtxt(f1)[:, 0]
				total_y=np.loadtxt(f1)[:, 1]

			if target == main_target and condition == 'vdw':
				vdw_x=np.loadtxt(f2)[:, 0]
				vdw_y=np.loadtxt(f2)[:, 1]

	common1=list(set(total_x).intersection(vdw_x))
	common1=sorted(common1)
	name='electrostatic'
	list_x, list_y = make_substraction(common1, total_x, total_y, vdw_x, vdw_y, d, name, show)


print('electrostatic contribution calculated!')

#######################################################################################

############# Creating index #############

print("creating index based on x-axis (separation distance)")

arr3 = os.listdir()
arr3 = sorted(arr3)

list_x=[]
for f in arr3:
	
	if len(f.split('_')) > 1:

		pfm_x=np.loadtxt(f)[:, 0]
		list_x.extend(pfm_x)
		list_x=sorted(list_x)

	dic_x=dict.fromkeys(list_x)
	for n,m in dic_x.items(): dic_x[n]=[]

############# Adding KT values to each index #############

list_y=[]
list_name=[]
for f in arr3:

	if len(f.split('_')) > 1:

		x=np.loadtxt(f)[:, 0]
		y=np.loadtxt(f)[:, 1]
		#list_name.append(f)
		j=0
		tt=0
		for g in dic_x:
			try:
				if g == x[j]:
					dic_x[g].append(y[j])
					j+=1
			except IndexError:
				if tt==0:
					print(f'ATTENTION!!!: Problem in curve {f}, only {len(y)} points are detected')
					tt+=1

############# Computing deviation #############

list_x=[]
list_y=[]
list_dev=[]
for n,m in dic_x.items():
    x=n
    h=(len(m))
    y=statistics.mean(m)
    dev=statistics.stdev(m)
    list_x.append(x)
    list_y.append(y)
    list_dev.append(dev)

print("standard deviation calculated!\n")

file3="0.average_and_deviation_div"+str(division)+".pfm"
header_name="average electrostatic curves"

np.savetxt(file3,np.c_[list_x,list_y,list_dev],fmt='%1.1f' '\t' '%10.5f' '\t' '%10.5f',header=header_name)
plt.clf()
plt.plot(list_x,list_y)
plt.errorbar(list_x,list_y,yerr=list_dev,fmt='.k')
plt.xlabel('Distance ($\AA$)')
plt.ylabel('Free energy ($k_B$$T$)')
if show == 1:
	plt.show()

