# Stage 1 — Build stage
FROM python:3.11-slim AS builder

WORKDIR /app

COPY requirements.txt .

RUN pip install --no-cache-dir --prefix=/install -r requirements.txt


# Stage 2 — Run stage
FROM python:3.11-slim

WORKDIR /app

COPY --from=builder /install /usr/local

COPY . .

EXPOSE 5000

CMD ["python", "-m", "flask", "--app", "app", "run", "--host=0.0.0.0", "--port=5000"]