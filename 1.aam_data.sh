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
		if [ $f -eq 9 ]; then
			arch=titration
		fi
		if [ $f -eq 10 ]; then
			arch=exchange
		fi

		cd $arch

		### Choosing aam ###

		if [ $f -eq 1 ]; then	# monomers

			if [ $v -eq 1 ]; then
				aam_file=zikv_ug_m.aam
			fi
			if [ $v -eq 2 ]; then
				aam_file=zikv_br_m.aam
			fi
			if [ $v -eq 3 ]; then
				aam_file=denv2_m.aam
			fi
			if [ $v -eq 4 ]; then
				aam_file=wnv_m.aam
			fi

		fi			

		if [ $f -ge 2 ] && [ $f -le 5 ]; then	# dimers and vdw

			if [ $v -eq 1 ]; then
				aam_file=zikv_ug_d.aam
			fi
			if [ $v -eq 2 ]; then
				aam_file=zikv_br_d.aam
			fi
			if [ $v -eq 3 ]; then
				aam_file=denv2_d.aam
			fi
			if [ $v -eq 4 ]; then
				aam_file=wnv_d.aam
			fi

		fi

		if [ $f -eq 6 ]; then	# dimers fixed charges

			if [ $v -eq 1 ]; then
				aam_file=charge_7.0_model_zv_5k6k.aam
			fi
			if [ $v -eq 2 ]; then
				aam_file=charge_7.0_model_zv_5gs6.aam
			fi
			if [ $v -eq 3 ]; then
				aam_file=charge_7.0_denv2.aam
			fi
			if [ $v -eq 4 ]; then
				aam_file=charge_7.0_wnv.aam
			fi

		fi		

		if [ $f -eq 7 ]; then	# dimers charge center

			if [ $v -eq 1 ]; then
				aam_file=charge_center_model_zv_5k6k.aam
			fi
			if [ $v -eq 2 ]; then
				aam_file=charge_center_model_zv_5gs6.aam
			fi
			if [ $v -eq 3 ]; then
				aam_file=charge_center_denv2.aam
			fi
			if [ $v -eq 4 ]; then
				aam_file=charge_center_wnv.aam
			fi

		fi	

		if [ $f -eq 8 ]; then	# dimers charge distributed

			if [ $v -eq 1 ]; then
				aam_file=charge_distributed_model_zv_5k6k.aam
			fi
			if [ $v -eq 2 ]; then
				aam_file=charge_distributed_model_zv_5gs6.aam
			fi
			if [ $v -eq 3 ]; then
				aam_file=charge_distributed_denv2.aam
			fi
			if [ $v -eq 4 ]; then
				aam_file=charge_distributed_wnv.aam
			fi

		fi	

		# Choosing structures UG and BR to EXCH
		if [ $f -eq 9 ] || [ $f -eq 10 ]; then	# if titration

			if [ $v -eq 1 ]; then
				aam_file_ex=zikv_ug_exchanged.aam
			fi 
			if [ $v -eq 2 ]; then
				aam_file_ex=zikv_br_exchanged.aam
			fi 

		fi

		pwd

		# Accesing in subdirectory

		ls | grep $virus > list_files
		lines=$(wc -l list_files | cut -d " " -f1)

#		lines=1
		for	((l=1 ; l<=$lines ; l+=1)) do

			sub_file=$(head -n$l list_files | tail -n1)

			# Accesing aam's
			ls $sub_file | grep aam > aam_files

			lm=$(wc -l aam_files | cut -d " " -f1)

			for ((m=1; m<=$lm ; m+=1)) do

				mol_aam=$(head -n$m aam_files | tail -n1)

				if echo $sub_file | grep -q EXCH; then  
					base_aam=$aam_file_ex
				else
					base_aam=$aam_file
				fi

				# Detecting difference

				if diff -q $sub_file/$mol_aam ../../../structures_base/$base_aam | grep -q "diff"; then
					differ=YES	
				else
					differ=NO
				fi
				echo $sub_file, $mol_aam X $base_aam, $differ

			done

		done

		cd ..

	echo
	done

	echo
	cd ..

done

cd ..

awk '{print $1,$5}' 1.aam_data.log | egrep -v "Titration|titration" | egrep "NO|home" | sed 's/,//g' > 1.valid_data.txt
echo '/home/' >> 1.valid_data.txt

aplay /usr/share/sounds/sound-icons/piano-3.wav
