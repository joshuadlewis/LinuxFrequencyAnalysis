#!/bin/bash
# Copyright Joshua Lewis, January 2016.
# Version 1.0  
# Permission to use and distribute this script permitted as long as the copyright is preserved and referenced
# Use of this script at your own risk, no warrany is implied

################### Setup variables ###################
#Define path to local binaries
LOCALPSCP=/home/sans/Desktop/pssh-2.3.1/bin/pscp
LOCALPSSH=/home/sans/Desktop/pssh-2.3.1/bin/pssh
LOCALSSH=/usr/bin/ssh
LOCALMKDIR=/bin/mkdir
LOCALTAR=/bin/tar
LOCALRM=/bin/rm
LOCALECHO=/bin/echo
LOCALLS=/bin/ls
LOCALMV=/bin/mv
LOCALGREP=/bin/grep
LOCALAWK=/bin/awk
LOCALSORT=/bin/sort
LOCALUNIQ=/usr/bin/uniq
LOCALHEAD=/usr/bin/head
LOCALTEE=/usr/bin/tee
LOCALIFCONFIG=/sbin/ifconfig
LOCALCUT=/bin/cut
LOCALSSHKEYSCAN=/usr/bin/ssh-keyscan
LOCALCHOWN=/bin/chown

#Define working directories and file variables
LOCALWORKINGDIR=/home/sans/Desktop
SCRIPANDTOOLSTAR=analysis.tgz
TARGETS=hosts.txt
FREQUENCYANALYSISKNOWNHOST=frequencyAnalysisKnownHost
FREQUENCYANALYSISRUNLOG=frequencyAnalysisRunLog.txt
ARTIFACTCOLLECTIONSCRIPT=artifactExtraction.sh
LOCALRESULTSDIR=/home/sans/Desktop/results
LOCALHISTORICALDIR=/home/sans/Desktop/results/historical
LOCALCURRENTDIR=/home/sans/Desktop/results/current
REMOTEROOTDIR=/root
REMOTEWORKINGDIR=/root/analysis

#Error handling to make sure the hosts.txt file exists
if [ ! -f "$LOCALWORKINGDIR/$TARGETS" ]; then
	$LOCALECHO "## <error>"	
	$LOCALECHO "host.txt file not present in $LOCALWORKINGDIR.  Create this file and add \"roo@host\" entries, one per line"
	$LOCALECHO "## </error>"
	exit 255	
fi

#Define network interface used to connect to remote machines
LOCALNETIF=eth3

#Define other runtime variables
DATETIME=$(date +%m-%d-%Y.%H.%M)
REMOTERESULTSTAR="${DATETIME}_results.tgz"
CURRENTUSER=$(whoami)

################### Setup SSH agent ###################
#Sourcing the ssh-agent file.  This file contains the SSH_AUTH_SOCK variable to allow ssh-agent to pass the keys that are loaded in memory
. $HOME/.ssh/ssh-agent

################### Clean up local results directory to prep for historical analysis ###################
# Check for previous host evaluation results, move any previous results to <local working directory>/results/historical/<host>/<last run time of analysis>
$LOCALMKDIR $LOCALRESULTSDIR 2>/dev/null
$LOCALMKDIR $LOCALCURRENTDIR 2>/dev/null
cd $LOCALCURRENTDIR
if [[ $($LOCALLS | $LOCALGREP .csv) ]] ; then
	while $LOCALLS *.csv &>/dev/null; do
		HOSTLASTRUN=$($LOCALLS | $LOCALGREP .csv | $LOCALAWK -F "_" '{print $1}' | $LOCALHEAD -1)
		DATELASTRUN=$($LOCALLS | $LOCALGREP .csv | $LOCALAWK -F "_" '{print $2}' | $LOCALHEAD -1)	
		$LOCALMKDIR $LOCALHISTORICALDIR 2>/dev/null
		$LOCALMKDIR $LOCALHISTORICALDIR/$($LOCALECHO $HOSTLASTRUN) 2>/dev/null
		$LOCALMKDIR $LOCALHISTORICALDIR/$($LOCALECHO $HOSTLASTRUN)/$DATELASTRUN 2>/dev/null
		$LOCALMV $($LOCALECHO $HOSTLASTRUN)*.csv $LOCALHISTORICALDIR/$HOSTLASTRUN/$DATELASTRUN
	done
fi

################### Copy tar artifact collection and tools to remote host ###################
cd $LOCALWORKINGDIR
#Copy tar of artifact collection script and tools
#Using parallel scp (pscp) -h (lists of hosts to run scp in parallel) -p (amount of parallel hosts at the same time); output results to console and to a log file
$LOCALPSCP -h $LOCALWORKINGDIR/$TARGETS -p 25 $LOCALWORKINGDIR/$SCRIPANDTOOLSTAR $REMOTEROOTDIR/$SCRIPANDTOOLSTAR 

#Copy statically or dynamically linked, trusted tar, cp, and rm binaries to handle the extraction of the artifact collection script
#Using parallel scp (pscp) -h (lists of hosts to run scp in parallel) -p (amount of parallel hosts at the same time); output results to console and to a log file
$LOCALPSCP -h $LOCALWORKINGDIR/$TARGETS -p 25 $LOCALWORKINGDIR/tar $REMOTEROOTDIR/tar 
$LOCALPSCP -h $LOCALWORKINGDIR/$TARGETS -p 25 $LOCALWORKINGDIR/rm $REMOTEROOTDIR/rm 

################### Run artifact collection script on remote host ###################
#Untar artifact collection script and tools, run the script, tar the results
#Using parallel ssh (pssh) -h (lists of hosts to run scp in parallel) -p (amount of parallel hosts at the same time); output results to console and to a log file
$LOCALPSSH -h $LOCALWORKINGDIR/$TARGETS -p 25 -t 600 "(cd $REMOTEROOTDIR; $REMOTEROOTDIR/tar -xzpf $SCRIPANDTOOLSTAR; cd $REMOTEWORKINGDIR; ./$ARTIFACTCOLLECTIONSCRIPT 2>/dev/null; cd $REMOTEWORKINGDIR/results; $REMOTEROOTDIR/tar -czf \$(hostname)_$REMOTERESULTSTAR *)" 

################### Copy the artifact collection results back to the local host and cleanup ###################
#Copy remote host results back to the local host
$LOCALMKDIR $LOCALHISTORICALDIR 2>/dev/null

#pssh-2.3.1 does not support the copy of files from a remote machine to a local machine, this section is a temp workaround
#Get the IP address of the interface used to connect to the remote machines, build a entry to be added to the known_hosts file on remote machines
$LOCALSSHKEYSCAN $($LOCALIFCONFIG $LOCALNETIF | $LOCALGREP 'inet addr:' | $LOCALCUT -d: -f2 | $LOCALAWK '{ print $1}') > $LOCALWORKINGDIR/$FREQUENCYANALYSISKNOWNHOST 
#copy the entry to be added to the known_hosts file to the remote machines
$LOCALPSCP -h $LOCALWORKINGDIR/$TARGETS -p 25 $LOCALWORKINGDIR/$FREQUENCYANALYSISKNOWNHOST $REMOTEROOTDIR/.ssh
#add the entry to the known_hosts file on the remote machines
$LOCALPSSH -h $LOCALWORKINGDIR/$TARGETS -p 25 "cat $REMOTEROOTDIR/.ssh/$FREQUENCYANALYSISKNOWNHOST >> $REMOTEROOTDIR/.ssh/known_hosts"
#ssh into the remote host using ssh-agent forwarding, then scp the results back to the analysis server
$LOCALPSSH -h $LOCALWORKINGDIR/$TARGETS -X -A -p 25 "scp $REMOTEWORKINGDIR/results/*_$REMOTERESULTSTAR root@$($LOCALIFCONFIG $LOCALNETIF | $LOCALGREP 'inet addr:' | $LOCALCUT -d: -f2 | $LOCALAWK '{ print $1}'):$LOCALCURRENTDIR"
#reset file permissions for the /results/current/* files
$LOCALSSH root@127.0.0.1 "$LOCALCHOWN $CURRENTUSER $LOCALCURRENTDIR/*.tgz"

#Cleanup files on the remote host
#Note that deleting and re-creating these files/directories overwrites unallocated space. The tradeoff of leaving these
# files in place is that an attacker may be able to see what artifacts are being collected and/or modify the local scripts.
$LOCALPSSH -h $LOCALWORKINGDIR/$TARGETS -p 25 "($REMOTEROOTDIR/rm -rf $REMOTEWORKINGDIR; $REMOTEROOTDIR/rm -f $SCRIPANDTOOLSTAR; $REMOTEROOTDIR/rm -f tar; $REMOTEROOTDIR/rm -f rm)" | $LOCALTEE -a $LOCALWORKINGDIR/$FREQUENCYANALYSISRUNLOG

#Untar local results and delete tar
cd $LOCALCURRENTDIR
for i in *.tgz; do $LOCALTAR -xzf $i &>/dev/null; done
$LOCALRM -f $LOCALCURRENTDIR/*.tgz
