# ----------------------------------------
FROM python:3.11-slim AS builder

WORKDIR /usr/src/app

# 依存関係をインストールする前に、requirements.txtのみをコピー
COPY requirements.txt .

RUN pip install --no-cache-dir -r requirements.txt

# ----------------------------------------
FROM python:3.11-slim

WORKDIR /usr/src/app

# 依存関係（site-packages）をコピー。バージョンは維持。
COPY --from=builder /usr/local/lib/python3.11/site-packages /usr/local/lib/python3.11/site-packages

# アプリケーションのコードのみをコピー。
# ここで「.dockerignore」が最も大きな効果を発揮します。
COPY . .

EXPOSE 8000

# 実行コマンドは、互換性と信頼性が高い「python -u -m uvicorn」形式に維持
CMD ["python", "-u", "-m", "uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8000"]
