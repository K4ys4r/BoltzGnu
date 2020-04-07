# BoltzGnu
BoltzGnu Contains Four Gnuplot Scripts which allow to plot BoltzTraP Output Data.

	1. pTRACE_E.gp       -> To plot Trasport proporties as a function of energy at define Temperature
	2. pTRACE_E_multT.gp -> To plot Trasport proporties as a function of energy at different define Temperatures
	3. pTRACE_N.gp       -> To plot Trasport proporties as a function of Carrier Concentration at define Temperature
	4. pDOPING_T.gp      -> To plot Trasport proporties as a function of Temperature at define [n]
	
Gnuplot Version > 5.0 is required  

The Scripts are used to plot BoltzTraP Data Output (i.e *trace files and doping)<br>
In this Folder you can find two exemple files  File.trace & Doping.data<br> 

To have a quick demonstration Run:
```bash
	./Run_test
or
	sh Run_test
```

# Doping File
The intrans file and giving the concentration of doping (hole or electron) and then execute boltztrap code and normally you get the file trace_doping

the intrance file will look like some things like that:
```
WIEN
0 0 0 0.0
0.7062793704 0.0005 0.4 42
CALC
5
BOLTZ
.15
1500. 10.
-1
HISTO
0 0 0 0     # ewperimental tau Values if you want to introduce them
2           # number of carrier concentration
1e18 -1e18  # 1st and 2nd carrier concentration /cm^3
```

For more informations or any questions, mail : hilal_balout@hotmail.com  
