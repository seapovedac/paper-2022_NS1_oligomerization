show=0
return_dir=`pwd`
echo 'main location:' $return_dir

oligomer='dimer'
oligomer_s='d'
div=3

dir_target="average_and_deviation_curves"
ls $dir_target > list_av
line=$(ls $dir_target | wc -l)

# Function
make_figure1(){

		cp $return_dir/8.contributions.py .
		cp $return_dir/8.contributions_dimer.par .
		cp $return_dir/8.line.dat .
		
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
	
			for ((p=1 ; p<=3 ; p+=1)) do

				if [ $p -eq 1 ]; then

					pH=3.0
	
					x1=30
					x2=130
					x_maj=20

					y1=-2.5
					y2=4
					y_maj=2

				fi
				if [ $p -eq 2 ]; then

					pH=7.0

					x1=30
					x2=130
					x_maj=20

					y1=-2.5
					y2=0.5
					y_maj=1

				fi
				if [ $p -eq 3 ]; then
					
					pH=8.5

					x1=30
					x2=130
					x_maj=20

					y1=-2.5
					y2=0.5
					y_maj=1

				fi

				echo $virus pH $pH bin $bin_size

			sed 's/##show##/'${show}'/g' 8.contributions.py | sed 's/##virus##/'${virus}'/g' | sed 's/##oligomer##/'${oligomer}'/g' | sed 's/##pH##/'${pH}'/g' > 888 ; mv 888 8.contributions.$virus.py
			python 8.contributions.$virus.py

		sed 's/##virus##/'${virus}'/g' 8.contributions_dimer.par | sed 's/##pH##/'${pH}'/g' | sed 's/##x1##/'${x1}'/g' | sed 's/##x2##/'${x2}'/g' | sed 's/##x_maj##/'${x_maj}'/g' | sed 's/##y1##/'${y1}'/g' | sed 's/##y2##/'${y2}'/g' | sed 's/##y_maj##/'${y_maj}'/g' > 8.contributions_pH${pH}_$virus.par


gracebat -settype xydy ${virus}_${oligomer}_pH${pH}_div${div}.pmf ${virus}_${oligomer_s}_vdw_pH7.0_div${div}.pmf ${virus}_${oligomer}_electrostatic_pH${pH}_div${div}.pmf 8.line.dat -p 8.contributions_pH${pH}_$virus.par -autoscale xy -saveall ${virus}_pH${pH}_contributions.xvg
gracebat -settype xydy ${virus}_${oligomer}_pH${pH}_div${div}.pmf ${virus}_${oligomer_s}_vdw_pH7.0_div${div}.pmf ${virus}_${oligomer}_electrostatic_pH${pH}_div${div}.pmf 8.line.dat -p 8.contributions_pH${pH}_$virus.par -autoscale xy -hdevice PNG -saveall ${virus}_pH${pH}_contributions.png

echo ${virus} >> command_figure.txt
echo "gracebat -settype xydy ${virus}_${oligomer}_pH${pH}_div${div}.pmf ${virus}_${oligomer_s}_vdw_pH7.0_div${div}.pmf ${virus}_${oligomer}_electrostatic_pH${pH}_div${div}.pmf 8.line.dat -p 8.contributions_pH${pH}_$virus.par -autoscale xy -saveall ${virus}_pH${pH}_contributions.xvg" >> command_figure.txt
echo >> command_figure.txt

		mv ${virus}_pH${pH}_contributions.ps figures_contributions/
		mv ${virus}_pH${pH}_contributions.xvg figures_contributions/
		mv ${virus}_pH${pH}_contributions.png figures_contributions/
		mv 8.contributions_pH${pH}_$virus.par figures_contributions
			
			done

		done

	mv command_figure.txt figures_contributions
	mv 8.line.dat figures_contributions

}

make_figure2(){

	cp $return_dir/8.virus.par .
	cp $return_dir/8.line.dat .

for ((tc=6 ; tc<=10 ; tc+=1)) do

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

	curves_per_production=$(echo "${test_cur}/${div}" | bc)

	for ((con=4 ; con <= 5; con+=1)) do
	
		if [ $con -eq 1 ]; then
			condition=monomer
			condition_name=Monomer
			pH_b=1
			pH_e=3
		fi
		if [ $con -eq 2 ]; then
			condition=dimer
			condition_name=Dimer
			pH_b=1
			pH_e=3
		fi
		
		if [ $con -eq 3 ]; then
			condition=dimer_0.005M
			condition_name=dimer_0.005M
			pH_b=2
			pH_e=2
		fi
		
		if [ $con -eq 4 ]; then
			condition=dimer
			condition_name=dimer
			pH_b=2
			pH_e=2
		fi
		
		if [ $con -eq 5 ]; then
			condition=d_vdw
			condition_name=vdW
			pH_b=2
			pH_e=2
		fi
		if [ $con -eq 6 ]; then
			condition=dimer_electrostatic
			condition_name=Electrostatic
			pH_b=1
			pH_e=3
		fi

		for ((p=${pH_b} ; p<=${pH_e} ; p+=1)) do

			if [ $p -eq 1 ]; then

				pH=3.0

				x1=40
				x2=130
				x_maj=20

				y1=-2.5
				y2=2
				y_maj=1

			fi
			if [ $p -eq 2 ]; then

				pH=7.0

				x1=32
				x2=60
				x_maj=5

				y1=-5
				y2=1
				y_maj=2

				#x1=32
				#x2=90
				#x_maj=10

				#y1=-2.7
				#y2=0.1
				#y_maj=0.5
				
				#x1=32			# for salt at 5 mM
				#x2=180
				#x_maj=30
				
				#y1=-5			# for salt at 5 mM
				#y2=1
				#y_maj=1
			fi
			if [ $p -eq 3 ]; then
				
				pH=8.5

				x1=32
				x2=90
				x_maj=10

				y1=-2.7
				y2=0.1
				y_maj=0.5

			fi

	sed 's/##contribution##/'${condition_name}'/g' 8.virus.par | sed 's/##pH##/'${pH}'/g' |sed 's/##x1##/'${x1}'/g' | sed 's/##x2##/'${x2}'/g' | sed 's/##x_maj##/'${x_maj}'/g' | sed 's/##y1##/'${y1}'/g' | sed 's/##y2##/'${y2}'/g' | sed 's/##y_maj##/'${y_maj}'/g' | sed 's/##curves##/'${curves_per_production}'/g' > virus_${condition}_pH${pH}.par

	gracebat -settype xydy ZIKV-UG_${condition}_pH${pH}_div${div}_curves${curves_per_production}.pmf ZIKV-BR_${condition}_pH${pH}_div${div}_curves${curves_per_production}.pmf DENV2_${condition}_pH${pH}_div${div}_curves${curves_per_production}.pmf WNV_${condition}_pH${pH}_div${div}_curves${curves_per_production}.pmf 8.line.dat -p virus_${condition}_pH${pH}.par -autoscale xy -saveall virus_${condition}_pH${pH}_curves${curves_per_production}.xvg

	gracebat -settype xydy ZIKV-UG_${condition}_pH${pH}_div${div}_curves${curves_per_production}.pmf ZIKV-BR_${condition}_pH${pH}_div${div}_curves${curves_per_production}.pmf DENV2_${condition}_pH${pH}_div${div}_curves${curves_per_production}.pmf WNV_${condition}_pH${pH}_div${div}_curves${curves_per_production}.pmf 8.line.dat -p virus_${condition}_pH${pH}.par -autoscale xy -hdevice PNG -saveall virus_${condition}_pH${pH}_curves${curves_per_production}.png

	echo ${condition} >> command_figure.txt
	echo "gracebat -settype xydy ZIKV-UG_${condition}_pH${pH}_div${div}_curves${curves_per_production}.pmf ZIKV-BR_${condition}_pH${pH}_div${div}_curves${curves_per_production}.pmf DENV2_${condition}_pH${pH}_div${div}_curves${curves_per_production}.pmf WNV_${condition}_pH${pH}_div${div}_curves${curves_per_production}.pmf 8.line.dat -p virus_${condition}_pH${pH}.par -autoscale xy -saveall virus_${condition}_pH${pH}.xvg" >> command_figure.txt
	echo >> command_figure.txt

	mv virus_${condition}_pH${pH}_curves${curves_per_production}.ps figures_virus/
	mv virus_${condition}_pH${pH}_curves${curves_per_production}.xvg figures_virus/
	mv virus_${condition}_pH${pH}_curves${curves_per_production}.png figures_virus/
	mv virus_${condition}_pH${pH}.par figures_virus/

		done

	done

done

	mv command_figure.txt figures_virus/
	mv 8.line.dat figures_virus/

}

#line=1
for ((i=1 ; i<=$line ; i +=1)) do

	dir_bin=$(head -n$i list_av | tail -n1)

	#rm -r ${dir_target}/${dir_bin}/figures_contributions
	#mkdir -p ${dir_target}/${dir_bin}/figures_contributions
	rm -r ${dir_target}/${dir_bin}/figures_virus
	mkdir -p ${dir_target}/${dir_bin}/figures_virus

	bin_size=$(echo ${dir_bin} | cut -d "n" -f2)

	cd ${dir_target}/${dir_bin}
	
	#make_figure1	# figure contributions
	make_figure2	# figure viruses

	cd ../../

done

rm list_av

aplay /usr/share/sounds/sound-icons/piano-3.wav
