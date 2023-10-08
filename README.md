# Build System

The build system for pacman-for-android.

Usage: `python build.py --help`.

## How it works

1. The build system acquires the latest source code for a package from the
   upstream repository.
2. The build system applies patches(if any) to the source code.
3. For some packages, the build system modifies the PKGBUILD via some bash scripts.
4. The build system builds the package via adb.

