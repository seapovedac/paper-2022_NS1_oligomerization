echo
echo "----------------- making figures and tables with virial values -----------------"
echo

rm -r virial_figures
mkdir virial_figures

arbitrary_pH_vdW=5.5

get_values(){

	if [ $bin -eq 0 ]; then
		grep ${virus} 9.virial.log | awk -F'\t' '{print $2, $1, $3}' | grep "^${condition}" | grep ${pH_c} | grep -v bin | awk '{print $3}' > values
	else
		grep ${virus} 9.virial.log | awk -F'\t' '{print $2, $1, $3}' | grep "^${condition}" | grep ${pH_c} | grep bin | awk '{print $3}' > values
	fi
	
	average=$(awk '{x+=$0;y+=$0}END{printf "%0.8f" , (y/NR)}' values)
	st_dev=$(awk '{x+=$0;y+=$0^2}END{printf "%0.8f" , sqrt(y/NR-(x/NR)^2)}' values)


	echo -e "$virus\t$name\t$pH\t$average\t$st_dev"

}

for ((b=1; b<=2; b+=1)) do 

	if [ $b -eq 1 ]; then
		bin=0
		bin_name=bin1
	fi
	if [ $b -eq 2 ]; then
		bin=1
		bin_name=bin##best_bin##
	fi

	shift_pH=1
	echo "Condition,pH,ZIKV-UG,,ZIKV-BR,,DENV2,,WNV,," > 9.data_virial_$bin_name.csv

	for ((v=1; v<=4; v+=1)) do

		if [ $v -eq 1 ]; then
			virus=ZIKV-UG
		fi
		if [ $v -eq 2 ]; then
			virus=ZIKV-BR
			shift_pH=0
		fi
		if [ $v -eq 3 ]; then
			virus=DENV2
		fi
		if [ $v -eq 4 ]; then
			virus=WNV
		fi
			
		for ((f=1; f<=3 ; f+=1)) do

			if [ $f -eq 1 ]; then
				condition='pH'
				name='Total  '
				pH_b=2
				pH_e=2
			fi
			if [ $f -eq 2 ]; then
				condition='vdw'
				name='vdW    '
				pH_b=2
				pH_e=2
			fi
			if [ $f -eq 3 ]; then
				condition='electrostatic'
				name='Electro'
				pH_b=2
				pH_e=2
			fi

			for ((p=${pH_b} ; p<=${pH_e} ; p+=1)) do

				if [ $p -eq 1 ]; then
					pH=3.0
					pH_c="3\.0"
				fi
				if [ $p -eq 2 ]; then
					pH=7.0
					pH_c="7\.0"
				fi
				if [ $p -eq 3 ]; then
					pH=8.5
					pH_c="8\.5"
				fi

				if [ $shift_pH -eq 1 ]; then
					echo -e "$name," >> name_data
					echo -e "$pH," >> pH_data
				fi
			
				if [ $bin -eq 0 ]; then

					get_values
					
					if [ $condition == 'vdw' ];then
						echo 0 $average 0 >> 9.virial_${bin_name}.dat
						echo 14 $average 0 >> 9.virial_${bin_name}.dat
						echo -e "$average,$st_dev," >> ${virus}.aux
					else
 						echo $pH $average $st_dev >> 9.virial_${bin_name}.dat
						echo -e "$average,$st_dev," >> ${virus}.aux
					fi

				else

					get_values

					if [ $condition == 'vdw' ];then
						echo 0 $average 0 >> 9.virial_${bin_name}.dat
						echo 14 $average 0 >> 9.virial_${bin_name}.dat
						echo -e "$average,$st_dev," >> ${virus}.aux
					else
 						echo $pH $average $st_dev >> 9.virial_${bin_name}.dat
						echo -e "$average,$st_dev," >> ${virus}.aux
					fi
				fi
				
			done

			echo '&' >> 9.virial_${bin_name}.dat

		done

	done

	paste name_data pH_data ZIKV-UG.aux ZIKV-BR.aux DENV2.aux WNV.aux >> 9.data_virial_$bin_name.csv
	sed 's/\t//g' 9.data_virial_$bin_name.csv > 999 ; mv 999 9.data_virial_$bin_name.csv
	gracebat -settype xydy 9.virial_${bin_name}.dat 9.line.dat -p 9.virial.par -autoscale xy -saveall virial_${bin_name}.xvg
	gracebat -settype xydy 9.virial_${bin_name}.dat 9.line.dat -p 9.virial.par -autoscale xy -hdevice PNG -saveall virial_${bin_name}.png

	mv 9.virial_${bin_name}.dat virial_figures
	mv virial_${bin_name}.xvg virial_figures
	mv virial_${bin_name}.ps virial_figures
	mv virial_${bin_name}.png virial_figures
	mv 9.data_virial_$bin_name.csv virial_figures

	rm values ZIKV-UG.aux ZIKV-BR.aux DENV2.aux WNV.aux pH_data name_data

done

echo
echo 'done!'
		
