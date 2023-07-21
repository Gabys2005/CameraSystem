const noblox = require("noblox.js");
const fs = require("fs");

async function run() {
	console.log(process.env.ROBLOSECURITY);
	console.log(process.env.ROBLOSECURITY.length);
	await noblox.setCookie(process.env.ROBLOSECURITY);
	const file = fs.readFileSync("module.rbxm");
	const response = await noblox.uploadModel(file, {}, 14142114135);
	console.log(`Uploaded to ${response.AssetId}`);
}

run();
