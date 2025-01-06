/*
 * Compile with:
 *   gcc -o check_mouse_usage check_mouse_usage.c -lX11
 *
 * Usage:
 *   ./check_mouse_usage
 * The program returns:
 *   0 if the mouse is set for right-handed usage (first button == 1),
 *   1 if the mouse is set for left-handed usage (first button == 3),
 *   2 otherwise (unrecognized mapping).
 */

#include <stdio.h>
#include <stdlib.h>
#include <X11/Xlib.h>

int main(void)
{
    Display *display;
    unsigned int max_buttons;
    unsigned char map[32];   /* 32 is often enough for typical pointers, 
                                but you can adjust if needed */
    int nbuttons;

    /* Open connection to the X server */
    display = XOpenDisplay(NULL);
    if (!display) {
        fprintf(stderr, "Unable to open display.\n");
        return 2; /* Non-zero indicates an error of some sort */
    }

    /* The maximum number of buttons can be queried, though for most setups
       it will be 3, 5, or maybe 7. We'll just use 32 above to be safe. */
    max_buttons = XGetPointerMapping(display, map, 32);
    if (max_buttons == 0) {
        fprintf(stderr, "XGetPointerMapping returned 0 buttons.\n");
        XCloseDisplay(display);
        return 2;
    }

    /*
     * map[0] holds the logical mapping of the "first button" (physically).
     * By default, for a right-handed setup:
     *   map[0] == 1 (left-button is primary).
     * For a left-handed setup:
     *   map[0] == 3 (right-button becomes the primary).
     */

    if (map[0] == 1) {
        /* Right-handed usage */
        XCloseDisplay(display);
        return 0;
    } else if (map[0] == 3) {
        /* Left-handed usage */
        XCloseDisplay(display);
        return 1;
    } else {
        /* Some other mapping; not just simple left-vs-right inversion. */
        XCloseDisplay(display);
        return 2;
    }
}
