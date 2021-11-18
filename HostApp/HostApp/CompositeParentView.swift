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

// swiftlint:disable:next type_name
struct AMLMapCompositeView_View: View {

    @State private var center: CLLocationCoordinate2D = .init(
        latitude: 37.785834,
        longitude: -122.406417
    )

    @State private var searchText = ""

    var body: some View {
        AMLMapCompositeView(
            mapState: AMLMapViewState(center: center),
            searchText: $searchText
        )
    }
}
