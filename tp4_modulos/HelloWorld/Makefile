CC := gcc
CFLAGS := -Wall -Wextra -O2
TARGET := helloworld
PREFIX := /usr/local

all: $(TARGET)

$(TARGET): helloworld.c
	$(CC) $(CFLAGS) -o $@ $<

# Esta es la regla que le faltaba a checkinstall
install: $(TARGET)
	install -D -m 755 $(TARGET) $(DESTDIR)$(PREFIX)/bin/$(TARGET)

clean:
	rm -f $(TARGET)