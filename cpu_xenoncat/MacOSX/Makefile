#
# Run assembler.
#

CUR ?= $(wildcard $(CURDIR))
FASM ?= $(wildcard $(CUR)/fasm)
OBJCONV ?= $(wildcard $(CUR)/objconv)

FASMOPT = -m 1920000 -p 8
OBJCONVOPT = -fmacho -nu -xs -v0

ASMDIR ?= $(wildcard $(CUR)/asm)
SOURCEFILES = $(wildcard $(ASMDIR)/*.asm) $(wildcard $(ASMDIR)/*.inc)

all: equihash_avx1_obj.o equihash_avx1.o equihash_avx2_obj.o equihash_avx2.o

equihash_avx1_obj.o: $(SOURCEFILES)
	$(FASM) $(FASMOPT) $(ASMDIR)/equihash_avx1.asm $(ASMDIR)/$@

equihash_avx1.o: $(ASMDIR)/equihash_avx1_obj.o
	$(OBJCONV) $(OBJCONVOPT) $(ASMDIR)/equihash_avx1_obj.o $@

equihash_avx2_obj.o: $(SOURCEFILES)
	$(FASM) $(FASMOPT) $(ASMDIR)/equihash_avx2.asm $(ASMDIR)/$@

equihash_avx2.o: $(ASMDIR)/equihash_avx2_obj.o
	$(OBJCONV) $(OBJCONVOPT) $(ASMDIR)/equihash_avx2_obj.o $@

clean:
	$(RM) *.o

.PHONY: all clean
