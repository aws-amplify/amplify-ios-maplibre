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

struct AMLMapCompositeView_View: View {
    
    var body: some View {
        AMLMapCompositeView()
            .clusterColor(.purple)
            .showUserLocation(true)
    }
}
