FROM python:3.8-slim


RUN mkdir /app
WORKDIR /app

RUN apt-get update && apt-get install --no-install-recommends ffmpeg libsm6 libxext6 -y && \
    rm -rf /var/lib/apt/lists/*
ADD requirements.txt /app/requirements.txt
RUN pip install -r /app/requirements.txt --no-cache-dir

COPY src .


ENV PORT 8000
CMD exec gunicorn --bind 0.0.0.0:$PORT --workers 1 --threads 4 --timeout 0 main:app

