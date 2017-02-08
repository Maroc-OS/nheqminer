#
# Run assembler.
#

FASM ?= $(wildcard $(CURDIR)/fasm)
OBJCONV ?= $(wildcard $(CURDIR)/objconv)

FASMOPT = -m 1920000 -p 8
OBJCONVOPT = -fmacho -nu -xs -v0

ASMDIR = $(wildcard $(CURDIR)/asm)
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
