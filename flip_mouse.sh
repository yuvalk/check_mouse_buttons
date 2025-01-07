#!/usr/bin/env bash
#
# flip_mouse.sh
#
# Uses the check_mouse_buttons utility to determine if the mouse is set
# to right-handed (returns 0) or left-handed (returns 1). It then flips
# the mapping using xmodmap.
#
# Return values of check_mouse_buttons:
#   0 => Right-handed (first button == 1)
#   1 => Left-handed  (first button == 3)
#   2 => Unknown mapping
#
# Requirements:
#   - The check_mouse_buttons binary is in the same directory or in $PATH
#   - xmodmap must be installed (e.g., via "sudo apt-get install x11-xserver-utils")
#   - An active X session is required for xmodmap to work


# Call the utility to get the current mouse usage
set +e
./check_mouse_buttons
RETVAL=$?
set -e
echo $RETVAL

case "$RETVAL" in
  0)
    echo "Currently right-handed (returns $RETVAL). Flipping to left-handed..."
    # Flip from right (pointer = 1 2 3) to left (pointer = 3 2 1)
    xmodmap -e "pointer = 3 2 1"
    ;;

  1)
    echo "Currently left-handed (returns $RETVAL). Flipping to right-handed..."
    # Flip from left (pointer = 3 2 1) to right (pointer = 1 2 3)
    xmodmap -e "pointer = 1 2 3"
    ;;

  2)
    echo "Unknown or custom mapping detected (returns $RETVAL). No changes made."
    exit 2
    ;;

  *)
    echo "Unexpected return value: $RETVAL"
    exit 2
    ;;
esac

exit 0
