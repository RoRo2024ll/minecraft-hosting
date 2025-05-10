#!/bin/bash

# 원하는 마인크래프트 버전
MINECRAFT_VERSION="1.21.4"
JAR_URL="https://piston-data.mojang.com/v1/objects/3275a4a3c3b1980f2b5ed1040b7710e79fc9e63b/server.jar"

# Java 버전 확인 (17 이상이어야 함)
JAVA_VER=$(java -version 2>&1 | awk -F '"' '/version/ {print $2}' | awk -F '.' '{print $1}')
if [ "$JAVA_VER" -lt 17 ]; then
  echo "❌ Java 17 이상이 필요합니다. 현재 버전: $JAVA_VER"
  exit 1
fi

# server.jar 파일 없으면 다운로드
if [ ! -f server.jar ]; then
  echo "📥 server.jar 다운로드 중..."
  curl -o server.jar "$JAR_URL"
fi

# eula 동의
if [ ! -f eula.txt ]; then
  echo "eula=true" > eula.txt
  echo "✅ EULA 동의 완료"
fi

# 서버 실행
echo "🚀 마인크래프트 서버 시작 (버전 $MINECRAFT_VERSION)..."
java -Xmx1024M -Xms1024M -jar server.jar nogui
