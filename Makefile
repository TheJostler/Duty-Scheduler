VOX     ?= vox
VOXLIBS ?= ../english/vox-libs

scheduler: src/*.vox
	$(VOX) src/scheduler.vox --lib-path $(VOXLIBS)/build -o scheduler

.PHONY: test clean
test: scheduler
	tests/run.sh

clean:
	rm -f scheduler
