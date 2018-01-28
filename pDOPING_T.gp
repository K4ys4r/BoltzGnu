#!/usr/local/bin/gnuplot --persist
##############################################################################################################
##############################################################################################################
####                                                                                                      ####
####   Gnuplot Script To plot Doping Output File From BoltzTrap Code                                      ####
####        at a define Carrier Concentration of electron or hole as a function of Temperature            ####
####   G N U P L O T Version 5.0 patchlevel 5                                                             ####
####                                                                                                      ####
####   Ref.  : Hilal Balout, mail: hilal_balout@hotmail.com                                               ####
####                                                                                                      ####
####   Usage: gnuplot -c pDOPING_T.gp N  volume xmin xmax file                                            ####
####                          \        \    \     \    \    \______BoltzTraP Doping File name {fort.25}   ####
####                           \        \    \     \    \__________Maximum of Temperature                 ####
####                            \        \    \     \______________Minimum of Teperature                  ####   
####                             \        \    \____________________Volume of System (in cm^3)            ####
####                              \        \________________________Doping Concentration (/uc (unit cell) ####
####                               \_______________________________Script Name                            ####
####                                                                                                      ####
####                                                                                                      ####
####   Exemple : gnuplot -c pDOPING_T.gp 0.00025832 2.5832133342483e-22 300 900 file.trace                ####
####   Output  : PDF File                                                                                 ####
####                                                                                                      ####
####                                                                                                      ####
##############################################################################################################
if  (ARGC != 5){print "\n       Arguments Error... ";
print "=====================================================================================================" 
print " Usage: gnuplot -c pDOPING_T.gp N  volume xmin xmax file                                             "
print "                        |        |    |     |    |    |______BoltzTraP Doping File name {fort.25}    "
print "                        |        |    |     |    |___________Maximum of Temperature                  "
print "                        |        |    |     |________________Minimum of Teperature                   "
print "                        |        |    |______________________Volume of System (in cm^3)             "
print "                        |        |___________________________Doping Concentration (/uc (unit cell)  "
print "                        |____________________________________Script Name                             "
print "=====================================================================================================\n" 
exit
}

#VariableVariableVariableVariableVariableVariableVariableVariableVariableVariableVariableVariableVariable
#Variables pour l'echelle

Echel_Sebk=1e6
Echel_Sigma=1e19
Echel_PF=1e11
volume=ARG2 # en cm^3
dop=(ARG1/ARG2)
#VariableVariableVariableVariableVariableVariableVariableVariableVariableVariableVariableVariableVariable

############################################################################################################
############################################################################################################
print "\n==========================================================" 
file2plot=ARG5
print "File name               : ", file2plot
print "Volume of the System    : ", ARG2," cm^3"
print "Doping level            : ", dop," /cm^3"
print "Plot Interval           : [", ARG3," : ",ARG4,"]"
print "----------------------------------------------------------\n" 
Log=sprintf("%.0f",log10(dop))
############################################################################################################

set term pdf enhanced color font "Times,6" size 3,3.5
set output sprintf("Trace_%g.pdf",dop)

set xrang [ARG3:ARG4]
set mxtics 5
set xtics scale 1.5 
set tics out nomirror 
set border 3 lw 0.5

set style line 1 lt 1 lw 2 pt 7 ps 0.75 lc rgb "red"
set label sprintf("Transport Properties at %3.2f {/Symbol \264} 10^{%s} /cm^{3}",(dop/(10**Log)),Log) at screen 0.5,0.975 center font ",8 bold" textcolor rgb "black"
set tmargin 1 
set bmargin 3 
set lmargin 12 
set rmargin 0
unset key
dyy=0.025
set multiplot

set size 0.95,0.35

set origin 0.,dyy
set ylabel "Seebeck  ( {/Symbol m}V . K^{-1} ) " 

print "Plot Seebeck at ",dop," cm^3 ..."
set xlabel "Temperature ( K )" 
plot sprintf("<awk '$2==%s' %s",ARG1,file2plot) u 1:($4*Echel_Sebk) w l ls 1 
print "           ...Done\n"

set origin 0,0.3+dyy
unset xlabel
unset label
set xtics offset 0,0.5 font ",4" textcolor rgb "grey"
set ylabel sprintf("{/Symbol s/t } ( 10^{%.0f} / {/Symbol W} .cm.s )",log10(Echel_Sigma)) 

print "Plot Electrical Conductivity at ",dop," cm^3 ..."
plot sprintf("<awk '$2==%s' %s",ARG1,file2plot) u 1:($5/Echel_Sigma) w l ls 1 
print "           ...Done\n"


set origin 0,0.6+dyy
set ylabel sprintf("PF/{/Symbol t} ( 10^{%.0f} W/m.K^{2}.s )",log10(Echel_PF))

print "Plot Power Factor at ",dop," /cm^3 ..."
plot sprintf("<awk '$2==%s' %s",ARG1,file2plot) u 1:(($4*$4*$5)/Echel_PF) w l ls 1 
print "           ...Done\n"

print "\nWriting Output file ---> ",sprintf("Trace_%g.pdf",dop),"\n"
