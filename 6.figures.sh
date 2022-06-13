show=0
return_dir=`pwd`
echo 'main location:' $return_dir

oligomer='dimer'
oligomer_s='d'

ls | grep "average_curves"  > list_av
line=$(ls | grep "average_curves" | wc -l)

copy_file(){

	#cp $return_dir/6.contributions.py .
	#cp $return_dir/6.contributions.par .
	cp $return_dir/6.virus.par .
	cp $return_dir/6.line.dat .
}

# Function
make_figure1(){

	copy_file

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
		sed 's/##show##/'${show}'/g' 6.contributions.py | sed 's/##virus##/'${virus}'/g' | sed 's/##ext##/'${ext}'/g' | sed 's/##bin##/'${bin_size}'/g' | sed 's/##number##/'${number}'/g' | sed 's/##line##/'${line_f}'/g' > 666 ; mv 666 6.contributions.$virus.py
			python 6.contributions.$virus.py

		sed 's/##virus##/'${virus}'/g' 6.contributions.par > 6.contributions_$virus.par

gracebat ${virus}_dimer_pH7.0${line_f}${bin_size}.pmf ${virus}_${oligomer_s}_vdw_pH7.0${line_f}${bin_size}.pmf ${virus}_fixed_charges_pH7.0${line_f}${bin_size}.pmf ${virus}_ch_dip_pH7.0${line_f}${bin_size}.pmf ${virus}_ch_reg_pH7.0${line_f}${bin_size}.pmf ${virus}_charge_central_pH7.0${line_f}${bin_size}.pmf ${virus}_charge_distributed_pH7.0${line_f}${bin_size}.pmf 6.line.dat -p 6.contributions_$virus.par -autoscale xy -saveall ${virus}_contributions.xvg

echo ${virus} >> command_figure.txt
echo "gracebat ${virus}_dimer_pH7.0${line_f}${bin_size}.pmf ${virus}_${oligomer_s}_vdw_pH7.0${line_f}${bin_size}.pmf ${virus}_fixed_charges_pH7.0${line_f}${bin_size}.pmf ${virus}_ch_dip_pH7.0${line_f}${bin_size}.pmf ${virus}_ch_reg_pH7.0.pmf ${virus}_charge_central_pH7.0${line_f}${bin_size}.pmf ${virus}_charge_distributed_pH7.0${line_f}${bin_size}.pmf 6.line.dat -p 6.contributions_$virus.par -autoscale xy -saveall ${virus}_contributions.xvg" >> command_figure.txt
echo >> command_figure.txt

gracebat ${virus}_dimer_pH7.0${line_f}${bin_size}.pmf ${virus}_${oligomer_s}_vdw_pH7.0${line_f}${bin_size}.pmf ${virus}_fixed_charges_pH7.0${line_f}${bin_size}.pmf ${virus}_ch_dip_pH7.0${line_f}${bin_size}.pmf ${virus}_ch_reg_pH7.0${line_f}${bin_size}.pmf ${virus}_charge_central_pH7.0${line_f}${bin_size}.pmf ${virus}_charge_distributed_pH7.0${line_f}${bin_size}.pmf 6.line.dat -p 6.contributions_$virus.par -autoscale xy -hdevice PNG -saveall ${virus}_contributions.png

		mv ${virus}_contributions.ps figures_contributions/
		mv ${virus}_contributions.xvg figures_contributions/
		mv ${virus}_contributions.png figures_contributions/
		mv 6.contributions_$virus.par figures_contributions

		done

	mv command_figure.txt figures_contributions
	cp 6.line.dat figures_contributions
}

make_figure2(){

	copy_file

	for ((con=4 ; con <= 5; con+=1)) do
	
		if [ $con -eq 1 ]; then
			condition=monomer
		fi
		if [ $con -eq 2 ]; then
			condition=dimer
		fi
		if [ $con -eq 3 ]; then
			condition=dimer_0.005M
		fi
		if [ $con -eq 4 ]; then
			condition=dimer
		fi
		if [ $con -eq 5 ]; then
			condition=d_vdw
		fi
		if [ $con -eq 6 ]; then
			condition=fixed_charges
		fi
		if [ $con -eq 7 ]; then
			condition=ch_dip
		fi
		if [ $con -eq 8 ]; then
			condition=ch_reg
		fi
		if [ $con -eq 9 ]; then
			condition=charge_central
		fi
		if [ $con -eq 10 ]; then
			condition=charge_distributed
		fi

	sed 's/##contribution##/'${condition}'/g' 6.virus.par > virus_${condition}.par
	gracebat ZIKV-UG_${condition}_pH7.0${line_f}${bin_size}.pmf ZIKV-BR_${condition}_pH7.0${line_f}${bin_size}.pmf DENV2_${condition}_pH7.0${line_f}${bin_size}.pmf WNV_${condition}_pH7.0${line_f}${bin_size}.pmf 6.line.dat -p virus_${condition}.par -autoscale xy -saveall virus_${condition}.xvg

	gracebat ZIKV-UG_${condition}_pH7.0${line_f}${bin_size}.pmf ZIKV-BR_${condition}_pH7.0${line_f}${bin_size}.pmf DENV2_${condition}_pH7.0${line_f}${bin_size}.pmf WNV_${condition}_pH7.0${line_f}${bin_size}.pmf 6.line.dat -p virus_${condition}.par -autoscale xy -hdevice PNG -saveall virus_${condition}.png

	echo ${condition} >> command_figure.txt
	echo "gracebat ZIKV-UG_${condition}_pH7.0${line_f}${bin_size}.pmf ZIKV-BR_${condition}_pH7.0${line_f}${bin_size}.pmf DENV2_${condition}_pH7.0${line_f}${bin_size}.pmf WNV_${condition}_pH7.0${line_f}${bin_size}.pmf 6.line.dat -p virus_${condition}.par -autoscale xy -saveall virus_${condition}.xvg" >> command_figure.txt
	echo >> command_figure.txt

	mv virus_$condition.ps figures_virus/
	mv virus_$condition.xvg figures_virus/
	mv virus_$condition.png figures_virus/
	mv virus_${condition}.par figures_virus/

	done

	mv command_figure.txt figures_virus/
	mv 6.line.dat figures_virus/

}

#line=1
for ((i=1 ; i<=$line ; i +=1)) do

	dir_ave=$(head -n$i list_av | tail -n1)
	bin_size=$(head -n$i list_av | tail -n1 | cut -d "_" -f3)

	if echo $dir_ave | grep -q "bin"; then

		number=-2
		ext=''
		line_f='_'

		rm -r $dir_ave/figures_virus
		mkdir -p $dir_ave/figures_virus
		#rm -r $dir_ave/figures_contributions
		#mkdir -p $dir_ave/figures_contributions
		cd $dir_ave/
		pwd

		#make_figure1 # figure contributions
		make_figure2 # figure viruses
		rm *par

		cd $return_dir
		
	else

		number=-1
		ext='.pmf'
		line_f=''

		rm -r $dir_ave/figures_virus
		mkdir -p $dir_ave/figures_virus
		#rm -r $dir_ave/figures_contributions
		#mkdir -p $dir_ave/figures_contributions
		cd $dir_ave/
		pwd

		#make_figure1 # figure contributions
		make_figure2 # figure viruses

		rm *par

		cd $return_dir

	fi

done

rm list_av

#

