//
// Copyright Amazon.com Inc. or its affiliates.
// All Rights Reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

import SwiftUI
import Mapbox
import Amplify

class AMLMapCompositeViewModel: ObservableObject {
    @Published var places: [Geo.Place] = []
    @Published var annotations: [MGLPointFeature] = []
    
    func search(
        _ text: String,
        area: Geo.SearchArea
    ) {
        Amplify.Geo.search(for: text, options: .init(area: area)) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case.success(let places):
                DispatchQueue.main.async {
                    self.places = places
                    self.annotations = self.transform(places)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func transform(_ places: [Geo.Place]) -> [MGLPointFeature] {
        places.map { place -> MGLPointFeature in
            let feature = MGLPointFeature()
            feature.coordinate = CLLocationCoordinate2D(place.coordinates)
            feature.attributes["label"] = place.labelLine ?? place.label
            feature.attributes["addressLineOne"] = place.streetLabelLine
            feature.attributes["addressLineTwo"] = place.cityLabelLine
                
            return feature
        }
    }
}

extension StringProtocol {
    func index<S: StringProtocol>(of string: S) -> Index? {
        range(of: string)?.lowerBound
    }
}

extension Geo.Place {
    var streetLabelLine: String {
        "\(addressNumber ?? "") \(street ?? "")"
    }
    
    var cityLabelLine: String {
        "\(municipality ?? ""), \(region ?? "") \(postalCode ?? "")"
    }
    
    // We should not have to do this string parsing. It's error prone and will lead to issues.
    // Ideally, we'd get just the name returned in a field.
    var labelLine: String? {
        if let placeLabel = label,
           let street = street,
           let streetIndex = label?.range(of: street)?.lowerBound,
           let commaIndex = placeLabel[..<streetIndex].range(of: ",", options: .backwards)?.lowerBound {
            return String(placeLabel[..<commaIndex])
        } else {
            return label
        }
    }
}
