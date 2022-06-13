import numpy as np
import matplotlib.pyplot as plt
import os

show=##show##
main_target='##virus##'
main_condition='dimer'
name_pH='7.0'
ext='##ext##'
main_pH='pH'+str(name_pH)+ext
bin_size="##bin##"

arr = os.listdir()

#######################################################################################

def make_substraction(common, reference_x, reference_y, target_x, target_y, main_target, name_pH, name, show):

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

	# Making plot

	file1=main_target+"_"+name+"_pH"+name_pH+"##line##"+bin_size+".pmf"
	np.savetxt(file1,np.c_[list_x,list_y],fmt='%1.1f' '\t' '%1.5f',header=name)
	plt.plot(list_x,list_y)
	plt.xlabel('Distance ($\AA$)')
	plt.ylabel('Free energy ($k_B$$T$)')

	if show == 1:
		plt.show()

	return list_x, list_y

#######################################################################################

f1=1
for f in arr:

	vdw_oligo=[]

	if len(f.split('_')) > 1:

		target=f.split('_')[0]
		condition=f.split('_')[1]
		pH=f.split('_')[##number##]
		vdw_oligo.append(main_condition[0])
		vdw_oligo.append('vdw')
		condition_vdw=f.split('_')[1:3]

		if target == main_target and condition == main_condition and pH == main_pH:
			total_x=np.loadtxt(f)[:, 0]
			total_y=np.loadtxt(f)[:, 1]

		if target == main_target and condition == 'fixed':
			non_tit_x=np.loadtxt(f)[:, 0]
			non_tit_y=np.loadtxt(f)[:, 1]

		if target == main_target and condition_vdw == vdw_oligo:
			vdw_x=np.loadtxt(f)[:, 0]
			vdw_y=np.loadtxt(f)[:, 1]

common1=list(set(total_x).intersection(non_tit_x))
common1=sorted(common1)
name='ch_reg'
list_x, list_y = make_substraction(common1, total_x, total_y, non_tit_x, non_tit_y, main_target, name_pH, name, show)

common2=list(set(vdw_x).intersection(non_tit_x))
common2=sorted(common2)
name='ch_dip'
list_x, list_y = make_substraction(common2, non_tit_x, non_tit_y, vdw_x, vdw_y, main_target, name_pH, name, show)

