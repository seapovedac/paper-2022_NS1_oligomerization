return_dir=`pwd`
echo 'main location:' $return_dir

rm 2.total_number_curves.log 2.curves_bad.dat

con1=0	# pH 3.0 dimer
con2=1	# pH 7.0 dimer 
con3=0	# pH 8.5 dimer
con4=1	# vdw, charges...
con5=0	# no 150 mM of salt

# minimum number of points per curve
min_point_mon=120 	
min_point_dim=260
minimum_eps=20 # the firs value in the row should be greater than minimum_eps

################################################################FUNCTIONS#####################################################################

correction_rdf(){

	# Applying corrections	
	cd ${dir_work}/pH${pH}_rdf/
	cp $return_dir/2.rdf_correction.py .
	#sleep 2
	python 2.rdf_correction.py

	cd $return_dir/
}

remove_copy(){

	# Conditional to remove copies or repeated lines in 1.valid_data.txt
	j_aux=$[ $j + 1 ]
	sub_dir1=$(head -n$j_aux 1.valid_data.txt | tail -n1 | cut -d " " -f1)

	if [ $sub_dir == $sub_dir1 ]; then
		j=$[ $j + 1 ]
	fi
}

returning_n(){

	# With this function the counter return n to 1 in order to restart a new folder with a physicochemical condition determinated

	sub_dir_pH=$(echo $sub_dir | cut -d "_" -f2)
	j_aux2=$[ $j + 1 ]
	sub_dir1_pH=$(head -n$j_aux2 1.valid_data.txt | tail -n1 | cut -d " " -f1 | cut -d "_" -f2)

	# This variable is based on the second word in the name of a specific folder. 
	# For example ZIKV-BR_nd_setA, the second word is "nd" so if the next folder conserve the same "nd"
	# it means that should not restar n yet.

	#echo $sub_dir_pH $sub_dir1_pH

	if [ $sub_dir_pH != $sub_dir1_pH ]; then
		nt=$[ $n - 1 ]

		correction_rdf

		echo "Total number of curves $nt" > 111
		echo $dir_work + pH $pH > 222
		paste 111 222 >> 2.total_number_curves.log
		rm 111 222
		echo -- Total number of curves $nt --
		n=1
	fi
}

cp_file(){
	cp ${dir_work}/${sub_dir}/DATA_RDF/${rdf} ${dir_work}/pH${pH}_rdf/rdf$n.dat
	sed -i "1 i\# ${dir_work}/${sub_dir}/DATA_RDF/${rdf} -> rdf$n.dat" ${dir_work}/pH${pH}_rdf/rdf$n.dat 
	n=$[ $n + 1 ]	
}

copy_rdf(){

	remove_copy

	ls ${dir_work}/${sub_dir}/DATA_RDF | grep pH > rdf_files
	rdf_l=$(ls ${dir_work}/${sub_dir}/DATA_RDF | grep pH | wc -l)

	if [ $condition -eq 1 ]; then

		for ((r=1 ; r<=$rdf_l ; r+=1)) do
			
			rdf=$(head -n$r rdf_files | tail -n1)

			head -n3 ${dir_work}/${sub_dir}/DATA_RDF/${rdf} | tail -n1 > /tmp/dfr
			read first_row nnn < /tmp/dfr
			first_row=${first_row%.*}

			# Removing curves with bad sampling
			length=$(wc -l ${dir_work}/${sub_dir}/DATA_RDF/${rdf} | cut -d " " -f1)

			if echo $dir_work | egrep -q "monomer"; then				
				if [ $length -gt $min_point_mon  ] && [ $first_row -gt $minimum_eps ]; then
					cp_file
				else
					echo ${sub_dir} - ${rdf} >> 2.curves_bad.dat
				fi
			else
				if [ $length -gt $min_point_dim  ] && [ $first_row -gt $minimum_eps ]; then
					cp_file
				else
					echo ${sub_dir} - ${rdf} >> 2.curves_bad.dat
				fi
				
			fi
			

		done

	fi

	returning_n
}

###################################################################################################################################

line=$(grep -n "home" 1.valid_data.txt | cut -d ":" -f1 | wc -l)
n=1
#line=1

for ((h=1; h<=$line ; h+=1)) do

	dir_work=$(grep -n "home" 1.valid_data.txt | cut -d ":" -f2 | head -n$h | tail -n1 | sed 's/ //g')

	begin=$[ 1 + $(grep -n "home" 1.valid_data.txt | cut -d ":" -f1 | head -n$h | tail -n1) ]
	begin_aux=$begin
	i=$[ $h + 1 ]
	end=$(grep -n "home" 1.valid_data.txt | cut -d ":" -f1 | head -n$i | tail -n1)
	echo $dir_work

	for ((j=$begin ; j < $end ; j+=1)) do

###################################################################################################################################

		if echo $dir_work | egrep -q "monomer|dimer"; then			# if monomer or dimer 

			if echo $dir_work | cut -d "/" -f9 | egrep -q "_"; then			# if monomer or dimer has salt concentration different to 150 mM

				sub_dir=$(head -n$j 1.valid_data.txt | tail -n1 | cut -d " " -f1)

				# Cleaning directories
				if [ $j -eq $begin_aux ]; then
					rm -r ${dir_work}/pH7.0_rdf
					mkdir -p ${dir_work}/pH7.0_rdf
				fi

				pH=7.0
				condition=$con5
				copy_rdf

			else 							# else monomer or dimer has 150 mM of salt concentration

				sub_dir=$(head -n$j 1.valid_data.txt | tail -n1 | cut -d " " -f1)

				# Cleaning directories
				if [ $j -eq $begin_aux ]; then

					#rm -r ${dir_work}/pH3.0_rdf
					rm -r ${dir_work}/pH7.0_rdf
					#rm -r ${dir_work}/pH8.5_rdf

					#mkdir -p ${dir_work}/pH3.0_rdf
					mkdir -p ${dir_work}/pH7.0_rdf
					#mkdir -p ${dir_work}/pH8.5_rdf

				fi

				echo $sub_dir $n

				if echo $sub_dir | grep -q "3\.0" ; then ######## pH 3.0
					pH=3.0
					condition=$con1
					copy_rdf
				fi

				if echo $sub_dir | grep -q "7\.0" ; then ######## pH 7.0
					pH=7.0
					condition=$con2
					copy_rdf
				fi

				if echo $sub_dir | grep -q "8\.5" ; then ######## pH 8.5
					pH=8.5
					condition=$con3
					copy_rdf
				fi

			fi

###################################################################################################################################

		else # if vdw, charge_*, etc.

			sub_dir=$(head -n$j 1.valid_data.txt | tail -n1 | cut -d " " -f1)

			# Cleaning directories
			if [ $j -eq $begin_aux ]; then
				rm -r ${dir_work}/pH7.0_rdf
				mkdir -p ${dir_work}/pH7.0_rdf
			fi

			pH=7.0
			condition=$con4
			copy_rdf

		fi	

	done

done

rm rdf_files

cd $return_dir
cut -d " " -f5,8 2.total_number_curves.log | cut -d "/" -f1,9,10 | sed 's/\// /g'

aplay /usr/share/sounds/sound-icons/piano-3.wav
