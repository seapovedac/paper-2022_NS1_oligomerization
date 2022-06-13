import filecmp

max=###max###+1

fff="0.comparison.dat"

f=open(fff, 'w+')

for i in range (1,max):

    file1 = "condition"+str(i)+".pfm"

    for j in range (1,max):

        file2 = "condition"+str(j)+".pfm"

        comp = filecmp.cmp(file1, file2, shallow=False)

        if comp == True:
            f.write(f"{i:.0f}\t{j:.0f}\n")
            f.write(f"&\n")

print('comparison done!')
