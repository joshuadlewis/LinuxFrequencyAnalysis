#!/bin/bash
# Copyright Joshua Lewis, 2016.
# Version 1.0  
# Permission to use and distribute this script permitted as long as the copyright is preserved and referenced
# Use of this script at your own risk, no warrany is implied

################### Setup variables ###################
#Define path to local binaries
LOCALECHO=/bin/echo
LOCALCLEAR=/usr/bin/clear
LOCALAWK=/bin/awk
LOCALCAT=/bin/cat
LOCALMKDIR=/bin/mkdir
LOCALSORT=/bin/sort
LOCALUNIQ=/usr/bin/uniq

#Define working directories
LOCALCURRENTRESULTSDIR=/home/sans/Desktop/results/current
LOCALFREQUENCYDIR=/home/sans/Desktop/results/frequency_analysis

#Reusable commands
##TODO Clean up the case statements by substituting some of the common sequences of multiple commands with a variable
################### Determine artifact to perform frequency analysis ###################
$LOCALCLEAR
$LOCALECHO "Select a number 1-27 to perform artifact frequency analysis"
$LOCALECHO "[1]  Frequency of listening ports"
$LOCALECHO "[2]  Frequency of running processes"
$LOCALECHO "[3]  Frequency of run level 3 & 5 services"
$LOCALECHO "[4]  Frequency of kernel modules"
$LOCALECHO "[5]  Frequency of setuid and setgid files"
$LOCALECHO "[6]  Frequency of open but unlinked files"
$LOCALECHO "[7]  Frequency of regular files in the /dev directory"
$LOCALECHO "[8]  Frequency of files that start with a dots or spaces"
$LOCALECHO "[9]  Frequency of directories that start with a dots"
$LOCALECHO "[10] Frequency of list and hash of files in the bin directories"
$LOCALECHO "[11] Frequency of list of immutable files"
$LOCALECHO "[12] Frequency of cron entries"
$LOCALECHO "[13] Frequency of run-parts daily, hourly, monthly entries"
$LOCALECHO "[14] Frequency of cron allow settings"
$LOCALECHO "[15] Frequency of cron deny settings"
$LOCALECHO "[16] Frequency of user accounts"
$LOCALECHO "[17] Frequency of user accounts with a null password"
$LOCALECHO "[18] Frequency of SSH authorized_keys for the root account"
$LOCALECHO "[19] Frequency of hash of sudoers file"
$LOCALECHO "[20] Frequency of the list of .rhost files"
$LOCALECHO "[21] Frequency of the list of hosts.equiv files"
$LOCALECHO "[22] Frequency of the list of X0.hosts files"
$LOCALECHO "[23] Frequency of default runlevels"
$LOCALECHO "[24] Frequency of the list and hash of run level 3 & 5 startup and kill scripts"
$LOCALECHO "[25] Frequency of host file entries"
$LOCALECHO "[26] Frequency of DNS servers used"
$LOCALECHO "[27] Frequency of RPM package verification"
$LOCALECHO -n "Enter number, the press [ENTER]: "
read ARTIFACTTOEVALNUM

##TODO Add parsing for additional artifacts
# 1) UID 0 accounts
# 2) List of groups
# 3) Pam configuration
# 4) SSHd_config
# 4) /etc/rc.local

################### Analyze artifacts based on user input ###################
$LOCALMKDIR $LOCALCURRENTRESULTSDIR 2>/dev/null
cd $LOCALCURRENTRESULTSDIR
$LOCALMKDIR $LOCALFREQUENCYDIR 2>/dev/null
case $ARTIFACTTOEVALNUM in
1)
	#Find the frequency for listening ports
	$LOCALCLEAR
	$LOCALCAT $LOCALCURRENTRESULTSDIR/*netstat*.csv > $LOCALFREQUENCYDIR/currentNetstatCombined.csv
	$LOCALAWK -F ',' '{print $1,$2}' $LOCALFREQUENCYDIR/currentNetstatCombined.csv | $LOCALSORT | $LOCALUNIQ -c | $LOCALSORT -n > $LOCALFREQUENCYDIR/netstatFrequency
	less $LOCALFREQUENCYDIR/netstatFrequency
	;;
2)
	##TODO Capture the PPID in this as well so that process name, user and PPID can help identify start anomalies for processes trying to hide in plane site	
	#Find the frequency for running processes
	$LOCALCLEAR
	$LOCALCAT $LOCALCURRENTRESULTSDIR/*processListing*.csv > $LOCALFREQUENCYDIR/currentProcessListingCombined.csv
	$LOCALAWK -F ',' '{print $1,$5}' $LOCALFREQUENCYDIR/currentProcessListingCombined.csv | $LOCALSORT | $LOCALUNIQ -c | $LOCALSORT -n > $LOCALFREQUENCYDIR/processListingFrequency
	less $LOCALFREQUENCYDIR/processListingFrequency
	;;
3)
	#Find the frequency for run level 3 & 5 services
	$LOCALCLEAR
	$LOCALCAT $LOCALCURRENTRESULTSDIR/*runLevel3And5Services*.csv > $LOCALFREQUENCYDIR/currentRunLevel3And5ServicesCombined.csv
	$LOCALAWK -F ',' '{print $1,$2,$3}' $LOCALFREQUENCYDIR/currentRunLevel3And5ServicesCombined.csv | $LOCALSORT | $LOCALUNIQ -c | $LOCALSORT -n > $LOCALFREQUENCYDIR/runLevel3And5ServicesFrequency
	less $LOCALFREQUENCYDIR/runLevel3And5ServicesFrequency
	;;
4)
	#Find the frequency for kernel modules
	$LOCALCLEAR
	$LOCALCAT $LOCALCURRENTRESULTSDIR/*kernelModules*.csv > $LOCALFREQUENCYDIR/currentKernelModulesCombined.csv
	$LOCALAWK -F ',' '{print $1,$2}' $LOCALFREQUENCYDIR/currentKernelModulesCombined.csv | $LOCALSORT | $LOCALUNIQ -c | $LOCALSORT -n > $LOCALFREQUENCYDIR/kernelModulesFrequency
	less $LOCALFREQUENCYDIR/kernelModulesFrequency
	;;
5)
	#Find the frequency for setuid and setgid files
	$LOCALCLEAR
	$LOCALCAT $LOCALCURRENTRESULTSDIR/*setUidAndSetGidFiles*.csv > $LOCALFREQUENCYDIR/currentsetUidAndSetGidFilesCombined.csv
	$LOCALAWK -F ',' '{print $1}' $LOCALFREQUENCYDIR/currentsetUidAndSetGidFilesCombined.csv | $LOCALSORT | $LOCALUNIQ -c | $LOCALSORT -n > $LOCALFREQUENCYDIR/setUidAndSetGidFilesFrequency
	less $LOCALFREQUENCYDIR/setUidAndSetGidFilesFrequency
	;;
6)
	#Find the frequency for open but unlinked files
	$LOCALCLEAR
	$LOCALCAT $LOCALCURRENTRESULTSDIR/*open_unlinked_file*.csv > $LOCALFREQUENCYDIR/currentOpenUnlinkedFilesCombined.csv
	$LOCALAWK -F ',' '{print $1,$4}' $LOCALFREQUENCYDIR/currentOpenUnlinkedFilesCombined.csv | $LOCALSORT | $LOCALUNIQ -c | $LOCALSORT -n > $LOCALFREQUENCYDIR/openUnlinkedFilesFrequency
	less $LOCALFREQUENCYDIR/openUnlinkedFilesFrequency
	;;
7)
	#Find the frequency for regular files in the /dev directory
	$LOCALCLEAR
	$LOCALCAT $LOCALCURRENTRESULTSDIR/*regularFilesInDev*.csv > $LOCALFREQUENCYDIR/currentregularFilesInDevCombined.csv
	$LOCALAWK -F ',' '{print $1}' $LOCALFREQUENCYDIR/currentregularFilesInDevCombined.csv | $LOCALSORT | $LOCALUNIQ -c | $LOCALSORT -n > $LOCALFREQUENCYDIR/regularFilesInDevFrequency
	less $LOCALFREQUENCYDIR/regularFilesInDevFrequency
	;;
8)
	#Find the frequency for files that start with a dots or spaces
	$LOCALCLEAR
	$LOCALCAT $LOCALCURRENTRESULTSDIR/*dotAndSpaceFiles*.csv > $LOCALFREQUENCYDIR/currentdotAndSpaceFilesCombined.csv
	$LOCALAWK -F ',' '{print $1}' $LOCALFREQUENCYDIR/currentdotAndSpaceFilesCombined.csv | $LOCALSORT | $LOCALUNIQ -c | $LOCALSORT -n > $LOCALFREQUENCYDIR/dotAndSpaceFilesFrequency
	less $LOCALFREQUENCYDIR/dotAndSpaceFilesFrequency
	;;
9)
	#Find the frequency for directories that start with a dots
	$LOCALCLEAR
	$LOCALCAT $LOCALCURRENTRESULTSDIR/*dotDirectories*.csv > $LOCALFREQUENCYDIR/currentdotDirectoriesCombined.csv
	$LOCALAWK -F ',' '{print $1}' $LOCALFREQUENCYDIR/currentdotDirectoriesCombined.csv | $LOCALSORT | $LOCALUNIQ -c | $LOCALSORT -n > $LOCALFREQUENCYDIR/dotDirectoriesFrequency
	less $LOCALFREQUENCYDIR/dotDirectoriesFrequency
	;;
10)
	#Find the frequency for list and hash of files in the bin directories
	$LOCALCLEAR
	$LOCALCAT $LOCALCURRENTRESULTSDIR/*hashOfFilesInBinDirectories*.csv > $LOCALFREQUENCYDIR/currenthashOfFilesInBinDirectoriesCombined.csv
	$LOCALAWK -F ',' '{print $1,$2}' $LOCALFREQUENCYDIR/currenthashOfFilesInBinDirectoriesCombined.csv | $LOCALSORT | $LOCALUNIQ -c | $LOCALSORT -n > $LOCALFREQUENCYDIR/hashOfFilesInBinDirectoriesFrequency
	less $LOCALFREQUENCYDIR/hashOfFilesInBinDirectoriesFrequency
	;;
11)
	#Find the frequency for list of immutable files
	$LOCALCLEAR
	$LOCALCAT $LOCALCURRENTRESULTSDIR/*chattrFiles*.csv > $LOCALFREQUENCYDIR/currentchattrFilesCombined.csv
	$LOCALAWK -F ',' '{print $1,$2}' $LOCALFREQUENCYDIR/currentchattrFilesCombined.csv | $LOCALSORT | $LOCALUNIQ -c | $LOCALSORT -n > $LOCALFREQUENCYDIR/chattrFilesFrequency
	less $LOCALFREQUENCYDIR/chattrFilesFrequency
	;;
12)
	#Find the frequency for cron entries
	$LOCALCLEAR
	$LOCALCAT $LOCALCURRENTRESULTSDIR/*crontabAndCron*.csv > $LOCALFREQUENCYDIR/currentcrontabAndCronCombined.csv
	$LOCALAWK -F ',' '{print $1}' $LOCALFREQUENCYDIR/currentcrontabAndCronCombined.csv | $LOCALSORT | $LOCALUNIQ -c | $LOCALSORT -n > $LOCALFREQUENCYDIR/crontabAndCronFrequency
	less $LOCALFREQUENCYDIR/crontabAndCronFrequency
	;;
13)
	#Find the frequency for run-parts daily, hourly, monthly entries
	$LOCALCLEAR
	$LOCALCAT $LOCALCURRENTRESULTSDIR/*run-partsDailyHourlyMonthly*.csv > $LOCALFREQUENCYDIR/currentrun-partsDailyHourlyMonthlyCombined.csv
	$LOCALAWK -F ',' '{print $1,$2}' $LOCALFREQUENCYDIR/currentrun-partsDailyHourlyMonthlyCombined.csv | $LOCALSORT | $LOCALUNIQ -c | $LOCALSORT -n > $LOCALFREQUENCYDIR/run-partsDailyHourlyMonthlyFrequency
	less $LOCALFREQUENCYDIR/run-partsDailyHourlyMonthlyFrequency
	;;
14)
	#Find the frequency for cron allow settings
	$LOCALCLEAR
	$LOCALCAT $LOCALCURRENTRESULTSDIR/*cronAllow*.csv > $LOCALFREQUENCYDIR/currentcronAllowCombined.csv
	$LOCALAWK -F ',' '{print $1}' $LOCALFREQUENCYDIR/currentcronAllowCombined.csv | $LOCALSORT | $LOCALUNIQ -c | $LOCALSORT -n > $LOCALFREQUENCYDIR/cronAllowFrequency
	less $LOCALFREQUENCYDIR/cronAllowFrequency
	;;
15)
	#Find the frequency for cron deny settings
	$LOCALCLEAR
	$LOCALCAT $LOCALCURRENTRESULTSDIR/*cronDeny*.csv > $LOCALFREQUENCYDIR/currentcronDenyCombined.csv
	$LOCALAWK -F ',' '{print $1}' $LOCALFREQUENCYDIR/currentcronDenyCombined.csv | $LOCALSORT | $LOCALUNIQ -c | $LOCALSORT -n > $LOCALFREQUENCYDIR/cronDenyFrequency
	less $LOCALFREQUENCYDIR/cronDenyFrequency
	;;
16)
	#Find the frequency for user accounts
	$LOCALCLEAR
	$LOCALCAT $LOCALCURRENTRESULTSDIR/*userAccts*.csv > $LOCALFREQUENCYDIR/currentuserAcctsCombined.csv
	$LOCALAWK -F ',' '{print $1}' $LOCALFREQUENCYDIR/currentuserAcctsCombined.csv | $LOCALSORT | $LOCALUNIQ -c | $LOCALSORT -n > $LOCALFREQUENCYDIR/cronuserAcctsFrequency
	less $LOCALFREQUENCYDIR/cronuserAcctsFrequency
	;;
17)
	#Find the frequency for user accounts with a null password
	$LOCALCLEAR
	$LOCALCAT $LOCALCURRENTRESULTSDIR/*accountsWithNullPasswd*.csv > $LOCALFREQUENCYDIR/currentaccountsWithNullPasswdCombined.csv
	$LOCALAWK -F ',' '{print $1}' $LOCALFREQUENCYDIR/currentaccountsWithNullPasswdCombined.csv | $LOCALSORT | $LOCALUNIQ -c | $LOCALSORT -n > $LOCALFREQUENCYDIR/accountsWithNullPasswdFrequency
	less $LOCALFREQUENCYDIR/accountsWithNullPasswdFrequency
	;;
18)
	#Find the frequency for SSH authorized_keys for the root account
	$LOCALCLEAR
	$LOCALCAT $LOCALCURRENTRESULTSDIR/*rootSshAuthKeys*.csv > $LOCALFREQUENCYDIR/currentrootSshAuthKeysCombined.csv
	$LOCALAWK -F ',' '{print $1}' $LOCALFREQUENCYDIR/currentrootSshAuthKeysCombined.csv | $LOCALSORT | $LOCALUNIQ -c | $LOCALSORT -n > $LOCALFREQUENCYDIR/rootSshAuthKeysFrequency
	less $LOCALFREQUENCYDIR/rootSshAuthKeysFrequency
	;;
19)
	#Find the frequency for hash of sudoers file
	$LOCALCLEAR
	$LOCALCAT $LOCALCURRENTRESULTSDIR/*sudoersFile*.csv > $LOCALFREQUENCYDIR/currentsudoersFileCombined.csv
	$LOCALAWK -F ',' '{print $1,$2}' $LOCALFREQUENCYDIR/currentsudoersFileCombined.csv | $LOCALSORT | $LOCALUNIQ -c | $LOCALSORT -n > $LOCALFREQUENCYDIR/sudoersFileFrequency
	less $LOCALFREQUENCYDIR/sudoersFileFrequency
	;;
20)
	#Find the frequency for list of .rhost files
	$LOCALCLEAR
	$LOCALCAT $LOCALCURRENTRESULTSDIR/*rhostFiles*.csv > $LOCALFREQUENCYDIR/currentrhostFilesCombined.csv
	$LOCALAWK -F ',' '{print $1}' $LOCALFREQUENCYDIR/currentrhostFilesCombined.csv | $LOCALSORT | $LOCALUNIQ -c | $LOCALSORT -n > $LOCALFREQUENCYDIR/rhostFilesFrequency
	less $LOCALFREQUENCYDIR/rhostFilesFrequency
	;;
21)
	#Find the frequency for the list of hosts.equiv files
	$LOCALCLEAR
	$LOCALCAT $LOCALCURRENTRESULTSDIR/*hosts.equivFiles*.csv > $LOCALFREQUENCYDIR/currenthosts.equivFilesCombined.csv
	$LOCALAWK -F ',' '{print $1}' $LOCALFREQUENCYDIR/currenthosts.equivFilesCombined.csv | $LOCALSORT | $LOCALUNIQ -c | $LOCALSORT -n > $LOCALFREQUENCYDIR/hosts.equivFilesFrequency
	less $LOCALFREQUENCYDIR/hosts.equivFilesFrequency
	;;
22)
	#Find the frequency for the list of X0.hosts files
	$LOCALCLEAR
	$LOCALCAT $LOCALCURRENTRESULTSDIR/*X0.hostsFiles*.csv > $LOCALFREQUENCYDIR/currentX0.hostsFilesCombined.csv
	$LOCALAWK -F ',' '{print $1}' $LOCALFREQUENCYDIR/currentX0.hostsFilesCombined.csv | $LOCALSORT | $LOCALUNIQ -c | $LOCALSORT -n > $LOCALFREQUENCYDIR/X0.hostsFilesFrequency
	less $LOCALFREQUENCYDIR/X0.hostsFilesFrequency
	;;
23)
	#Find the frequency for default runlevels
	$LOCALCLEAR
	$LOCALCAT $LOCALCURRENTRESULTSDIR/*inittab*.csv > $LOCALFREQUENCYDIR/currentinittabCombined.csv
	$LOCALAWK -F ',' '{print $1}' $LOCALFREQUENCYDIR/currentinittabCombined.csv | $LOCALSORT | $LOCALUNIQ -c | $LOCALSORT -n > $LOCALFREQUENCYDIR/inittabFrequency
	less $LOCALFREQUENCYDIR/inittabFrequency
	;;
24)
	#Find the frequency for the list and hash of run level 3 & 5 startup and kill scripts
	$LOCALCLEAR
	$LOCALCAT $LOCALCURRENTRESULTSDIR/*runlevel3And5StartKillScripts*.csv > $LOCALFREQUENCYDIR/currentrunlevel3And5StartKillScriptsCombined.csv
	$LOCALAWK -F ',' '{print $1,$2}' $LOCALFREQUENCYDIR/currentrunlevel3And5StartKillScriptsCombined.csv | $LOCALSORT | $LOCALUNIQ -c | $LOCALSORT -n > $LOCALFREQUENCYDIR/runlevel3And5StartKillScriptsFrequency
	less $LOCALFREQUENCYDIR/runlevel3And5StartKillScriptsFrequency
	;;
25)
	#Find the frequency for the host file entries
	$LOCALCLEAR
	$LOCALCAT $LOCALCURRENTRESULTSDIR/*etcHosts*.csv > $LOCALFREQUENCYDIR/currentetcHostsCombined.csv
	$LOCALAWK -F ',' '{print $1,$2}' $LOCALFREQUENCYDIR/currentetcHostsCombined.csv | $LOCALSORT | $LOCALUNIQ -c | $LOCALSORT -n > $LOCALFREQUENCYDIR/etcHostsFrequency
	less $LOCALFREQUENCYDIR/etcHostsFrequency
	;;
26)
	#Find the frequency for the DNS servers used
	$LOCALCLEAR
	$LOCALCAT $LOCALCURRENTRESULTSDIR/*resolv.confEntries*.csv > $LOCALFREQUENCYDIR/currentresolv.confEntriesCombined.csv
	$LOCALAWK -F ',' '{print $1,$2}' $LOCALFREQUENCYDIR/currentresolv.confEntriesCombined.csv | $LOCALSORT | $LOCALUNIQ -c | $LOCALSORT -n > $LOCALFREQUENCYDIR/resolv.confEntriesFrequency
	less $LOCALFREQUENCYDIR/resolv.confEntriesFrequency
	;;
27)
	#Find the frequency for RPM package verification
	$LOCALCLEAR
	$LOCALCAT $LOCALCURRENTRESULTSDIR/*rpmPackageVerification*.csv > $LOCALFREQUENCYDIR/currentrpmPackageVerificationCombined.csv
	$LOCALAWK -F ',' '{print $1,$2}' $LOCALFREQUENCYDIR/currentrpmPackageVerificationCombined.csv | $LOCALSORT | $LOCALUNIQ -c | $LOCALSORT -n > $LOCALFREQUENCYDIR/rpmPackageVerificationFrequency
	less $LOCALFREQUENCYDIR/rpmPackageVerificationFrequency
	;;
*)
	echo "Value entered outside of options 1-27.  Try again"
	;;

esac
