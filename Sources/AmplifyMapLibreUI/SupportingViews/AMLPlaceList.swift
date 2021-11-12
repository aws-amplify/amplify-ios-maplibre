//
// Copyright Amazon.com Inc. or its affiliates.
// All Rights Reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

import SwiftUI
import Amplify

// WIP
public struct AMLPlaceList: View {
    public init(_ places: [Geo.Place]) {
        self.places = places.map(_Place.init)
    }
    
    let places: [_Place]
    
    public var body: some View {
        VStack {
            if places.isEmpty {
                Text("No Results")
                    .font(.headline)
            } else {
                if #available(iOS 14, *) {
                    List(places) {
                        AMLPlaceCellView(place: .init($0))
                    }
                    .listStyle(InsetGroupedListStyle())
                } else {
                    List(places) {
                        AMLPlaceCellView(place: .init($0))
                    }
                }
            }
        }
    }
}
