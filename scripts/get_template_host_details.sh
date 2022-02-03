SSH_DETAILS_OUTPUTFILE=remote_access_details.yml
EXTRA_MOUNTS_OUTPUTFILE=extra_mounts_details.yml
USERFILE=template_user_details.yml
CRON_OUTPUT_FOLDER=crons
source ./bash_variables.sh

## input argument switches. #########################################
   # if no input argument execute all. 
   # If input SSH, execute only SSH. 
   # if input NOT_SSH execute everything except SSH

	SSH=true
	NOT_SSH=true

	if [ "$1" == "SSH" ]; then
		NOT_SSH=false
	fi

	if [ "$1" == "NOT_SSH" ]; then
		SSH=false
	fi

## function definitions ############################################
get_passwordless_ssh_connections ()
{  
   LOCAL_USERS=$1
   REMOTE_USERS=$2
   OUTPUTFILE=$3

   echo 'remote_access_details:' > "$OUTPUTFILE"
   for LOCAL_USER in "${LOCAL_USERS[@]}"
   do
	
	echo -e "\nxxxxxxxxxxxxxxxxxxxxxxxxxxx\nchecking ssh access for $LOCAL_USER\nxxxxxxxxxxxxxxxxxxxxxxxxxxx\n"
	for HOST in $(su -l $LOCAL_USER -c "cat \$HOME/.ssh/known_hosts | awk '{print \$1}'|tr ',' '\n'")
	do
		echo -e "\nFound host: $HOST\n"
		for REMOTE_USER in "${REMOTE_USERS[@]}"
		do
			echo Checking access for user $REMOTE_USER
			#OUT=$(su -l $LOCAL_USER -c "ssh -o PubkeyAuthentication=yes -o ConnectTimeout=5 $REMOTE_USER@$HOST 'echo 1' 2>/dev/null")
			OUT=$(timeout 3 su -l $LOCAL_USER -c "ssh -o PubkeyAuthentication=yes -o ConnectTimeout=2 $REMOTE_USER@$HOST 'echo 1'")
			if [ "$OUT" == "1" ]; then
				echo "$LOCAL_USER has access to $REMOTE_USER@$HOST"
				echo "  - local_user: $LOCAL_USER" >> "$OUTPUTFILE"
				echo "    remote_host: $HOST" >> "$OUTPUTFILE"
				echo "    remote_user: $REMOTE_USER" >> "$OUTPUTFILE"
				echo "    remote_password: " >> "$OUTPUTFILE"
			fi
		done
		
	done
	

   done
}

get_cronjobs ()
{  
   LOCAL_USERS=$1
   OUTPUTFOLDER=$2
   mkdir -p $OUTPUTFOLDER 2>/dev/null && rm $OUTPUTFOLDER/* 2>/dev/null
   for LOCAL_USER in "${LOCAL_USERS[@]}"
   do
	crontab -l -u $LOCAL_USER > "$OUTPUTFOLDER"/"$LOCAL_USER".cron
   done

   
}

get_user_details ()
{  
   LOCAL_USERS=$1
   OUTPUTFILE=$2
   
   echo 'host_users:' > "$OUTPUTFILE"
   for LOCAL_USER in "${LOCAL_USERS[@]}"
   do 
     #  if [ "$LOCAL_USER" != "root" ]; then
         ID=$(id -u $LOCAL_USER)
         GID=$(id -g $LOCAL_USER)
         GNAME=$(id -gn $LOCAL_USER)
         EXTRA_GIDS=$(id -G $LOCAL_USER)
       
         echo " - user: $LOCAL_USER" >>  "$OUTPUTFILE"
         echo "   id: $ID"  >>  "$OUTPUTFILE"
         echo "   gid: $GID"  >>  "$OUTPUTFILE"
         echo "   group_name: $GNAME"  >>  "$OUTPUTFILE"
         echo "   extra_gids: $EXTRA_GIDS"  >>  "$OUTPUTFILE"
     #  fi
   done
}
   

get_extra_mounts ()
{ 
  OUTPUTFILE=$1
  echo 'extra_mounts:' > "$OUTPUTFILE"
  IFS=$'\n' # newline as separator for for loop instead of default space
  for MOUNT in $( cat /etc/fstab |grep nfs|egrep -v '^#' )
  do
	echo "$MOUNT" | awk '{ print $1}' |sed 's/^/ - mount_source: /' >> "$OUTPUTFILE"
	echo "$MOUNT" | awk '{ print $2}' |sed 's/^/   mount_point: /' >> "$OUTPUTFILE"
	echo "$MOUNT" | awk '{ print $3}' |sed 's/^/   type: /' >> "$OUTPUTFILE"
	echo "$MOUNT" | awk '{ print $4}' |sed 's/^/   options: /' >> "$OUTPUTFILE"

  done 

}


## execute functions ###############################################
if [ "$SSH" == "true" ]; then
	get_passwordless_ssh_connections $LOCAL_USERS $REMOTE_USERS $SSH_DETAILS_OUTPUTFILE
fi

if [ "$SSH" == "true" ]; then
	get_cronjobs $LOCAL_USERS $CRON_OUTPUT_FOLDER
	get_extra_mounts $EXTRA_MOUNTS_OUTPUTFILE
	get_user_details $LOCAL_USERS $USERFILE 
fi
