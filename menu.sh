#!/bin/bash


### TO-DO: ADD COLORS
###        ADD exit codes and fixes
 main()
{
    $log_file= date "+%Y%m%d%H%M%S.json"
    touch $log_file
    echo "TEST " >> $log_file
    #trying to figure out if the user wrote his name.  example: ./menu.sh Alex 
    if [ -z $1 ];
    then
        echo " Hello $1"

    elif [ -n "$1" ];
    then
        $1="Boiiii!"
        echo $1
    fi
    
    echo "Bonjour! Please choose what would you like to know today about this system. 1 for system_status, 2 for who is logged in currently, 3 for checking updates, 4 for service ops, 5 for storage options"
    read user_input

    if [ $user_input -eq 1 ]; 
    then
    system_status
    elif [ $user_input -eq 2 ];
    then
    who_is_in
    elif [ $user_input -eq 3 ];
    then
    update_system
    elif [ $user_input -eq 4 ];
    then
    service_check
    elif [ $user_input -eq 5 ];
    then
    storage_check
    fi
   
}

system_status()     #OPTION 1
{
    echo "Running System Status Checks..."

    uptime  |tee -a "$log_file"                       #check load average.

    mpstat |tee -a $log_file                          #check CPU  utilization & 
    free -h  |tee -a $log_file                        # check memory in a more human readable way.

    netstat |grep "systemd" |tee -a $log_file         #Finding the network traffic of systemd
    df -h                   |tee -a $log_file         #Checking disk utilization
   
}

who_is_in()         #OPTION 2
{

    echo "Checking who is logged in currently" |tee -a $log_file

    w      |tee -a $log_file  #check who is in and what is he/she running.

    who -w |tee -a $log_file  #a more detailed aspect along with who is logged in  and how many times and what is he running.
    ps au  |tee -a $log_file #check who is in and what are they running (equivelant to top command.)


    ps -e -o pcpu,pid,user,args|sort -k1 -nr|head -10 |tee -a $log_file #show top 10 CPU usage processes with user
    ps -e -o pmem,pid,user,args|sort -k1 -nr|head -10 |tee -a $log_file #show top 10 memory consuming processes with user.

    iotop -u root -t -o -n 3                          |tee -a $log_file #we can have a lot of variations in iotop args. -t -> w timestamp, -o who actually uses the disk, -n number of iterations.

}

update_system()     #OPTION 3
{
    echo "Checking System Updates...\n Please enter 1 for Debian based (aptitude) and 2 for Redhat based distro (yum)" |tee -a $log_file
    read distro

    if [ $distro -eq 1 ];
    then   
        sudo apt update             |tee -a $log_file                #checks any updates and goes forward to update the software.

        sudo apt-get dist-upgrade   |tee -a $log_file      #checks and moves forward if you want to upgrade your system.

        sudo apt upgrade kernel     |tee -a $log_file        #checks and moves forward if you want to upgrade the kernel.
    elif [ $distro -eq 2 ];
    then
        sudo yum update             |tee -a $log_file

        sudo yum upgrade            |tee -a $log_file

        sudo yum upgrade kernel     |tee -a $log_file
    fi
}

service_check()      #OPTION 4
{  
    echo "Write the service's name to be checked."  |tee -a $log_file
    read service
    echo "Checking Services..."                     |tee -a $log_file

    sudo service $service Status

    echo "What to do with the service? 1: Restart, 2: Stop,  3: start, 4: status"   |tee -a $log_file
    read service_choice
    if [ $service_choice -eq 1 ];
    then 
    sudo service $service restart   |tee -a $log_file
    
    elif [ $service_choice -eq 2 ];
    then
    sudo service $service stop      |tee -a $log_file
    
    elif [ $service_choice -eq 3 ];
    then
    sudo service $service start     |tee -a $log_file
    
    elif [ $service_choice -eq 4 ];
    then
    sudo service $service status    |tee -a $log_file
    fi


}   

storage_check()     #OPTION 5
{
    echo "Checking Storage..."                             |tee -a $log_file

    echo "Listing All partitions and mountpoints..."       |tee -a $log_file
    lsblk
    echo "Listing All partitions in an alternative way..." |tee -a $log_file
    sudo fdisk -l                                          |tee -a $log_file
    echo "Checking partitions labeled by UUIDS"            |tee -a $log_file
    blkid |grep UUID                                       |tee -a $log_file     #alternative way: grep UUID /etc/fstab

    echo "Checking disk used by user..."                   |tee -a $log_file

    du -h /home                                            |tee -a $log_file
    echo "specify the username:"                           |tee -a $log_file
    read username

    du -h /home/$username                                  |tee -a $log_file




}

#TO-DO
store_to_db()      #Probably make a function which saves into a .json file the output of the commands. 
                            #But first do it in menu_history.log file.
{
    $db_filename= date "+%Y%m%d%H%M%S.json"
    
    echo $output >> $db_filename    
    
    echo "Store the history command in a db in txt. We 'll need to find out a way to store them in key-value pairs in a json format to be nice.\
        Key -> Timestamp of the command with HUGE precision in order to be unique.\
        Value -> Function names\
        Value2 -> Output of the commands."   
}


main

