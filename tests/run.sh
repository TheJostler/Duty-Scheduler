#!/usr/bin/env bash
set -u

root=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
make -C "$root" scheduler >/dev/null

failures=0
for case_dir in "$root"/tests/cases/*/; do
  case_name=$(basename "$case_dir")
  work_dir=$(mktemp -d)
  cp -r "$case_dir." "$work_dir"/
  cp "$root/scheduler" "$work_dir"/

  readarray -t case_args < <(xargs -n1 < "$work_dir/args")
  (cd "$work_dir" && ./scheduler "${case_args[@]}" >actual.out 2>&1; echo $? >actual.status)

  report=$(mktemp)
  case_passed=1

  diff -u "$work_dir/expected.out" "$work_dir/actual.out" >>"$report" || case_passed=0

  expected_status=$(cat "$work_dir/expected.status")
  actual_status=$(cat "$work_dir/actual.status")
  if [ "$expected_status" != "$actual_status" ]; then
    echo "exit status: expected $expected_status, got $actual_status" >>"$report"
    case_passed=0
  fi

  if [ -f "$work_dir/expected.csv" ]; then
    diff -u "$work_dir/expected.csv" "$work_dir/schedule.csv" >>"$report" || case_passed=0
  fi

  if [ -f "$work_dir/expected.grid" ]; then
    diff -u "$work_dir/expected.grid" "$work_dir/availability.csv" >>"$report" || case_passed=0
  fi

  if [ "$case_passed" -eq 1 ]; then
    echo "PASS $case_name"
  else
    echo "FAIL $case_name"
    cat "$report"
    failures=1
  fi

  rm -f "$report"
  rm -rf "$work_dir"
done

exit "$failures"
