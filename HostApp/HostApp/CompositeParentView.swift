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
    
    @State private var searchText = ""
    @State private var features: [MGLPointFeature] = []
    
    var body: some View {
        AMLMapCompositeView(
            mapState: AMLMapViewState(center: center),
            searchText: $searchText
        )
//            .showUserLocation(true)
//            .featureClusterTapped { mapView, pointFeatureCluster in
//                print("FEATURE CLUSTER TAPPED")
//                dump(pointFeatureCluster)
//            }
    }
}


func myVeryOwnCreateMap(_ completion: @escaping (Result<MGLMapView, Geo.Error>) -> Void) {
    // do something
    
    // go get mapStyle
    // doSomething to map style
//    completion(...)
}
