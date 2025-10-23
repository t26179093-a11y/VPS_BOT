# Verwende das offizielle Python 3.12 Slim-Image
FROM python:3.12-slim

# Installiere notwendige Systempakete
RUN apt-get update && apt-get install -y \
    python3-pip python3-dev git curl sudo openssh-server \
    && rm -rf /var/lib/apt/lists/*

# Erstelle das Arbeitsverzeichnis
WORKDIR /app

# Kopiere die lokalen Dateien in das Container-Dateisystem
COPY . /app

# Installiere die Python-Abhängigkeiten
RUN pip install --no-cache-dir -r requirements.txt

# Konfiguriere den SSH-Server
RUN mkdir /var/run/sshd
RUN echo 'root:rootpassword' | chpasswd
RUN sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN sed -i 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' /etc/pam.d/sshd

# Exponiere den SSH-Port
EXPOSE 22

# Starte den SSH-Server und den Bot
CMD service ssh start && python3 bot.py
