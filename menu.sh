#!/bin/bash


### TO-DO: ADD COLORS
###        ADD exit codes and fixes
 main()
{
    #script -a my_draft_db.txt           Den douleuei h mlkia ... #We keep the -a argument in order to append to the same file and NOT to delete it's history.
    
    #trying to figure out if the client wrote his name.  example: ./menu.sh Alex 
    if [ -z "$1"];
    then
        echo " Hello $1"

    elif [ -n "$1"];
    then
        $1="Boiiii!"
        echo $1

    fi
    
    echo "Bonjour! Please choose what would you like to know today about this system. 1 for system_status, 2 for who is logged in currently, 3 for checking updates, 4 for service ops, 5 for storage options"
    read user_input
sadf
    if ["$user_input"=1]; 
    then
    system_status
    elif ["$user_input"=2];
    then
    who_is_in
    elif ["$user_input"=3];
    then
    update_system
    elif ["$user_input"=4];
    then
    service_check
    elif ["$user_input"=5];
    then
    storage_check
    fi
   
}


system_status()     #OPTION 1
{
    echo "Running System Status Checks..."

    uptime      #check load average.

    mpstat      #check CPU  utilization & 
    free -h     # check memory in a more human readable way.

    netstat |grep "systemd"     #Finding the network traffic of systemd
    df -h                       #checking disk utilization
   
}

who_is_in()         #OPTION 2
{

    echo "Checking who is logged in currently"

    w       #check who is in and what is he/she running.

    who -w  #a more detailed aspect along with who is logged in  and how many times and what is he running.
    ps au   #check who is in and what are they running (equivelant to top command.)


    ps -e -o pcpu,pid,user,args|sort -k1 -nr|head -10 #show top 10 CPU usage processes with user
    ps -e -o pmem,pid,user,args|sort -k1 -nr|head -10 #show top 10 memory consuming processes with user.

    iotop -u root -t -o -n 3                          #we can have a lot of variations in iotop args. -t -> w timestamp, -o who actually uses the disk, -n number of iterations.

}

update_system()     #OPTION 3
{
    echo "Checking System Updates..."

    sudo apt update                  #checks any updates and goes forward to update the software.

    sudo apt-get dist-upgrade       #checks and moves forward if you want to upgrade your system.

    sudo apt upgrade kernel         #checks and moves forward if you want to upgrade the kernel.

}

service_check()      #OPTION 4
{  
    echo "Write the service's name to be checked."
    read service
    echo "Checking Services..."

    sudo service $service Status

    echo "What to do with the service? 1: Restart, 2: Stop, 3: Enable, 4: Disable, 5: start"
    read service_choice
    if [service_choice== 1];
    then 
    sudo service $service restart
    
    elif [service_choice== 2];
    then
    sudo service $service stop
    
    elif [service_choice== 3];
    then
    sudo service $service enable
    elif [service_choice== 4];
    then
    sudo service $service disable
    elif [service_choice== 5];
    then
    sudo service $service start
    fi


}   

storage_check()     #OPTION 5
{
    echo "Checking Storage..."

    echo "Listing All partitions and mountpoints..."
    lsblk
    echo "Listing All partitions in an alternative way..."
    sudo fdisk -l
    echo "Checking partitions labeled by UUIDS"
    blkid |grep UUID            #alternative way: grep UUID /etc/fstab

    echo "Checking disk used by user..."

    du -h /home
    echo "specify the username:"
    read username

    du -h /home/$username




}


store_to_db()      #Probably make a function which saves into a .json file the output of the commands. 
                            #But first do it in menu_history.log file.
{
    echo "Store the history command in a db in txt. We 'll need to find out a way to store them in key-value pairs in a json format to be nice.\
        Key -> Timestamp of the command with HUGE precision in order to be unique.\
        Value -> Function names\
        Value2 -> Output of the commands."   
}


main

