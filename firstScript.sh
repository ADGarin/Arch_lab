#!/bin/bash
usage=$(df /home/exlivos/try | awk 'NR==2 {print $5}' | tr -d '%')
echo "Использование: $usage%"
logDir="/home/exlivos/try"
backupDir="/home/exlivos/backup"

read -p "Введите пороговое значение: " border

if [ "$usage" -gt "$border" ]; then
  echo "Использование больше порога ($border%). Архивируем файлы."

  read -p "Введите количество файлов для архивации: " N

  N=${N:-10}
  timestamp=$(date +%Y%m%d_%H%M%S)


  filesToArchive=$(find "$logDir" -path "$logDir/lost+found" -prune -o -type f -printf "%T@ %p\n" 2>/dev/null | sort -n | tail -n "$N" | cut -d' ' -f2-)

  if [ -z "$filesToArchive" ]; then
    echo "Нет файлов для архивирования."
    exit 1
  fi

  echo "$filesToArchive" | tar -czf "$backupDir/backup_$timestamp.tar.gz" -T -

  echo "Удаляем заархивированные файлы..."
  echo "$filesToArchive" | xargs rm -f

  echo "Заархивировано $N файлов из $logDir в $backupDir/backup_$timestamp.tar.gz"
else
  echo "Использование ($usage%) меньше или равно пороговому значению ($border%). Архивировать не нужно."
fi
