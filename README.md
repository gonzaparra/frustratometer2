Frustratometer Download README file:

You have downloaded the result files for a 'Frustratometer' job. Visit
http://bonarda.qb.fcen.uba.ar/ for more information.

This folder should contain 3 subfolders and this README file. Below a description of the content for each subfolder:

1) FrustrationData
This folder contains all the data that is calculated by the frustratomer. Depending on the frustration indexes that were selected to be calculated (i.e, configurational, mutational and singleresidue) you will find the following files:

	*JobID.pdb_configurational: This file contains the "configurational frustration index" report for the contacts in the protein. One line per contact. The columns in the file have the following meaning:
		Res1: Residue 1 in the interacting pair.
		Res2: Residue 2 int he interacting pair
		ChainRes1: Chain to which the Residue 1 belongs in the PDB file (useful for multichain jobs).
		ChainRes2: Chain to which the Residue 2 belongs in the PDB file (useful for multichain jobs).
		DensityRes1: Local density for Residue 1
		DensityRes2: Local density for Residue 2
		AA1: Amino acid type for Residue 1
		AA2: Amino acid type for Residue 2
		NativeEnergy: Native Energy for the original interacting pair.
		DecoyEnergy: Mean value for the energy distribution calculated from the decoys
		SDEnergy: Santard deviation for the energy distribution calculated from the decoys.
		FrstIndex: Configurational frustration index calculated for the interacting pair.
		Welltype: Type of contact based on the distance between the two residues and their local densities (long, short and water-mediated)
		FrstState: Frustration class for the interacting pair. 

	*JobID.pdb_mutational: This file contains the "mutational frustration index" report for the contacts in the protein. One line per contact. The file is structured in the same way as the JobID.pdb_configurational having the mutational frustration index value in the FrstIndex column.

	*JobID.pdb_singleresidue: This file contains the "single residue level frustration index" report. One line per residue. The file is structured as follows:
		Res: Residue number
		ChainRes: Chain to which the residue belongs.
		DensityRes: local density for the residue
		AA: Amino acid type for the residue
		NativeEnergy: Native energy for the residue
		DecoyEnergy: Mean value for the energy distribution calculated from the decoys.
		SDEnergy: Standard deviation value for the energy distribution calculated from the decoys.
		FrstIndex: Single res frustration index.

	*JobID.pdb_configurational_5adens: This file contains the density of contacts around a sphere of 5 Armstrongs, centered in the C-alfa atom from the residue. The different classes of contacts based on the configurational frustration index are counted both in absolute and relative terms. The file is structured as follows:
		Residue: Residue number
		Chain: Chain to which the residue belongs
		TotalDensity: Total number of contacts within 5 Armstrongs from the C-alfa atom in the residue
		HighlyFrustratedDensity: Fraction of highly frustrated contacts within 5 Armstrongs from the C-alfa atom in the residue
		NeutrallyFrustratedDensity: Fraction of neutral contacts within 5 Armstrongs from the C-alfa atom in the residue
		MinimallyFrustratedDensity: Fraction of minimally frustrated contacts within 5 Armstrongs from the C-alfa atom in the residue
		relHighlyFrustratedDensity: HighlyFrustratedDensity normalized to the Total Density
		relNeutrallyFrustratedDensity: NeutrallyFrustratedDensity normalized to the Total Density
		relMinimallyFrustratedDensity: MinimallyFrustratedDensity normalized to the Total Density

	*JobID.pdb_mutational_5adens: This file contains the density of contacts around a sphere of 5 Armstrongs, centered in the C-alfa atom from the residue. The different classes of contacts based on the mutational frustration index are counted both in absolute and relative terms. The file is structured in the same way as the *JobID.pdb_configurational_5adens file.

2) VisualizationScripts
	This folder contains pymol and vmd scripts to visualize the frustration patterns over the protein structures. The following files are present in the folder.

	*.pdb_configurational.tcl : a script to draw the 'configurational frustration
	index' of contacts in the protein structure using VMD.

	*.pdb_mutational.tcl:  a script to draw the 'mutational frustration
	index' of contacts in the protein structure using VMD.
		
		To see the 3D structure with the contacts drawn you'll need a program
		called VMD (download free at http://www.ks.uiuc.edu/Research/vmd/ ).
		- open VMD, a command window will also open.
		- load the protein (go to File/NewMolecule and look for it in the
		folder were the Frustratometer results are)
		- then go to the command window and change directory to where the
		associated files for the pdb are, for example type in: 
		"cd route_to_the_results_folder/frustratometer_jobID.pdb"
		- then type: source mfrst_yourprotein.pdb.tcl (this will actually draw
		the 'mutational frustration index' according to: highly frustrated
		contacts in red, the minimally frustrated in green, the direct ones in
		solid, and the water-mediated ones in dashed. "neutral" contacts are
		not drawn. All contacts are represented as lines emerging from the
		Calpha of each aminoacid)

		- you can also type from a console "vmd file.pdb -e file.tcl" replacing "file" with the name given to you jobid and then PyMOL will open and show the associated contacts.

	*.pdb_configurational.pml : a script to draw the 'configurational frustration
	index' of contacts in the protein structure using PyMOL.

	*.pdb_mutational.pml:  a script to draw the 'mutational frustration
	index' of contacts in the protein structure using PyMOL.

		To see the 3D structure with the contacts drawn using pml scripts you need a program called PyMOL. 
		- open PyMOL, a command window will also open.
		- load the protein (go to File/Open and look for it in the folder where the Frustratometer results are)  
		- then go to File/Run.. and select the .pml file you wanna run.

		- you can also type from a console "pymol file.pml" replacing "file" with the name given to you jobid and then PyMOL will open and show the associated contacts.

	*draw_links.py: This is a script needed to draw the frustratographs in PyMOL.
	 
3) Images
This folder contains all the images that are generated in the web server both for the entire protein structure and for each chain that is present on it.

---------------------------------------------------------------------------------------------------------------

- We hope you find this application useful, for any questions you can contact us: frustratometer (at) gmail.com

How to cite us:

"Protein Frustratometer 2: a tool to localize energetic frustration in protein molecules, now with electrostatics". Parra R , Schafer NP, Radusky L, Tsai MY , Guzovsky AB, Wolynes PG and Ferreiro DU. Nucleic Acids Res. 2016 Apr 29. pii: gkw304.

-Enjoy

The Frustratometer Server
(version 2.0, 2016)