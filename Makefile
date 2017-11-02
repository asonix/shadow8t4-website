CC=elm-make
CFLAGS= --warn --output assets/javascripts/main.js
DEBUGFLAGS= --debug

all:
	$(CC) $(CFLAGS) src/Main.elm

debug:
	$(CC) $(CFLAGS) $(DEBUGFLAGS) src/Main.elm
