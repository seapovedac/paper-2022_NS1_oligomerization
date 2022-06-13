rm 3.total_number_curves_no-redundant.log

return_dir=`pwd`
echo 'main location:' $return_dir
echo

cd DATA

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
		
	echo $virus
	cd $virus

	for ((f=4; f<=5 ; f+=1)) do

		if [ $f -eq 1 ]; then
			arch=monomer
		fi
		if [ $f -eq 2 ]; then
			arch=dimer
		fi
		if [ $f -eq 3 ]; then
			arch=dimer_0.005M
		fi
		if [ $f -eq 4 ]; then
			arch=dimer
		fi
		if [ $f -eq 5 ]; then
			arch=d_vdw
		fi
		if [ $f -eq 6 ]; then
			arch=fixed_charges
		fi
		if [ $f -eq 7 ]; then
			arch=charge_central
		fi
		if [ $f -eq 8 ]; then
			arch=charge_distributed
		fi

		cd $arch

		ls | grep rdf | grep pH > unique_rdf
		line=$(ls | grep rdf | grep pH | wc -l)
		
		for ((l=1; l <= $line ; l+=1)) do

			file_rdf=$(head -n$l unique_rdf | tail -n1)
			file_pmf=$(echo $file_rdf | sed 's/_rdf/_pmf/g')
			echo $file_rdf '->' $file_pmf
		
			rm -r $file_pmf
			mkdir -p $file_pmf
			cd $file_pmf
			pwd

			# Converting rdf to pmf
			cp ${return_dir}/3.pmf.py .
			sed 's/##dir##/'${file_rdf}'/g' 3.pmf.py > 333 ; mv 333 3.pmf.py
			python 3.pmf.py

			# Comparing pmf curves
			echo comparing curves
			number_rdfs=$(tail -n1 list_rdfs.log)
			cp ${return_dir}/3.comparison.py .
			sed 's/###max###/'${number_rdfs}'/g' 3.comparison.py > 333 ; mv 333 3.comparison.py
			python 3.comparison.py

			# Removing repeated pmf curves
			echo removing repeated curves
			cp ${return_dir}/3.remove_rep.sh .
			sed 's/###max###/'${number_rdfs}'/g' 3.remove_rep.sh > 333 ; mv 333 3.remove_rep.sh
			chmod +x 3.remove_rep.sh
			./3.remove_rep.sh

			pwd > location			
			paste location number_no_rep > num
			cat num >> ${return_dir}/3.total_number_curves_no-redundant.log
			rm num

			rm location 
			
			cd ..
			
			echo 

		done
			
		rm unique_rdf

		cd ..
	
	done

	echo
	
	cd ..
done

aplay /usr/share/sounds/sound-icons/piano-3.wav
