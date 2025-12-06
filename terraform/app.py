import os
import pymysql
from flask import Flask
import sys

app = Flask(__name__)

DB_HOST = os.getenv("DB_HOST")
DB_USER = os.getenv("DB_USER")
DB_PASS = os.getenv("DB_PASS")
DB_NAME = os.getenv("DB_NAME")

PORT = 5000
if len(sys.argv) > 1:
    try:
        PORT = int(sys.argv[1].replace("--port", ""))
    except:
        pass

@app.route("/")
def index():
    try:
        conn = pymysql.connect(
            host=DB_HOST,
            user=DB_USER,
            password=DB_PASS,
            database=DB_NAME
        )
        cursor = conn.cursor()
        cursor.execute("SELECT NOW();")
        result = cursor.fetchone()
        conn.close()
        return f"<h1>Hello from Terraform Web Server!</h1><p>Connected successfully to MySQL!</p><p>Current DB Time: {result}</p>"
    except Exception as e:
        return f"ERROR connecting to DB: {e}"

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=PORT)
