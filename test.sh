#!/usr/bin/env bash
# A simple test script for check_mouse_buttons.
# It sets different pointer mappings and checks the exit code from check_mouse_buttons.

set -e  # Exit on any error

echo "Setting pointer = 1 2 3 (Right-handed usage)"
xmodmap -e "pointer = 1 2 3"
RETVAL=$(./check_mouse_buttons)
if [ "$RETVAL" -ne 0 ]; then
  echo "TEST FAILED: Expected 0 (right-handed), got $RETVAL"
  exit 1
fi
echo "Right-handed usage test: PASSED"

echo "Setting pointer = 3 2 1 (Left-handed usage)"
xmodmap -e "pointer = 3 2 1"
RETVAL=$(./check_mouse_buttons)
if [ "$RETVAL" -ne 1 ]; then
  echo "TEST FAILED: Expected 1 (left-handed), got $RETVAL"
  exit 1
fi
echo "Left-handed usage test: PASSED"

echo "Setting pointer = 2 1 3 (Unknown usage)"
xmodmap -e "pointer = 2 1 3"
RETVAL=$(./check_mouse_buttons)
if [ "$RETVAL" -ne 2 ]; then
  echo "TEST FAILED: Expected 2 (unknown), got $RETVAL"
  exit 1
fi
echo "Unknown usage test: PASSED"

echo "All tests passed successfully!"

