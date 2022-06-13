grep -v '&' 0.comparison.dat > 0.comparison2.dat

total=###max###
for ((i=1 ; i<=$total ; i+=1)) do

	# Reading lines
	rep=$(grep -w "^$i" 0.comparison2.dat | wc -l)

	if [ $rep -gt 1 ]; then	# Choosing lines with repetitions

		rep_aux=$[ $rep - 1 ]
		grep -w "^$i" 0.comparison2.dat | tail -n$rep_aux | cut -f2 > aux_com

		# Removing repeats
		for ((j=1 ; j<=$rep_aux ; j+=1)); do
					
			rep2=$(head -n$j aux_com | tail -n1)
			grep -v	"^$rep2" 0.comparison2.dat > aux_com2
			mv aux_com2 0.comparison2.dat

			awk -v awkvar=$rep2 -F " " '{ if ( $2 != awkvar ) print $0 }' 0.comparison2.dat > aux_com2 
			mv aux_com2 0.comparison2.dat

		done

	fi

done

lines=$(wc -l 0.comparison2.dat | cut -d ' ' -f1)
echo $lines > number_no_rep
echo 'redudant curves eliminated!'
#rm aux_com
