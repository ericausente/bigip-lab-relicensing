################################################

#script name:  Simple Automatic Lab Relicensing Script

# version:         4

# ECA

# v3: Seems the lab does not allow me to relicense the device before the License Expiration date.

# v3: Hence the script is changed to check if license expiry date is equal to the current date and proceed to do the licensing. 

# v4: Changed the "cut -d" command to awk instead; Seems the spacing changed in 'tmsh show sys license' output in version 15

################################################

#!/bin/bash

license=$(tmsh show sys license | grep Reg | awk '{print $3}')
#echo "License is $license -------->>> Comment this out"

expiration=$(tmsh show sys license | grep "License End" | awk '{print $4}')
#echo "Expiration of License will be on $expiration ------>>> Comment this out"

expirationnewformat=$(date -d $expiration +%Y%m%d)
#echo "New format is $expirationnewformat ----->>>> Comment this out"

today=$(date +%Y%m%d)
#echo "today is $today ------> Comment this out"

if [ $today -ge $expirationnewformat ]; #put the loop where you need it
then
#echo 'yes';
#echo "$today is greater than $expirationnewformat";
logger -p local0.info "Proceeding to relicense your system using this Reg Key $license";
/usr/local/bin/SOAPLicenseClient --basekey $license;
logger -p local0.info "License successfully applied!";

else
#echo 'no';
#echo "$today is lesser than $expirationnewformat";
logger -p local0.info "It's not time to license yet...";
fi
