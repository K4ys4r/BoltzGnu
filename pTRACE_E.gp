#!/usr/local/bin/gnuplot --persist
###########################################################################################################################
###########################################################################################################################
####                                                                                                                   ####
####   Gnuplot Script To plot TRACE Output File From BoltzTrap Code at a define Temperature as a function of Eenrgy    ####
####   G N U P L O T Version 5.0 patchlevel 5                                                                          ####
####                                                                                                                   ####
####   Ref.  : Hilal Balout, mail: hilal_balout@hotmail.com                                                            ####
####                                                                                                                   ####
####   Usage: gnuplot -c pTRACE_E.gp Temp Efermi dE file                                                               ####
####                          \      \     \    \   \____BoltzTraP TRACE File name {.trace}                            ####
####                           \      \     \    \_______plot interva (with Ef set to 0)                               ####
####                            \      \     \___________Fermi Energy (in Ry)                                          ####
####                             \      \________________Temperature                                                   ####
####                              \______________________Script Name                                                   ####
####                                                                                                                   ####
####   Exemple: gnuplot -c pTRACE_E.gp 300 0.4 0.1 file.trace                                                          ####
####   Output : PDF File  i.e at 300 K --->  Trace_300K.pdf                                                            ####
####                                                                                                                   ####
###########################################################################################################################

if  (ARGC != 4){print "\n       Arguments Error... ";
print "========================================================================================"
print "  Usage: gnuplot -c pTRACE_E.gp Efermi dE file                                   " 
print "                          |      |      |    |  |____BoltzTraP TRACE File name {.trace}" 
print "                          |      |      |    |_______plot interva (with Ef set to 0)   "
print "                          |      |      |____________Fermi Energy (in Ry)              "
print "                          |      |___________________Temperature                       "
print "                          |__________________________Script Name                       "
print "========================================================================================\n"
exit
}

#VariableVariableVariableVariableVariableVariableVariableVariableVariableVariableVariableVariableVariable
#Scaling Variables

Echel_Sebk=1e6
Echel_Sigma=1e19
Echel_PF=1e11

#VariableVariableVariableVariableVariableVariableVariableVariableVariableVariableVariableVariableVariable

############################################################################################################
############################################################################################################
file2plot=ARG4
Temp=ARG1+0.0
print "\n================================================="
print "File name          : ", file2plot
print "Temperature        : ", Temp
print "Fermi Energy       : ", ARG2
print "Plot Interval      :  [", -ARG3," : ",ARG3,"]"
print "-------------------------------------------------\n"
############################################################################################################


set term pdf enhanced color font "Times,6" size 3,3.5
set output sprintf("Trace_%sK.pdf",ARG1)

set xrang [-ARG3:ARG3]
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
set xlabel "{/Symbol e - e}_{Fermi} ( Ry )" 
set ylabel "Seebeck  ( {/Symbol m}V . K^{-1} ) " 
print "Plot Seebeck at ",ARG1," K ..."
plot sprintf("<awk '$2==%f' %s",Temp,file2plot) u ($1-ARG2):($5*Echel_Sebk) w l ls 1 
print "          ...Done\n" 


set origin 0,0.3+dyy
unset xlabel
unset label
set xtics offset 0,0.5 font ",4" textcolor rgb "grey"
print "Plot Electrical Conductivity at ",ARG1," K ..."
set ylabel sprintf("{/Symbol s/t } ( 10^{%.0f} / {/Symbol W} .cm.s )",log10(Echel_Sigma)) 
plot  sprintf("<awk '$2==%f'  %s",Temp,file2plot) u ($1-ARG2):($6/Echel_Sigma) w l ls 1 
print "          ...Done\n" 


set origin 0,0.6+dyy
set ylabel sprintf("PF/{/Symbol t} ( 10^{%.0f}  W/m.K^{2}.s )",log10(Echel_PF))
print "Plot Power Factor at ",ARG1," K ..."
plot  sprintf("<awk '$2==%f' %s",Temp,file2plot) u ($1-ARG2):($5*$5*$6/Echel_PF) w l ls 1 
print "          ...Done\n" 
print "\nWriting Output file ---> ",sprintf("Trace_%sK.pdf",ARG1),"\n"
