set dotenv-load

default: build

build:
  @echo "Building firmware for Arduino Uno..."
  docker compose run --remove-orphans build zig build

flash-uno:
  @echo "Flashing firmware to Arduino Uno using port $PORT..."
  sudo avrdude -c arduino -P $PORT -b 115200 -p atmega328p -D -U flash:w:zig-out/firmware/arduino-uno.elf:e