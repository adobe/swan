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
import urllib.request
import zipfile
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
            },
            "dxcompiler": {
                "type": "staticLibrary",
                "version": "1.0.0",
                "variants": [
                    {
                        "path": "dxc/bin/arm64/dxcompiler.dll",
                        "supportedTriples": ["arm64-unknown-windows-msvc"],
                    },
                    {
                        "path": "dxc/bin/x64/dxcompiler.dll",
                        "supportedTriples": ["x86_64-unknown-windows-msvc"],
                    },
                ],
            },
            "dxil": {
                "type": "staticLibrary",
                "version": "1.0.0",
                "variants": [
                    {
                        "path": "dxc/bin/arm64/dxil.dll",
                        "supportedTriples": ["arm64-unknown-windows-msvc"],
                    },
                    {
                        "path": "dxc/bin/x64/dxil.dll",
                        "supportedTriples": ["x86_64-unknown-windows-msvc"],
                    },
                ],
            },
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


def addDXSupportLibraries(artifact_bundle_dir: pathlib.Path) -> None:
    """
    Add the DX support libraries to the artifact bundle.

    Fetches the latest DirectX Shader Compiler release from GitHub,
    downloads the dxc zip file, extracts it to the artifact bundle,
    and removes x86 directories.

    Args:
        artifact_bundle_dir: Path to the artifact bundle directory
    """
    # GitHub API endpoint for latest release
    api_url = (
        "https://api.github.com/repos/microsoft/DirectXShaderCompiler/releases/latest"
    )

    # Fetch the latest release info
    with urllib.request.urlopen(api_url) as response:
        release_data = json.loads(response.read().decode())

    # Find the zip asset whose name begins with "dxc"
    dxc_asset = None
    for asset in release_data.get("assets", []):
        if asset["name"].startswith("dxc") and asset["name"].endswith(".zip"):
            dxc_asset = asset
            break

    if not dxc_asset:
        raise ValueError("No dxc zip file found in the latest release")

    # Download the zip file
    download_url = dxc_asset["browser_download_url"]
    zip_filename = artifact_bundle_dir / f"{dxc_asset['name']}"

    print(f"Downloading {dxc_asset['name']} from {download_url}")
    urllib.request.urlretrieve(download_url, zip_filename)

    # Create dxc directory in artifact bundle
    dxc_dir = artifact_bundle_dir / "dxc"
    dxc_dir.mkdir(exist_ok=True, parents=True)

    # Extract the zip file
    with zipfile.ZipFile(zip_filename, "r") as zip_ref:
        zip_ref.extractall(dxc_dir)

    # Remove the downloaded zip file
    zip_filename.unlink()

    # Remove unneeded x86 directories
    x86_paths = [dxc_dir / "bin" / "x86", dxc_dir / "lib" / "x86"]

    for x86_path in x86_paths:
        if x86_path.exists():
            shutil.rmtree(x86_path)

    print("DX support libraries added successfully")


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

    # Add the DX support libraries to the artifact bundle
    addDXSupportLibraries(archive_dir)

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
