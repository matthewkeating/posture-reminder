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

Available targets:

| Target | Description |
|---|---|
| `make generate` | Generate the `.xcodeproj` from `project.yml` |
| `make build` | Generate project and build a Debug binary under `./build/Debug/` |
| `make run` | Build (Debug) and open the app |
| `make release` | Generate project and build a Release binary under `./build/Release/` |
| `make clean` | Remove all build artifacts and the generated `.xcodeproj` |
