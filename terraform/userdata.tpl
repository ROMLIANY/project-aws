#!/bin/bash
# update and install
yum update -y
yum install -y python3 python3-pip amazon-cloudwatch-agent

# install python dependencies
pip3 install flask pymysql

# create .env
cat <<ENVEOF > /home/ec2-user/.env
DB_HOST=${db_endpoint}
DB_USER=${db_user}
DB_PASS=${db_password}
DB_NAME=${db_name}
ENVEOF

# create app.py
cat <<'APPEOF' > /home/ec2-user/app.py
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
            database=DB_NAME,
            connect_timeout=5
        )
        cursor = conn.cursor()
        cursor.execute("SELECT NOW();")
        result = cursor.fetchone()
        conn.close()
        return f"<h1>Hello from Terraform Web Server!</h1><p>Connected to MySQL.</p><p>DB Time: {result}</p>"
    except Exception as e:
        return f"ERROR connecting to DB: {e}"

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=PORT)
APPEOF

# configure simple CloudWatch agent to send mem metric (so mem_used_percent is available)
cat <<CWEOF > /opt/aws/amazon-cloudwatch-agent/etc/amazon-cloudwatch-agent.json
{
  "metrics": {
    "metrics_collected": {
      "mem": {
        "measurement": [
          {"name": "mem_used_percent", "unit": "Percent"}
        ]
      }
    }
  }
}
CWEOF

amazon-cloudwatch-agent-ctl -a fetch-config -m ec2 -c file:/opt/aws/amazon-cloudwatch-agent/etc/amazon-cloudwatch-agent.json -s

# export env and run app
chown ec2-user:ec2-user /home/ec2-user/app.py /home/ec2-user/.env
chmod 600 /home/ec2-user/.env
cd /home/ec2-user
export $(cat .env | xargs)
nohup python3 /home/ec2-user/app.py --port 5000 > /home/ec2-user/app.log 2>&1 &
