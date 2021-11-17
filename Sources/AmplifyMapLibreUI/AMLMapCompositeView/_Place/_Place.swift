//
// Copyright Amazon.com Inc. or its affiliates.
// All Rights Reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

import SwiftUI
import Amplify

// swiftlint:disable type_name
/// An internal duplicate of `Geo.Place` that conforms to `Identifiable` for use in SwiftUI views.
struct _Place: Identifiable {
// swiftlint:enable type_name

    /// The ID
    let id = UUID()

    /// The coordinates of the place. (required)
    let coordinates: Geo.Coordinates

    /// The full name and address of the place.
    let label: String?

    /// The numerical portion of the address of the place, such as a building number.
    let addressNumber: String?

    /// The name for the street or road of the place. For example, Main Street.
    let street: String?

    /// The name of the local area of the place, such as a city or town name. For example, Toronto.
    let municipality: String?

    /// The name of a community district.
    let neighborhood: String?

    /// The name for the area or geographical division, such as a province or state
    /// name, of the place. For example, British Columbia.
    let region: String?

    /// An area that's part of a larger region for the place.  For example, Metro Vancouver.
    let subRegion: String?

    /// A group of numbers and letters in a country-specific format, which accompanies
    /// the address for the purpose of identifying the place.
    let postalCode: String?

    /// The country of the place.
    let country: String?

    /// Initializer
    init(_ place: Geo.Place) {
        self.coordinates = place.coordinates
        self.label = place.label
        self.addressNumber = place.addressNumber
        self.street = place.street
        self.municipality = place.municipality
        self.neighborhood = place.neighborhood
        self.region = place.region
        self.subRegion = place.subRegion
        self.postalCode = place.postalCode
        self.country = place.country
    }
}
