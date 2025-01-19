set dotenv-load

default: build

build:
  @echo "Building firmware for Arduino Uno..."
  docker compose run --remove-orphans build zig build

clean:
  @echo "Cleaning build artifacts..."
  rm -rf zig-out

flash-uno:
  @echo "Flashing firmware to Arduino Uno using port $PORT..."
  sudo avrdude -c arduino -P $PORT -b 115200 -p atmega328p -D -U flash:w:zig-out/firmware/arduino-uno.elf:e

term:
  @echo "Starting interactive terminal with Arduino Uno using port $PORT..."
  sudo avrdude -c arduino -P $PORT -p atmega328p -t -v

test:
  @echo "Running tests..."
  docker compose run --remove-orphans build zig build test --summary all
