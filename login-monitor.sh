#!/bin/bash

LOGFILE="/var/log/auth.log"
COPY_LOG="./logs/auth_copy.log"
THRESHOLD=3
FAIL_COUNT=0


# To clear the contents of the copy of the auth.log file
truncate -s 0 "$COPY_LOG"

 # Function to handle login success
handle_success() {
    kill 0  # Terminates all processes in the current script group
    exit 0  # Ensures script stops immediately
}


# To monitor the file in real-time 
tail -F "$LOGFILE" | while read -r line; do

    # To check for successful login attempts (session opened)
    if echo "$line" | grep -q "session opened for user"; then
        echo "Successful login detected: $line"
        # To reset the failure count on successful login
        FAIL_COUNT=0
        exit 0 
    fi

    # To check for failed authentication attempts
    if echo "$line" | grep -q "authentication failure"; then
        ((FAIL_COUNT++))

        # To trigger an alert if the threshold is reached 
        if [ "$FAIL_COUNT" -ge "$THRESHOLD" ]; then
            echo "[ALERT] 3 consecutive login failures detected!"
            TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')

            # To change the directory to where the snapshot will be captured
            cd ./snapshots
            
            # To snap the attacker and send thTimestae outputs
            fswebcam snapshot.jpg > ../logs/fswebcam.log 2>&1
            
            # Function to check internet connectivity in case the system is connected to the internet for the email to send 
            check_internet() {
                ping -c 1 google.com &> /dev/null
                return $?
            }
            
            
            # Once the internet connnection has been established the email is sent to 
		# the owner of the system with the captured image of the attacker. 
             on_internet_connected() {
               (echo "Subject: URGENT SECURITY ALERT"; 
          echo "We have detected 3 consecutive login failures on your system, which indicates an unauthorized access attempt by this attacker. The attacker, whose identity has been attached to the mail, attempted to breach your system at "; 
          echo $TIMESTAMP
                uuencode snapshot.jpg snapshot.jpg) | msmtp okekerichard281@gmail.com
            }

            # Loop to monitor connectivity 
            while true; do
                if check_internet; then
                    on_internet_connected
                    break  # The loop exits after detecting connection
                fi
                sleep 10  # If there is no connection, the check_internet function is called after every 10 seconds
            done



            # To reset the counter after sending an alert
            FAIL_COUNT=0
        fi
    fi
done

