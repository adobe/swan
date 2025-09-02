# Building Dawn

This directory contains scripts that can be used to build Dawn for various platforms.
These scripts are used in CI to build a [static library artifact
bundle](https://github.com/swiftlang/swift-evolution/blob/main/proposals/0482-swiftpm-static-library-binary-target-non-apple-platforms.md).
That is a bundle that contains static libraries for a number of different architectures
and platforms.

## Dawn and Chromium

Dawn does not have version numbers like most software libraries. This makes it hard to
decide what to build. Since Dawn is tightly linked to Chromium, we choose what git hash
of Dawn to build by matching it with a release of Chromium.

## Using the CI Scripts

If you wish to build a version of Dawn yourself, you can use these CI scripts as follows:

```bash
# Recommended Python setup
python3 -m venv .venv
pip3 install -r requirements.txt

# Download the Dawn source matching the latest release of Chromium Canary
./ci_build_dawn.py get-dawn

# Build Dawn, running these commands on the appropriate platform
# Note that macosx builds both Intel and Arm
./ci_build_dawn.py build-target --target macosx
./ci_build_dawn.py build-target --target iphoneos
./ci_build_dawn.py build-target --target iphonesimulator

# Or on a Linux machine
./ci_build_dawn.py build-target --target linux

# Combine the builds into an archive bundle (all build products need to be in the same filesystem)
./ci_build_dawn.py bundle
```

