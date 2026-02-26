#!/usr/bin/env python3

# Copyright 2025 Adobe
# All Rights Reserved.
#
# NOTICE: Adobe permits you to use, modify, and distribute this file in
# accordance with the terms of the Adobe license agreement accompanying
# it.

import os
import sys
import json
import shutil
import pathlib
import subprocess
from dataclasses import dataclass
from typing import Optional, List, Dict, Any
from enum import Enum


_EXIT_FAILURE = 1
_EXIT_SUCCESS = 0


# fmt: off
class BuildDawnError(Exception): pass
class SDKPathNotFoundError(BuildDawnError): pass
class CMakeError(BuildDawnError): pass
class CMakeBuildError(BuildDawnError): pass
class UploadArchiverError(BuildDawnError): pass
# fmt: on


def _subprocess_exception_message(exc: subprocess.CalledProcessError) -> None:
    """
    Print subprocess exception details.

    Args:
        exc: The CalledProcessError exception
    """
    print(f"Command failed with exit code {exc.returncode}")
    print(f"stdout: {exc.stdout}")
    print(f"stderr: {exc.stderr}")


class PlatformGroup(str, Enum):
    APPLE = "apple"
    WINDOWS = "windows"
    LINUX = "linux"


class OS(Enum):
    MACOS = "macosx"
    WINDOWS = "windows"
    LINUX = "linux"
    IPHONE = "iphone"
    IPADOS = "ipados"

    def is_apple(self) -> bool:
        """
        Check if this OS is an Apple platform.

        Returns:
            True if this is an Apple OS (macOS, iPhone, iPadOS)
        """
        return self in [OS.MACOS, OS.IPHONE, OS.IPADOS]

    def is_windows(self) -> bool:
        """
        Check if this OS is Windows.

        Returns:
            True if this is a Windows OS
        """
        return self == OS.WINDOWS

    def platform_group(self) -> PlatformGroup:
        """
        Get the platform group for this OS.

        Returns:
            The PlatformGroup for this OS
        """
        if self.is_apple():
            return PlatformGroup.APPLE
        if self.is_windows():
            return PlatformGroup.WINDOWS
        return PlatformGroup.LINUX

    @classmethod
    def from_target_name(cls, target_name: str) -> "OS":
        """
        Parse an OS from a target name string.

        Args:
            target_name: Target name string (e.g. "macosx_arm64_release")

        Returns:
            The matching OS enum value

        Raises:
            ValueError: If no matching OS is found
        """
        for member in cls:
            if target_name.startswith(member.value):
                return member
        raise ValueError(f"Could not determine OS from target name: {target_name}")


def get_current_os() -> OS:
    """
    Get the current operating system.

    Returns:
        OS enum value for the current platform
    """
    match os.uname().sysname:
        case "Darwin":
            return OS.MACOS
        case "Windows":
            return OS.WINDOWS
        case "Linux":
            return OS.LINUX
        case _:
            return OS.UNKNOWN


class Arch(Enum):
    X86_64 = "x86_64"
    ARM64 = "arm64"
    AARCH64 = "aarch64"

@dataclass
class TargetConfig:
    os: OS
    arch: List[Arch]
    sdk: Optional[str] = None
    runtime: Optional[str] = None
    deployment_target: Optional[str] = None
    config: str = "release"
    build_tool: str = "Ninja"

    def __str__(self) -> str:
        """
        Get a string representation of the target configuration.

        Returns:
            String representation of the target config
        """
        parts = [self.os.value]
        for arch in self.arch:
            parts.append(arch.value)
        if self.sdk:
            parts.append(self.sdk)
        parts.append(self.config)
        return "_".join(parts)

    def triples(self) -> List[str]:
        """
        Get the target triples for this configuration.

        Returns:
            List of target triple strings
        """
        vendor = "apple" if self.os.is_apple() else "unknown"
        os = self.os.value
        return [
            f"{arch.value}-{vendor}-{os}{'-' + self.runtime if self.runtime else ''}"
            for arch in self.arch
        ]


def cmake_flags(target_config: TargetConfig) -> List[str]:
    """
    Generate CMake flags for the given target configuration.

    Args:
        target_config: Target configuration to generate flags for

    Returns:
        List of CMake flags
    """
    flags = []

    if target_config.os.is_apple():
        flags.append(
            f"-DCMAKE_OSX_ARCHITECTURES={';'.join([arch.value for arch in target_config.arch])}"
        )
        if target_config.deployment_target:
            flags.append(
                f"-DCMAKE_OSX_DEPLOYMENT_TARGET={target_config.deployment_target}"
            )
        if target_config.os != OS.MACOS:
            flags.append("-DDAWN_USE_GLFW=OFF")
            flags.append("-DCMAKE_SYSTEM_NAME=iOS")

    if target_config.config == "debug":
        flags.append("-DCMAKE_BUILD_TYPE=Debug")
    else:
        flags.append("-DCMAKE_BUILD_TYPE=Release")

    if target_config.os.is_apple():
        sdk_path = find_sdk_path(target_config.sdk)
        if not sdk_path:
            print(f"SDK {target_config.sdk} not found")
            sys.exit(1)
        flags.append(f"-DCMAKE_OSX_SYSROOT={sdk_path}")

    return flags


def get_sdk_info() -> Optional[List[Dict[str, Any]]]:
    """
    Get information about available SDKs from xcodebuild.

    Returns:
        List of SDK information dictionaries, or None if command fails
    """
    # Run xcodebuild command to get SDK info
    try:
        result = subprocess.run(
            ["xcodebuild", "-showsdks", "-json"],
            capture_output=True,
            text=True,
            check=True,
        )
    except (subprocess.SubprocessError, OSError):
        return None

    # Parse JSON output
    try:
        sdks = json.loads(result.stdout)
    except json.JSONDecodeError:
        return None

    # Filter out SDKs that are not macOS or iOS, return unique SDK names
    sdks = [
        sdk
        for sdk in sdks
        if sdk.get("canonicalName", "").startswith(("macosx", "iphone"))
    ]
    return sdks


def find_sdk_path(sdk_name: Optional[str]) -> Optional[str]:
    """
    Find the path to a specific SDK.

    Args:
        sdk_name: Name of the SDK to find

    Returns:
        Path to the SDK, or None if not found
    """
    if not sdk_name:
        return None

    sdks = get_sdk_info()
    if not sdks:
        return None

    # Find matching SDK
    for sdk in sdks:
        if sdk.get("canonicalName") == sdk_name:
            return sdk.get("sdkPath")

    return None


def build_dawn(
    dawn_path: pathlib.Path, output_dir: pathlib.Path, target_config: TargetConfig
) -> None:
    """
    Build Dawn for the specified target configuration.

    Args:
        dawn_path: Path to the Dawn source directory
        output_dir: Directory to install the built artifacts
        target_config: Target configuration for the build

    Raises:
        CMakeError: If CMake or build commands fail
    """
    print(f"Building Dawn for {target_config}")

    # Create builds directory if it doesn't exist
    builds_dir = pathlib.Path("builds")
    sdk_build_dir = builds_dir / target_config.__str__()

    # Create build and install directory for this SDK
    build_dir = sdk_build_dir / "out"

    build_dir.mkdir(exist_ok=True, parents=True)
    output_dir.mkdir(exist_ok=True, parents=True)

    flags = cmake_flags(target_config)

    cmake_exec = shutil.which("cmake", path=os.environ.get("PATH"))

    # Use the CMakeLists.txt wrapper in the parent directory of dawn_source
    cmake_wrapper_path = dawn_path.parent
    
    # Run cmake command to create the build files
    try:
        subprocess.run(
            [cmake_exec, f"-G{target_config.build_tool}", *flags, str(cmake_wrapper_path)],
            env=os.environ,
            cwd=build_dir,
            capture_output=True,
            text=True,
            check=True,
        )
    except subprocess.CalledProcessError as e:
        _subprocess_exception_message(e)
        raise CMakeError

    config = "Debug" if target_config.config == "debug" else "Release"

    # Run the cmake build command
    try:
        subprocess.run(
            [
                cmake_exec,
                "--build",
                ".",
                "--config",
                config,
            ],
            cwd=build_dir,
            check=True,
        )
    except subprocess.CalledProcessError as e:
        _subprocess_exception_message(e)
        raise CMakeBuildError

    # Install the library and headers
    try:
        subprocess.run(
            [
                cmake_exec,
                "--install",
                str(build_dir),
                "--prefix",
                str(output_dir),
                "--config",
                config,
            ],
            check=True,
            capture_output=True,
            text=True,
        )
    except subprocess.CalledProcessError as e:
        _subprocess_exception_message(e)
        raise CMakeError

    # Copy DirectX support files to output_dir/bin (Windows only)
    if target_config.os.is_windows():
        source_dir = build_dir / config
        dest_dir = output_dir / "bin"
        if source_dir.exists():
            dest_dir.mkdir(exist_ok=True, parents=True)
            for item in source_dir.iterdir():
                if item.is_file():
                    shutil.copy2(item, dest_dir / item.name)
