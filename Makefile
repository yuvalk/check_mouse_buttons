CC      = gcc
CFLAGS  = -Wall -Wextra -O2
LDLIBS  = -lX11

all: check_mouse_buttons

check_mouse_buttons: check_mouse_buttons.o
	$(CC) $(CFLAGS) -o check_mouse_buttons check_mouse_buttons.o $(LDLIBS)

check_mouse_buttons.o: check_mouse_buttons.c
	$(CC) $(CFLAGS) -c check_mouse_buttons.c

clean:
	rm -f check_mouse_buttons check_mouse_buttons.o
