.SUFFIXES:

ifeq ($(strip $(DEVKITSH4)),)
$(error "Please set DEVKITSH4 in your environment. export DEVKITSH4=<path to sdk>")
endif
include $(DEVKITSH4)/exword_rules

TARGET       := nyear
SOURCEDIR    := src
HTMLDIR      := html
MODNAME      := newyear
APPTITLE     := Happy New Year
APPID        := NYEAR  # Must be 5 characters long
APPMOD       := $(TARGET).d01
BUILDS       := ja cn

EXCLUDE      :=
CFILES       := $(filter-out $(EXCLUDE),$(wildcard $(SOURCEDIR)/*.c)) $(wildcard $(SOURCEDIR)/libc/*.c)
SFILES       := $(wildcard $(SOURCEDIR)/*.s) $(wildcard $(SOURCEDIR)/libc/*.s)
HTMLINFILES  := $(foreach dir,$(BUILDS),$(wildcard $(HTMLDIR)/$(dir)/*.in))

OBJECTS      := $(CFILES:.c=.o) $(SFILES:.s=.o)
HTML         := $(HTMLINFILES:.htm.in=.htm)

CC_OPTS      :=
LDFLAGS      := -nostdlib -L$(DEVKITPRO)/libdataplus/lib -ldataplus -lgraphics -lsh4a
CFLAGS       := -fno-builtin -I$(DEVKITPRO)/libdataplus/include -I$(SOURCEDIR) -I$(SOURCEDIR)/libc/include -O3 $(CC_OPTS)
ASFLAGS      := -m4-nofpu

app: $(addprefix build/,$(addsuffix /$(APPID),$(BUILDS)))

build/%/$(APPID): $(TARGET).d01 $(HTML)
	@echo building $* version in $@...
	@mkdir -p $@
	@cp $(TARGET).d01 $@
	@cp html/$*/*.htm $@
	@touch $@/fileinfo.cji

$(TARGET).elf: $(OBJECTS)

%.htm: %.htm.in
	@echo building html $@...
	@sed -e 's/@APPTITLE/$(APPTITLE)/g' -e 's/@APPID/$(APPID)/g' -e 's/@APPMOD/$(APPMOD)/g' $< > $@

clean:
	@echo clean ...
	@rm -fr build $(HTML) $(OBJECTS) $(TARGET).elf $(TARGET).d01 *.map
