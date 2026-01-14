# Copyright 2025 Adobe
# All Rights Reserved.
#
# NOTICE: Adobe permits you to use, modify, and distribute this file in
# accordance with the terms of the Adobe license agreement accompanying
# it.

import platform
from dawn_builder import TargetConfig, Arch, OS


def get_current_arch() -> Arch:
    """
    Detect the current machine architecture.
    
    Returns:
        Arch enum value for the current architecture
    """
    machine = platform.machine().lower()
    if machine in ('amd64', 'x86_64', 'x64'):
        return Arch.X86_64
    elif machine in ('arm64', 'aarch64'):
        return Arch.ARM64
    else:
        # Default to X86_64 if unknown
        return Arch.X86_64


def ci_target(target: str, archs: list[str], config: str = "release") -> TargetConfig:
    """
    Create a TargetConfig for the specified target OS, architectures, and configuration.

    Args:
        target: The target OS name (macosx, iphoneos, iphonesimulator, ipados, linux, windows)
        archs: List of architecture strings (x86_64, arm64)
        config: The configuration to build for

    Returns:
        TargetConfig object configured for the specified target

    Raises:
        ValueError: If the target name is not recognized
    """
    # Convert architecture strings to Arch enums
    arch_enums = []
    for arch_str in archs:
        if arch_str == "x86_64":
            arch_enums.append(Arch.X86_64)
        elif arch_str == "arm64":
            arch_enums.append(Arch.ARM64)
        else:
            raise ValueError(f"Invalid architecture: {arch_str}")
    
    match target:
        case "macosx":
            return TargetConfig(
                os=OS.MACOS,
                arch=arch_enums,
                sdk="macosx15.5",
                deployment_target="15.0",
                config=config,
            )
        case "iphoneos":
            return TargetConfig(
                os=OS.IPHONE,
                arch=arch_enums,
                sdk="iphoneos18.5",
                deployment_target="18.0",
                config=config,
            )
        case "iphonesimulator":
            return TargetConfig(
                os=OS.IPHONE,
                arch=arch_enums,
                sdk="iphonesimulator18.5",
                deployment_target="18.0",
                config=config,
            )
        case "ipados":
            return TargetConfig(
                os=OS.IPADOS,
                arch=arch_enums,
                sdk="ipados18.5",
                deployment_target="18.0",
                config=config,
            )
        case "linux":
            return TargetConfig(os=OS.LINUX, arch=arch_enums, config=config)
        case "windows":
            return TargetConfig(
                os=OS.WINDOWS,
                arch=arch_enums,
                runtime="msvc",
                config=config,
                build_tool="Visual Studio 17 2022",
            )
        case _:
            raise ValueError(f"Invalid target name: {target}")
