#!/bin/bash


### TO-DO: ADD COLORS
###        ADD exit codes and fixes

 main()
{
    script -a my_draft_db.txt           #We keep the -a argument in order to append to the same file and NOT to delete it's history.
    
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

}

service_check()      #OPTION 4
{  
    echo "Checking Services..."
}   

storage_check()     #OPTION 5
{
    echo "Checking Storage..."
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