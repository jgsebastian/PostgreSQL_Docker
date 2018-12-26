#!/bin/bash

################################################################################
##       Author:   Jaime Gª Sebastián                                         ##
##         Date:   2018-07-06                                                 ##
##      Version:   1.0                                                        ##
##  Description:   Exports every PostgreSQL table vía Docker with 2 arguments ##
##                 (Table Name & CSV File)                                    ##
##                                                                            ##
################################################################################

. /Path_to_Config_File/config.cfg

# Control of args number passed. 

echo "[ "$(date -u) " ]" "LOG: Script Name: $0" > $LOGPATH/$LOGFILE
echo "[ "$(date -u) " ]" "LOG: $# Arguments passed" >> $LOGPATH/$LOGFILE
if [ $# -ne 2 ] 
    then echo "ERROR: Illegal number of parameters passed. Usage: [SCRIPT NAME] [SOURCE TABLE] [TARGET CSV FILE]" >> $LOGPATH/$LOGFILE
    exit -2
fi

echo "[ "$(date -u) " ]" "LOG: Beggining with the data export to CSV file" >> $LOGPATH/$LOGFILE
echo "[ "$(date -u) " ]" "LOG: Source Table: $1" >> $LOGPATH/$LOGFILE
echo "[ "$(date -u) " ]" "LOG: Source Table Schema: $PGSCHEMA" >> $LOGPATH/$LOGFILE
echo "[ "$(date -u) " ]" "LOG: Target File: $2" >> $LOGPATH/$LOGFILE

# Export to CSV File

docker exec -it $DOCKERNAME  psql \
-U $PGUSER \
-d $PGDATABASE \
--quiet \
-c "\copy $PGSCHEMA.$1  to '$SOURCEDIR/$2' with delimiter as '$CSVDELIMITER'" 
if [ $? -ne "0" ]
	then
		echo "[ "$(date -u) " ]" "ERROR: Error during the Export to file from table $1" >> $LOGPATH/$LOGFILE
		exit -4 
fi

#Counts number of records exported

export_count=`wc -l /Users/jaimegsebastian/Projects/CSV/$2  | cut -d'/' -f1`
echo "Number of records exported to /Users/jaimegsebastian/Projects/CSV/$2 file:" $export_count >> $LOGPATH/$LOGFILE

exit 0