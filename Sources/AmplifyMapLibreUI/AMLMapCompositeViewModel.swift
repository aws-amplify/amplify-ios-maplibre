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
            // We should not have to do this prefix check. It's error prone and will lead to issues.
            // Ideally, we'd get just the name returned in a field.
            feature.attributes["label"] = place.label?.prefix(while: { $0 != "," })
            
            feature.attributes["addressLineOne"] = place.streetLabelLine
            feature.attributes["addressLineTwo"] = place.cityLabelLine
            return feature
        }
    }
}

fileprivate extension Geo.Place {
    var streetLabelLine: String {
        "\(addressNumber ?? "") \(street ?? "")"
    }
    
    var cityLabelLine: String {
        "\(municipality ?? ""), \(region ?? "") \(postalCode ?? "")"
    }
}
