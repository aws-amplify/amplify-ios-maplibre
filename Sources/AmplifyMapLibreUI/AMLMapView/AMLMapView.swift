//
// Copyright Amazon.com Inc. or its affiliates.
// All Rights Reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

import SwiftUI
import Amplify
import AWSLocationGeoPlugin
import Mapbox
import AmplifyMapLibreAdapter

/// The `SwiftUI` wrapper for `MGLMapView`
public struct AMLMapView: View {
    /// Object to track state changes in the map.
    @ObservedObject var mapState: AMLMapViewState
    
    /// Map configuration settings. Accessible through view modifiers.
    @ObservedObject var mapSettings: AMLMapViewSettings
    
    /// Create an instance of `AMLMapView`
    /// - Parameter mapState: Object to track state changes.
    public init(mapState: AMLMapViewState = .init()) {
        self.mapState = mapState
        self.mapSettings = AMLMapViewSettings()
        if let mapView = mapState.mapView {
            mapState.mapLoadingState.state = .complete(mapView)
        }
    }
    
    /// Create an instance of `AMLMapView`
    /// - Parameter mapState: Object to track state changes.
    
    /// Internal initializer to pass mapSettings in from composite view.
    /// - Parameters:
    ///   - mapState: Object to track state changes.
    ///   - mapSettings: Configurable settings for the map. Set through view modfiiers.
    internal init(mapState: AMLMapViewState, mapSettings: AMLMapViewSettings) {
        self.mapState = mapState
        self.mapSettings = mapSettings
        if let mapView = mapState.mapView {
            mapState.mapLoadingState.state = .complete(mapView)
        }
    }
    
    public var body: some View {
        switch mapState.mapLoadingState.state {
        case .complete(let mapView):
            _MGLMapViewWrapper(
                mapView: mapView,
                zoomLevel: $mapState.zoomLevel,
                bounds: $mapState.bounds,
                center: $mapState.center,
                heading: $mapState.heading,
                userLocation: $mapState.userLocation,
                showUserLocation: mapSettings.showUserLocation,
                features: $mapState.features,
                attribution: $mapState.attribution,
                featureImage: mapSettings.featureImage,
                clusteringBehavior: mapSettings.clusteringBehavior,
                proxyDelegate: mapSettings.proxyDelegate
            )
                .showUserLocation(mapSettings.showUserLocation)
                .compassPosition(mapSettings.compassPosition)
                .minZoomLevel(mapSettings.minZoomLevel)
                .maxZoomLevel(mapSettings.maxZoomLevel)
                .hideAttributionButton(mapSettings.hideAttributionButton)
        case .error(let error):
            Text("Error loading view: \(error.localizedDescription)")
        case .begin:
            AMLActivityIndicator()
                .onAppear {
                    AmplifyMapLibre.createMap {
                        mapState
                            .transitionMapLoadingState(input: $0)
                    }
                }
        }
    }
}
