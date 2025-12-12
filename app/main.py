import os
import socket
import psutil
from fastapi import FastAPI, Request
from fastapi.responses import HTMLResponse
from fastapi.templating import Jinja2Templates

app = FastAPI()

# ------------------------------------------------------------------------------
# システム情報取得 (System Info)
# ------------------------------------------------------------------------------
def get_system_info():
    # ホスト名 (Pod Name)
    hostname = socket.gethostname()
    
    # IPアドレス (Pod IP)
    ip_address = socket.gethostbyname(hostname)
    
    # CPU / Memory 使用率
    cpu_usage = psutil.cpu_percent(interval=None)
    memory_info = psutil.virtual_memory()
    
    return {
        "hostname": hostname,
        "ip": ip_address,
        "cpu": cpu_usage,
        "memory": memory_info.percent
    }

# ------------------------------------------------------------------------------
# メインページ (Dashboard)
# ------------------------------------------------------------------------------
@app.get("/", response_class=HTMLResponse)
async def read_root():
    info = get_system_info()
    
    # シンプルなHTMLダッシュボードを返す
    html_content = f"""
    <html>
        <head>
            <title>EKS GitOps Portfolio</title>
            <style>
                body {{ font-family: Arial, sans-serif; text-align: center; padding-top: 50px; background-color: #f0f2f5; }}
                .container {{ background: white; padding: 30px; border-radius: 10px; display: inline-block; box-shadow: 0 4px 8px rgba(0,0,0,0.1); }}
                h1 {{ color: #333; }}
                .info {{ margin: 10px 0; font-size: 18px; }}
                .highlight {{ color: #007bff; font-weight: bold; }}
                .metric {{ margin-top: 20px; font-size: 14px; color: #666; }}
            </style>
        </head>
        <body>
            <div class="container">
                <h1>🚀 Hello from EKS!</h1>
                <p>Traffic is being served by:</p>
                
                <div class="info">Pod Hostname: <span class="highlight">{info['hostname']}</span></div>
                <div class="info">Pod IP Address: <span class="highlight">{info['ip']}</span></div>
                
                <hr>
                
                <div class="metric">
                    <p>CPU Usage: {info['cpu']}%</p>
                    <p>Memory Usage: {info['memory']}%</p>
                </div>
                
                <p style="margin-top: 30px; font-size: 12px;">
                    Refresh this page to see load balancing in action.<br>
                    (ロードバランシングを確認するにはページを更新してください)
                </p>
            </div>
        </body>
    </html>
    """
    return html_content

# ------------------------------------------------------------------------------
# ヘルスチェック (Health Check) - AWS Load Balancer用
# ------------------------------------------------------------------------------
@app.get("/health")
async def health_check():
    return {"status": "healthy"}

