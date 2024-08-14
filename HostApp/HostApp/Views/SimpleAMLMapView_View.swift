//
// Copyright Amazon.com Inc. or its affiliates.
// All Rights Reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

import SwiftUI
import AmplifyMapLibreAdapter
import AmplifyMapLibreUI
import CoreLocation
import MapLibre
import Amplify
import Combine

// swiftlint:disable:next type_name
struct SimpleAMLMapView_View: View {

    @StateObject var mapState = AMLMapViewState()

    var body: some View {
        AMLMapView(mapState: mapState)
            .edgesIgnoringSafeArea(.all)
    }
}

// swiftlint:disable:next type_name
struct SimpleAMLMapView_View_Previews: PreviewProvider {
    static var previews: some View {
        SimpleAMLMapView_View()
    }
}
