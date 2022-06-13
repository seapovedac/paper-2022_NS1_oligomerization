show=0
return_dir=`pwd`
echo 'main location:' $return_dir

oligomer=##oligomer##
oligomer_s=##oligomer_s##
div=3
best_bin=##bin##
curves_per_production=##curves##

mkdir average_and_deviation_curves_v2_with_electro
dir_target="average_and_deviation_curves"
echo bin1 > list_av
echo bin$best_bin >> list_av
line=$(more list_av | wc -l)

make_figure(){


	# Copying files

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
		
			for ((p=2 ; p<=2 ; p+=1)) do

				if [ $p -eq 1 ]; then
					pH=3.0
				fi
				if [ $p -eq 2 ]; then
					pH=7.0
				fi
				if [ $p -eq 3 ]; then
					pH=8.5
				fi
		
			if [ $bin_size -eq 1 ]; then
				bin_name=''
			else
				bin_bame='_bin2'
			fi
		
			electrostatic_file=$return_dir/DATA/$virus/${oligomer_s}_electrostatic/0.average_and_deviation_electrostatic_pH${pH}${bin_name}_div${div}.pfm
			cp $electrostatic_file ${virus}_${oligomer}_electrostatic_pH${pH}_div${div}_curves${curves_per_production}.pmf

		done

	done
	
#########################################################################################################

	cp $return_dir/8.virus.par .
	cp $return_dir/8.line.dat .	

	for ((con=4 ; con <= 4; con+=1)) do
	
		if [ $con -eq 1 ]; then
			condition=monomer
			condition_name=Monomer
			pH_b=1
			pH_e=3
		fi
		if [ $con -eq 2 ]; then
			condition=dimer
			condition_name=Dimer
			pH_b=2
			pH_e=2
		fi
		if [ $con -eq 3 ]; then
			condition=d_vdw
			condition_name=vdW
			pH_b=2
			pH_e=2
		fi
		if [ $con -eq 4 ]; then
			condition=dimer_electrostatic
			condition_name=Electrostatic
			pH_b=2
			pH_e=2
		fi

		for ((p=${pH_b} ; p<=${pH_e} ; p+=1)) do

			if [ $p -eq 1 ]; then

				pH=3.0

				x1=40
				x2=130
				x_maj=20

				y1=-3
				y2=2
				y_maj=1

			fi
			if [ $p -eq 2 ]; then

				pH=7.0

				x1=30
				x2=130
				x_maj=20

				y1=-3
				y2=2
				y_maj=1

			fi
			if [ $p -eq 3 ]; then
				
				pH=8.5

				x1=30
				x2=130
				x_maj=20

				y1=-3
				y2=2
				y_maj=1

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

	mv command_figure.txt figures_virus/
	mv 8.line.dat figures_virus/

}

for ((i=1 ; i<=$line ; i +=1)) do

	dir_bin=$(head -n$i list_av | tail -n1)
	bin_size=$(echo ${dir_bin} | cut -d "n" -f2)
	
	mkdir -p average_and_deviation_curves_v2_with_electro/${dir_bin}

	cd average_and_deviation_curves_v2_with_electro/$dir_bin

	mkdir -p figures_virus

	make_figure

	cd ../../

done

rm list_av

