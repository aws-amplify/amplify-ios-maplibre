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
    public init(_ places: [IdentifiablePlace]) {
        self.places = places
    }
    
    let places: [IdentifiablePlace]
    
    public var body: some View {
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


// To be removed. Only for Indetifiable conformance for List
public struct IdentifiablePlace: Identifiable {
    public let id = UUID()
    /// The coordinates of the place. (required)
    public let coordinates: Geo.Coordinates
    /// The full name and address of the place.
    public let label: String?
    /// The numerical portion of the address of the place, such as a building number.
    public let addressNumber: String?
    /// The name for the street or road of the place. For example, Main Street.
    public let street: String?
    /// The name of the local area of the place, such as a city or town name. For example, Toronto.
    public let municipality: String?
    /// The name of a community district.
    public let neighborhood: String?
    /// The name for the area or geographical division, such as a province or state
    /// name, of the place. For example, British Columbia.
    public let region: String?
    /// An area that's part of a larger region for the place.  For example, Metro Vancouver.
    public let subRegion: String?
    /// A group of numbers and letters in a country-specific format, which accompanies
    /// the address for the purpose of identifying the place.
    public let postalCode: String?
    /// The country of the place.
    public let country: String?
    
    /// Initializer
    public init(_ place: Geo.Place) {
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

public extension Geo.Place {
    init(_ place: IdentifiablePlace) {
        self.init(
            coordinates: place.coordinates,
            label: place.label,
            addressNumber: place.addressNumber,
            street: place.street,
            municipality: place.municipality,
            neighborhood: place.neighborhood,
            region: place.region,
            subRegion: place.subRegion,
            postalCode: place.postalCode,
            country: place.country
        )
    }
}
