date

show=0
return_dir=`pwd`
echo 'main location:' $return_dir
echo

chmod +x 5.clean_bin_folder.sh 
./5.clean_bin_folder.sh

bin_calculation(){

	cd $file_rdf

	cp ${return_dir}/5.bin.py .

	sed 's/##bin_size##/'${bin}'/g' 5.bin.py > 5.bin_${bin}.py
	echo "Calculating bin size = $bin"
	python 5.bin_${bin}.py
	echo 'done!'

	mkdir -p ${return_dir}/average_curves_bin${bin}

}

pmf_calculation(){
	# Making directory pmf with new bin

	cd ..

	file_pmf=$(echo $file_rdf | sed 's/_rdf/_pmf/g')
	rm -r ${file_pmf}_bin${bin}
	mkdir -p ${file_pmf}_bin${bin}
	cd ${file_pmf}_bin${bin}

	# Copying just the relevant rdf curves 

	echo "copying just relevant rdf curves"

	cp ../${file_pmf}/0.comparison2.dat .
	
	comp_line=$(wc -l 0.comparison2.dat | cut -d " " -f1)

	for ((cc=1; cc<=$comp_line; cc+=1)) do
		num_cur=$(head -n$cc 0.comparison2.dat | tail -n1 | cut -f1)
		cp ../${file_rdf}/bin_${bin}/rdf${num_cur}_bin${bin}.dat .
	done

	# Converting rdf to pmf

	echo ${file_rdf}_bin${bin} '->' ${file_pmf}_bin${bin}

	cp ${return_dir}/5.pmf.py .
	python 5.pmf.py
	rm rdf*dat

	# Calculating average 

	echo "calculating average"

	cp ${return_dir}/5.average.py .
	num_cur_nr=$(tail -n1 list_rdfs.log)
	sed 's/##show##/'${show}'/g' 5.average.py | sed 's/##max##/'${num_cur_nr}'/g' > 555
	mv 555 5.average.py
	python 5.average.py

	pH_name=$(echo $file_pmf | cut -d "_" -f1)
	cp 0.average.pfm ${return_dir}/average_curves_bin${bin}/${virus}_${arch}_${pH_name}_bin${bin}.pmf
	echo	

	cd ..
}

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
		echo "---------------------------------" $virus - $arch "---------------------------------"
		echo

		ls | grep rdf | grep pH > unique_rdf
		line=$(ls | grep rdf | grep pH | wc -l)
		
		for ((l=1; l <= $line ; l+=1)) do

			file_rdf=$(head -n$l unique_rdf | tail -n1)

			bin=2
			bin_calculation
			pmf_calculation

			bin=3
			bin_calculation
			pmf_calculation

			bin=5
			bin_calculation
			pmf_calculation

			echo "---------------------------------"
			echo

		done
			
		rm unique_rdf

		cd ..
	
	done

	echo
	
	cd ..
done

cd $return_dir

date

aplay /usr/share/sounds/sound-icons/piano-3.wav
