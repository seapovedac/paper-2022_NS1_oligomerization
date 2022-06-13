show=0
return_dir=`pwd`
echo 'main location:' $return_dir
echo

rm -r average_curves
mkdir average_curves

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
		echo "------ $arch ------"

		ls | grep pmf | grep pH > unique_pmf
		line=$(ls | grep pmf | grep pH | wc -l)

		for ((l=1; l <= $line ; l+=1)) do
			
			file_pmf=$(head -n$l unique_pmf | tail -n1)
			pH_name=$(echo $file_pmf | cut -d "_" -f1)

			if ! echo $file_pmf | grep -q bin; then

				cd $file_pmf

				pwd 
				cp ${return_dir}/4.average.py .
				sed 's/##show##/'${show}'/g' 4.average.py > 444 
				mv 444 4.average.py
				python 4.average.py

				cp 0.average.pfm ${return_dir}/average_curves/${virus}_${arch}_${pH_name}.pmf
				#cp 0.average.his ${return_dir}/average_curves/his/${virus}_${arch}_${pH_name}.his

				cd ..
			fi
		
		done

		rm unique_pmf

		cd ..

	done

	echo
	cd ..

done

aplay /usr/share/sounds/sound-icons/piano-3.wav
