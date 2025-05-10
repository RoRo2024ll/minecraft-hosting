from flask import Flask, request, redirect, render_template_string
import subprocess
import os

app = Flask(__name__)

# 비밀번호 설정
PASSWORD = "1029"

# 서버 실행 함수
def start_server():
    if not is_server_running():
        subprocess.Popen(["java", "-Xmx1024M", "-Xms1024M", "-jar", "minecraft_server.jar", "nogui"])
        return True
    return False

# 서버 중지 함수
def stop_server():
    if is_server_running():
        subprocess.Popen(["pkill", "java"])
        return True
    return False

# 서버 상태 체크 함수
def is_server_running():
    result = subprocess.run(["pgrep", "-f", "minecraft_server.jar"], stdout=subprocess.PIPE)
    return len(result.stdout) > 0

# 홈페이지 라우팅
@app.route("/", methods=["GET", "POST"])
def index():
    if request.method == "POST":
        password = request.form.get("password")
        if password != PASSWORD:
            return "잘못된 비밀번호입니다.", 403

        action = request.form.get("action")
        if action == "start":
            if start_server():
                return "서버가 시작되었습니다!"
            else:
                return "서버가 이미 실행 중입니다."
        elif action == "stop":
            if stop_server():
                return "서버가 중지되었습니다!"
            else:
                return "서버가 실행 중이지 않습니다."

    return render_template_string("""
    <html>
        <body>
            <h1>마인크래프트 서버</h1>
            <form method="POST">
                <label for="password">비밀번호:</label>
                <input type="password" id="password" name="password">
                <button type="submit" name="action" value="start">서버 시작</button>
                <button type="submit" name="action" value="stop">서버 중지</button>
            </form>
        </body>
    </html>
    """)

if __name__ == "__main__":
    app.run(debug=True, host="0.0.0.0", port=5000)
