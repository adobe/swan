# Copyright 2025 Adobe
# All Rights Reserved.
#
# NOTICE: Adobe permits you to use, modify, and distribute this file in
# accordance with the terms of the Adobe license agreement accompanying
# it.

import hashlib
import pathlib
import json
import shutil
import dawn_source
import dawn_builder
from collections import defaultdict
from typing import List, Dict, Any
from dawn_builder import OS, PlatformGroup, TargetConfig


# Extra SDK-version-qualified triples to include in the .artifactbundleindex for
# Apple platforms, in addition to the generic OS triples produced by TargetConfig.
# Add new SDK versions here as Xcode / macOS / iOS releases ship.
EXTRA_APPLE_SDK_TRIPLES: Dict[OS, List[str]] = {
    OS.MACOS: [
        "arm64-apple-macos26.2",
        "arm64-apple-macos26.3",
    ],
    OS.IPHONE: [
        "arm64-apple-iphoneos26.2",
        "arm64-apple-iphoneos26.3",
        "arm64-apple-iphonesimulator26.2",
        "arm64-apple-iphonesimulator26.3",
    ],
}


def write_target_manifest(
    manifest_file: pathlib.Path, target_config: TargetConfig
) -> None:
    """
    Write a target manifest file with build configuration information.

    Args:
        manifest_file: Path to the manifest file to write
        target_config: Target configuration containing build settings
    """
    build_dir = pathlib.Path("builds")
    target_dir = build_dir / str(target_config) / "install"
    manifest = {
        "targetName": str(target_config),
        "libraryPath": (target_dir / "lib").as_posix(),
        "includePath": (target_dir / "include").as_posix(),
        "supportedTriples": target_config.triples(),
        "libraryName": "webgpu_dawn.lib"
        if target_config.os.is_windows()
        else "libwebgpu_dawn.a",
    }

    if target_config.os.is_windows():
        manifest["binPath"] = (target_dir / "bin").as_posix()

    manifest_file.write_text(json.dumps(manifest, indent=2))


def read_target_manifests() -> List[Dict[str, Any]]:
    """
    Read all target manifest files from the manifests directory.

    Returns:
        List of manifest dictionaries
    """
    manifests = []
    for manifest_file in manifests_dir().glob("*.json"):
        with open(manifest_file, "r") as f:
            manifests.append(json.load(f))
    return manifests


def platform_group_for_target_name(target_name: str) -> PlatformGroup:
    """
    Determine the platform group for a given target name.

    Args:
        target_name: The target name string (e.g. "macosx_arm64_release")

    Returns:
        The PlatformGroup for the target name
    """
    return OS.from_target_name(target_name).platform_group()


def group_manifests_by_platform(
    manifests: List[Dict[str, Any]],
) -> Dict[PlatformGroup, List[Dict[str, Any]]]:
    """
    Group target manifests by platform (apple, windows, linux).

    Args:
        manifests: List of target manifest dictionaries

    Returns:
        Dictionary mapping PlatformGroup to list of manifests
    """
    groups: Dict[PlatformGroup, List[Dict[str, Any]]] = defaultdict(list)
    for manifest in manifests:
        groups[platform_group_for_target_name(manifest["targetName"])].append(manifest)
    return groups


def _build_platform_info_json(
    platform: PlatformGroup, manifests: List[Dict[str, Any]], version: str
) -> Dict[str, Any]:
    """
    Build the info.json artifact manifest for a platform bundle.

    Args:
        platform: The PlatformGroup for this bundle
        manifests: Target manifests for this platform
        version: Version string for the artifacts

    Returns:
        Dictionary representing the info.json content
    """
    target_variants = [
        {
            "path": (
                pathlib.Path(manifest["targetName"]) / manifest["libraryName"]
            ).as_posix(),
            "staticLibraryMetadata": {
                "headerPaths": [
                    (pathlib.Path(manifest["targetName"]) / "include").as_posix()
                ]
            },
            "supportedTriples": manifest["supportedTriples"],
        }
        for manifest in manifests
    ]

    artifacts: Dict[str, Any] = {
        "dawn_webgpu": {
            "version": version,
            "type": "staticLibrary",
            "variants": target_variants,
        }
    }

    # Windows DLL artifacts are only included in the Windows bundle
    if platform == PlatformGroup.WINDOWS:
        artifacts["dxcompiler"] = {
            "type": "experimentalWindowsDLL",
            "version": "1.0.0",
            "variants": [
                {
                    "path": "windows_arm64_release/bin/dxcompiler.dll",
                    "supportedTriples": ["aarch64-unknown-windows-msvc"],
                },
                {
                    "path": "windows_x86_64_release/bin/dxcompiler.dll",
                    "supportedTriples": ["x86_64-unknown-windows-msvc"],
                },
            ],
        }
        artifacts["dxil"] = {
            "type": "experimentalWindowsDLL",
            "version": "1.0.0",
            "variants": [
                {
                    "path": "windows_arm64_release/bin/dxil.dll",
                    "supportedTriples": ["aarch64-unknown-windows-msvc"],
                },
                {
                    "path": "windows_x86_64_release/bin/dxil.dll",
                    "supportedTriples": ["x86_64-unknown-windows-msvc"],
                },
            ],
        }
        artifacts["d3dcompiler_47"] = {
            "type": "experimentalWindowsDLL",
            "version": "1.0.0",
            "variants": [
                {
                    "path": "windows_arm64_release/bin/d3dcompiler_47.dll",
                    "supportedTriples": ["aarch64-unknown-windows-msvc"],
                },
                {
                    "path": "windows_x86_64_release/bin/d3dcompiler_47.dll",
                    "supportedTriples": ["x86_64-unknown-windows-msvc"],
                },
            ],
        }

    return {"schemaVersion": "1.0", "artifacts": artifacts}


def compute_checksum(file_path: pathlib.Path) -> str:
    """
    Compute the SHA-256 checksum of a file.

    Args:
        file_path: Path to the file

    Returns:
        Hex-encoded SHA-256 digest string
    """
    sha256 = hashlib.sha256()
    with open(file_path, "rb") as f:
        for chunk in iter(lambda: f.read(65536), b""):
            sha256.update(chunk)
    return sha256.hexdigest()


def create_platform_artifact_bundle(
    platform: PlatformGroup,
    manifests: List[Dict[str, Any]],
    chromium_version: str,
    dawn_hash: str,
    dawn_json: pathlib.Path,
    base_name: str,
) -> pathlib.Path:
    """
    Create an artifact bundle zip for a single platform group.

    Args:
        platform: The PlatformGroup for this bundle
        manifests: Target manifests for this platform
        chromium_version: Chromium version string
        dawn_hash: Dawn hash string
        dawn_json: Path to the dawn.json source file
        base_name: Base name for the bundle (e.g. "dawn_webgpu")

    Returns:
        Path to the created zip archive (without the .zip extension appended by
        shutil.make_archive; the actual file is at the returned path + ".zip")
    """
    bundle_name = f"{base_name}_{platform}.artifactbundle"
    bundle_dir = dist_directory() / bundle_name

    # Remove any existing bundle directory
    if bundle_dir.exists():
        shutil.rmtree(bundle_dir)
    bundle_dir.mkdir(exist_ok=True, parents=True)

    # Copy libraries, headers, and (for Windows) binaries
    for manifest in manifests:
        target_dir = bundle_dir / manifest["targetName"]
        shutil.copytree(manifest["libraryPath"], target_dir)
        shutil.copytree(manifest["includePath"], target_dir / "include")
        if "binPath" in manifest:
            shutil.copytree(manifest["binPath"], target_dir / "bin")

    # Copy dawn.json
    shutil.copy2(dawn_json, bundle_dir / "dawn.json")

    # Write dawn_version.json
    version_data = {
        "dawn_hash": dawn_hash,
        "chromium_version": chromium_version,
    }
    (bundle_dir / "dawn_version.json").write_text(json.dumps(version_data, indent=2))

    # Write info.json
    info = _build_platform_info_json(platform, manifests, chromium_version)
    (bundle_dir / "info.json").write_text(json.dumps(info, indent=2))

    # Create the zip archive
    archive_stem = dist_directory() / bundle_name
    archive_path_no_ext = archive_stem

    # Remove existing zip if present
    zip_path = pathlib.Path(str(archive_path_no_ext) + ".zip")
    if zip_path.exists():
        zip_path.unlink()

    shutil.make_archive(
        str(archive_path_no_ext),
        "zip",
        root_dir=dist_directory(),
        base_dir=bundle_name,
    )

    return zip_path


def create_bundle_index(
    platform_zip_paths: Dict[PlatformGroup, pathlib.Path],
    manifests_by_platform: Dict[PlatformGroup, List[Dict[str, Any]]],
    base_name: str,
) -> pathlib.Path:
    """
    Create the artifact bundle index zip that references all platform bundles.

    The .artifactbundleindex file is written directly to dist/, alongside the
    platform zip archives it references.

    Args:
        platform_zip_paths: Mapping from PlatformGroup to zip path
        manifests_by_platform: Mapping from PlatformGroup to list of manifests
        base_name: Base name for the index (e.g. "dawn_webgpu")

    Returns:
        Path to the created .artifactbundleindex file
    """
    # Build the list of bundle entries
    bundle_entries = []
    for platform, zip_path in sorted(platform_zip_paths.items()):
        triples: List[str] = []
        for manifest in manifests_by_platform.get(platform, []):
            triples.extend(manifest["supportedTriples"])

        # Append extra SDK-version-qualified triples for Apple platforms.
        # Collect them per OS (deduplicated) so each SDK triple appears once.
        if platform == PlatformGroup.APPLE:
            seen_extra: set = set()
            for manifest in manifests_by_platform.get(platform, []):
                os_value = OS.from_target_name(manifest["targetName"])
                for extra in EXTRA_APPLE_SDK_TRIPLES.get(os_value, []):
                    if extra not in seen_extra:
                        seen_extra.add(extra)
                        triples.append(extra)

        bundle_entries.append(
            {
                "fileName": zip_path.name,
                "checksum": compute_checksum(zip_path),
                "supportedTriples": triples,
            }
        )

    index_data = {
        "schemaVersion": "1.0",
        "archives": bundle_entries,
    }

    index_file = dist_directory() / f"{base_name}.artifactbundleindex"
    index_file.write_text(json.dumps(index_data, indent=2))

    return index_file


def build_bundle_target(target_config: TargetConfig) -> None:
    """
    Build a target and create its manifest file.

    Args:
        target_config: Target configuration for the build
    """
    dawn_path = dawn_source.get_dawn_path()
    build_dir = pathlib.Path("builds")

    target_name = str(target_config)
    target_dir = build_dir / target_name / "install"
    target_dir.mkdir(exist_ok=True, parents=True)

    manifest_dir = build_dir / "manifest"
    manifest_dir.mkdir(exist_ok=True, parents=True)
    manifest_file = manifest_dir / f"{target_name}.json"

    dawn_builder.build_dawn(dawn_path, target_dir, target_config)
    write_target_manifest(manifest_file, target_config)


def create_artifact_bundles(
    chromium_version: str, dawn_hash: str, base_name: str
) -> pathlib.Path:
    """
    Create per-platform artifact bundles and a bundle index zip.

    Produces one artifact bundle zip per platform group (apple, windows, linux)
    and a .artifactbundleindex zip that references all of them.

    Args:
        chromium_version: Chromium version string
        dawn_hash: Dawn hash string
        base_name: Base name used for all output files (e.g. "dawn_webgpu")

    Returns:
        Path to the created .artifactbundleindex file
    """
    dawn_path = dawn_source.get_dawn_path()
    dawn_json = dawn_path / "src" / "dawn" / "dawn.json"

    dist_directory().mkdir(exist_ok=True, parents=True)

    manifests = read_target_manifests()
    manifests_by_platform = group_manifests_by_platform(manifests)

    platform_zip_paths: Dict[PlatformGroup, pathlib.Path] = {}
    for platform, platform_manifests in manifests_by_platform.items():
        zip_path = create_platform_artifact_bundle(
            platform,
            platform_manifests,
            chromium_version,
            dawn_hash,
            dawn_json,
            base_name,
        )
        platform_zip_paths[platform] = zip_path

    index_zip = create_bundle_index(
        platform_zip_paths, manifests_by_platform, base_name
    )
    return index_zip


def dist_directory() -> pathlib.Path:
    """
    Get the path to the dist directory.

    Returns:
        Path to the dist directory
    """
    return pathlib.Path("dist")


def artifact_bundle_directory() -> pathlib.Path:
    """
    Get the path to the artifact bundle directory.

    Returns:
        Path to the artifact bundle directory
    """
    return dist_directory() / "dawn_webgpu.artifactbundle"


def remove_build_directory() -> None:
    """
    Remove the build directory and all its contents.
    """
    build_dir = pathlib.Path("builds")
    if build_dir.exists():
        shutil.rmtree(build_dir)


def remove_artifact_bundle_directory() -> None:
    """
    Remove all per-platform artifact bundle directories and index artifacts from dist/.
    """
    dist = dist_directory()
    if not dist.exists():
        return

    for entry in dist.iterdir():
        if entry.is_dir() and entry.name.endswith(".artifactbundle"):
            shutil.rmtree(entry)
        elif entry.is_file() and entry.name.endswith(".artifactbundle.zip"):
            entry.unlink()
        elif entry.is_file() and entry.name.endswith(".artifactbundleindex"):
            entry.unlink()


def manifests_dir() -> pathlib.Path:
    """
    Get the path to the manifests directory.

    Returns:
        Path to the manifests directory
    """
    return pathlib.Path("builds") / "manifest"
