import pandas as pd
import numpy as np
import statistics
import matplotlib.pyplot as plt
import os

show=##show##

# Function to read pmf file

def reader(f):
	file_g="condition"+str(f)+".pfm"
	file_pmf=file_g
	pfm_x=np.loadtxt(file_pmf)[:, 0]
	pfm_y=np.loadtxt(file_pmf)[:, 1]
	#print(file_pmf)
	
	return pfm_x,pfm_y,file_pmf

############# Reading no redundant information #############

list_nr = list(range(1, ##max##+1))

############# Creating index #############

print("creating index based on x-axis (separation distance)")

list_x=[]
for f in list_nr:
    x,y,file_pmf=reader(f)
    list_x.extend(x)
    list_x=sorted(list_x)
dic_x=dict.fromkeys(list_x)
for n,m in dic_x.items(): dic_x[n]=[]

#print(dic_x)

############# Adding KT values to each index #############

list_y=[]
list_name=[]

for f in list_nr:
	x,y,file_pmf=reader(f)
	list_name.append(file_pmf)
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

#print(dic_x)

############# Calculating average #############

print("calculating average from: ", len(list_name), " curves")

list_x=[]
list_y=[]
list_h=[]
for n,m in dic_x.items():
    x=n
    h=(len(m))
    y=statistics.mean(m)
    list_x.append(x)
    list_y.append(y)
    list_h.append(h)

############# Last adjustments #############

file2="0.average.pfm"
#file3="0.average.his"
name_file="Number of curves: "+str(len(list_name))+" "+str(list_name)

np.savetxt(file2,np.c_[list_x,list_y,list_h],fmt='%1.1f' '\t' '%1.5f' '\t' '%1.1f',header=name_file)
#np.savetxt(file3,np.c_[list_x,list_h],fmt='%1.1f' '\t' '%1.5f',header=name_file)
plt.plot(list_x,list_y)
plt.xlabel('Distance ($\AA$)')
plt.ylabel('Free energy ($k_B$$T$)')

if show == 1:
    plt.show()

print("average done!")

