#!/bin/bash
LOGFILE=~/server.log

send_telegram() {
    TOKEN="BOT_TOKEN"
    CHAT_ID="CHAT_ID"
    MSG="$1"
    curl -s -X POST https://api.telegram.org/bot$TOKEN/sendMessage \
         -d chat_id=$CHAT_ID -d text="$MSG"
}

log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') $1" | tee -a $LOGFILE
}

alert_if_down() {
    local name=$1
    local port=$2
    if nc -z localhost $port >/dev/null 2>&1; then
        log "[✓] $name is running on port $port"
    else
        log "[✗] $name is NOT running"
        send_telegram "⚠️ ALERT: $name service is DOWN at $(date)"
    fi
}

status_services() {
    log "=== Checking Services ==="
    alert_if_down "Hadoop NameNode" 9870
    alert_if_down "Hadoop YARN" 8088
    alert_if_down "Spark Master" 8080
    if pgrep -f "org.apache.spark.deploy.worker.Worker" >/dev/null; then
        log "[✓] Spark Worker is running"
    else
        log "[✗] Spark Worker is NOT running"
        send_telegram "⚠️ ALERT: Spark Worker is DOWN at $(date)"
    fi
    alert_if_down "Neo4j Browser" 7474
    log "========================="
}

case "$1" in
    start)   log "Starting services..." ;;
    stop)    log "Stopping services..." ;;
    restart) log "Restarting services..." ;;
    status)  status_services ;;
    *) echo "Usage: $0 {start|stop|restart|status}" ;;
esac
