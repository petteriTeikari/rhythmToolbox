This matlab package is used to detect periodic expression profiles in DNA microarray time-series data.
LSPR is a three step integrated algorithm, featuring high resolution of periodicity detection for evenly or unevenly sampled time-course data.
	
Copyright (c) 2010, Chen ZHANG and Rendong Yang

Table of Contents
=================
- Pre-installation
- Usage
- Input/Output Files
- FAQ
- Contact
- Web Site

________________
Pre-installation

	Before running this package, make sure you have installed the following software and related toolboxes:
		- Program environments:
			Matlab version R2009 or newer
		- Related toolboxes in Matlab:
			1. signal processing toolbox
			2. statistics toolbox
			3. bioinformatics toolbox
_____
Usage

	Command-line running:
		- usage:
		1. create a file named start.command and input following commands:
		matlab ¨Cr "cd LSPRpackagePath; LSPR('inputFilename.txt','outputFilename.txt','inputPath','outputPath',defaultPeriod,lower,upper)"
		- explanation of input variables:
			inputFilename          - input text file name
			outputFilename         - output text file name
			inputPath              - load input file from
			outputPath             - save output file to
			defaultPeriod          - use a default period (i.e. 24 for circadian microarray data) to do harmonic analysis when no periods could be detected in [lower,upper]
			lower/upper            - endpoints of period range
		- example:
		matlab -r "cd /home/user/LSPR; LSPR('inputExample.txt','outputExample.txt','/home/user/LSPR/input/','/home/user/LSPR/output/',24,20,28)"
		2. run start.command:
		$at now -f start.command

	Matlab environment:
		- usage:
			LSPR('inputFilename.txt','outputFilename.txt','inputPath','outputPath',defaultPeriod,lower,upper)
		- example:
			LSPR('inputExample.txt','outputExample.txt','input/','output/',24,20,28)
__________________
Input/Output File

	<Input>

		file type: tab delimited text file
		file format:
			1st row   	- sampled time points
			1st column	- probesets names
			others     	- a NxM matrix representing N genes (probes) with M expression level measurements/samples over time.

	<Output>
	file type: text file
	file format:
			1st column	- probe names
			2nd column	- filter type
			3rd column	- method
			4th column	- number of oscillations
			5th column	- period
			6th column	- amplitude
			7th column	- phase
			8th column	- R square
			9th column	- pvalue
			10th column	- qvalue
			11th column	- FDR-BH

		explanation:
			filter type     - preprocess microarray data with Savitzky-Golay filter or not
			                '1' -> microarray data have been detrended and filtered
			                '-1'-> microarray data have been detrended
			method	        - method for harmonic analysis
			                	'LSPR'	 -> do harmonic regression with periods detected in [lower,upper]
			                	'default'-> do harmonic regression with default period
			number of oscillations - number of different oscillations detected by LSPR
			period	        - detected periods in [lower,upper] or a given default period
			amplitude       - amplitude of harmonic model
			phase           - phase of harmonic model
			R square        - R square of regression curve
			pvalue          - p-value in harmonic analysis
			qvalue          - false discovery rate computed by q-value method
			FDR-BH          - false discovery rate computed by Benjamini¨CHochberg method
___
FAQ

	1. How to deal with missing values?
		LSPR will ignore those time-series whose values are missing more than 50% of sampling time points. The output parameters corresponding to them will be assigned values of "NaN". Samples missing less than 50% of sampling time points will be analyzed based on existing experiment values and coresponding timepoints.
					example:
					contents of input file:
					probe     0    4    8    12    16    20    24    28    32    36    40    44
					example01 1    0.8       0.4         0.8         0.8         0.4         0.8
					example02                0.5   0.6   0.8                     0.5   0.6   0.8
					example03                                                                   
					example04      1         0.6                                 0.6    0.5  0.7
					example05 0.8  1    0.8  0.6   0.4   0.6   0.8   1     0.8   0.6    0.4  0.6

					contents of output file:
					probe     filter type  method number of oscillations period    amplitude    phase    R square    pvalue    qvalue    FDR-BH
					example01 -1             LSPR      1                 24.55     0.26175      23.3787  0.9225      0.006006   NaN        0.009009
					example02 -1             LSPR      1                 27.75     0.165589     22.1381  0.954796    0.009611   NaN        0.009611
					example03 NaN            NaN       NaN               NaN       NaN          NaN      NaN         NaN        NaN        NaN
					example04 NaN            NaN       NaN               NaN       NaN          NaN      NaN         NaN        NaN        NaN
					example05 -1             LSPR      1                 23.1      0.231736     4.675    0.816717    0.00048310 NaN        0.00144933
	
	2. What data sets can LSPR analyze?
		LSPR can detect oscillations of circadian, cell-cycle microarray data and other temporal expression profiles.
	
	3. How are periodic genes determined?
		For a single input gene expression profile, periodicity can be determined by p-value. Usually, a gene with p-value < 0.05 is considered to be periodic.
		For large-scale microarray data, periodic genes could be determined by the false discovery rate (q-value or FDR-BH value), instead. Generally, the Benjamini¨CHochberg method (FDR-BH) is more stringent than the q-value method to evaluate the false discovery rate .
	
	4. How are genes whose output parameters are "NaN" values dealt with?
		Genes with missing values for more than 50% of sampling time points, or that fit linear (i.e. y = x+c) or constant expressions (i.e. y = c), will be assigned "NaNs" in the output parameters.
		To get a meaningful result, we suggest to remove genes of this kind and re-analyze the rest by the LSPR program.

	5. What is the minimum/maximum number of time points? How many genes can the application handle at a time?
		Ideally, at least six time points for the input time-series according to our analysis (see Supplemental information) and there is no upper limit for the length.
		LSPR analyzes one time-series at a time. If the user's computer has enough computing capacity, there will be no limitations for how many genes LSPR can handle at a time.

Contact

Please contact us if you have suggestions for improvement, or if you have any problem with the program, or with the interpretation of the results.

	Chen ZHANG 
	College of Science
	China Agricultural University
	P.O.Box 0590
	100083, Beijing, China 	
	tel: +86-13811497473
	email: zcreation@yahoo.cn 
OR
	Rendong Yang	
	College of Biological Sciences
	China Agricultural University
	P.O.Box B1061
	100193, Beijing, China
	tel: +86-10-62734385
	email: cauyrd@gmail.com

Thanks!

________
Web Site

http://bioinformatics.cau.edu.cn/LSPR