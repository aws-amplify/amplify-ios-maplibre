//
// Copyright Amazon.com Inc. or its affiliates.
// All Rights Reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

import SwiftUI
import MapLibre
import Amplify

/// Object to track state changes.
public class AMLMapViewState: ObservableObject {
    /// The underlying `MLNMapView`
    @Published public var mapView: MLNMapView?

    /// The current heading of the map in degrees.
    @Published public var heading: CLLocationDirection

    /// Current zoom level of the map.
    @Published public var zoomLevel: Double

    /// The coordinate bounds of the currently displayed area of the map.
    @Published public var bounds: MLNCoordinateBounds

    /// The center coordinates of the currently displayed area of the map.
    @Published public var center: CLLocationCoordinate2D

    /// The user's current location. Setting this will trigger an OS prompt for location sharing permission.
    @Published public var userLocation: CLLocationCoordinate2D?

    /// Features that are displayed on the map.
    @Published public var features: [MLNPointFeature]

    /// The attribution string for the map data providers.
    @Published public var attribution: String?

    /// Whether the attribution test is currently being displayed.
    @Published public internal(set) var isAttributionTextDisplayed: Bool

    /// Create an `AMLMapViewState` object to track state changes.
    /// - Parameters:
    ///   - mapView: The underlying `MLNMapView`
    ///   - heading: The current heading of the map in degrees. Default is `0` (North).
    ///   - zoomLevel: Current zoom level of the map. Default is `14`.
    ///   - bounds: The coordinate bounds of the currently displayed area of the map.
    ///   Default is an empty `MLNCoordinateBounds`.
    ///   - center: The center coordinates of the currently displayed area of the map.
    ///   Default is an empty `CLLOcationCoordinate2D`.
    ///   - userLocation: The user's current location. Default is `nil`.
    ///     Setting this will trigger an OS prompt for location sharing permission.
    ///   - features: Features that are displayed on the map. Default is `[]`
    ///   - attribution: The attribution string for the map data providers. Default is `nil`.
    public init(
        mapView: MLNMapView? = nil,
        heading: CLLocationDirection = 0,
        zoomLevel: Double = 14,
        bounds: MLNCoordinateBounds = .init(),
        center: CLLocationCoordinate2D = .init(
            latitude: 47.62246,
            longitude: -122.336775
        ),
        userLocation: CLLocationCoordinate2D? = nil,
        features: [MLNPointFeature] = [],
        attribution: String? = nil
    ) {
        self.mapView = mapView
        self.heading = heading
        self.zoomLevel = zoomLevel
        self.bounds = bounds
        self.center = center
        self.userLocation = userLocation
        self.attribution = attribution
        self.features = features
        self.isAttributionTextDisplayed = false
    }
}
