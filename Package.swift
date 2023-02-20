// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "XMLCoding",
	platforms: [
		.iOS(.v13),
		.macOS(.v11)
	],
    products: [
		.library(
			name: "XMLCoding",
			targets: ["XMLCoding"]
		),
    ],
    dependencies: [
		.package(
			url: "https://github.com/pointfreeco/swift-snapshot-testing",
			exact: "1.10.0"
		),
    ],
    targets: [
        .target(
            name: "XMLCoding",
            dependencies: []
		),
        .testTarget(
            name: "XMLCodingTests",
            dependencies: [
				"XMLCoding",
				.product(name: "SnapshotTesting", package: "swift-snapshot-testing")
			]
		),
    ]
)
