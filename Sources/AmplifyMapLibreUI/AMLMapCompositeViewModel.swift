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
            switch result {
            case.success(let places):
                DispatchQueue.main.async {
                    self?.places = places
                    self?.annotations = places.map(MGLPointFeature.init)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}


