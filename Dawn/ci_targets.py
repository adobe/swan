# Copyright 2025 Adobe
# All Rights Reserved.
#
# NOTICE: Adobe permits you to use, modify, and distribute this file in
# accordance with the terms of the Adobe license agreement accompanying
# it.

from dawn_builder import TargetConfig, Arch, OS


def ci_target(name: str, config: str = "release") -> TargetConfig:
    """
    Create a TargetConfig for the specified target name and debug mode.

    Args:
        name: The target platform name (macosx, iphoneos, iphonesimulator, ipados, linux, windows)
        config: The configuration to build for

    Returns:
        TargetConfig object configured for the specified target

    Raises:
        ValueError: If the target name is not recognized
    """
    match name:
        case "macosx":
            return TargetConfig(
                os=OS.MACOS,
                arch=[Arch.X86_64, Arch.ARM64],
                sdk="macosx15.5",
                deployment_target="15.0",
                config=config,
            )
        case "iphoneos":
            return TargetConfig(
                os=OS.IPHONE,
                arch=[Arch.ARM64],
                sdk="iphoneos18.5",
                deployment_target="18.0",
                config=config,
            )
        case "iphonesimulator":
            return TargetConfig(
                os=OS.IPHONE,
                arch=[Arch.X86_64],
                sdk="iphonesimulator18.5",
                deployment_target="18.0",
                config=config,
            )
        case "ipados":
            return TargetConfig(
                os=OS.IPADOS,
                arch=[Arch.ARM64],
                sdk="ipados18.5",
                deployment_target="18.0",
                config=config,
            )
        case "linux":
            return TargetConfig(os=OS.LINUX, arch=[Arch.X86_64], config=config)
        case "windows":
            return TargetConfig(
                os=OS.WINDOWS,
                arch=[Arch.X86_64],
                runtime="msvc",
                config=config,
                build_tool="Visual Studio 17 2022",
            )
        case _:
            raise ValueError(f"Invalid target name: {name}")
