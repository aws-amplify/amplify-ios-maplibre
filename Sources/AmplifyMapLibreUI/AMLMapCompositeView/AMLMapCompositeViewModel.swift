//
// Copyright Amazon.com Inc. or its affiliates.
// All Rights Reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

import SwiftUI
import MapLibre
import Amplify
import AmplifyMapLibreAdapter

public class AMLMapCompositeViewModel: ObservableObject {
    /// Places to be displayed in `AMLPlaceList`.
    @Published var places: [Geo.Place] = []

    /// Tracks state changes in the map.
    @ObservedObject public var mapState: AMLMapViewState

    /// Defines settings in the map.
    @ObservedObject var mapSettings = AMLMapViewSettings()

    /// The display state of the composite view. Either `map` or `list`
    @Published var displayState: AMLSearchBar.DisplayState = .map

    /// The search text in the included `AMLSearchBar`
    @Published var searchText: String = ""

    /// Instantiate a view model for `AMLMapCompositeView`.
    /// - Parameter mapState: The map state object used to track state changes.
    public init(mapState: AMLMapViewState = .init()) {
        self.mapState = mapState
    }

    /// Internal search implementation. Called when user taps `search` or `go` on keyboard.
    func search() {
        let text = searchText
        let searchOptions = Geo.SearchForTextOptions(area: .near(mapState.center))
        Task {
            do {
                let places = try await Amplify.Geo.search(for: text, options: searchOptions)
                self.places = places
                self.mapState.features = AmplifyMapLibre.createFeatures(places)
            } catch {
                print(error)
            }
        }
    }

    /// Internal cancel search implementation. Called when user taps `x` button in `AMLSearchBar`.
    func cancelSearch() {
        mapState.features = []
        places = []
    }
}
