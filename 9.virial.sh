# Note: Pay attetion to compile FORTRAN codes with gfortran 8

echo 'Compiling virial FORTRAN codes' 
cd virial
chmod +x compile.sh
./compile.sh
cd ..
echo

rm -r average_and_deviation_curves_v2_with_electro

return_dir=`pwd`

rm 9.virial.log

cd DATA

div=3
curves=52 	 # Number of curves to get a production
best_bin=2 	 # Best bin

calculate_electrostatic=YES
calculate_vdw=YES

show=0
RED='\033[0;31m'

condition_oli=2

for ((v=1; v<=4 ; v+=1)) do

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
		
	cd $virus

	for ((f=${condition_oli}; f<=${condition_oli} ; f+=1)) do
	
		if [ $f -eq 1 ]; then
			arch=monomer
			oligomer='monomer'
			arch_short=m		
		fi
		if [ $f -eq 2 ]; then
			arch=dimer
			oligomer='dimer'
			arch_short=d		
		fi
		if [ $f -eq 3 ]; then
			arch=dimer_0.005M
			oligomer='dimer'
			arch_short=d
		fi

		echo "---------------------------------" $virus - $arch "---------------------------------"
		echo

		shift=0 # Variable to read first the vdW curves

		rm -r ${arch_short}_electrostatic
		mkdir ${arch_short}_electrostatic
		
		pwd

		# Selecting files just with bin1 and bin$bin
		
		ls ${arch_short}_vdw | grep pH | grep pmf > list_ar
		ls $arch | grep pH | grep pmf >> list_ar
		
		line=$(wc -l list_ar | cut -d " " -f1)

		# Adding a tail with bin1		
		for ((bb=1 ; bb<=$line ; bb+=1)) do	
			echo '_bin1' >> bin1
		done
		
		new_bin=bin$best_bin
		# Removing bins that are not relevant 		
		paste list_ar bin1 | sed 's/\t//' | cut -d '_' -f1-3 | egrep "bin1|$new_bin" | sed 's/_bin1//g' > aux_list
		
		if [ $calculate_vdw == 'NO' ]; then 
			sort -u -t' ' -k1,1 aux_list > auxaux ; mv auxaux aux_list
			shift=1
		fi

		mv aux_list list_ar
		
		rm bin1 		
	
#######################################################################################################################################################################

		for ((i=1 ; i<=$line; i+=1)) do
		
			file_pmf=$(head -n$i list_ar | tail -n1)
			pH=$(echo $file_pmf | cut -d "_" -f1)
			bin=$(echo $file_pmf | cut -d "_" -f3)
		
			ls $arch/$file_pmf | grep average_div > list_pmf

			line_p=$(ls $arch/$file_pmf | grep average_div | wc -l)
		
			# Separation total curves

			if [ $shift -eq 1 ]; then ### 1
					
				mkdir -p ${arch_short}_electrostatic/$file_pmf
				mkdir -p ${arch_short}_electrostatic/electrostatic_$file_pmf

				cp $return_dir/9.contributions.py ${arch_short}_electrostatic/electrostatic_$file_pmf

				# Copying all files necessary
				
				if echo $bin | grep -q 'bin'; then
					bin_aux='_bin'$best_bin
					line_bin='_'
				else
					line_bin=''		
					bin_aux=''	
				fi

				
				for ((p=1 ; p<=$line_p ; p+=1)) do
					
					file_pmf_dev=$(head -n$p list_pmf | tail -n1)
						
					if echo $file_pmf_dev | cut -d "_" -f3 | grep -q curves$curves.pfm ; then ##### 2
					
						new_name_pfm=$(echo $file_pmf_dev | sed 's/_curves'${curves}'//g') 

						cp $arch/$file_pmf/$file_pmf_dev ${arch_short}_electrostatic/$file_pmf/$new_name_pfm
						
					fi ##### 2

				done
			

				# Calculation electrostatic contribution 
				
				if [ $calculate_electrostatic == 'YES' ]; then
				
					if [ $calculate_vdw == 'YES' ]; then ### vdw
		
						file_pmf_vdw="vdw_pH7.0_pmf${bin_aux}"

						cd ${arch_short}_electrostatic/electrostatic_$file_pmf
					
						pwd

			sed 's/##show##/'${show}'/g' 9.contributions.py | sed 's/##div##/'${div}'/g' | sed 's/##file_pmf##/'${file_pmf}'/g' | sed 's/##file_pmf_vdw##/'${file_pmf_vdw}'/g' >> 999 
						mv 999 9.contributions.py	
						python 9.contributions.py
						mv 0.average_and_deviation_div3.pfm ../0.average_and_deviation_electrostatic_${pH}${line_bin}${bin}_div$div.pfm

						cd ../../
						
					else ### vdw
					
						echo "${RED}Electrostatics can not be calculated if vdW is off!${NC}"
						
					fi ### vdw
					
				fi

			cp $arch/$file_pmf/0.average_and_deviation_div${div}_curves${curves}.pfm ${arch_short}_electrostatic/0.average_and_deviation_${pH}${line_bin}${bin}_div${div}.pfm
				
			# Separation vdW curves

			else ### 1
			
				if [ $calculate_vdw == 'YES' ]; then ################## 3

					if echo $bin | grep -q 'bin'; then
						line_bin='_'
						shift=1
					else
						line_bin=''		
					fi

					if echo $file_pmf | grep -q "pH7.0"; then ############## 4

						mkdir -p ${arch_short}_electrostatic/vdw_$file_pmf

						for ((p=1 ; p<=$line_p ; p+=1)) do
					
							file_pmf_dev=$(head -n$p list_pmf | tail -n1)
			
							if echo $file_pmf_dev | cut -d "_" -f3 | grep -q curves$curves.pfm ; then
							
								new_name_pfm=$(echo $file_pmf_dev | sed 's/_curves'${curves}'//g') 
							
								cp ${arch_short}_vdw/$file_pmf/$file_pmf_dev ${arch_short}_electrostatic/vdw_$file_pmf/vdw_$new_name_pfm
								
							fi
		

						done

			cp ${arch_short}_vdw/$file_pmf/0.average_and_deviation_div${div}_curves${curves}.pfm ${arch_short}_electrostatic/0.average_and_deviation_vdw${line_bin}${bin}_div${div}.pfm
			
					fi ############## 4
					
				fi  ################## 3

			fi ### 1
	
		done
		
#######################################################################################################################################################################

		#### Calculation of virial ####

		echo "computing virial..."

		cp $return_dir/virial/${arch_short}_virial_${virus} . # Copying FORTRAN code
		
		ls ${arch_short}_electrostatic/ | egrep "^pH|^electrostatic|^vdw" > list_u
		line_u=$(ls ${arch_short}_electrostatic/ | egrep "^pH|^electrostatic|^vdw" | wc -l)

		for ((u=1 ; u<=$line_u ; u+=1)) do 

			dir_pfm=$(head -n$u list_u | tail -n1)

			ls ${arch_short}_electrostatic/$dir_pfm | grep average > list_t
			line_t=$(ls ${arch_short}_electrostatic/$dir_pfm | grep average | wc -l)
				
			for ((t=1 ; t<=$line_t; t+=1)) do
		
				new_pfm=$(head -n$t list_t | tail -n1)
				cp ${arch_short}_electrostatic/$dir_pfm/$new_pfm pfm.dat

				echo ${arch_short}_electrostatic/$dir_pfm/$new_pfm
				echo $virus > name_virus
				echo $dir_pfm > way

				# FORTRAN
				./${arch_short}_virial_${virus}
				paste name_virus way integral >> $return_dir/9.virial.log
				
			done

			
		done

		#################################

		rm list_ar list_pmf list_u list_t integral pfm.dat way ${arch_short}_virial_${virus} name_virus

	done

	cd ..

done

cd ..

# Making plots

if [ $calculate_electrostatic == 'YES' ]; then

	echo
	echo '----------------- making pmf plots with new electrostatic curves -----------------'
	echo
sed 's/best_bin=##bin##/best_bin='${best_bin}'/g' 9.figures.sh | sed 's/curves_per_production=##curves##/curves_per_production='${curves}'/g' | sed 's/##oligomer##/'${oligomer}'/g' | sed 's/##oligomer_s##/'${arch_short}'/g' > f9.sh

	chmod +x f9.sh
	./f9.sh
	echo
	rm f9.sh
	echo 'done!'
fi

sed 's/##best_bin##/'${best_bin}'/g' 9.virial_average_and_deviation.sh > vf9.sh
chmod +x vf9.sh
./vf9.sh
rm vf9.sh

echo
echo Information:
echo division = $div
echo number of curves = $curves
echo best bin = $best_bin
echo oligomer = $oligomer
echo electrostatic = $calculate_electrostatic
echo vdW = $calculate_vdw
echo

aplay /usr/share/sounds/sound-icons/piano-3.wav
