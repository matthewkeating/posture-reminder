.PHONY: generate build release run clean

generate:
	xcodegen generate

build: generate
	xcodebuild -project PostureReminder.xcodeproj \
		-scheme PostureReminder \
		-configuration Debug \
		SYMROOT=./build \
		build

release: generate
	xcodebuild -project PostureReminder.xcodeproj \
		-scheme PostureReminder \
		-configuration Release \
		SYMROOT=./build \
		build

run: build
	open ./build/Debug/PostureReminder.app

clean:
	rm -rf build
	rm -rf PostureReminder.xcodeproj
