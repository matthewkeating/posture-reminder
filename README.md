# posture-reminder

A menu-bar-only macOS app that reminds you to sit or stand up straight. Every configurable number of minutes, a brief animated reminder appears on all connected displays. Adapts it's color scheme for light and dark modes.

![](animation.gif)

## Requirements

- macOS 14 (Sonoma) or later
- Swift 5.9 or later (included with Xcode 15+)
- [XcodeGen](https://github.com/yonaskolb/XcodeGen) — used to generate the `.xcodeproj` from `project.yml`

## Build instructions

**1. Install XcodeGen**

```sh
brew install xcodegen
```

**2. Generate the Xcode project**

```sh
make generate
```

**3. Build and run**

```sh
make run
```

This generates the project, builds a Debug binary under `./build/Debug/`, and opens the app. The `make build` target builds without launching, and `make clean` removes all build artifacts and the generated `.xcodeproj`.
