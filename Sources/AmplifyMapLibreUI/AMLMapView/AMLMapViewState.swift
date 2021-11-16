//
// Copyright Amazon.com Inc. or its affiliates.
// All Rights Reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

import SwiftUI
import Mapbox
import Amplify

/// Object to track state changes.
public class AMLMapViewState: ObservableObject {
    /// The underlying `MGLMapView`
    @Published public var mapView: MGLMapView?
    
    /// Loading state for track asynchronous loading of map
    @Published internal var mapLoadingState = MapCreationStateMachine(state: .begin)
    
    /// The current heading of the map in degrees.
    @Published public var heading: CLLocationDirection
    
    /// Current zoom level of the map.
    @Published public var zoomLevel: Double
    
    /// The coordinate bounds of the currently displayed area of the map.
    @Published public var bounds: MGLCoordinateBounds
    
    /// The center coordinates of the currently displayed area of the map.
    @Published public var center: CLLocationCoordinate2D
    
    /// The user's current location. Setting this will trigger an OS prompt for location sharing permission.
    @Published public var userLocation: CLLocationCoordinate2D?
    
    /// Features that are displayed on the map.
    @Published public var features: [MGLPointFeature]
    
    /// The attribution string for the map data providers.
    @Published public var attribution: String?
    
    /// Create an `AMLMapViewState` object to track state changes.
    /// - Parameters:
    ///   - mapView: The underlying `MGLMapView`
    ///   - heading: The current heading of the map in degrees. Default is `0` (North).
    ///   - zoomLevel: Current zoom level of the map. Default is `14`.
    ///   - bounds: The coordinate bounds of the currently displayed area of the map. Default is an empty `MGLCoordinateBounds`.
    ///   - center: The center coordinates of the currently displayed area of the map. Default is an empty `CLLOcationCoordinate2D`.
    ///   - userLocation: The user's current location. Default is `nil`.
    ///     Setting this will trigger an OS prompt for location sharing permission.
    ///   - features: Features that are displayed on the map. Default is `[]`
    ///   - attribution: The attribution string for the map data providers. Default is `nil`.
    public init(
        mapView: MGLMapView? = nil,
        heading: CLLocationDirection = 0,
        zoomLevel: Double = 14,
        bounds: MGLCoordinateBounds = .init(),
        center: CLLocationCoordinate2D = .init(),
        userLocation: CLLocationCoordinate2D? = nil,
        features: [MGLPointFeature] = [],
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
    }
    
    func transitionMapLoadingState(input: Result<MGLMapView, Geo.Error>) {
        mapLoadingState.transition(input: input, assign: &mapView)
    }
}
