use strict;
use File::Basename;
#Example: perl /home/user/Desktop/FrustraStandAlone/RunFrustratometer.pl file.pdb configurational 3.1

#######################################################################
#------------Input parameters---------------###########################
#######################################################################
my $jobID=$ARGV[0];

#modes can be: configurational, mutational o singleresidue
my $Modes=$ARGV[1];

#constant for electrostatics calculation. 
#skip this variable or set to 0 to not use
#electrostatics at all 
my $Electrostatics_K=$ARGV[2];

my $jobsDir=qx(pwd);
chomp $jobsDir;

#Sequence separation used to calculate 
#the local densities of the amino acids.  
my $seqdist=12;

#Change this path to the folder in which this script is located
my $scriptsDir="/home/gonzalo/frustratometer2/Scripts";
my ($pdbfile, $parentdir, $extension) = fileparse($jobID, qr/\.[^.]*$/);
########################################################################
#------------End Input parameters---------------########################
########################################################################

#Creates jobdir
system("mkdir $jobsDir/$jobID.done; cp $jobID $jobsDir/$jobID.done");

#Checkpoints
system ("echo Job $jobID started > $jobsDir/$jobID.done/Checkpoints");

#Generates equivalences files for further renumbering of files
print "$jobsDir/$jobID.done\n";
print "Getting equivalences\n";
system("perl $scriptsDir/get_equivalences.pl $jobsDir/$jobID.done/$jobID");

print "Cleaning PDB\n";
#Clean PDBFile
system("perl $scriptsDir/CleanCompletePDB.pl $jobID $jobsDir/$jobID.done $scriptsDir");

my @splittedModes=split ",", $Modes;
foreach my $mode (@splittedModes)
{
		$mode=lc $mode; 

		#Prepare the PDB file to get awsem input files, create the workdir and move neccessary files to it.
                my $jobIDNoExt=$jobID;
		$jobIDNoExt=~s/$extension//g;
		system("cd $jobsDir/$jobID.done; pwd; $scriptsDir/AWSEMFiles/AWSEMTools/PdbCoords2Lammps.sh $jobIDNoExt $jobIDNoExt $scriptsDir; cp $scriptsDir/AWSEMFiles/*.dat* $jobsDir/$jobID.done/");

		#Modify the .in file to run a single step - Modify the fix_backbone file to change the mode and set options
		system("cd $jobsDir/$jobID.done/; sed -i 's/run		10000/run		0/g' $jobIDNoExt.in; sed -i 's/mutational/$mode/g' fix_backbone_coeff.data;");

		if($Electrostatics_K)
		{
		   system("cd $jobsDir/$jobID.done; sed -i 's/\\[DebyeHuckel\\]-/\\[DebyeHuckel\\]/g' fix_backbone_coeff.data; sed -i 's/4.15 4.15 4.15/$Electrostatics_K $Electrostatics_K $Electrostatics_K/g' fix_backbone_coeff.data;");
		   system("cd $jobsDir/$jobID.done; python $scriptsDir/Pdb2Gro.py $jobID $jobID.gro; perl $scriptsDir/GenerateChargeFile.pl $jobID.gro > $jobsDir/$jobID.done/charge_on_residues.dat");
		}

		system("echo $mode frustration index calculation started... >> $jobsDir/$jobID.done/Checkpoints");
		system("cp $scriptsDir/lmp_serial_$seqdist $jobsDir/$jobID.done; cd $jobsDir/$jobID.done; ./lmp_serial_$seqdist < $jobIDNoExt.in");

                #Calculate 5Adens
		if($mode eq "configurational" || $mode eq "mutational")
		{
		    system("perl $scriptsDir/5Adens.pl $jobID $jobsDir/$jobID.done $mode");
                }

 		#Renumerate Files to the original numbering
		system("perl $scriptsDir/RenumFiles.pl $jobID $jobsDir/$jobID.done $mode");

                #Generate Images
                if($mode eq "configurational" || $mode eq "mutational")
                {
                system("perl $scriptsDir/GenerateVisualizations.pl $jobID\_$mode\_auxiliar $jobID $jobsDir/$jobID.done $mode");
                system("perl $scriptsDir/Graph.pl $jobID $jobsDir/$jobID.done $mode");
                system("Rscript $scriptsDir/Graph.r $jobID $jobsDir/$jobID.done $mode");
                }

		#Organize the files into directories
		system("cd $jobsDir/$jobID.done; mkdir Images; mv *.png Images/; mkdir VisualizationScripts; mv *$jobID*.pml VisualizationScripts; mv *$jobID*.tcl VisualizationScripts; cp $scriptsDir/draw_links.py VisualizationScripts; cp $jobID VisualizationScripts; mkdir FrustrationData; mv $jobID\_$mode FrustrationData; mv $jobID*5adens FrustrationData;");

system("echo $mode frustrational index calculation finished... >> $jobsDir/$jobID.done/Checkpoints");
}

system("echo Job finished >> $jobsDir/$jobID.done/Checkpoints");

#Remove auxiliar files
system("rm $jobsDir/$jobID.done/*.dat; rm $jobsDir/$jobID.done/*.in; rm $jobsDir/$jobID.done/*.coord; rm $jobsDir/$jobID.done/*.vps; rm $jobsDir/$jobID.done/*.log; rm $jobsDir/$jobID.done/*.seq; rm $jobsDir/$jobID.done/dump.*; rm $jobsDir/$jobID.done/*data*; rm $jobsDir/$jobID.done/*auxiliar; rm $jobsDir/$jobID.done/*log*; rm $jobsDir/$jobID.done/*tertiary*; rm $jobsDir/$jobID.done/*.jml; rm $jobsDir/$jobID.done/*equivalences*; rm $jobsDir/$jobID.done/*lmp_*;");
