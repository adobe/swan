#!/usr/bin/env node
// Downloads and installs a pinned WASM SDK.
// Usage: node Scripts/sdk-install.mjs <sdk-id> <download-url> <checksum>

import { spawnSync } from "node:child_process";

const [sdkId, downloadUrl, checksum] = process.argv.slice(2);

if (!sdkId || !downloadUrl || !/^[a-f0-9]{64}$/i.test(checksum ?? "")) {
	console.error("Usage: sdk-install.mjs <sdk-id> <download-url> <checksum>");
	process.exitCode = 1;
} else {
	const sdkListResult = spawnSync("swift", ["sdk", "list"], { encoding: "utf8" });
	if (sdkListResult.error) {
		console.error(`Failed to run swift sdk list: ${sdkListResult.error.message}`);
		process.exitCode = 1;
	} else if (sdkListResult.status !== 0) {
		if (sdkListResult.stderr) process.stderr.write(sdkListResult.stderr);
		process.exitCode = sdkListResult.status ?? 1;
	} else if (sdkListResult.stdout.split(/\r?\n/).some((line) => line.trim() === sdkId)) {
		console.log("SDK already installed, skipping.");
	} else {
		const result = spawnSync("swift", ["sdk", "install", downloadUrl, "--checksum", checksum], { stdio: "inherit" });
		if (result.error) {
			console.error(`Failed to run swift sdk install: ${result.error.message}`);
			process.exitCode = 1;
		} else {
			process.exitCode = result.status ?? 1;
		}
	}
}
