import pandas as pd
import numpy as np
import statistics
import matplotlib.pyplot as plt
import copy

show=##show##
div=##div##

# Function to read pmf file

def reader(f):
	file_g="condition"+str(f)+".pfm"
	file_pmf=file_g
	pfm_x=np.loadtxt(file_pmf)[:, 0]
	pfm_y=np.loadtxt(file_pmf)[:, 1]
	
	return pfm_x,pfm_y,file_pmf

############# Reading no redundant information #############

with open('sets.dat', 'r') as n:
	no_redundant = [d for d in n.read().split('\n') if d != '']

############# Creating index #############

print("creating index based on x-axis (separation distance)")

list_x=[]
for f in no_redundant:
    x,y,file_pmf=reader(f)
    list_x.extend(x)
    list_x=sorted(list_x)
dic_x=dict.fromkeys(list_x)
for n,m in dic_x.items(): dic_x[n]=[]

division=int(len(no_redundant)/div)

############# Making list with Y-values per key in dict #############

ca=1
dic_x_aux=copy.deepcopy(dic_x) 
cc=1
division_aux=division
list_y=[]
list_name=[]
for d in range(0, len(no_redundant)):

	x,y,file_pmf=reader(no_redundant[d])
	list_name.append(file_pmf)

	j=0
	tt=0
	for g in dic_x:
		try:
			if g == x[j]:
				dic_x_aux[g].append(y[j])
				j+=1
		except IndexError:
			if tt==0:
				print(f'ATTENTION!!!: Problem in curve {f}, only {len(y)} points are detected')
				tt+=1

#	print(dic_x_aux)

	if cc == (division_aux):	

############# Computing average #############

		print("calculating average from: ", len(list_name), " curves - division", ca)

		list_x=[]
		list_y=[]
		for n,m in dic_x_aux.items():
			x=n
			h=(len(m))
			y=statistics.mean(m)
			list_x.append(x)
			list_y.append(y)

		# Saving plots

		file2="0.average_div"+str(ca)+".pfm"

		with open(file2, 'wb') as fave:
		
			header_name="Number of curves: "+str(len(list_name))+" "+str(list_name)

			np.savetxt(fave,np.c_[list_x,list_y],fmt='%1.1f' '\t' '%1.5f',header=header_name)
			plt.plot(list_x,list_y)
			plt.xlabel('Distance ($\AA$)')
			plt.ylabel('Free energy ($k_B$$T$)')
			#if show == 1:
			#	plt.show()

		fave.close()
		
		# Reloading everything
	
		division_aux+=division
		dic_x_aux=copy.deepcopy(dic_x) 
		list_y=[]
		list_name=[]
		j=0
		tt=0
		ca+=1

	cc+=1

print("average calculated!")

############# Making list with Y-values per key in dict based on the previous averaged curves #############

list_y=[]
list_name=[]
dic_x_aux=copy.deepcopy(dic_x) 

for ca in range(1,div+1):

	file_new_pmf="0.average_div"+str(ca)+".pfm"
	x=np.loadtxt(file_new_pmf)[:, 0]
	y=np.loadtxt(file_new_pmf)[:, 1]

	j=0
	tt=0
	for g in dic_x_aux:
		try:
			if g == x[j]:
				dic_x_aux[g].append(y[j])
				j+=1
		except IndexError:
			if tt==0:
				print(f'ATTENTION!!!: Problem in curve {f}, only {len(y)} points are detected')
				tt+=1

############# Computing deviation #############

list_x=[]
list_y=[]
list_dev=[]
for n,m in dic_x_aux.items():
    x=n
    h=(len(m))
    y=statistics.mean(m)
    dev=statistics.stdev(m)
    list_x.append(x)
    list_y.append(y)
    list_dev.append(dev)

print("standard deviation calculated!")

file3="0.average_and_deviation_div"+str(div)+".pfm"
header_name=str(len(no_redundant))+" curves divided by "+str(div)+" = "+str(division)

np.savetxt(file3,np.c_[list_x,list_y,list_dev],fmt='%1.1f' '\t' '%10.5f' '\t' '%10.5f',header=header_name)
plt.clf()
plt.plot(list_x,list_y)
plt.errorbar(list_x,list_y,yerr=list_dev,fmt='.k')
plt.xlabel('Distance ($\AA$)')
plt.ylabel('Free energy ($k_B$$T$)')
if show == 1:
	plt.show()

