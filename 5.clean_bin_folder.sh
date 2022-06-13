rm -fr average_curves*bin*

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

		#rm -r pH*_pmf_bin4 pH*_pmf_bin6

		ls | grep rdf | grep pH > list
		line=$(ls | grep rdf | grep pH | wc -l)
		
		for ((i=1;i<=$line;i+=1)) do
	
			file_rdf=$(head -n$i list | tail -n1)
			cd $file_rdf

			#rm -fr bin_4 bin_6 5.bin_6.py 5.bin_4.py
	
			cd ..

		done
	
		#rm -fr pH*_pmf_bin*			
		
		rm list
		
		cd ..

	done

cd ..

done

cd ..	

