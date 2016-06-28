#!/bin/bash
#This script re-sets the ssh-agent environment variables and loads the encrypted private keys into memory. 
#RUN THIS SCRIPT AFTER EACH RESTART

#Script derived from SANS 506 Securing Linux/Unix by Hal Pomeranz

#remove previous versions of the ssh-agent file
rm -f $HOME/.ssh/ssh-agent

#run the ssh-agent command to get shellcode the SSH_AUTH_SOCK and SSH_AGENT_PID, then output this to a file
ssh-agent | grep -v echo > $HOME/.ssh/ssh-agent

#set the permissions on the ssh-agent file
chmod 700 $HOME/.ssh/ssh-agent

#source this file so that the environment variables remain available
. $HOME/.ssh/ssh-agent

#force ssh-agent to load the private keys in memory; will be prompted to enter passwords for encrypted private keys
ssh-add
