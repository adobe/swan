#!/usr/bin/env node
// Downloads and installs a Swift WASM SDK from a direct URL.
// Usage: node Scripts/sdk-install.mjs <download-url> <checksum>
//   download-url: e.g. "https://download.swift.org/swift-6.3-release/wasm-sdk/swift-6.3-RELEASE/swift-6.3-RELEASE_wasm.artifactbundle.tar.gz"
//   checksum:     SHA-256 checksum of the artifact bundle

import { spawnSync } from "node:child_process";

const downloadUrl = process.argv[2];
const checksum = process.argv[3];

if (!downloadUrl || !checksum) {
	console.error("Usage: sdk-install.mjs <download-url> <checksum>");
	process.exit(1);
}

console.log(`Download: ${downloadUrl}`);

const result = spawnSync("swift", ["sdk", "install", downloadUrl, "--checksum", checksum], { stdio: "inherit" });

if (result.status !== 0) {
	// Exit code 1 from swift sdk install may mean "already installed" — check
	const listResult = spawnSync("swift", ["sdk", "list"], { encoding: "utf8" });
	console.log("\nInstalled SDKs:");
	console.log(listResult.stdout);
}

process.exit(result.status ?? 1);
