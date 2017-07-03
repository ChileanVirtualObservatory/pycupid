current_dir := $(shell pwd)
starlink_dir := $(current_dir)/pycupid/star

unexport STARLINK
unexport INSTALL
export STARCONF_DEFAULT_PREFIX := $(starlink_dir)
export STARCONF_DEFAULT_STARLINK := $(starlink_dir)
export PATH := $(starlink_dir)/bin:$(starlink_dir)/buildsupport/bin:$(PATH)
export FC := gfortran
export F77 := gfortran

PYTHONS =2.7 3.4 3.5 3.6
DIST =$(shell uname )

ifeq ($(DIST), Linux)
	PLATAFORM = manylinux1_x86_64
else
	PLATAFORM = TMP
endif

all: buildcupid

upload_wheels: build_wheels
	twine upload dist/* 

build_wheels: clean $(PYTHONS)

$(PYTHONS): %:
	./build_wheel.sh $@ $(PLATAFORM)

.PHONY: buildcupid
buildcupid: $(starlink_dir)/bin/cupid

.PHONY: buildsupport
buildsupport: $(starlink_dir)/buildsupport

.PHONY: updatestarlink
updatestarlink: 
	git submodule update --init
	
$(starlink_dir)/buildsupport: updatestarlink
	cd ./starlink && ./bootstrap --buildsupport

$(starlink_dir)/bin/cupid: buildsupport
	cd ./starlink && ./bootstrap
	$(MAKE) -C ./starlink configure-deps
	cd ./starlink && ./configure -C --without-stardocs
	$(MAKE) -C ./starlink $(starlink_dir)/manifests/cupid
	strip -S --strip-unneeded --remove-section=.note.gnu.gold-version --remove-section=.comment --remove-section=.note --remove-section=.note.gnu.build-id --remove-section=.note.ABI-tag $(current_dir)/pycupid/star/lib/*.so

.PHONY: clean
clean:
	-rm -rf build/
	-rm -rf dist/
	-rm -f *.so
