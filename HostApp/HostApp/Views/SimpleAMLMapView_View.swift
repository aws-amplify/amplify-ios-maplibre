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
import Mapbox
import Amplify
import Combine

// swiftlint:disable:next type_name
struct SimpleAMLMapView_View: View {

    @StateObject var mapState = AMLMapViewState(pitch: 60)

    var body: some View {
        AMLMapView(mapState: mapState)
            .onReceive(mapState.$zoomLevel, perform: {
                print("zoom level ", $0)
            })
            .onReceive(mapState.$pitch, perform: {
                print("pitch ", $0)
            })
            .edgesIgnoringSafeArea(.all)
    }
}

// swiftlint:disable:next type_name
struct SimpleAMLMapView_View_Previews: PreviewProvider {
    static var previews: some View {
        SimpleAMLMapView_View()
    }
}
