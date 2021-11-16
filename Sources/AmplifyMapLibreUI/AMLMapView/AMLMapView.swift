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
    @Binding var mapView: MGLMapView?
    @Binding var features: [MGLPointFeature]
    @ObservedObject var mapState: AMLMapViewState
    @ObservedObject var mapSettings = AMLMapViewSettings()
    
    public init(
        mapView: Binding<MGLMapView?> = .constant(nil),
        features: Binding<[MGLPointFeature]> = .constant([]),
        mapState: AMLMapViewState = .init()
    ) {
        _mapView = mapView
        _features = features
        self.mapState = mapState
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
                features: $features,
                attribution: $mapState.attribution,
                clusteringBehavior: mapSettings.clusteringBehavior,
                proxyDelegate: mapSettings.proxyDelegate
            )
                .showUserLocation(mapSettings.showUserLocation)
                .compassPosition(mapSettings.compassPosition)
                .minZoomLevel(mapSettings.minZoomLevel)
                .maxZoomLevel(mapSettings.maxZoomLevel)
            //                .featureClusterTapped(viewModel.clusterTapped)
            //                .featureTapped(viewModel.featureTapped)
        case .error(let error):
            Text("Error loading view: \(error.localizedDescription)")
        case .loading:
            AMLActivityIndicator()
        case .begin:
            AMLActivityIndicator()
                .onAppear {
                    AmplifyMapLibre.createMap {
                        mapState
                            .mapLoadingState
                            .transition(input: $0, assign: &mapView)
                    }
                }
        }
        
    }
}
