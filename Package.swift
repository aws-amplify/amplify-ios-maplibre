// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

// Package
let package = Package(
    name: "AmplifyMapLibreAdapter",
    defaultLocalization: "en",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        .library(
            name: "AmplifyMapLibreAdapter",
            targets: ["AmplifyMapLibreAdapter"]),
        .library(
            name: "AmplifyMapLibreUI",
            targets: ["AmplifyMapLibreUI"]),
    ],
    dependencies: [
        // Amplify
        .package(
            name: "Amplify",
            url: "https://github.com/aws-amplify/amplify-ios.git",
            .branch("dev-preview")
        ),

        // MapLibre
        .package(
            name: "MapLibre GL Native",
            url: "https://github.com/maplibre/maplibre-gl-native-distribution",
            .exact("5.12.0")
        )
    ],
    targets: [
        .target(
            name: "AmplifyMapLibreAdapter",
            dependencies: [
                .product(name: "Amplify", package: "Amplify"),
                .product(name: "AWSCognitoAuthPlugin", package: "Amplify"),
                .product(name: "AWSLocationGeoPlugin", package: "Amplify"),
                .product(name: "Mapbox", package: "MapLibre GL Native")
            ]
        ),
        .target(
            name: "AmplifyMapLibreUI",
            dependencies: ["AmplifyMapLibreAdapter"]
        ),
        .testTarget(
            name: "AmplifyMapLibreAdapterTests",
            dependencies: ["AmplifyMapLibreAdapter"]
        ),
        .testTarget(
            name: "AmplifyMapLibreUITests",
            dependencies: ["AmplifyMapLibreAdapter", "AmplifyMapLibreUI"]
        )
    ]
)
