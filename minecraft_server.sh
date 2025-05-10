#!/bin/bash

# 서버 시작 함수
start_server() {
    if ! pgrep -f "minecraft_server.jar" > /dev/null; then
        echo "Starting Minecraft server..."
        java -Xmx1024M -Xms1024M -jar minecraft_server.jar nogui &
        echo "Minecraft server started!"
    else
        echo "Minecraft server is already running."
    fi
}

# 서버 중지 함수
stop_server() {
    if pgrep -f "minecraft_server.jar" > /dev/null; then
        echo "Stopping Minecraft server..."
        pkill -f "minecraft_server.jar"
        echo "Minecraft server stopped!"
    else
        echo "Minecraft server is not running."
    fi
}

case "$1" in
    start)
        start_server
        ;;
    stop)
        stop_server
        ;;
    *)
        echo "Usage: $0 {start|stop}"
        exit 1
        ;;
esac
