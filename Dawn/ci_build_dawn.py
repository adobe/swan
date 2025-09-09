#! /usr/bin/env python3

# Copyright 2025 Adobe
# All Rights Reserved.
#
# NOTICE: Adobe permits you to use, modify, and distribute this file in
# accordance with the terms of the Adobe license agreement accompanying
# it.

from ci_targets import ci_target
import archive_builder
import argparse
import dawn_source
import json

_EXIT_FAILURE = 1
_EXIT_SUCCESS = 0


def build_target(target: str, config: str = "release") -> None:
    """
    Build a target using the specified configuration.

    Args:
        target: The target platform to build for
        config: The configuration to build for
    """
    target_config = ci_target(target, config)
    archive_builder.build_bundle_target(target_config)


def bundle(chromium_version: str, dawn_hash: str, bundle_name: str) -> None:
    """
    Create an artifact bundle from the current Dawn build.
    """
    archive_path = archive_builder.create_artifact_bundle(
        chromium_version,
        dawn_hash,
        bundle_name,
    )
    print(f"Archive created: {archive_path}")


def upload(debug: bool) -> None:
    """
    Upload the built artifacts.

    Args:
        debug: Whether to run in debug mode
    """
    pass


def clean() -> None:
    """
    Clean up all build artifacts and temporary files.
    """
    print("Removing Dawn source directory...")
    dawn_source.remove_dawn_source()

    print("Removing build directory...")
    archive_builder.remove_build_directory()

    print("Removing archive directory...")
    archive_builder.remove_artifact_bundle_directory()


# Main


def parse_args() -> argparse.Namespace:
    """
    Parse command line arguments for the CI build tools.

    Returns:
        Parsed command line arguments
    """
    parser = argparse.ArgumentParser(description="CI build tools for Dawn")
    subparsers = parser.add_subparsers(dest="command")

    get_parser = subparsers.add_parser(
        "get-dawn-version", help="Get the latest Dawn version"
    )
    get_parser.add_argument(
        "--channel",
        choices=["stable", "beta", "canary"],
        default="canary",
        help="Chromium channel to use for Dawn",
    )

    get_parser = subparsers.add_parser("get-source", help="Get the Dawn source")
    get_parser.add_argument(
        "--hash",
        required=True,
        help="Dawn hash to get the source for",
    )

    build_parser = subparsers.add_parser("build-target", help="Build a target")
    build_parser.add_argument(
        "--target",
        choices=["windows", "linux", "macosx", "iphoneos", "iphonesimulator"],
        required=True,
        help="Target platform to build for",
    )
    build_parser.add_argument(
        "--config",
        choices=["release", "debug"],
        default="release",
        help="Configuration to build for",
    )

    bundle_parser = subparsers.add_parser("bundle", help="Bundle a target")
    bundle_parser.add_argument(
        "--chromium-version",
        required=True,
        help="Chromium version to bundle",
    )
    bundle_parser.add_argument(
        "--dawn-hash",
        required=True,
        help="Dawn hash to bundle",
    )
    bundle_parser.add_argument(
        "--bundle-name",
        required=True,
        help="Name of the bundle",
    )

    subparsers.add_parser("clean", help="Clean the build environment")

    return parser.parse_args()


def main() -> int:
    """
    Main entry point for the CI build tools.

    Returns:
        Exit code (0 for success, 1 for failure)
    """
    args = parse_args()
    if args.command == "get-dawn-version":
        dawn_source.get_matching_dawn_for_chromium(args.channel)
        print(json.dumps(dawn_source.get_version(), indent=2))
    elif args.command == "get-source":
        dawn_source.fetch_dawn_source(args.hash)
    elif args.command == "build-target":
        if args.target not in [
            "windows",
            "linux",
            "macosx",
            "iphoneos",
            "iphonesimulator",
            "windows",
        ]:
            print(f"Invalid target: {args.target}")
            return _EXIT_FAILURE

        build_target(args.target, args.config)
    elif args.command == "bundle":
        bundle(args.chromium_version, args.dawn_hash, args.bundle_name)
    elif args.command == "upload":
        upload(args.debug)
    elif args.command == "clean":
        clean()

    return _EXIT_SUCCESS


if __name__ == "__main__":
    exit(main())
