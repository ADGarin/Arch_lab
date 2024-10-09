#!/bin/bash

TEST_DIR="/home/exlivos/try"
BACKUP_DIR="/home/exlivos/backup"


rm -rf "$TEST_DIR"/*
rm -rf "$BACKUP_DIR"/*

generate_test_data() {
  local size=$1
  local file_count=$2
  mkdir -p "$TEST_DIR"
  for i in $(seq 1 $file_count); do
    dd if=/dev/urandom of="$TEST_DIR/file$i" bs=1M count=$((size / file_count)) 2>dev>null 
  done
}


run_test() {
  local test_name=$1
  local threshold=$2
  local expected_result=$3
  local N=$4

  echo "=== Запуск теста: $test_name ==="
  generate_test_data 512 512
  ./firstScript.sh <<EOF
$threshold
$N
EOF


  if [ "$expected_result" == "archive" ]; then
    if [ -n "$(ls -A $BACKUP_DIR)" ]; then
      echo "Тест $test_name пройден: файлы были архивированы."
    else
      echo "Тест $test_name провален: файлы не были архивированы."
    fi
  elif [ "$expected_result" == "no_archive" ]; then
    if [ -z "$(ls -A $BACKUP_DIR)" ]; then
      echo "Тест $test_name пройден: файлы не были архивированы."
    else
      echo "Тест $test_name провален: файлы были архивированы, хотя не должны были."
    fi
  fi


  rm -rf "$TEST_DIR"/*
  rm -rf "$BACKUP_DIR"/*
}

run_test "Тест 1" 60 "archive" 10

run_test "Тест 2" 50 "archive" 10

run_test "Тест 3" 80 "no_archive" 10

run_test "Тест 4" 80 "no_archive" 10

echo "Тестирование завершено."
