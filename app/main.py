import os
import socket
import psutil
from fastapi import FastAPI
from fastapi.responses import HTMLResponse

app = FastAPI()

# ------------------------------------------------------------------------------
# システム情報取得 (System Info)
# ------------------------------------------------------------------------------
def get_system_info():
    hostname = socket.gethostname()
    try:
        ip_address = socket.gethostbyname(hostname)
    except:
        ip_address = "127.0.0.1"
    
    cpu_usage = psutil.cpu_percent(interval=None)
    memory_info = psutil.virtual_memory()
    
    return {
        "hostname": hostname,
        "ip": ip_address,
        "cpu": cpu_usage,
        "memory": memory_info.percent
    }

# ------------------------------------------------------------------------------
# メインページ (Dashboard UI)
# ------------------------------------------------------------------------------
@app.get("/", response_class=HTMLResponse)
async def read_root():
    info = get_system_info()
    
    # CSS: モダンなカードデザインとレスポンシブ対応
    html_content = f"""
    <!DOCTYPE html>
    <html lang="ja">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Infrastructure Status</title>
        <style>
            :root {{
                --bg-color: #f4f7f6;
                --card-bg: #ffffff;
                --primary-color: #5835CC; /* Terraform Purple */
                --text-main: #2d3748;
                --text-sub: #718096;
                --success: #48bb78;
            }}
            body {{
                font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
                background-color: var(--bg-color);
                color: var(--text-main);
                display: flex;
                justify-content: center;
                align-items: center;
                min-height: 100vh;
                margin: 0;
            }}
            .dashboard-card {{
                background: var(--card-bg);
                width: 400px;
                padding: 40px;
                border-radius: 16px;
                box-shadow: 0 10px 25px rgba(0,0,0,0.05);
                text-align: center;
            }}
            .status-badge {{
                background-color: #e6fffa;
                color: var(--success);
                padding: 5px 12px;
                border-radius: 20px;
                font-size: 0.85rem;
                font-weight: 600;
                display: inline-block;
                margin-bottom: 20px;
                border: 1px solid #b2f5ea;
            }}
            h1 {{
                font-size: 1.5rem;
                margin-bottom: 10px;
                color: #1a202c;
            }}
            .subtitle {{
                color: var(--text-sub);
                font-size: 0.9rem;
                margin-bottom: 30px;
            }}
            .info-grid {{
                display: grid;
                grid-template-columns: 1fr;
                gap: 15px;
                text-align: left;
            }}
            .info-item {{
                background: #f7fafc;
                padding: 15px;
                border-radius: 8px;
                border-left: 4px solid var(--primary-color);
            }}
            .info-label {{
                font-size: 0.75rem;
                color: var(--text-sub);
                text-transform: uppercase;
                letter-spacing: 0.5px;
                margin-bottom: 4px;
                display: block;
            }}
            .info-value {{
                font-size: 1.1rem;
                font-weight: 600;
                color: #2d3748;
            }}
            .metrics {{
                margin-top: 25px;
                display: flex;
                justify-content: space-between;
                gap: 10px;
            }}
            .metric-box {{
                flex: 1;
                background: #ebf4ff;
                padding: 10px;
                border-radius: 8px;
                color: #4299e1;
            }}
            .refresh-note {{
                margin-top: 30px;
                font-size: 0.8rem;
                color: #a0aec0;
            }}
        </style>
    </head>
    <body>
        <div class="dashboard-card">
            <div class="status-badge">● System Operational</div>
            <h1>EKS GitOps Demo</h1>
            <p class="subtitle">Managed by Terraform & ArgoCD</p>
            
            <div class="info-grid">
                <div class="info-item">
                    <span class="info-label">Pod Hostname</span>
                    <div class="info-value">{info['hostname']}</div>
                </div>
                <div class="info-item">
                    <span class="info-label">Pod IP Address</span>
                    <div class="info-value">{info['ip']}</div>
                </div>
            </div>

            <div class="metrics">
                <div class="metric-box">
                    <span class="info-label" style="color:#4299e1">CPU Load</span>
                    <div class="info-value">{info['cpu']}%</div>
                </div>
                <div class="metric-box">
                    <span class="info-label" style="color:#4299e1">Memory</span>
                    <div class="info-value">{info['memory']}%</div>
                </div>
            </div>

            <p class="refresh-note">
                Refresh to test Load Balancing<br>
                (ページを更新してロードバランシングを確認)
            </p>
        </div>
    </body>
    </html>
    """
    return html_content

@app.get("/health")
async def health_check():
    return {"status": "healthy"}