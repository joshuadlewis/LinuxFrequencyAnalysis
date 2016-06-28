#!/bin/bash
# Copyright Joshua Lewis, 2016.
# Version 1.0  
# Permission to use and distribute this script permitted as long as the copyright is preserved and referenced
# Use of this script at your own risk, no warrany is implied

#Define path to trusted binaries
BINPATH="/root/analysis/tools"
#Define path for output
OUTPATH="/root/analysis/results"
#Set date and time the analysis was ran
DATETIME=$(date +%m-%d-%Y.%H.%M)

#Make directory results
mkdir $OUTPATH

################### Ports ###################
#$BINPATH/echo "### Capture listenging ports "
$BINPATH/netstat -ln | $BINPATH/egrep -v '^unix|Active|Proto' | $BINPATH/sed -e 's@^@'"$($BINPATH/hostname)"\ '@' | $BINPATH/awk '{ print $5,$2,$1}' | $BINPATH/tr -s ' ' ',' > $OUTPATH/$($BINPATH/hostname)_$(echo $DATETIME)_netstat.csv

################### Process ###################
#$BINPATH/echo "### Capture running processes "
$BINPATH/ps -Ao "comm,pid,ppid,start,user" | $BINPATH/grep -v ^COMMAND |$BINPATH/sed -e 's@^@'"$($BINPATH/hostname)"\ '@' | $BINPATH/awk '{ print $2,$3,$4,$5,$6,$1}' | $BINPATH/tr -s " " "," > $OUTPATH/$($BINPATH/hostname)_$(echo $DATETIME)_processListing.csv

################### Services ###################
#$BINPATH/echo "### Capture run level 3 & 5 services "
$BINPATH/chkconfig --list | $BINPATH/awk '{print $1,$5,$7}'| $BINPATH/sed -e 's@$@'\ "$(hostname)"'@'| $BINPATH/tr -s ' ' ',' > $OUTPATH/$($BINPATH/hostname)_$(echo $DATETIME)_runLevel3And5Services.csv

################### Kernel modules ###################
#$BINPATH/echo "### Capture kernel modules "
$BINPATH/lsmod | $BINPATH/awk '{print $1,$2}'| $BINPATH/tr -s ' ' ','| $BINPATH/sed -e 's@$@',"$($BINPATH/hostname)"'@' > $OUTPATH/$($BINPATH/hostname)_$(echo $DATETIME)_kernelModules.csv

################### Files ###################
#$BINPATH/echo "### Capture setuid and setgid files "
$BINPATH/find / -perm -2000 -o -perm -4000 -exec $BINPATH/sh -c 'echo "$0"' {} \; 2>/dev/null | $BINPATH/sed -e 's@$@'\ "$($BINPATH/hostname)"'@'| $BINPATH/tr -s ' ' ',' > $OUTPATH/$($BINPATH/hostname)_$(echo $DATETIME)_setUidAndSetGidFiles.csv

#$BINPATH/echo "### Capture open but unlinked files "
# The idea to collect this artifact derived from the SANS Intrusion Discovery Cheat Sheet for Linux (https://pen-testing.sans.org/resources/downloads)
$BINPATH/lsof +L1 | $BINPATH/awk '{print $1,$2,$3,$10}'|$BINPATH/tr -s ' ' ','| $BINPATH/sed -e 's@$@',"$($BINPATH/hostname)"'@' | $BINPATH/grep -v 'COMMAND,PID,USER,NAME,'> $OUTPATH/$($BINPATH/hostname)_$(echo $DATETIME)_open_unlinked_files.csv

#$BINPATH/echo "### Capture regular files in the /dev directory "
# The idea to collect this artifact derived from SANS 506 Securing Linux/Unix by Hal Pomeranz
$BINPATH/find /dev -type f | $BINPATH/sed -e 's@$@',"$($BINPATH/hostname)"'@' >$OUTPATH/$($BINPATH/hostname)_$(echo $DATETIME)_regularFilesInDev.csv

#$BINPATH/echo "### Capture files that start with a dots or spaces "
# The idea to collect this artifact derived from the SANS Intrusion Discovery Cheat Sheet for Linux (https://pen-testing.sans.org/resources/downloads)
$BINPATH/find / \( -name " *" -o -name ".*" \) -exec sh -c 'echo "$0"' {} \; | $BINPATH/sed -e 's@$@',"$($BINPATH/hostname)"'@' >$OUTPATH/$($BINPATH/hostname)_$(echo $DATETIME)_dotAndSpaceFiles.csv

#$BINPATH/echo "### Capture directories that start with a dots "
$BINPATH/find / -type d -name .\* | $BINPATH/sed -e 's@$@',"$($BINPATH/hostname)"'@' >$OUTPATH/$($BINPATH/hostname)_$(echo $DATETIME)_dotDirectories.csv

#$BINPATH/echo "### Capture list and hash of files in the bin directories "
$BINPATH/sha256sum /bin/* /sbin/* /usr/bin/* 2>/dev/null | $BINPATH/sed -e 's@$@',"$($BINPATH/hostname)"'@' | $BINPATH/tr -s ' ' ',' > $OUTPATH/$($BINPATH/hostname)_$(echo $DATETIME)_hashOfFilesInBinDirectories.csv

#$BINPATH/echo "### Capture list of immutable files "
$BINPATH/lsattr -R / 2>/dev/null | $BINPATH/grep -e '----i-' | $BINPATH/sed -e 's@$@',"$($BINPATH/hostname)"'@' | $BINPATH/tr -s ' ' ',' > $OUTPATH/$($BINPATH/hostname)_$(echo $DATETIME)_chattrFiles.csv

################### Tasks ###################
#$BINPATH/echo "### Capture crontab "
$BINPATH/cat /etc/crontab /etc/cron.d/* | $BINPATH/grep -Ev '^SHELL=/bin/bash|^PATH=/sbin|^MAILTO=root|^HOME=/|^#' | $BINPATH/sed -s '/^$/d'| $BINPATH/sed -e 's/$/,/'| $BINPATH/sed -e 's@$@'"$($BINPATH/hostname)"'@' >$OUTPATH/$($BINPATH/hostname)_$(echo $DATETIME)_crontabAndCron.d.csv

#$BINPATH/echo "### Capture shell scripts executed by run-parts daily, hourly, monthly "
$BINPATH/sha256sum /etc/cron.daily/* /etc/cron.hourly/* /etc/cron.monthly/* | $BINPATH/sed -e 's@$@'\ "$($BINPATH/hostname)"'@'| $BINPATH/tr -s ' ' ',' > $OUTPATH/$($BINPATH/hostname)_$(echo $DATETIME)_run-partsDailyHourlyMonthly.csv

#$BINPATH/echo "### Capture cron allow settings "
$BINPATH/cat /etc/cron.allow 2>/dev/null | $BINPATH/sed -e 's@$@',"$($BINPATH/hostname)"'@' | $BINPATH/tr -s ' ' ',' > $OUTPATH/$($BINPATH/hostname)_$(echo $DATETIME)_cronAllow.csv

#$BINPATH/echo "### Capture cron deny settings "
$BINPATH/cat /etc/cron.deny 2>/dev/null | $BINPATH/sed -e 's@$@',"$($BINPATH/hostname)"'@' | $BINPATH/tr -s ' ' ',' > $OUTPATH/$($BINPATH/hostname)_$(echo $DATETIME)_cronDeny.csv

################### Authentication ###################
#$BINPATH/echo "### Capture user accounts "
$BINPATH/cat /etc/passwd | $BINPATH/sed -e 's@$@',"$($BINPATH/hostname)"'@'>$OUTPATH/$($BINPATH/hostname)_$(echo $DATETIME)_userAccts.csv

# The idea to collect this artifact derived from the "Blue Team Handbook: Incident Response Edition" by Don Murdoch
#$BINPATH/echo "### Capture user accounts with a null password "
$BINPATH/awk -F: '($2 == "") {print $1}' /etc/shadow | $BINPATH/sed -e 's@$@',"$($BINPATH/hostname)"'@' | $BINPATH/tr -s ' ' ',' > $OUTPATH/$($BINPATH/hostname)_$(echo $DATETIME)_accountsWithNullPasswd.csv

#$BINPATH/echo "### Capture SSH authorized_keys for the root account "
$BINPATH/cat /root/.ssh/authorized_keys | $BINPATH/sed -e 's@$@',"$($BINPATH/hostname)"'@' >$OUTPATH/$($BINPATH/hostname)_$(echo $DATETIME)_rootSshAuthKeys.csv

#$BINPATH/echo "### Capture hash of sudoers file "
$BINPATH/sha256sum /etc/sudoers | $BINPATH/sed -e 's@$@'\ "$($BINPATH/hostname)"'@'| $BINPATH/tr -s ' ' ',' > $OUTPATH/$($BINPATH/hostname)_$(echo $DATETIME)_sudoersFile.csv

#$BINPATH/echo "### Capture the list of .rhost files "
$BINPATH/find / -name .rhosts | $BINPATH/sed -e 's@$@',"$($BINPATH/hostname)"'@' > $OUTPATH/$($BINPATH/hostname)_$(echo $DATETIME)_rhostFiles.csv

# The idea to collect this artifact derived from the "Blue Team Handbook: Incident Response Edition" by Don Murdoch
#$BINPATH/echo "### Capture the list of hosts.equiv files "
$BINPATH/find /etc -name hosts.equiv | $BINPATH/sed -e 's@$@',"$($BINPATH/hostname)"'@' > $OUTPATH/$($BINPATH/hostname)_$(echo $DATETIME)_hosts.equivFiles.csv

# The idea to collect this artifact derived from the "Blue Team Handbook: Incident Response Edition" by Don Murdoch
#$BINPATH/echo "### Capture the list of X0.hosts files "
$BINPATH/find /etc -name X0.hosts | $BINPATH/sed -e 's@$@',"$($BINPATH/hostname)"'@' > $OUTPATH/$($BINPATH/hostname)_$(echo $DATETIME)_X0.hostsFiles.csv

#TODO add UID 0 accounts in /etc/passwd
#TODO add list of groups
#TODO add Pam configuration
#TODO add /etc/ssh/sshd_config

################### Startup ###################
#$BINPATH/echo "### Capture default runlevel "
$BINPATH/cat /etc/inittab | $BINPATH/grep -Ev '^#' | $BINPATH/sed -e 's@$@',"$($BINPATH/hostname)"'@' >$OUTPATH/$($BINPATH/hostname)_$(echo $DATETIME)_inittab.csv

#$BINPATH/echo "### Capture the list and hash of run level 3 & 5 startup and kill scripts "
$BINPATH/sha256sum /etc/rc3.d/* /etc/rc5.d/* | $BINPATH/sed -e 's@$@'\ "$($BINPATH/hostname)"'@'| $BINPATH/tr -s ' ' ',' > $OUTPATH/$($BINPATH/hostname)_$(echo $DATETIME)_runlevel3And5StartKillScripts.csv

##TODO add /etc/rc.local

################### DNS ###################
# The idea to collect this artifact derived from the Security Incident Survey Cheat Sheet for Server Administrators (https://zeltser.com/security-incident-survey-cheat-sheet/)
#$BINPATH/echo "### Capture host file entries "
$BINPATH/cat /etc/hosts | $BINPATH/grep -ve $($BINPATH/hostname) | $BINPATH/grep -v '::1' | $BINPATH/awk '{print $1,$2}' | $BINPATH/sed -e 's@$@',"$($BINPATH/hostname)"'@' | $BINPATH/tr -s ' ' ',' > $OUTPATH/$($BINPATH/hostname)_$(echo $DATETIME)_etcHosts.csv

# The idea to collect this artifact derived from the Security Incident Survey Cheat Sheet for Server Administrators (https://zeltser.com/security-incident-survey-cheat-sheet/)
#$BINPATH/echo "### Capture DNS servers used "
$BINPATH/cat /etc/resolv.conf | $BINPATH/grep -Ev '^#' | $BINPATH/sed -e 's@$@',"$($BINPATH/hostname)"'@' | $BINPATH/tr -s ' ' ',' > $OUTPATH/$($BINPATH/hostname)_$(echo $DATETIME)_resolv.confEntries.csv

################### Packages ###################
# The idea to collect this artifact derived from the SANS Intrusion Discovery Cheat Sheet for Linux (https://pen-testing.sans.org/resources/downloads)
#$BINPATH/echo "### Capture RPM package verification "
#$BINPATH/rpm -Va 2>/dev/null | $BINPATH/sort | $BINPATH/grep -v 'prelink' | $BINPATH/awk '{ print $1,$3}' | $BINPATH/sed -e 's@$@',"$($BINPATH/hostname)"'@' | $BINPATH/tr -s ' ' ',' > $OUTPATH/$($BINPATH/hostname)_$(echo $DATETIME)_rpmPackageVerification.csv



