#!/bin/bash

#sudo 패스워드를 생략하는 코드
#echo 'root비밀번호' | sudo -kS docker

# KST 시간대 출력
echo_ct_kst() {
    echo "TIME: $(TZ='Asia/Seoul' date +'%y-%m-%d-%H-%M-%S')"
}

# 팰월드 서버 도커 컨테이너에 올리고 시작
start_palworld() {
    echo "Starting Palworld Server..."
    echo_ct_kst
    sudo docker start palworld-server
    sleep 15
    echo "Palworld Server start successfully."
}

# 팰월드 도커 컨테이너 서버 종료
stop_palworld() {
    echo "Stopping Palworld Server..."
    echo_ct_kst
    sudo docker exec -i palworld-server rcon-cli save
    sleep 10
    echo "World save complete."
    sudo docker exec -i palworld-server rcon-cli shutdown
    echo "Server will shut down after 30 seconds."
    sleep 31
    sudo docker stop palworld-server
    echo "Palworld Server stop successfully."
}

# 재시작하면서 월드 백업
restart_palworld() {
    echo "Restarting Palworld Server..."
    echo_ct_kst
    sudo docker exec -i palworld-server rcon-cli "broadcast Server_will_restart_now."
    sleep 5
    sudo docker exec -i palworld-server rcon-cli save
    sleep 10
    echo "World save complete."
    sudo docker exec -i palworld-server rcon-cli shutdown
    echo "Server will shut down after 30 seconds."
    sleep 31
    sudo docker stop palworld-server
    echo "Palworld Server stopped."
    sleep 10
    echo "Archiving Palworld Server save files..."
    sleep 5
    TIMESTAMP=$(TZ='Asia/Seoul' date +'%y-%m-%d-%H-%M-%S')
    cd /home/user/Server/PalWorld/serverfile/palworld/Pal && zip -r /home/user/Server/PalWorld/backups/${TIMESTAMP}-palworld-saved.zip Saved/
    echo "Archiving Completed."
    sleep 5
    echo "Starting Palworld Server..."
    sudo docker start palworld-server
    sleep 15
    echo "Palworld Server Restart successfully."
}

# 팰월드 서버 세이브파일 백업업
backup_palworld() {
    echo_ct_kst
    echo "Archiving Palworld Server save files..."
    sleep 5
    TIMESTAMP=$(TZ='Asia/Seoul' date +'%y-%m-%d-%H-%M-%S')
    cd /home/user/Server/PalWorld/serverfile/palworld/Pal && zip -r /home/user/Server/PalWorld/backups/${TIMESTAMP}-palworld-saved.zip Saved/
    echo "Archiving Completed."

}

# 현재 하드웨어 메모리를 체크후(가상메모리 제외) 사용률이 80%를 초과하면 서버에 알림 전송후 20분뒤 재시작 및 세이브파일 백업
check_palworld() {
    echo "Checking memory usage..."
    echo 'shaki1012!' | sudo -kS docker exec -i palworld-server rcon-cli "broadcast Checking_Server_Status...."
    sleep 5
    echo_ct_kst
    MEMORY_USAGE=$(awk '/MemTotal/{total=$2}/MemAvailable/{available=$2} END {printf "%d", (total-available)/total*100}' /proc/meminfo)% 
    MEMORY_USAGE=${MEMORY_USAGE%\%}
    echo "memory: $MEMORY_USAGE"
    # Calculate used memory as percentage of total
    if [ $MEMORY_USAGE -gt 70 ]; then
        echo "Out of Memory! reset protocol active"
        echo_ct_kst
        sleep 10	
        sudo docker exec -i palworld-server rcon-cli "broadcast Server_Status_Bad."
        sleep 3	
        sudo docker exec -i palworld-server rcon-cli "broadcast Restart_Protocol_Active."
        sleep 3
        sudo docker exec -i palworld-server rcon-cli save
        sleep 3
        sudo docker exec -i palworld-server rcon-cli "broadcast Server_restart_after_20_min."
        sleep 300
        sudo docker exec -i palworld-server rcon-cli "broadcast Server_restart_after_15_min."
        sleep 300
        sudo docker exec -i palworld-server rcon-cli "broadcast Server_restart_after_10_min."
        sleep 300
        sudo docker exec -i palworld-server rcon-cli "broadcast Server_restart_after_5_min."
        sleep 240
        sudo docker exec -i palworld-server rcon-cli "broadcast Server_restart_after_1_min."
        sleep 10
        sudo docker exec -i palworld-server rcon-cli save
        sleep 20
        sudo docker exec -i palworld-server rcon-cli shutdown
        echo "Server will shut down in 30 seconds."
        sleep 31
        sudo docker stop palworld-server
        echo "palworld-server stopped!!"
        echo_ct_kst
        sleep 10
        echo "Backup starting..."
        echo_ct_kst
        sleep 5
        TIMESTAMP=$(TZ='Asia/Seoul' date +'%y-%m-%d-%H-%M-%S')
        cd /home/user/Server/PalWorld/serverfile/palworld/Pal && zip -r /home/user/Server/PalWorld/backups/${TIMESTAMP}-palworld-saved.zip Saved/
        echo "Backup and Compression completed!!"
        echo_ct_kst
        sleep 5
        echo "Starting palworld-server..."
        echo_ct_kst
        sudo docker start palworld-server
        sleep 15
        echo "palworld-server started!!"
        echo_ct_kst
        sleep 120
        sudo docker exec -i palworld-server rcon-cli save
    else
        echo "Server status good"
        sudo docker exec -i palworld-server rcon-cli "broadcast Server_Status_Good."
    fi
    echo_ct_kst
}


# Main logic to call functions based on passed argument
case "$1" in
    start)
        start_palworld
        ;;
    stop)
        stop_palworld
        ;;
    restart)
        restart_palworld
        ;;
    backup)
        backup_palworld
        ;;
    check)
        check_palworld
        ;;
    *)
        echo "Unknown Command. select this one: $0 {start|stop|restart|backup|check}"
        exit 1
        ;;
esac

