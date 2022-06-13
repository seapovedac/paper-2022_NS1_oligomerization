import numpy as np
import matplotlib.pyplot as plt
from itertools import repeat
import os

show=##show##
main_target='##virus##'
main_condition='##oligomer##'
name_pH='##pH##'
main_pH='pH'+str(name_pH)

arr = os.listdir()

#######################################################################################

def make_substraction(common, reference_x, reference_y, target_x, target_y, main_target, main_condition, name_pH, name, show):

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

	file1=main_target+"_"+main_condition+"_"+name+"_pH"+name_pH+"_div3.pmf"
	np.savetxt(file1,np.c_[list_x,list_y,list_0],fmt='%1.1f' '\t' '%1.5f' '\t' '%1.0f',header=name)
	plt.plot(list_x,list_y)
	plt.xlabel('Distance ($\AA$)')
	plt.ylabel('Free energy ($k_B$$T$)')

	if show == 1:
		plt.show()

	return list_x, list_y

#######################################################################################

f1=1
for f in arr:

	if len(f.split('_')) > 1:

		target=f.split('_')[0]
		vdw_oligo=[]

		if target == main_target:

			condition=f.split('_')[1]
			pH=f.split('_')[-2]
			condition_aux=f.split('_')[-4]
			vdw_oligo.append(main_condition[0])
			vdw_oligo.append('vdw')
			condition_vdw=f.split('_')[1:3]

			if condition_vdw[-1] == 'vdw':
				condition_aux=f.split('_')[-5]
		
			if target == main_target and condition == main_condition and pH == main_pH and condition_aux == main_target:
				total_x=np.loadtxt(f)[:, 0]
				total_y=np.loadtxt(f)[:, 1]

			if target == main_target and condition_vdw == vdw_oligo and condition_aux == main_target:
				vdw_x=np.loadtxt(f)[:, 0]
				vdw_y=np.loadtxt(f)[:, 1]

common1=list(set(total_x).intersection(vdw_x))
common1=sorted(common1)
name='electrostatic'
list_x, list_y = make_substraction(common1, total_x, total_y, vdw_x, vdw_y, main_target, main_condition, name_pH, name, show)

