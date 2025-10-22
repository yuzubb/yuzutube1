# ----------------------------------------
FROM python:3.11-alpine AS builder

# 必要なビルド依存関係（gcc, libc-devなど）をインストール
# これらはpip install時にC拡張をビルドするために必要
RUN apk add --no-cache gcc musl-dev

WORKDIR /usr/src/app

COPY requirements.txt .

# ビルド依存関係をインストール
# --no-cache-dirはそのまま
RUN pip install --no-cache-dir -r requirements.txt

# ビルド依存関係を削除してイメージサイズを削減
RUN apk del gcc musl-dev

# ----------------------------------------
FROM python:3.11-alpine

# Alpineベースではsite-packagesのパスが異なるため修正
COPY --from=builder /usr/local/lib/python3.11/site-packages /usr/local/lib/python3.11/site-packages

WORKDIR /usr/src/app

# アプリケーションコードをコピー
COPY . .

EXPOSE 8000

# 実行コマンドは互換性の高い形式を維持
CMD ["python", "-u", "-m", "uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8000"]
