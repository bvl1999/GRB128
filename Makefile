ASMFILES = geosramboot.asm
ACMEFLAGS = -f cbm --initmem 0 --maxdepth 16 -v2 --cpu 6502
TARGET = geosramboot.prg

all: $(TARGET)

geosramboot.prg: $(ASMFILES)
	acme $(ACMEFLAGS) -o geosramboot.prg geosramboot.asm

clean:
	rm -f geosramboot.prg

