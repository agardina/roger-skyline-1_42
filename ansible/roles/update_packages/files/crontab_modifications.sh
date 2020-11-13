#!/bin/bash

cat /etc/crontab > /home/agardina/crontab_new
DIFF=$(diff /home/agardina/crontab_tmp /home/agardina/crontab_new)
if [ "$DIFF" != "" ]; then
	echo -e "The crontab file has been modified" | mail -s "Crontab" root
	cat /home/agardina/crontab_new > /home/agardina/crontab_tmp
fi