// swift-tools-version:4.2

import PackageDescription

let package = Package(
	name: "PerfectTemplate",
	products: [
		.executable(name: "SwiftPerfectDemo", targets: ["SwiftPerfectDemo"])
	],
	dependencies: [
		.package(url: "https://github.com/PerfectlySoft/Perfect-HTTPServer.git", from: "3.0.0"),
	],
	targets: [
		.target(name: "SwiftPerfectDemo", dependencies: ["PerfectHTTPServer"])
	]
)