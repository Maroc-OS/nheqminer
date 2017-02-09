#
# Run assembler.
#

CUR ?= $(wildcard $(CURDIR))
FASM ?= $(wildcard $(CUR)/fasm)
FASMOPT ?= -m 1920000 -p 8

ASMDIR ?= $(wildcard $(CUR))
SOURCEFILES = $(wildcard $(ASMDIR)/*.asm) $(wildcard $(ASMDIR)/*.inc)

all: equihash_avx1.o equihash_avx2.o

equihash_avx1.o: $(SOURCEFILES)
	$(FASM) $(FASMOPT) $(ASMDIR)/equihash_avx1.asm $@

equihash_avx2.o: $(SOURCEFILES)
	$(FASM) $(FASMOPT) $(ASMDIR)/equihash_avx2.asm $@

clean:
	$(RM) *.o

.PHONY: all clean
