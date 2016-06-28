# LinuxFrequencyAnalysis
Incident identification through outlier analysis

########## Parallel gather artifacts setup ##########
1. Read documentation that describes why this script was created, what problem it was designed to address, and how it conceptually works (https://www.sans.org/reading-room/whitepapers/detection/incident-identification-outlier-analysis-36740)

2. Open parallelGatherArtifacts.sh, and adjust local working directories and files:
LOCALWORKINGDIR=/home/sans/Desktop 			              #Default build runs the script from the desktop, replace 'sans' with your home directory
TARGETS=hosts.txt 					                          #File that contains hosts to analyze, one host per line in the format 'root@ip'
FREQUENCYANALYSISKNOWNHOST=frequencyAnalysisKnownHost
FREQUENCYANALYSISRUNLOG=frequencyAnalysisRunLog.txt 	#Default name of log file that captures pssh / pscp execution information
ARTIFACTCOLLECTIONSCRIPT=artifactExtraction.sh 		    #Default name of script that extracts artifacts from the remote host
LOCALRESULTSDIR=/home/sans/Desktop/results 		        #Path to results
LOCALHISTORICALDIR=/home/sans/Desktop/results/historical #Path to save results from the previous analysis sessions (used for historical analysis)
LOCALCURRENTDIR=/home/sans/Desktop/results/current 	  #Path to save results from the current analysis session
REMOTEROOTDIR=/root 
REMOTEWORKINGDIR=/root/analysis 			                #Path to save temporary tools and extracted artifacts

3. Ensure that you have a public key on the systems that you would like to assess, and the corresponding private key.  Reference the documentation in step 1 for additional details.

4. Run the ./updateSSH.sh to add to populate the auth_sock variable (reference the documentation in step 1 for additional details). Then run ". ~/.ssh/ssh-agent" (without quotes) in the terminal that you will be running the parallelGatherArtifacts.sh

5. SSH to the remote endpoints to test connectivity and ensure that the remote host SSH fingerprint is added to your known_hosts file

6. Download (https://github.com/pkittenis/parallel-ssh) and unzip parallel ssh, then update the following variables based on the location and version of parallel ssh:
LOCALPSCP=/home/sans/Desktop/pssh-2.3.1/bin/pscp
LOCALPSSH=/home/sans/Desktop/pssh-2.3.1/bin/pssh

7. Ensure the SCRIPANDTOOLSTAR contains the artifactExtraction.sh and trusted binaries.  Update the SCRIPANDTOOLSTAR with the name of the tar and place this in the LOCALWORKINGDIR path defined in step 2.  Reference To Do below for future BusyBox use.
SCRIPANDTOOLSTAR=analysis.tgz 				            #Default name of tar that contains trusted binaries and artifact extraction script

8. Ensure that the trusted tar and rm binaries are in the LOCALWORKINGDIR path.  Reference To Do below for future BusyBox use.

########## Frequency analysis setup ##########
1. Read documentation that describes why this script was created, what problem it was designed to address, and how it conceptually works (https://www.sans.org/reading-room/whitepapers/detection/incident-identification-outlier-analysis-36740)

2. Update local binary path variables based on your distribution:
LOCALECHO=/bin/echo
LOCALCLEAR=/usr/bin/clear
LOCALAWK=/bin/awk
LOCALCAT=/bin/cat
LOCALMKDIR=/bin/mkdir
LOCALSORT=/bin/sort
LOCALUNIQ=/usr/bin/uniq

3. Update working directories
LOCALCURRENTRESULTSDIR=/home/sans/Desktop/results/current
LOCALFREQUENCYDIR=/home/sans/Desktop/results/frequency_analysis

########## Historical analysis setup ##########
1. Read documentation that describes why this script was created, what problem it was designed to address, and how it conceptually works (https://www.sans.org/reading-room/whitepapers/detection/incident-identification-outlier-analysis-36740)

2. Update local binary path variable based on your distribution:
LOCALCLEAR=/usr/bin/clear
LOCALECHO=/bin/echo
LOCALFIND=/usr/bin/find
LOCALCAT=/bin/cat
LOCALAWK=/usr/bin/awk
LOCALSORT=/bin/sort
LOCALUNIQ=/usr/bin/uniq
LOCALLESS=/usr/bin/less
LOCALGREP=/bin/grep
LOCALMKDIR=/bin/mkdir

3. Update working directories
LOCALCURRENTRESULTSDIR=/home/sans/Desktop/results/current
LOCALHISTORICALDIR=/home/sans/Desktop/results/historical
LOCALHISTORICALRESULTS=/home/sans/Desktop/results/historical_working_dir

########## Known bugs ##########
- This script was created on CentOS. There are some command options that may not work on RedHat or other Linux distributions.  Additionally, some distributions may output the results of the artifact extraction commands in a different manner, which may corrupt the built-in parsing.  These issues can be fixed by tweaking the artifact extraction script for your distribution.

########## To Do ##########
- These scripts are currently leveraging trusted (not statically linked) binaries.  In the future, I plan to use BusyBox (which is a trusted statically linked binary).  The scripts will need to be updated to copy and invoke BusyBox to the host to be analyzed.
