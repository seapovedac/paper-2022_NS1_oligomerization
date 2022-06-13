******************
* Calculating B2 *
******************

*********************************************************************
* Este programa hace una lectura de un fichero (rdf) a dos columnas *
* término a término y calcula el coeficiente de virial              *
*********************************************************************

 	
        program virial

	implicit none

 	integer, parameter :: num = 10000
 	integer i, j, var, num1
	real wr(num), rad(num)
	real sig, x1, x2, y1, y2, f1, f2
	real term1, term2, term3, term4, term5, sim
	real smt, b2el, b2er, b2
	double precision, parameter :: pi = 3.141592654d0
	double precision, parameter :: avg = 6.022E23
	double precision, parameter :: mw = 79499.6 ! g/mol o Da


***********************
* Lectura del archivo *
***********************

	open(2,file='pfm.dat')
	read(2,*)
    	open(3,file='integral')

	var = 0
80	do while (var < num)
		var = var + 1
		read (2,*,end=99) rad(var), wr(var)
	go to 80	
	end do

*************************************
* Recorriendo posición por posición *
*************************************

99	continue

	var = 0 
	num1 = num - 1
	x1 = 0
  	x2 = 0

	do while (var < num1)	
		do i = 1, 2
		j = j + 1
		var = var + 1 

		if (var .EQ. 1) then

		sig = rad(var)

		!write(*,*) var, rad(var), sig

		end if
	
		if (i .EQ. 1) then ! primera posición 
		x1 = rad(var)
		y1 = wr(var)

		else		   ! segunda posición 
		x2 = rad(var)	
		y2 = wr(var)	
		
		end if

	 	!write(*,*) x1, x2

		if (x2 .NE. 0) then
		if (x1 .NE. x2) then


		f1 = (exp(-y1) - 1) * x1**2 ! funciones
		f2 = (exp(-y2) - 1) * x2**2

*********************
* Método de Simpson *
*********************

	term1 = (x2 - x1) / 6
	term2 = ((f2 + f1) / 2 ) * 4

	sim = term1 * (f1 + term2 + f2) 
	smt = smt + sim ! sumatória

	!write(3,*) sim, smt
	
	end if
	end if

	end do

	var = var - 1
	
	end do

	write(*,*) 'Integral: ', smt

*****************
* Calculando B2 *
*****************

	term3 = (-avg*pi*2)/(mw*mw) 
	b2el = (smt * 1E-24) * term3 
	write(*,'('' B2 (ele + VdW): '',E12.4 )') b2el

	term4 = avg/(3*mw*mw) 
	term5 = pi * (sig+sig)**3 * 1E-24 
	b2er = term4 * term5 	
	write(*,'('' B2 (er): '',E12.4 )') b2er

	b2 = (b2el + b2er) * 1E4 ! Eureka!
	write(*,*) 'B2:', b2
	write(3, '(F13.7 )') b2

	close (2)
	close (3)
	
	end program virial
