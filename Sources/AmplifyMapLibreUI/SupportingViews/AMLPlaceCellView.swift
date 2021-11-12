//
// Copyright Amazon.com Inc. or its affiliates.
// All Rights Reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

import SwiftUI
import Amplify

/// View to display information from a `Geo.Place`. For use in a `List` or `ForEach`
public struct AMLPlaceCellView: View {
    
    /// Model of the place with location information.
    let place: Geo.Place
    
    /// View to display information from a `Geo.Place`. For use in a `List` or `ForEach`
    /// - Parameter place: Model of the place with location information.
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
    
    /// Given a `Geo.Place` this formats an address 1 line.
    ///
    /// Format:
    /// `place.addressNumber` `place.street`
    /// Example:
    ///  410 Terry Ave N
    ///
    /// - Parameter place: The `Geo.Place` to be formatted.
    /// - Returns: A formatted address line.
    /// - Important: `nil` values will default to empty `String`s
    private func addressLine(for place: Geo.Place) -> String {
        "\(place.addressNumber ?? "") \(place.street ?? "")"
    }
    
    /// Given a `Geo.Place` this formats a `<municipality>, <region> <postalCode>` line.
    ///
    /// Example:
    ///  Seattle, Washington 98109
    ///
    /// - Parameter place: The `Geo.Place` to be formatted.
    /// - Returns: A formatted address line.
    /// - Important: `nil` values will default to empty `String`s
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
