# Copyright 2025 Adobe
# All Rights Reserved.
#
# NOTICE: Adobe permits you to use, modify, and distribute this file in
# accordance with the terms of the Adobe license agreement accompanying
# it.

import json
import pathlib
import requests
import shutil
import subprocess
import sys
from typing import Dict, Any, Tuple

DAWN_GIT_URL = "https://dawn.googlesource.com/dawn"

# URL endpoint for latest release info from the Chromium version history page.
# We arbitrarily select the Windows platform for fetching the information to reduce the payload size.
_CHROMIUM_FETCH_VESION_URL = "https://chromiumdash.appspot.com/fetch_releases?channel={channel}&platform=Windows&num=1"


# fmt: off
class CiBuildDawnError(Exception): pass
class ChromiumVersionError(CiBuildDawnError): pass
class ChromiumVersionFetchError(ChromiumVersionError): pass
class ChromiumVersionParseError(ChromiumVersionError): pass
class GitOperationError(CiBuildDawnError): pass
class DawnSourceDirectoryConfigurationError(CiBuildDawnError): pass
class DawnSourceToolsDirectoryNotFoundError(DawnSourceDirectoryConfigurationError): pass
# fmt: on


def get_matching_dawn_for_chromium(channel: str = "canary") -> None:
    """
    Get the Dawn version that matches the latest Chromium release for the given channel

    Args:
        channel: The Chromium channel to use for fetching the latest version

    Returns:
        A tuple containing the Dawn hash, version, and suffix
    """

    chromium_dawn_hash, chromium_dawn_version, chromium_dawn_suffix = (
        get_latest_chromium_version(channel)
    )
    print(
        f"Downloading Dawn matching Chromium version {chromium_dawn_version} ({chromium_dawn_hash})..."
    )
    fetch_dawn_source(chromium_dawn_hash)

    version_data = {
        "chromium_dawn_hash": chromium_dawn_hash,
        "chromium_dawn_version": chromium_dawn_version,
        "chromium_dawn_suffix": chromium_dawn_suffix,
        "chromium_channel": channel,
    }

    version_file = pathlib.Path("dawn_version.json")
    print(f"Writing version data to {version_file}")
    version_file.write_text(json.dumps(version_data, indent=2))


def get_version() -> Dict[str, Any]:
    """
    Get the version information from the dawn_version.json file.

    Returns:
        Dictionary containing version information
    """
    version_file = pathlib.Path("dawn_version.json")
    with open(version_file, "r") as f:
        return json.load(f)


def get_latest_chromium_version(channel: str = "canary") -> Tuple[str, str, str]:
    """
    Get the version number of the most recently released version of Chromium.

    Args:
        channel: The Chromium channel to fetch version from

    Returns:
        Tuple containing (dawn_hash, version, suffix)

    Raises:
        ChromiumVersionFetchError: If the request fails
        ChromiumVersionParseError: If the response cannot be parsed
        ChromiumVersionError: If the version cannot be determined
    """
    url = _CHROMIUM_FETCH_VESION_URL.format(channel=channel)
    try:
        response = requests.get(url)
    except requests.exceptions.ConnectionError as e:
        raise ChromiumVersionFetchError(e)
    else:
        if response.status_code != 200:
            raise ChromiumVersionFetchError

    data = response.json()
    try:
        data = data.pop()
    except IndexError as e:
        raise ChromiumVersionParseError(f"JSON payload is unexpected: {data}")
    except AttributeError:
        raise ChromiumVersionParseError("Response object is None")

    # Get version number from first (most recent) release
    version = data.get("version")
    if version is None:
        raise ChromiumVersionError("Could not determine latest Chromium version")

    dawn_hash = data.get("hashes").get("dawn")
    suffix = f"chromium_{version}_{channel.lower()}_{dawn_hash}"
    return dawn_hash, version, suffix


def fetch_dawn_source(hash: str) -> None:
    """
    Clone the Dawn repository and checkout specified branch

    Args:
        hash: The git hash to checkout

    Raises:
        GitOperationError for failed git operations
        DawnSourceDirectoryConfigurationError, DawnSourceToolsDirectoryNotFoundError, for Dawn Source directory errors
    """
    # Remove destination directory if it exists
    dest_dir = get_dawn_path()
    if dest_dir.exists():
        shutil.rmtree(dest_dir)

    # Clone the repository
    try:
        subprocess.run(
            ["git", "clone", DAWN_GIT_URL, str(dest_dir)],
            check=True,
            capture_output=True,
            text=True,
        )
    except subprocess.CalledProcessError as e:
        raise GitOperationError(f"Failed to clone Dawn repository: {e.stderr}")

    # Checkout the specified hash
    try:
        subprocess.run(
            ["git", "checkout", hash],
            check=True,
            capture_output=True,
            text=True,
            cwd=str(dest_dir),
        )
    except subprocess.CalledProcessError as e:
        raise GitOperationError(f"Failed to checkout Dawn repository: {e.stderr}")

    # Verify Dawn tools directory and fetch dawn dependencies
    dawn_source_tools = dest_dir / "tools" / "fetch_dawn_dependencies.py"
    if not dawn_source_tools.exists():
        raise DawnSourceToolsDirectoryNotFoundError(dawn_source_tools)

    try:
        subprocess.run(
            [sys.executable, "-B", dawn_source_tools, "-d", str(dest_dir)],
            check=True,
            capture_output=True,
            text=True,
        )
    except subprocess.CalledProcessError as e:
        raise DawnSourceDirectoryConfigurationError(
            f"Failed to fetch Dawn dependencies: {e.stderr}"
        )


def remove_dawn_source() -> None:
    """
    Remove the Dawn source directory and version file.
    """
    dawn_source_dir = get_dawn_path()
    if dawn_source_dir.exists():
        shutil.rmtree(dawn_source_dir)

    version_file = pathlib.Path("dawn_version.json")
    if version_file.exists():
        version_file.unlink()


def get_dawn_path() -> pathlib.Path:
    """
    Get the path to the Dawn source directory.

    Returns:
        Path to the Dawn source directory
    """
    return pathlib.Path("dawn_source").resolve()
