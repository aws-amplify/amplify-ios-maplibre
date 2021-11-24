//
// Copyright Amazon.com Inc. or its affiliates.
// All Rights Reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

import SwiftUI
import Mapbox

/// Configurable map settings. These values are set through view modifiers on `AMLMapView`.
internal class AMLMapViewSettings: ObservableObject {
    /// Whether the user's location is shown. Default is `false`
    /// Setting this triggers an OS location sharing prompt.
    /// To access the user's location, location access must be enabled in the app,
    /// and the user must choose to allow access.
    @Published internal var showUserLocation: Bool

    /// The map's minimum allowed zoom level.
    @Published internal var minZoomLevel: Double

    /// The map's maximum allowed zoom level.
    @Published internal var maxZoomLevel: Double

    /// Whether the attribution button is hidden.
    @Published internal var hideAttributionButton: Bool

    /// The compass position on the map.
    @Published internal var compassPosition: MGLOrnamentPosition

    /// The image representing a feature on the map.
    @Published internal var featureImage: UIImage

    /// Definition of the map's clustering behavior
    let clusteringBehavior: AMLMapView.ClusteringBehavior

    /// Implementation definitions for user interactions with the map.
    let proxyDelegate: AMLMapView.ProxyDelegate  // swiftlint:disable:this weak_delegate

    /// Create a new `AMLMapViewSettings` object that defines map settings.
    /// - Parameters:
    ///   - showUserLocation: Whether the user's location is shown. Default is `false`
    ///   Setting this triggers an OS location sharing prompt.
    ///   To access the user's location, location access must be enabled in the app,
    ///   and the user must choose to allow access.
    ///   - minZoomLevel: The map's minimum allowed zoom level. Default is `0`
    ///   - maxZoomLevel: The map's maximum allowed zoom level. Default is `22`
    ///   - hideAttributionButton: Whether the attribution button is hidden. Default is `false`
    ///   - compassPosition: The position of the compass on the map. Default is `.bottomleft`
    ///   - featureImage: The image representing a feature on the map. Default is `AMLFeatureView`.
    ///   - clusteringBehavior: Define the map views clustering behavior.
    ///   Default implementation provided.
    ///   - proxyDelegate: Define your own implementations of user interactions with the map.
    ///   Default implementation provided.
    internal init(
        showUserLocation: Bool = false,
        minZoomLevel: Double = 0,
        maxZoomLevel: Double = 22,
        hideAttributionButton: Bool = false,
        compassPosition: MGLOrnamentPosition = .bottomLeft,
        featureImage: UIImage = UIImage(
            named: "AMLFeatureView",
            in: Bundle.module,
            compatibleWith: nil
        )!,
        clusteringBehavior: AMLMapView.ClusteringBehavior = .init(),
        proxyDelegate: AMLMapView.ProxyDelegate = .init()
    ) {
        self.showUserLocation = showUserLocation
        self.minZoomLevel = minZoomLevel
        self.maxZoomLevel = maxZoomLevel
        self.hideAttributionButton = hideAttributionButton
        self.compassPosition = compassPosition
        self.featureImage = featureImage
        self.clusteringBehavior = clusteringBehavior
        self.proxyDelegate = proxyDelegate
    }
}
