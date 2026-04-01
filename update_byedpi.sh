#!/bin/bash

SUBMODULE_PATH="Sources/ByeDPIC/byedpi"

# Re-clone byedpi with the latest commit
rm -rf "$SUBMODULE_PATH"
git clone --depth 1 https://github.com/hufrea/byedpi "$SUBMODULE_PATH"

# Prepare cloned directory
rm -rf "$SUBMODULE_PATH/.git"
rm -rf "$SUBMODULE_PATH/.github"
rm -rf "$SUBMODULE_PATH/dist"
rm -f "$SUBMODULE_PATH/.dockerignore"
rm -f "$SUBMODULE_PATH/.editorconfig"
rm -f "$SUBMODULE_PATH/Dockerfile"
rm -f "$SUBMODULE_PATH/Makefile"
rm -f "$SUBMODULE_PATH/README.md"
# rm -f "$SUBMODULE_PATH/win_service.h"
# rm -f "$SUBMODULE_PATH/win_service.c"
[ -f "$SUBMODULE_PATH/main.c" ] && mv "$SUBMODULE_PATH/main.c" "$SUBMODULE_PATH/ciadpi_main.c"
sed -i "" "s|#define DAEMON|//#define DAEMON|g" "$SUBMODULE_PATH/ciadpi_main.c"
