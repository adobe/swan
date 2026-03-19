#!/usr/bin/env node
// Downloads and installs the given WASM SDK
// Usage: node scripts/sdk-install.mjs <sdk-id>
//   sdk-id : 			e.g. "swift-6.3-DEVELOPMENT-SNAPSHOT-2026-02-27-a_wasm"

import { spawnSync } from "node:child_process";

function isSdkInstalled(sdkId, sdkListOutput) {
	return new RegExp(`^${sdkId}$`, "m").test(sdkListOutput);
}

// Get the SDK ID from the command line arguments
const sdkId = process.argv[2];

if (!sdkId) {
	console.error("Usage: sdk-install.mjs <sdk-id>");
	process.exit(1);
}

// check the "swift sdk list" output with grep to find the matching SDK entry
const sdkListResult = spawnSync("swift", ["sdk", "list"], { encoding: "utf8" });
if (isSdkInstalled(sdkId, sdkListResult.stdout)) {
	console.log("SDK already installed, skipping.");
	process.exit(0);
}

// parse version from the sdkID, default to main
const sdkVersionMatch = sdkId.match(/swift-(\d+\.\d+)-DEVELOPMENT-SNAPSHOT/);
const sdkVersion = sdkVersionMatch ? sdkVersionMatch[1] : "main";

let apiUrl, baseUrl;

if (sdkVersion === "main") {
	apiUrl = "https://www.swift.org/api/v1/install/dev/main/wasm-sdk.json";
	baseUrl = "https://download.swift.org/development/";
} else {
	apiUrl = `https://www.swift.org/api/v1/install/dev/${sdkVersion}/wasm-sdk.json`;
	baseUrl = `https://download.swift.org/swift-${sdkVersion}-branch/`;
}

const response = await fetch(apiUrl);
if (!response.ok) {
	console.error(`Failed to fetch SDK list: ${response.status} ${response.statusText}`);
	process.exit(1);
}
const entries = (await response.json()).map((entry) => ({...entry, sdkId: `${entry.dir}_wasm` }));

let entry = entries.find((e) => sdkId === e.sdkId);
if (!entry) {
	console.error(`SDK not found for ID: ${sdkId}.\n`)
	// ask user (y)es/(n)o if we should install the latest available SDK which is the first entry in the list
	const selectedIndex = await new Promise((resolve) => {
		process.stdout.write(`Do you want to install the latest available ${sdkVersion}-snapshot SDK (${entries[0].dir})? (y/n) `);
		process.stdin.setEncoding("utf8");
		process.stdin.on("data", (data) => {
			const answer = data.trim().toLowerCase();
			if (answer === "y" || answer === "yes") {
				resolve(0);
			} else {
				resolve(-1);
			}
		});
	});

	if (selectedIndex === -1) {
		console.error("Aborting.");
		process.exit(1);
	}
	
	entry = entries[selectedIndex];
}

if (isSdkInstalled(entry.sdkId, sdkListResult.stdout)) {
	console.log("SDK already installed, skipping.");
	process.exit(0);
}

const downloadUrl = `${baseUrl}wasm-sdk/${entry.dir}/${entry.download}`;

console.log(`SDK:      ${entry.dir}`);
console.log(`Download: ${downloadUrl}`);

const result = spawnSync("swift", ["sdk", "install", downloadUrl, "--checksum", entry.checksum], { stdio: "inherit", },);

process.exit(result.status ?? 1);
