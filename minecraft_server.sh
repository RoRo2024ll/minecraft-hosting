#!/bin/bash

# 설정
PAPER_VERSION="1.21.4"
PAPER_BUILD="latest"
PAPER_JAR="paper-${PAPER_VERSION}.jar"
PAPER_API_URL="https://api.papermc.io/v2/projects/paper/versions/${PAPER_VERSION}/${PAPER_BUILD}/downloads/paper-${PAPER_VERSION}.jar"

# Java 버전 확인 (17 이상이어야 함)
JAVA_VER=$(java -version 2>&1 | awk -F '"' '/version/ {print $2}' | awk -F '.' '{print $1}')
if [ "$JAVA_VER" -lt 17 ]; then
  echo "❌ Java 17 이상이 필요합니다. 현재 버전: $JAVA_VER"
  exit 1
fi

# paper.jar 파일 없으면 다운로드
if [ ! -f "$PAPER_JAR" ]; then
  echo "📥 Paper ${PAPER_VERSION} 다운로드 중..."
  curl -o "$PAPER_JAR" "$PAPER_API_URL"
fi

# EULA 동의
if [ ! -f eula.txt ]; then
  echo "eula=true" > eula.txt
  echo "✅ EULA 동의 완료"
fi

# server.properties 포트 설정
if [ -f server.properties ]; then
  sed -i "s/^server-port=.*/server-port=25565/" server.properties
else
  echo "server-port=25565" > server.properties
fi

# 서버 실행
echo "🚀 Paper 서버 시작 (버전 ${PAPER_VERSION}, 포트 25565)..."
java -Xmx1024M -Xms1024M -jar "$PAPER_JAR" nogui
