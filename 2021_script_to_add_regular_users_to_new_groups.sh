#!/bin/bash
## This script create  groups and assign additionnal groups to all regular users in the server.
## in this case sysadmin as the primary group and middleware as secondary group
## created by Mocktar Tairou (mocktar.tairou@gmail.com)
## Greensboro NC August, 2021.
# Feel free to send me any suggestion or contribution. 
# Email: mocktar.tairou@gmail.com
# github: https://github.com/mocktar77 
echo " "
## Let's create the following variables to store the groups we have to create
PRIMARY_GROUP=sysadmin
SECONDARY_GROUP=middleware
echo "group ${PRIMARY_GROUP} is being created ......."
sleep 2
#This command will create the primary group we stock in the variable PRIMARY_GROUP
groupadd ${PRIMARY_GROUP}
# The following command will check if the ${PRIMARY_GROUP} was created.
tail -1 /etc/group
sleep 2
echo "group ${SECONDARY_GROUP} is being created ......"
#This command will create the secondary group we stock in the variable SECONDARY_GROUP
groupadd ${SECONDARY_GROUP}
sleep 2
# The following command will check if the ${SECONDARY_GROUP} was created.
tail -1 /etc/group
# We will use awk command to filter the /etc/passwd file
# We will extract from the third field, the user id superior and equal to 1000
# Assuming that the regular user's ids start at 1000. 
# From this list we will exclude the user nfsnobody by using the username extract from the first field.
# We excule nfsnobody or nobody (if this is the case for your server) because it is a systenm user with an id superior to 1000
# From this list, we will extract the first field that constitute the correspondant usernames with the argument {print $1}
#n The result will be redirected to the file call user_name to be created since it not exist
awk -F: '$3 >= 1000 && $1 != "nfsnobody" {print $1}' /etc/passwd >> user_name
The following for loop will go through the list of usernames obtained and add them the groups created accordingly
for USER_NAME in $(cat user_name);
do
    usermod -ag ${PRIMARYL_GROUP} -aG ${SECONDARY_GROUP} ${USER_NAME}
done
sleep 2
echo " "
echo " All regular users have been modified..."
echo " "
echo " Verification in progress ..... "
echo " "
# This following command will check the result for each of the users.
# In case the number of users is high we can just check the result for just 1 user
# We will need to comment the following command and remove the # sign for the #id 1000 command
for i in `cat user_name`; do id $i && sleep 1; done
#id 1000
echo " "
echo " "
#This command will check if the script didn't impact the other users
id 1
echo " "
#This command will delete the user_name file.
rm -f user_name


