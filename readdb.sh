#!/bin/bash

dbfile=`pwd`/contacts2.db

# Convertdb file to readable text
if [[ ! -e  "$dbfile" ]]
then
	echo "Error: Could not locate database file: contacts2.db"
	exit 1
else
echo '.dump' | sqlite3 contacts2.db > contacts2.txt
fi


# Find names

echo -n "Whose number are you looking for (name) :"
read name
echo "Finding number for $name"

# Search name and return number value ex 84
grep -iw "$name" contacts2.txt | grep -o 'INSERT INTO "raw_contacts" VALUES([0-9]\{1,3\}' | grep  [0-9] | cut -d'(' -f2 > smsfile.txt

#check if name exists and redirect stdout and sterror to /dev/null
grep -iwo "$name" contacts2.txt > /dev/null 2>&1
if [ $? = 0 ]
then
	:
else
echo "Error: Could not find name. Try Addind or Deleting the last name."
exit 1
fi

while read no1 
do

#Search number and print out phone numbers to smsfile1.txt
grep -i "INSERT INTO \"phone_lookup\" VALUES(.*,$no1" contacts2.txt | grep -o '[0-9]\{10,11\}' > smsfile1.txt


#Search only ten digit numbers 
grep -w '[0-9]\{10\}' smsfile1.txt
done < smsfile.txt

#Delete temp files
rm smsfile.txt smsfile1.txt
exit 0
