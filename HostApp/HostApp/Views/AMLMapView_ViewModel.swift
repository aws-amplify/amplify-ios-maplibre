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

// swiftlint:disable:next type_name
class AMLMapView_ViewModel: ObservableObject {

    @Published var places: [Geo.Place] = []
    @ObservedObject var mapState = AMLMapViewState(userLocation: .init())
    @Published var mapDisplayState = AMLSearchBar.DisplayState.map

    func search(
        _ text: String,
        area: Geo.SearchArea
    ) {
        Task {
            do {
                let places = try await Amplify.Geo.search(for: text, options: .init(area: area))
                self.places = places
                self.mapState.features = AmplifyMapLibre.createFeatures(places)
            } catch {
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
