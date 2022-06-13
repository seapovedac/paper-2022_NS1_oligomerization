show=0
return_dir=`pwd`
echo 'main location:' $return_dir
echo

#rm -r average_and_deviation_curves
mkdir average_and_deviation_curves

div=3	# Number of divisions

RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

set_curves1(){
	target_file=0.comparison2.dat
}

set_curves2(){
	ls | grep condition | cut -c10-20 | cut -d "." -f1 | sort -n > 0.comparison3.dat
	target_file=0.comparison3.dat
}

average_and_deviation(){

	if [ ${max_cur} -le ${num_cur_avail} ]; then

		if [ $compatible -eq 1 ]; then

		# Creating a set of curves based on the maximum curves requested

			rm sets.dat 

			if [ ${set_curves} == 1 ]; then
				set_curves1
			else
				set_curves2
			fi

		for ((c=1; c<=${max_cur}; c+=1)) do

			ran_cur=$(head -n$c ${target_file} | tail -n1 | awk '{print $1}') 

			if [ $c -eq 1 ]; then
				echo $ran_cur >> sets.dat 
			else
				if grep -q "^$ran_cur" sets.dat; then
					c=$[ $c - 1 ]
				else
					echo $ran_cur >> sets.dat 							
				fi
			fi

		done

		sort -n sets.dat > sss ; mv sss sets.dat

			# Python 
			
			cp $return_dir/7.average_and_deviation.py .
			sed 's/##show##/'${show}'/g' 7.average_and_deviation.py | sed 's/##div##/'${div}'/g' > 777
			mv 777 7.average_and_deviation.py
			python 7.average_and_deviation.py
		
			curves_per_production=$(echo "${max_cur}/${div}" | bc)
			
			cp 0.average_and_deviation_div$div.pfm ${return_dir}/average_and_deviation_curves/bin${bin}/${virus}_${arch}_${pH_name}_div${div}_curves${curves_per_production}.pmf
			mv 0.average_and_deviation_div${div}.pfm 0.average_and_deviation_div${div}_curves${curves_per_production}.pfm 
			
			for ((tcc=1 ; tcc<=$div ; tcc+=1)) do
				
				mv 0.average_div$tcc.pfm 0.average_div${tcc}_curves${curves_per_production}.pfm 
			
			done

		else

			echo "average and deviation no calculated -> division no compatible at pH ${pH_name:(-3)}"	

		fi
		
	else

		echo "average and deviation no calculated -> there are many curves at pH ${pH_name:(-3)}:" "${cur_req} (requested) vs $num_cur_avail (available)" 

	fi

}

reading_condition(){

	# Verification to check if there are enough curves

	if [ $arch == monomer ]; then
		max_cur=${mon_cur}
		average_and_deviation
	fi

	if [ $arch == dimer ]; then
		max_cur=${dim_cur}
		average_and_deviation
	fi

	if [ $arch == dimer_0.005M ]; then
		max_cur=${dim_cur}
		average_and_deviation
	fi
	
	if [ $arch == dimer_10M ]; then
		max_cur=${dim_cur}
		average_and_deviation
	fi
	
	if [ $arch == d_vdw ]; then
		max_cur=${vdw_cur}
		average_and_deviation
	fi

}

cd DATA


for ((tc=8 ; tc<=10 ; tc+=1)) do

	if [ $tc -eq 1 ]; then
	   test_cur=1200
	fi
	if [ $tc -eq 2 ]; then
	   test_cur=900
	fi
	if [ $tc -eq 3 ]; then
	   test_cur=600
	fi
	if [ $tc -eq 4 ]; then
	   test_cur=300
	fi
	if [ $tc -eq 5 ]; then
	   test_cur=270
	fi
	if [ $tc -eq 6 ]; then
	   test_cur=207
	fi
	if [ $tc -eq 7 ]; then
	   test_cur=180
	fi
	if [ $tc -eq 8 ]; then
	   test_cur=156
	fi
	if [ $tc -eq 9 ]; then
	   test_cur=120
	fi
	if [ $tc -eq 10 ]; then
	   test_cur=93
	fi

	for ((v=1; v<=4; v+=1)) do

		if [ $v -eq 1 ]; then
			virus=ZIKV-UG
		fi
		if [ $v -eq 2 ]; then
			virus=ZIKV-BR
		fi
		if [ $v -eq 3 ]; then
			virus=DENV2
		fi
		if [ $v -eq 4 ]; then
			virus=WNV
		fi

		mon_cur=$test_cur
		dim_cur=$test_cur
		vdw_cur=$test_cur

		echo "********************"
		echo "	$virus		"
		echo "********************"
		echo

		cd $virus

		for ((f=4; f<=5 ; f+=1)) do

			# MONOMER
			if [ $f -eq 1 ]; then

				arch=monomer
				cur_req=$mon_cur

				# Verifying compatibility monomer

				if [ `echo "${mon_cur} % ${div}" | bc` -eq 0 ]; then
					echo -e 'requested curves for monomer condition =' $mon_cur 'is'"${BLUE} compatible${NC}!"
					compatible=1
				else
					echo -e 'requested curves for monomer condition =' $mon_cur 'is'"${RED} not compatible${NC}!"
					compatible=0
				fi
			fi

			# DIMER
			if [ $f -eq 2 ]; then

				arch=dimer
				cur_req=$dim_cur

				# Verifying compatibility dimer

				if [ `echo "${dim_cur} % ${div}" | bc` -eq 0 ]; then
					echo -e 'requested curves for dimer condition =' $dim_cur 'is'"${BLUE} compatible${NC}!"
					compatible=1
				else
					echo -e 'requested curves for dimer condition =' $dim_cur 'is'"${RED} not compatible${NC}!"
					compatible=0
				fi
			fi
			
			# DIMER 150 mM
			if [ $f -eq 3 ]; then

				arch=dimer_0.005M
				cur_req=$dim_cur

				# Verifying compatibility dimer

				if [ `echo "${dim_cur} % ${div}" | bc` -eq 0 ]; then
					echo -e 'requested curves for dimer condition =' $dim_cur 'is'"${BLUE} compatible${NC}!"
					compatible=1
				else
					echo -e 'requested curves for dimer condition =' $dim_cur 'is'"${RED} not compatible${NC}!"
					compatible=0
				fi
			fi
			
			# DIMER 		
			if [ $f -eq 4 ]; then

				arch=dimer
				cur_req=$dim_cur

				# Verifying compatibility dimer

				if [ `echo "${dim_cur} % ${div}" | bc` -eq 0 ]; then
					echo -e 'requested curves for dimer condition =' $dim_cur 'is'"${BLUE} compatible${NC}!"
					compatible=1
				else
					echo -e 'requested curves for dimer condition =' $dim_cur 'is'"${RED} not compatible${NC}!"
					compatible=0
				fi
			fi

			# VDW
			if [ $f -eq 5 ]; then

				arch=d_vdw
				cur_req=$vdw_cur

				# Verifying compatibility vdw

				if [ `echo "${vdw_cur} % ${div}" | bc` -eq 0 ]; then
					echo -e 'requested curves for vdW condition =' $vdw_cur 'is'"${BLUE} compatible${NC}!"
					compatible=1
				else
					echo -e 'requested curves for vdW condition =' $vdw_cur 'is'"${RED} not compatible${NC}!"
					compatible=0
				fi
			fi

			cd $arch

			ls | grep pmf | grep pH > unique_pmf
			line=$(ls | grep pmf | grep pH | wc -l)

			#cat unique_pmf

			#############################################################################

			for ((l=1; l <= $line ; l+=1)) do
				
				file_pmf=$(head -n$l unique_pmf | tail -n1)
				pH_name=$(echo $file_pmf | cut -d "_" -f1)

				if ! echo $file_pmf | grep -q bin; then

					set_curves=1
					bin=1
					mkdir -p ${return_dir}/average_and_deviation_curves/bin$bin

					cd $file_pmf 

					num_cur_avail=$(head number_no_rep)
					
					echo	
					echo "... $arch - pH ${pH_name:(-3)} ..."

					reading_condition

					echo

					cd ..

				else # For files bin > 1

					set_curves=2

					cd $file_pmf
					bin_size=$(echo $file_pmf | cut -d "_" -f3)
					bin=$(echo $bin_size | cut -d "n" -f2)
					mkdir -p ${return_dir}/average_and_deviation_curves/bin$bin

					echo	
					echo "... $arch - pH ${pH_name:(-3)} $bin_size ..."

					reading_condition	

					echo

					cd ..


				fi

			done

			rm unique_pmf

			cd ..

		done

		cd ..

		echo
	done

done

aplay /usr/share/sounds/sound-icons/piano-3.wav
