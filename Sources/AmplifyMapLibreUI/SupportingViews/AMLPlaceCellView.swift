//
// Copyright Amazon.com Inc. or its affiliates.
// All Rights Reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

import SwiftUI
import Amplify

public struct AMLPlaceCellView: View {
    
    let place: Geo.Place
    
    public init(place: Geo.Place) {
        self.place = place
    }
    
    public var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(place.label ?? "")
                    .font(.headline.weight(.semibold))
                Spacer()
                Text(place.neighborhood?.uppercased() ?? "")
                    .font(.footnote.weight(.light))
                    .foregroundColor(.secondary)
            }
            Text(addressLine(for: place))
            Text(cityLine(for: place))
        }.padding()
    }
    
    private func addressLine(for place: Geo.Place) -> String {
        "\(place.addressNumber ?? "") \(place.street ?? "")"
    }
    
    private func cityLine(for place: Geo.Place) -> String {
        "\(place.municipality ?? ""), \(place.region ?? "") \(place.postalCode ?? "")"
    }
}

struct PlaceCellView_Preview: PreviewProvider {
    static var previews: some View {
        AMLPlaceCellView(
            place: .init(
                coordinates: .init(latitude: 1, longitude: 2),
                label: "Example Label",
                addressNumber: "US",
                street: "CA",
                municipality: "",
                neighborhood: "San Jose",
                region: "5569",
                subRegion: "Downtown",
                postalCode: "95118",
                country: "Union Ave"
            )
        )
    }
}
