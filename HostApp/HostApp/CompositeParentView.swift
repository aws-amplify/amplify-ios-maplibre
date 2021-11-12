//
// Copyright Amazon.com Inc. or its affiliates.
// All Rights Reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

import SwiftUI
import CoreLocation
import AmplifyMapLibreAdapter
import AmplifyMapLibreUI
import Mapbox
import Amplify

struct CompositeParentView: View {
    
    @State private var center: CLLocationCoordinate2D = .init(
        latitude: 37.785834,
        longitude: -122.406417
    )
    
    @State private var bounds = MGLCoordinateBounds()
    @State private var zoomLevel: Double = 14
    @State private var heading: CLLocationDirection = 0
    @State private var displayState = AMLSearchBar.DisplayState.map
    @State private var searchText = ""
    @State private var mapViewResult: Result<MGLMapView, Geo.Error>?
    
    var body: some View {
        switch mapViewResult {
        case .success(let map):
            AMLMapCompositeView(
                center: $center,
                bounds: $bounds,
                zoomLevel: $zoomLevel,
                heading: $heading,
                displayState: $displayState,
                searchText: $searchText,
                mapView: map
            )
        case .failure(let error):
            Text(error.localizedDescription)
        case .none:
            AMLActivityIndicator()
                .onAppear {
                    AmplifyMapLibre.createMap {
                        self.mapViewResult = $0
                    }
                }
        }
    }
}
