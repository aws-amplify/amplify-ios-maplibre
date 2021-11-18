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

    @StateObject var viewModel = AMLMapCompositeViewModel()

    var body: some View {
        AMLMapCompositeView(viewModel: viewModel)
            .onReceive(viewModel.mapState.$center) {
                dump($0)
            }
    }
}
