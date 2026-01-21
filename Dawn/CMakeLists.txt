cmake_minimum_required(VERSION 3.20)

project(DawnBuilder LANGUAGES C CXX)

# ---- Dawn Common Configuration ----
# These options MUST be set BEFORE add_subdirectory

set(DAWN_ENABLE_PIC ON CACHE BOOL "Enable position independent code")
set(DAWN_BUILD_SAMPLES OFF CACHE BOOL "Disable Dawn samples")
set(TINT_BUILD_TESTS OFF CACHE BOOL "Disable Tint tests")
set(TINT_BUILD_CMD_TOOLS OFF CACHE BOOL "Disable Tint command line tools")
set(DAWN_ENABLE_INSTALL ON CACHE BOOL "Enable Dawn install target")
set(DAWN_FETCH_DEPENDENCIES ON CACHE BOOL "Fetch Dawn dependencies")
set(DAWN_BUILD_MONOLITHIC_LIBRARY STATIC CACHE STRING "Build Dawn as static monolithic library")
set(DAWN_USE_BUILT_DXC ON CACHE BOOL "Use built DXC")

# Add Dawn from source
add_subdirectory(dawn_source)

# ---- Overrides MUST come AFTER add_subdirectory ----

if (MSVC)
  if (TARGET webgpu_dawn)
    set_target_properties(webgpu_dawn PROPERTIES
      OUTPUT_NAME "libwebgpu_dawn"
    )
  endif()
endif()
