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
        AMLMapCompositeView(
            createMap: AmplifyMapLibre.createMap,
            zoomLevel: $zoomLevel,
            bounds: $bounds,
            center: $center,
            heading: $heading,
            displayState: $displayState,
            searchText: $searchText
        )
    }
}
