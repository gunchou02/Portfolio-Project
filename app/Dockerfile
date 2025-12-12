# ------------------------------------------------------------------------------
# Base Image: Python 3.9 Slim (軽量化バージョン)
# ------------------------------------------------------------------------------
FROM python:3.9-slim

# 作業ディレクトリ設定
WORKDIR /app

# 依存パッケージのインストール
# キャッシュを活用するために requirements.txt を先にコピー
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# ソースコードのコピー
COPY . .

# セキュリティ対策: Root権限ではなく一般ユーザーで実行する
# (Security Best Practice: Run as non-root user)
RUN useradd -m appuser
USER appuser

# ポート公開
EXPOSE 8000

# アプリケーション起動
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]
