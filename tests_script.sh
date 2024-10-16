#!/bin/bash

# Путь к скрипту
SCRIPT_PATH="./archive_shell-script.sh"

# Функция для тестирования
run_test() {
  expected_output="$1"
  shift
  output="$("$SCRIPT_PATH" "$@" 2>&1)"
  if [[ "$output" == *"$expected_output"* ]]; then
    echo "Test passed: $expected_output"
  else
    echo "Test failed: Expected '$expected_output' but got '$output'"
  fi
}

# Тест 1: Ничего не передано
run_test "Error: The input is not a folder" ""

# Тест 2: Неправильный путь
run_test "Can't turn into" "/invalid/path" "50" "5"

# Тест 3: Неправильный процент
run_test "Error: The percent is not in input" "/tmp" "" "5"

# Тест 4: Неправильный count
run_test "Error: The count is not in input" "/tmp" "50" ""

# Тест 5: Достаточно свободного места (папка существует)
run_test "No archiving needed." "/tmp/test_folder" "10" "1"
