#!/bin/bash

printf "\n" >> /var/log/update_script.log
printf "##### Packages sources and packages update #####" >> /var/log/update_script.log
printf "\n" >> /var/log/update_script.log
date >> /var/log/update_script.log
apt-get -y -q update >> /var/log/update_script.log
apt-get -y -q upgrade >> /var/log/update_script.log
printf "##### Update done #####" >> /var/log/update_script.log
printf "\n" >> /var/log/update_script.log