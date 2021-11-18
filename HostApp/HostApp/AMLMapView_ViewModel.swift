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

// swiftlint:disable type_name
class AMLMapView_ViewModel: ObservableObject {
// swiftlint:enable type_name

    @Published var places: [Geo.Place] = []
    @ObservedObject var mapState = AMLMapViewState(userLocation: .init())
    @Published var mapDisplayState = AMLSearchBar.DisplayState.map

    func search(
        _ text: String,
        area: Geo.SearchArea
    ) {
        Amplify.Geo.search(for: text, options: .init(area: area)) { [weak self] result in
            switch result {
            case .success(let places):
                DispatchQueue.main.async {
                    self?.places = places
                    self?.mapState.features = AmplifyMapLibre.createFeatures(places)
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
