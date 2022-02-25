#!/usr/bin/env bash

computers=("192.168.20.90" "192.168.20.91" "192.168.20.92")
owners=("maggie" "koby" "charli")

for i in {0..2};
do
	computer=${computers[i]}
	owner=${owners[i]}
	
	echo Updating $owner $computer
	ssh $computer "cd .dotfiles; git pull && sudo nixos-rebuild switch"
done
