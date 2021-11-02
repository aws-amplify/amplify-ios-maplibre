// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

enum Amplify {
    static let packageName = "Amplify"
    static let packageURL = "https://github.com/aws-amplify/amplify-ios"
    static let requirement: Package.Dependency.Requirement = .branch("geo.main")
    static let package: Package.Dependency = .package(
        name: Amplify.packageName,
        url: Amplify.packageURL,
        Amplify.requirement
    )
}

let package = Package(
    name: "AmplifyMapLibreAdapter",
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
            name: Amplify.packageName,
            url: Amplify.packageURL,
            Amplify.requirement
        ),

        // MapLibre
        .package(
            name: "MapLibre GL Native",
            url: "https://github.com/maplibre/maplibre-gl-native-distribution",
            .exact("5.12.1")
        )
    ],
    targets: [
        .target(
            name: "AmplifyMapLibreAdapter",
            dependencies: [
                .product(name: "Amplify", package: Amplify.packageName),
                .product(name: "AWSCognitoAuthPlugin", package: Amplify.packageName),
                .product(name: "AWSLocationGeoPlugin", package: Amplify.packageName),
                .product(name: "AWSPluginsCore", package: Amplify.packageName),
                .product(name: "Mapbox", package: "MapLibre GL Native")
            ]),
        .target(
            name: "AmplifyMapLibreUI",
            dependencies: ["AmplifyMapLibreAdapter"]),
        .testTarget(
            name: "AmplifyMapLibreAdapterTests",
            dependencies: ["AmplifyMapLibreAdapter"]),
        .testTarget(
            name: "AmplifyMapLibreUITests",
            dependencies: ["AmplifyMapLibreAdapter"])
    ]
)

