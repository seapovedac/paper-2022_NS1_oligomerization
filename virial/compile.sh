ls | grep "\.f" > list_fortran
line=$(ls | grep "\.f" | wc -l)

for ((i=1; i<=$line ; i+=1)) do
	
	code_fortran=$(head -n$i list_fortran | tail -n1)
	file_fortran=$(echo $code_fortran | cut -d "." -f1)
	gfortran-8 $code_fortran -o $file_fortran
	echo $code_fortran '->' $file_fortran

done


