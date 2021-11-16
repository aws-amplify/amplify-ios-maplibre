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

public struct AMLMapView: View {
//    @Binding var mapView: MGLMapView?
    @ObservedObject var mapState: AMLMapViewState
    @ObservedObject var mapSettings = AMLMapViewSettings()
    
    public init(
//        mapView: Binding<MGLMapView?> = .constant(nil),
        mapState: AMLMapViewState = .init()
    ) {
//        _mapView = mapView
        self.mapState = mapState
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
//                            .mapLoadingState
//                            .transition(input: $0, assign: &mapState.mapView)
                    }
                }
        }
        
    }
}
