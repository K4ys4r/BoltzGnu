#!/usr/local/bin/gnuplot --persist
##############################################################################################################
##############################################################################################################
####                                                                                                      ####
####   Gnuplot Script To plot TRACE Output File From BoltzTrap Code                                       ####
####        at a define Temperature as a function of Carrier Concentration of electron or hole /cm^3      ####
####   G N U P L O T Version 5.0 patchlevel 5                                                             ####
####                                                                                                      ####
####   Ref.  : Hilal Balout, mail: hilal_balout@hotmail.com                                               ####
####                                                                                                      ####
####   Usage: gnuplot -c pTrace.gp Temp volume xmin xmax file (N,P)                                       ####
####                         \       \    \      \    \    \    \_____N or P type                         ####
####                          \       \    \      \    \    \_________BoltzTraP TRACE File name {.trace}  ####
####                           \       \    \      \    \_____________Maximum of Carrier Concentration    ####
####                            \       \    \      \_________________Minimum of Carrier Concentration    ####   
####                             \       \    \_______________________Volume of System (in cm^3)          ####
####                              \       \___________________________Temperature                         ####
####                               \__________________________________Script Name                         ####
####                                                                                                      ####
####                                                                                                      ####
####   Exemple : gnuplot -c pTRACE_N.gp 900 2.5832133342483e-22 1e18 1e21 file.trace N                    ####
####   Output  : PDF File  i.e at 300 K & for Ntype --->  Trace_300K_Ntype.pdf                            ####
####                                                                                                      ####
####                                                                                                      ####
##############################################################################################################

if( ARGC != 6 ){print "\n       Arguments Error... ";
print "======================================================================================================"
print "   Usage: gnuplot -c pTrace.gp Temp volume xmin xmax file (N,P)                                      "
print "                         |       |    |      |    |    |    |_____N or P type                        "
print "                         |       |    |      |    |    |__________BoltzTraP TRACE File name {.trace} "
print "                         |       |    |      |    |_______________Maximum of Carrier Concentration   "
print "                         |       |    |      |____________________Minimum of Carrier Concentration   "
print "                         |       |    |___________________________Volume of System (in cm^3)         "
print "                         |       |________________________________Temperature                        "
print "                         |________________________________________Script Name                        "
print "======================================================================================================\n"
exit
}

#VariableVariableVariableVariableVariableVariableVariableVariableVariableVariableVariableVariableVariable
#Variables pour l'echelle

Echel_Sebk=1e6
Echel_Sigma=1e19
Echel_PF=1e11
volume=ARG2 # en cm^3

#VariableVariableVariableVariableVariableVariableVariableVariableVariableVariableVariableVariableVariable

############################################################################################################
############################################################################################################
print "\n=================================================" 
file2plot=ARG5
Temp=ARG1+0.0
print "File name               : ", file2plot
print "Temperature             : ", ARG1
print "Volume of the System    : ", ARG2
print "Plot Interval           : [", ARG3," : ",ARG4,"]"
print "-------------------------------------------------\n" 
############################################################################################################

set term pdf enhanced color font "Times,6" size 3,3.5
set output sprintf("Trace_%sK_%stype.pdf",ARG1,ARG6)

set xrang [ARG3:ARG4]
set mxtics 5
set xtics scale 1.5 
set tics out nomirror 
set border 3 lw 0.5

set style line 1 lt 1 lw 2 pt 7 ps 0.75 lc rgb "red"
set label sprintf("Transport Properties at %s K",ARG1) at screen 0.5,0.975 center font ",8 bold" textcolor rgb "black"
set tmargin 1 
set bmargin 3 
set lmargin 12 
set rmargin 0
unset key
dyy=0.025
set multiplot

set size 0.95,0.35

set origin 0.,dyy
set logscal x
set xtics format "10^{%L}"
set ylabel "Seebeck  ( {/Symbol m}V . K^{-1} ) " 

if(ARG6 eq "N") {print "Plot Seebeck for ",ARG6,"-Type at ",ARG1," K ...";
set xlabel "Doping [ e . cm^{-3} ]" 
plot sprintf("<awk '$2==%f && $3<0' %s",Temp,file2plot) u (-$3/volume):($5*Echel_Sebk) w l ls 1 
print "           ...Done\n"
} 
if (ARG6 eq "P") {print "Plot Seebeck for ",ARG6,"-Type at ",ARG1," K ...";
set xlabel "Doping [ h . cm^{-3} ]" 
plot sprintf("<awk '$2==%f && $3>0' %s",Temp,file2plot) u ($3/volume):($5*Echel_Sebk) w l ls 1 
print "           ...Done\n"
}


set origin 0,0.3+dyy
unset xlabel
unset label
set xtics offset 0,0.5 font ",4" textcolor rgb "grey"
set ylabel sprintf("{/Symbol s/t } ( 10^{%.0f} / {/Symbol W} .cm.s )",log10(Echel_Sigma)) 

if(ARG6 eq "N") {print "Plot Electrical Conductivity for ",ARG6,"-Type at ",ARG1," K ...";
plot sprintf("<awk '$2==%f && $3<0' %s",Temp,file2plot) u (-$3/volume):($6/Echel_Sigma) w l ls 1 
print "           ...Done\n"
} 
if (ARG6 eq "P") {print "Plot Electrical Conductivity for ",ARG6,"-Type at ",ARG1," K ...";
plot sprintf("<awk '$2==%f && $3>0' %s",Temp,file2plot) u ($3/volume):($6/Echel_Sigma) w l ls 1 
print "           ...Done\n"
}


set origin 0,0.6+dyy
set ylabel sprintf("PF/{/Symbol t} ( 10^{%.0f} W/m.K^{2}.s )",log10(Echel_PF))

if(ARG6 eq "N") {print "Plot Power Factor for ",ARG6,"-Type at ",ARG1," K ...";
plot sprintf("<awk '$2==%f && $3<0' %s",Temp,file2plot) u (-$3/volume):(($5*$5*$6)/Echel_PF) w l ls 1 
print "           ...Done\n"
} 
if (ARG6 eq "P") {print "Plot Power Factor for ",ARG6,"-Type at ",ARG1," K ...";
plot sprintf("<awk '$2==%f && $3>0' %s",Temp,file2plot) u ($3/volume):(($5*$5*$6)/Echel_PF) w l ls 1 
print "           ...Done\n"
}


print "\nWriting Output file ---> ",sprintf("Trace_%sK_%stype.pdf",ARG1,ARG6),"\n"
