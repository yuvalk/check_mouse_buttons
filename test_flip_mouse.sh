#!/usr/bin/env bash
#
# test_flip_mouse.sh
#
# Automated tests for flip_mouse.sh using different pointer mappings.
#
# Usage:
#   chmod +x test_flip_mouse.sh
#   ./test_flip_mouse.sh
#
# or in CI:
#   xvfb-run --auto-servernum --server-args='-screen 0 1280x1024x24' bash ./test_flip_mouse.sh
#

set -e

# Helper function to get the code for Physical Button 1 using xmodmap.
get_first_button_mapping() {
  xmodmap -pp | awk '$1 == 1 {print $2}'
}

# 1. Right-handed -> Flip -> Should become Left-handed
echo "Test 1: Right-handed -> Flip -> Should become Left-handed"
xmodmap -e "pointer = 1 2 3"
INITIAL=$(get_first_button_mapping)
if [ "$INITIAL" != "1" ]; then
  echo "ERROR: Expected Physical Button 1 to be mapped to 1, got $INITIAL"
  exit 1
fi

./flip_mouse.sh
AFTER_FLIP=$(get_first_button_mapping)
if [ "$AFTER_FLIP" != "3" ]; then
  echo "ERROR: Expected Physical Button 1 to be mapped to 3 after flip, got $AFTER_FLIP"
  exit 1
fi
echo "Test 1 PASSED: Right-handed successfully flipped to Left-handed"
echo

# 2. Left-handed -> Flip -> Should become Right-handed
echo "Test 2: Left-handed -> Flip -> Should become Right-handed"
xmodmap -e "pointer = 3 2 1"
INITIAL=$(get_first_button_mapping)
if [ "$INITIAL" != "3" ]; then
  echo "ERROR: Expected Physical Button 1 to be mapped to 3, got $INITIAL"
  exit 1
fi

./flip_mouse.sh
AFTER_FLIP=$(get_first_button_mapping)
if [ "$AFTER_FLIP" != "1" ]; then
  echo "ERROR: Expected Physical Button 1 to be mapped to 1 after flip, got $AFTER_FLIP"
  exit 1
fi
echo "Test 2 PASSED: Left-handed successfully flipped to Right-handed"
echo

# 3. Unknown -> Flip -> Should remain unknown
echo "Test 3: Unknown -> Flip -> Should remain unknown (and script should return 2)"
xmodmap -e "pointer = 2 1 3"
INITIAL=$(get_first_button_mapping)
if [ "$INITIAL" != "2" ]; then
  echo "ERROR: Expected Physical Button 1 to be mapped to 2, got $INITIAL"
  exit 1
fi

set +e  # allow capturing the return code
./flip_mouse.sh
EXITCODE=$?
set -e

if [ "$EXITCODE" -ne 2 ]; then
  echo "ERROR: flip_mouse.sh was expected to exit with code 2 for unknown mapping, but got $EXITCODE"
  exit 1
fi

AFTER_FLIP=$(get_first_button_mapping)
if [ "$AFTER_FLIP" != "2" ]; then
  echo "ERROR: Expected Physical Button 1 to still be 2, got $AFTER_FLIP"
  exit 1
fi
echo "Test 3 PASSED: Unknown mapping was unchanged, and script exited with code 2"

echo
echo "All tests PASSED!"
exit 0

