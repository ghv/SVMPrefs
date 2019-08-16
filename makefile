.PHONY: unit build run test rbuild install clean

RELEASE_FLAGS = -c release
EXECUTABLE_PATH = $(shell swift build $(RELEASE_FLAGS) --show-bin-path)/svmprefs
INSTALL_FOLDER = /usr/local/bin

unit:
	swift test

build:
	swift build

run:
	cp DemoOrig.swift Demo.swift
	.build/debug/svmprefs gen -b -d -i 4 Demo.swift

test: build run

rbuild:
	@echo Building Release...
	swift build $(RELEASE_FLAGS)

install: rbuild
	@echo "Installing svmprefs in $(INSTALL_FOLDER)"
	@install $(EXECUTABLE_PATH) $(INSTALL_FOLDER)

clean:
	swift package reset
