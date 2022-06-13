import pandas as pd
import numpy as np
import statistics
import glob
import os

directory_rdf="../##dir##/"

rm_file=glob.glob(directory_rdf+"*pfm")

for rr in rm_file:
    os.remove(rr)

entries = os.listdir(directory_rdf)

list_log=open('list_rdfs.log', 'w+')

f1=1
for f in entries:

    file_rdf=directory_rdf+f

    if f != '0.comparison.dat' and f[0:3] == 'rdf':
        #print(file_rdf)

        rdf_x=np.loadtxt(file_rdf)[:, 0]
        rdf_y=np.loadtxt(file_rdf)[:, 1]
        rdf_y_log=-1*(np.log(rdf_y))+0.0000000001
        subs=statistics.mean(rdf_y_log[-10:])
        pfm=rdf_y_log-subs
        file2="condition"+str(f1)+".pfm"
        list_log.write(f'{file_rdf} -> {file2} \n')
        np.savetxt(file2, np.c_[rdf_x,pfm],fmt='%0.1f' '\t' '%10.5f')
        f1+=1

list_log.write(f'{f1-1}')
