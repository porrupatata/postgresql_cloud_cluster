SSHKEY="$1"
PASSWD="$2"
HOSTFILE=hostfile

## function to remove current host from known_hosts if it's already there
clean_known_hosts () {
        THISHOST=$1
        MYUSER=`whoami`
        if [ "$MYUSER" == "root" ]; then
                KnownHostsPATH='/root'
        else
                KnownHostsPATH="/home/$MYUSER"
        fi
        KnownHostsFILE="$KnownHostsPATH"/.ssh/known_hosts
        if [ `grep $THISHOST $KnownHostsFILE |wc|awk '{print $1}'` -gt 0 ]; then
                echo "removing current IP $THISHOST from known hosts as the host has been re-created"
                sed -i "/$THISHOST/d" $KnownHostsFILE
        #else
        #        echo 'not in here'
        fi
}

for host in $(ansible -i "$HOSTFILE" --list-hosts all | grep -v hosts)
do
	echo "processing $host"
	clean_known_hosts "$host"

	ssh -i "$SSHKEY" rocky@"$host" "sudo sed -i 's/PermitRootLogin.*$/PermitRootLogin yes/g' /etc/ssh/sshd_config; sudo sed 's/PasswordAuthentication/#PasswordAuthentication/g' -i /etc/ssh/sshd_config; echo -e '\nPasswordAuthentication yes' | sudo tee -a /etc/ssh/sshd_config ; echo 'root:$PASSWD' | sudo chpasswd; sudo systemctl restart sshd"

	#ssh-copy-id $host
	sshpass -p $PASSWD ssh-copy-id $host
done

for host in $(ansible -i "$HOSTFILE" --list-hosts all | grep -v hosts)
do
	echo "processing $host"
	su - ansible-user -c 'clean_known_hosts "$host"'


	#ssh-copy-id $host
	su - ansible-user -c "sshpass -p $PASSWD ssh-copy-id root@$host"
done
