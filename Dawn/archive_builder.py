# Copyright 2025 Adobe
# All Rights Reserved.
#
# NOTICE: Adobe permits you to use, modify, and distribute this file in
# accordance with the terms of the Adobe license agreement accompanying
# it.

import pathlib
import json
import shutil
import dawn_source
import dawn_builder
from typing import List, Dict, Any
from dawn_builder import TargetConfig


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
        "libraryName": "libwebgpu_dawn.lib"
        if target_config.os.is_windows()
        else "libwebgpu_dawn.a",
    }
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


def write_bundle_manifest(version: str) -> None:
    """
    Write the main bundle manifest file for the artifact bundle.

    Args:
        version: Version string for the bundle
    """
    archive_dir = pathlib.Path("dist") / "dawn_webgpu.artifactbundle"
    archive_dir.mkdir(exist_ok=True, parents=True)
    archive_manifest_file = archive_dir / "info.json"

    target_manifests = [
        {
            "path": (
                pathlib.Path(manifest["targetName"]) / manifest["libraryName"]
            ).as_posix(),
            "staticLibraryMetadata": {"headerPaths": ["include"]},
            "supportedTriples": manifest["supportedTriples"],
        }
        for manifest in read_target_manifests()
    ]

    archive_manifest = {
        "schemaVersion": "1.0",
        "artifacts": {
            "dawn_webgpu": {
                "version": version,
                "type": "staticLibrary",
                "variants": target_manifests,
            }
        },
    }
    archive_manifest_file.write_text(json.dumps(archive_manifest, indent=2))


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


def create_artifact_bundle(
    chromium_version: str, dawn_hash: str, archive_name: str
) -> pathlib.Path:
    """
    Create a complete artifact bundle with all built targets.

    Args:
        chromium_version: Chromium version string for the bundle
        dawn_hash: Dawn hash string for the bundle
        archive_name: Name for the archive file

    Returns:
        Path to the created archive file
    """
    dawn_path = dawn_source.get_dawn_path()
    dawn_json = dawn_path / "src" / "dawn" / "dawn.json"

    # Remove the artifact bundle directory if it exists
    if artifact_bundle_directory().exists():
        shutil.rmtree(artifact_bundle_directory())

    # Create the final archive bundle directory
    archive_dir = artifact_bundle_directory()
    archive_dir.mkdir(exist_ok=True, parents=True)

    # Copy the include directory from the first target manifest
    manifests = read_target_manifests()
    include_dir = manifests[0]["includePath"]
    shutil.copytree(include_dir, archive_dir / "include")

    # Copy the libraries from the target manifests
    for manifest in manifests:
        library_path = manifest["libraryPath"]
        target_dir = archive_dir / manifest["targetName"]
        shutil.copytree(library_path, target_dir)
        
    # Copy the dawn.json file to the archive directory
    shutil.copy2(dawn_json, archive_dir / "dawn.json")

    # Write the archive manifest
    write_bundle_manifest(chromium_version)

    # Write the dawn version file
    dawn_version_file = archive_dir / "dawn_version.json"
    version_data = {
        "dawn_hash": dawn_hash,
        "chromium_version": chromium_version,
    }
    dawn_version_file.write_text(json.dumps(version_data, indent=2))

    # Create the archive
    archive_path = pathlib.Path("dist") / f"{archive_name}"

    # Remove the archive if it exists (from shutil.make_archive)
    if archive_path.exists():
        archive_path.unlink()

    shutil.make_archive(
        archive_path,
        "zip",
        root_dir=dist_directory(),
        base_dir=archive_dir.name,
    )

    return archive_path


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
    Remove the artifact bundle directory and all its contents.
    """
    dir_path = artifact_bundle_directory()
    if dir_path.exists():
        shutil.rmtree(dir_path)


def manifests_dir() -> pathlib.Path:
    """
    Get the path to the manifests directory.

    Returns:
        Path to the manifests directory
    """
    return pathlib.Path("builds") / "manifest"
