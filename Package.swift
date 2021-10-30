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
            .upToNextMajor(from: "5.12.0")
        ),
        
        // SwiftFormat
        .package(
            url: "https://github.com/nicklockwood/SwiftFormat",
            .upToNextMajor(from: "0.48.11")
        ),
        
        // SwiftLint
        .package(
            url: "https://github.com/realm/SwiftLint",
            .upToNextMajor(from: "0.44.0")
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
        .testTarget(
            name: "AmplifyMapLibreAdapterTests",
            dependencies: ["AmplifyMapLibreAdapter"]),
    ]
)

