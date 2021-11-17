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

// swiftlint:disable type_name
struct SimpleAMLMapView_View: View {
    var body: some View {
        AMLMapView()
            .edgesIgnoringSafeArea(.all)
    }
}

struct SimpleAMLMapView_View_Previews: PreviewProvider {
    static var previews: some View {
        SimpleAMLMapView_View()
    }
}
// swiftlint:enable type_name
