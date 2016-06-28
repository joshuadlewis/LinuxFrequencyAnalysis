#!/bin/bash
# Copyright Joshua Lewis, 2016.
# Version 1.0  
# Permission to use and distribute this script permitted as long as the copyright is preserved and referenced
# Use of this script at your own risk, no warrany is implied

################### Setup variables ###################
#Define path to local binaries
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

#Define working directories
LOCALCURRENTRESULTSDIR=/home/sans/Desktop/results/current
LOCALHISTORICALDIR=/home/sans/Desktop/results/historical
LOCALHISTORICALRESULTS=/home/sans/Desktop/results/historical_working_dir

################### Determine host and artifact to perform historical analysis ###################
cd $LOCALHISTORICALDIR
$LOCALMKDIR -p $LOCALHISTORICALRESULTS 2>/dev/null

## Set host to perform historical analysis
$LOCALCLEAR
$LOCALECHO "##### Endpoints available for historical analysis #####"
$LOCALECHO ""
ls | $LOCALGREP -v *.csv | $LOCALGREP -v *.sh
$LOCALECHO ""
$LOCALECHO "##### Select endpoint to perform historical analysis #####"
$LOCALECHO ""
$LOCALECHO -n "Enter the endpoint name as listed above, then press [ENTER]: "
read ENDPOINT
$LOCALCLEAR
$LOCALECHO "##### Endpoint selected for historical analysis #####"
$LOCALECHO $ENDPOINT
$LOCALECHO ""

## Set artifact to perform historical analysis
$LOCALECHO "##### Select a number 1-27 to perform artifact frequency analysis #####"
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
$LOCALECHO -n "Enter number, then press [ENTER]: "
read ARTIFACTTOEVALNUM

################### Analyze artifacts based on user input ###################
cd $LOCALHISTORICALDIR
case $ARTIFACTTOEVALNUM in
1)
	#Find the frequency for listening ports
	$LOCALCLEAR
	$LOCALFIND $LOCALHISTORICALDIR -name $($ENDPOINT)*netstat* -exec $LOCALCAT {} \; > $LOCALHISTORICALRESULTS/historicalNetstatCombined.csv
	$LOCALAWK -F ',' '{print $1,$2}' $LOCALHISTORICALRESULTS/historicalNetstatCombined.csv | $LOCALSORT | $LOCALUNIQ -c | $LOCALSORT -n | $LOCALLESS
	;;
2)
	#Find the frequency for running processes
	$LOCALCLEAR
	$LOCALFIND $LOCALHISTORICALDIR -name $($ENDPOINT)*processListing* -exec $LOCALCAT {} \; > $LOCALHISTORICALRESULTS/historicalProcessListingCombined.csv
	$LOCALAWK -F ',' '{print $1,$5}' $LOCALHISTORICALRESULTS/historicalProcessListingCombined.csv | $LOCALSORT | $LOCALUNIQ -c | $LOCALSORT -n | $LOCALLESS
	;;
3)
	#Find the frequency for run level 3 & 5 services
	$LOCALCLEAR
	$LOCALFIND $LOCALHISTORICALDIR -name $($ENDPOINT)*runLevel3And5Services* -exec $LOCALCAT {} \; > $LOCALHISTORICALRESULTS/historicalRunLevel3And5ServicesCombined.csv
	$LOCALAWK -F ',' '{print $1,$2,$3}' $LOCALHISTORICALRESULTS/historicalRunLevel3And5ServicesCombined.csv | $LOCALSORT | $LOCALUNIQ -c | $LOCALSORT -n | $LOCALLESS
	;;
4)
	#Find the frequency for kernel modules
	$LOCALCLEAR
	$LOCALFIND $LOCALHISTORICALDIR -name $($ENDPOINT)*kernelModules* -exec $LOCALCAT {} \; > $LOCALHISTORICALRESULTS/historicalKernelModulesCombined.csv
	$LOCALAWK -F ',' '{print $1,$2}' $LOCALHISTORICALRESULTS/historicalKernelModulesCombined.csv | $LOCALSORT | $LOCALUNIQ -c | $LOCALSORT -n | $LOCALLESS
	;;
5)
	#Find the frequency for setuid and setgid files
	$LOCALCLEAR
	$LOCALFIND $LOCALHISTORICALDIR -name $($ENDPOINT)*setUidAndSetGidFiles* -exec $LOCALCAT {} \; > $LOCALHISTORICALRESULTS/historicalSetUidAndSetGidFilesCombined.csv
	$LOCALAWK -F ',' '{print $1}' $LOCALHISTORICALRESULTS/historicalSetUidAndSetGidFilesCombined.csv | $LOCALSORT | $LOCALUNIQ -c | $LOCALSORT -n | $LOCALLESS
	;;
6)
	#Find the frequency for open but unlinked files
	$LOCALCLEAR
	$LOCALFIND $LOCALHISTORICALDIR -name $($ENDPOINT)*open_unlinked_file* -exec $LOCALCAT {} \; > $LOCALHISTORICALRESULTS/historicalOpenUnlinkedFilesCombined.csv
	$LOCALAWK -F ',' '{print $1,$4}' $LOCALHISTORICALRESULTS/historicalOpenUnlinkedFilesCombined.csv | $LOCALSORT | $LOCALUNIQ -c | $LOCALSORT -n | $LOCALLESS
	;;
7)
	#Find the frequency for regular files in the /dev directory
	$LOCALCLEAR
	$LOCALFIND $LOCALHISTORICALDIR -name $($ENDPOINT)*regularFilesInDev* -exec $LOCALCAT {} \; > $LOCALHISTORICALRESULTS/historicalregularFilesInDevCombined.csv
	$LOCALAWK -F ',' '{print $1}' $LOCALHISTORICALRESULTS/historicalregularFilesInDevCombined.csv | $LOCALSORT | $LOCALUNIQ -c | $LOCALSORT -n | $LOCALLESS
	;;
8)
	#Find the frequency for files that start with a dots or spaces
	$LOCALCLEAR
	$LOCALFIND $LOCALHISTORICALDIR -name $($ENDPOINT)*dotAndSpaceFiles* -exec $LOCALCAT {} \; > $LOCALHISTORICALRESULTS/historicaldotAndSpaceFilesCombined.csv
	$LOCALAWK -F ',' '{print $1}' $LOCALHISTORICALRESULTS/historicaldotAndSpaceFilesCombined.csv | $LOCALSORT | $LOCALUNIQ -c | $LOCALSORT -n | $LOCALLESS
	;;
9)
	#Find the frequency for directories that start with a dots
	$LOCALCLEAR
	$LOCALFIND $LOCALHISTORICALDIR -name $($ENDPOINT)*dotDirectories* -exec $LOCALCAT {} \; > $LOCALHISTORICALRESULTS/historicaldotDirectoriesCombined.csv
	$LOCALAWK -F ',' '{print $1}' $LOCALHISTORICALRESULTS/historicaldotDirectoriesCombined.csv | $LOCALSORT | $LOCALUNIQ -c | $LOCALSORT -n | $LOCALLESS
	;;
10)
	#Find the frequency for list and hash of files in the bin directories
	$LOCALCLEAR
	$LOCALFIND $LOCALHISTORICALDIR -name $($ENDPOINT)*hashOfFilesInBinDirectories* -exec $LOCALCAT {} \; > $LOCALHISTORICALRESULTS/historicalhashOfFilesInBinDirectoriesCombined.csv
	$LOCALAWK -F ',' '{print $1,$2}' $LOCALHISTORICALRESULTS/historicalhashOfFilesInBinDirectoriesCombined.csv | $LOCALSORT | $LOCALUNIQ -c | $LOCALSORT -n | $LOCALLESS
	;;
11)
	#Find the frequency for list of immutable files
	$LOCALCLEAR
	$LOCALFIND $LOCALHISTORICALDIR -name $($ENDPOINT)*chattrFiles* -exec $LOCALCAT {} \; > $LOCALHISTORICALRESULTS/historicalchattrFilesCombined.csv
	$LOCALAWK -F ',' '{print $1,$2}' $LOCALHISTORICALRESULTS/historicalchattrFilesCombined.csv | $LOCALSORT | $LOCALUNIQ -c | $LOCALSORT -n | $LOCALLESS
	;;
12)
	#Find the frequency for cron entries
	$LOCALCLEAR
	$LOCALFIND $LOCALHISTORICALDIR -name $($ENDPOINT)*crontabAndCron* -exec $LOCALCAT {} \; > $LOCALHISTORICALRESULTS/historicalcrontabAndCronCombined.csv
	$LOCALAWK -F ',' '{print $1}' $LOCALHISTORICALRESULTS/historicalcrontabAndCronCombined.csv | $LOCALSORT | $LOCALUNIQ -c | $LOCALSORT -n | $LOCALLESS
	;;
13)
	#Find the frequency for run-parts daily, hourly, monthly entries
	$LOCALCLEAR
	$LOCALFIND $LOCALHISTORICALDIR -name $($ENDPOINT)*run-partsDailyHourlyMonthly* -exec $LOCALCAT {} \; > $LOCALHISTORICALRESULTS/historicalrun-partsDailyHourlyMonthlyCombined.csv
	$LOCALAWK -F ',' '{print $1,$2}' $LOCALHISTORICALRESULTS/historicalrun-partsDailyHourlyMonthlyCombined.csv | $LOCALSORT | $LOCALUNIQ -c | $LOCALSORT -n | $LOCALLESS
	;;
14)
	#Find the frequency for cron allow settings
	$LOCALCLEAR
	$LOCALFIND $LOCALHISTORICALDIR -name $($ENDPOINT)*cronAllow* -exec $LOCALCAT {} \; > $LOCALHISTORICALRESULTS/historicalcronAllowCombined.csv
	$LOCALAWK -F ',' '{print $1}' $LOCALHISTORICALRESULTS/historicalcronAllowCombined.csv | $LOCALSORT | $LOCALUNIQ -c | $LOCALSORT -n | $LOCALLESS
	;;
15)
	#Find the frequency for cron deny settings
	$LOCALCLEAR
	$LOCALFIND $LOCALHISTORICALDIR -name $($ENDPOINT)*cronDeny* -exec $LOCALCAT {} \; > $LOCALHISTORICALRESULTS/historicalcronDenyCombined.csv
	$LOCALAWK -F ',' '{print $1}' $LOCALHISTORICALRESULTS/historicalcronDenyCombined.csv | $LOCALSORT | $LOCALUNIQ -c | $LOCALSORT -n | $LOCALLESS
	;;
16)
	#Find the frequency for user accounts
	$LOCALCLEAR
	$LOCALFIND $LOCALHISTORICALDIR -name $($ENDPOINT)*userAccts* -exec $LOCALCAT {} \; > $LOCALHISTORICALRESULTS/historicaluserAcctsCombined.csv
	$LOCALAWK -F ',' '{print $1}' $LOCALHISTORICALRESULTS/historicaluserAcctsCombined.csv | $LOCALSORT | $LOCALUNIQ -c | $LOCALSORT -n | $LOCALLESS
	;;
17)
	#Find the frequency for user accounts with a null password
	$LOCALCLEAR
	$LOCALFIND $LOCALHISTORICALDIR -name $($ENDPOINT)*accountsWithNullPasswd* -exec $LOCALCAT {} \; > $LOCALHISTORICALRESULTS/historicalaccountsWithNullPasswdCombined.csv
	$LOCALAWK -F ',' '{print $1}' $LOCALHISTORICALRESULTS/historicalaccountsWithNullPasswdCombined.csv | $LOCALSORT | $LOCALUNIQ -c | $LOCALSORT -n | $LOCALLESS
	;;
18)
	#Find the frequency for SSH authorized_keys for the root account
	$LOCALCLEAR
	$LOCALFIND $LOCALHISTORICALDIR -name $($ENDPOINT)*rootSshAuthKeys* -exec $LOCALCAT {} \; > $LOCALHISTORICALRESULTS/historicalrootSshAuthKeysCombined.csv
	$LOCALAWK -F ',' '{print $1}' $LOCALHISTORICALRESULTS/historicalrootSshAuthKeysCombined.csv | $LOCALSORT | $LOCALUNIQ -c | $LOCALSORT -n | $LOCALLESS
	;;
19)
	#Find the frequency for hash of sudoers file
	$LOCALCLEAR
	$LOCALFIND $LOCALHISTORICALDIR -name $($ENDPOINT)*sudoersFile* -exec $LOCALCAT {} \; > $LOCALHISTORICALRESULTS/historicalsudoersFileCombined.csv
	$LOCALAWK -F ',' '{print $1,$2}' $LOCALHISTORICALRESULTS/historicalsudoersFileCombined.csv | $LOCALSORT | $LOCALUNIQ -c | $LOCALSORT -n | $LOCALLESS
	;;
20)
	#Find the frequency for list of .rhost files
	$LOCALCLEAR
	$LOCALFIND $LOCALHISTORICALDIR -name $($ENDPOINT)*rhostFiles* -exec $LOCALCAT {} \; > $LOCALHISTORICALRESULTS/historicalrhostFilesCombined.csv
	$LOCALAWK -F ',' '{print $1}' $LOCALFREQUENCYDIR/currentrhostFilesCombined.csv | $LOCALSORT | $LOCALUNIQ -c | $LOCALSORT -n | $LOCALLESS
	;;
21)
	#Find the frequency for the list of hosts.equiv files
	$LOCALCLEAR
	$LOCALFIND $LOCALHISTORICALDIR -name $($ENDPOINT)*hosts.equivFiles* -exec $LOCALCAT {} \; > $LOCALHISTORICALRESULTS/historicalhosts.equivFilesCombined.csv
	$LOCALAWK -F ',' '{print $1}' $LOCALHISTORICALRESULTS/historicalhosts.equivFilesCombined.csv | $LOCALSORT | $LOCALUNIQ -c | $LOCALSORT -n | $LOCALLESS
	;;
22)
	#Find the frequency for the list of X0.hosts files
	$LOCALCLEAR
	$LOCALFIND $LOCALHISTORICALDIR -name $($ENDPOINT)*X0.hostsFiles* -exec $LOCALCAT {} \; > $LOCALHISTORICALRESULTS/historicalX0.hostsFilesCombined.csv
	$LOCALAWK -F ',' '{print $1}' $LOCALHISTORICALRESULTS/historicalX0.hostsFilesCombined.csv | $LOCALSORT | $LOCALUNIQ -c | $LOCALSORT -n | $LOCALLESS
	;;
23)
	#Find the frequency for default runlevels
	$LOCALCLEAR
	$LOCALFIND $LOCALHISTORICALDIR -name $($ENDPOINT)*inittab* -exec $LOCALCAT {} \; > $LOCALHISTORICALRESULTS/historicalinittabCombined.csv
	$LOCALAWK -F ',' '{print $1}' $LOCALHISTORICALRESULTS/historicalinittabCombined.csv | $LOCALSORT | $LOCALUNIQ -c | $LOCALSORT -n | $LOCALLESS
	;;
24)
	#Find the frequency for the list and hash of run level 3 & 5 startup and kill scripts
	$LOCALCLEAR
	$LOCALFIND $LOCALHISTORICALDIR -name $($ENDPOINT)*runlevel3And5StartKillScripts* -exec $LOCALCAT {} \; > $LOCALHISTORICALRESULTS/historicalrunlevel3And5StartKillScriptsCombined.csv
	$LOCALAWK -F ',' '{print $1,$2}' $LOCALHISTORICALRESULTS/historicalrunlevel3And5StartKillScriptsCombined.csv | $LOCALSORT | $LOCALUNIQ -c | $LOCALSORT -n | $LOCALLESS
	;;
25)
	#Find the frequency for the host file entries
	$LOCALCLEAR
	$LOCALFIND $LOCALHISTORICALDIR -name $($ENDPOINT)*etcHosts* -exec $LOCALCAT {} \; > $LOCALHISTORICALRESULTS/historicaletcHostsCombined.csv
	$LOCALAWK -F ',' '{print $1,$2}' $LOCALHISTORICALRESULTS/historicaletcHostsCombined.csv | $LOCALSORT | $LOCALUNIQ -c | $LOCALSORT -n | $LOCALLESS
	;;
26)
	#Find the frequency for the DNS servers used
	$LOCALCLEAR
	$LOCALFIND $LOCALHISTORICALDIR -name $($ENDPOINT)*resolv.confEntries* -exec $LOCALCAT {} \; > $LOCALHISTORICALRESULTS/historicalresolv.confEntriesCombined.csv
	$LOCALAWK -F ',' '{print $1,$2}' $LOCALHISTORICALRESULTS/historicalresolv.confEntriesCombined.csv | $LOCALSORT | $LOCALUNIQ -c | $LOCALSORT -n | $LOCALLESS
	;;
27)
	#Find the frequency for RPM package verification
	$LOCALCLEAR
	$LOCALFIND $LOCALHISTORICALDIR -name $($ENDPOINT)*rpmPackageVerification* -exec $LOCALCAT {} \; > $LOCALHISTORICALRESULTS/historicalrpmPackageVerificationCombined.csv
	$LOCALAWK -F ',' '{print $1,$2}' $LOCALHISTORICALRESULTS/historicalrpmPackageVerificationCombined.csv | $LOCALSORT | $LOCALUNIQ -c | $LOCALSORT -n | $LOCALLESS
	;;
*)
	echo "Value entered outside of options 1-27.  Try again"
	;;

esac
