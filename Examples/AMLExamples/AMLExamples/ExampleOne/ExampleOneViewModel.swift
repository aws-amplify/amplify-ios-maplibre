//
// Copyright Amazon.com Inc. or its affiliates.
// All Rights Reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

import SwiftUI
import Amplify
import AmplifyMapLibreAdapter
import AmplifyMapLibreUI

class ExampleOneViewModel: ObservableObject {
    @ObservedObject var mapState = AMLMapViewState()
    @Published var places: [IdentifiablePlace] = []
    @Published var bottomSheetDisplayState: BottomSheetDisplayState = .halfScreen
    @Published var searchBarText: String = ""
    @Published var displayPlacesInBottomSheetContent = false

    func search() {
        Task { @MainActor in
            let places = try await geoSearch(
                for: searchBarText,
                options: .init(area: .near(mapState.center))
            )
            self.places = places.map(IdentifiablePlace.init)
            self.mapState.features = AmplifyMapLibre.createFeatures(places)
            self.bottomSheetDisplayState = .halfScreen
            self.displayPlacesInBottomSheetContent = true
        }
    }

    private func geoSearch(for text: String, options: Geo.SearchForTextOptions) async throws -> [Geo.Place] {
        try await withCheckedThrowingContinuation { continuation in
            Amplify.Geo.search(
                for: text,
                options: options,
                completionHandler: continuation.resume(with:)
            )
        }
    }

    var scrollViewAxes: Axis.Set {
        bottomSheetDisplayState == .fullScreen
        ? .vertical
        : []
    }

    func cancelSearch() {
        bottomSheetDisplayState = .halfScreen
        displayPlacesInBottomSheetContent = false
    }
}
