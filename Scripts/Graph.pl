my $JobID=$ARGV[0];
my $Dir=$ARGV[1];
my $mode=$ARGV[2];
my $FileToPlot="$Dir/$JobID\_$mode\_5adens";
my $FileToPlotMap="$Dir/$JobID\_$mode";
my @Chains=qx(awk -F \"\" '{if(\$1\$2\$3\$4==\"ATOM\" && \$0~!/DT/ && \$0~!/DG/ && \$0~!/DA/ && \$0~!/DC/) print \$22}' $Dir/$JobID | sort -u);

chomp @Chains;

if($mode eq "configurational" || $mode eq "mutational")
{

# PNG
open (GNUPLOT, "|gnuplot");
print GNUPLOT <<EOPLOT;
set grid
set nokey
set terminal png nocrop enhanced font Vera 12 size 500,500
set size square
set output "$Dir/$JobID\_$mode\_map.png"
set palette defined (-3 "red", 0 "grey", 3 "green")
set cbrange [-3:3];set cblabel "Local $mode Frustration Index"
set pointsize 0.5
set view map
set xlabel "Residue i"
set ylabel "Residue j"
splot "$FileToPlotMap\_renumbered" using 1:2:12 with points pt 5 palette 
EOPLOT
close(GNUPLOT);

foreach my $chain (@Chains)
{
system("awk '{if(\$3==\"$chain\" && \$4==\"$chain\") print }' $FileToPlotMap > $Dir/aux_map");

# PNG
open (GNUPLOT, "|gnuplot");
print GNUPLOT <<EOPLOT;
set grid
set nokey
set terminal png nocrop enhanced font Vera 12 size 500,500
set size square
set output "$Dir/$JobID\_$mode\_map_chain$chain.png"
set palette defined (-3 "red", 0 "grey", 3 "green")
set cbrange [-3:3];set cblabel "Local $mode Frustration Index"
set pointsize 0.5
set view map
set xlabel "Residue i"
set ylabel "Residue j"
splot "$Dir/aux_map" using 1:2:12 with points pt 5 palette 
EOPLOT
close(GNUPLOT);

system("rm $Dir/aux_map");
}

#Generate Images
system("cd $Dir; cp $Dir/$JobID\_$mode.tcl $Dir/$JobID\_$mode\_snapshot.tcl; echo \"color Display Background white\;\" >> $Dir/$JobID\_$mode\_snapshot.tcl;  echo \"render TachyonInternal $Dir/$JobID\_$mode\_snapshot.tga\; exit\;\" >> $Dir/$JobID\_$mode\_snapshot.tcl; vmd -dispdev none -e $Dir/$JobID\_$mode\_snapshot.tcl -m $Dir/$JobID; convert $Dir/$JobID\_$mode\_snapshot.tga -resize 520x520 $Dir/$JobID\_$mode\_snapshot.png; mv $Dir/$JobID\_$mode\_snapshot.png $Dir/$mode.png; rm $Dir/$JobID\_$mode\_snapshot.tga $Dir/$JobID\_$mode\_snapshot.tcl");
}
