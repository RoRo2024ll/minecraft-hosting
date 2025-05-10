import os
import subprocess
from flask import Flask, request, render_template_string

app = Flask(__name__)

# Minecraft server folder path
MINECRAFT_SERVER_PATH = '/path/to/your/minecraft/server'

# Home page
@app.route('/')
def home():
    return render_template_string("""
    <h1>Minecraft Server Hosting</h1>
    <form action="/start_server" method="post">
        <button type="submit">Start Minecraft Server</button>
    </form>
    <form action="/stop_server" method="post">
        <button type="submit">Stop Minecraft Server</button>
    </form>
    """)

# Start Minecraft server
@app.route('/start_server', methods=['POST'])
def start_server():
    try:
        # Run the Minecraft server in a subprocess
        subprocess.Popen(['java', '-Xmx1024M', '-Xms1024M', '-jar', 'server.jar', 'nogui'], cwd=MINECRAFT_SERVER_PATH)
        return "Minecraft server is starting..."
    except Exception as e:
        return f"Error starting the server: {e}"

# Stop Minecraft server
@app.route('/stop_server', methods=['POST'])
def stop_server():
    try:
        # Kill the Minecraft server process
        subprocess.run(['pkill', '-f', 'server.jar'])
        return "Minecraft server has been stopped."
    except Exception as e:
        return f"Error stopping the server: {e}"

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=True)
