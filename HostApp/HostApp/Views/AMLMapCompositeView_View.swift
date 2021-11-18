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

// swiftlint:disable type_name
struct AMLMapCompositeView_View: View {

    var body: some View {
        AMLMapCompositeView()
            .clusterColor(.purple)
            .showUserLocation(true)
    }
}
// swiftlint:enable type_name
