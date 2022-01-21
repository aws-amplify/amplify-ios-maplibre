//
// Copyright Amazon.com Inc. or its affiliates.
// All Rights Reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

import SwiftUI
import AmplifyMapLibreUI

struct SearchResultsView: View {
    let places: [IdentifiablePlace]

    var body: some View {
        VStack {
            ForEach(places) { place in
                AMLPlaceCellView(place: place.place)
            }
            .padding(.top, 8)
            .background(Color.tertiaryBackground)
            .cornerRadius(8)
        }
    }
}
