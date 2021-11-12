//
// Copyright Amazon.com Inc. or its affiliates.
// All Rights Reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

import SwiftUI
import Mapbox
import Amplify
import AmplifyMapLibreAdapter
import AmplifyMapLibreUI

class ContentViewModel: ObservableObject {

    @Published var places: [Place] = []
    @Published var annotations: [MGLPointFeature] = []

    func search(
        _ text: String,
        area: Geo.SearchArea
    ) {
        Amplify.Geo.search(for: text, options: .init(area: area)) { [weak self] result in
            switch result {
            case.success(let places):
                DispatchQueue.main.async {
                    self?.places = places.map(Place.init)
                    
                    self?.annotations = places.map { place -> MGLPointFeature in
                        let feature = MGLPointFeature()
                        feature.coordinate = CLLocationCoordinate2D(place.coordinates)
                        // We should not have to do this prefix check. It's error prone and will lead to issues.
                        // Ideally, we'd get just the name returned in a field.
                        feature.attributes["label"] = place.label?.prefix(while: { $0 != "," })
                        
                        feature.attributes["addressLineOne"] = place.streetLabelLine
                        feature.attributes["addressLineTwo"] = place.cityLabelLine
                        return feature
                    }
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}

extension Geo.Place {
    var streetLabelLine: String {
        "\(addressNumber ?? "") \(street ?? "")"
    }
    
    var cityLabelLine: String {
        "\(municipality ?? ""), \(region ?? "") \(postalCode ?? "")"
    }
}

// To be removed. Only for Indetifiable conformance for List
struct Place: Identifiable {
    let id = UUID()
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
