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

public class AMLMapCompositeViewModel: ObservableObject {
    @Published var places: [Geo.Place] = []
    @ObservedObject var mapState: AMLMapViewState

    /// The display state of the composite view. Either `map` or `list`
    @Published var displayState: AMLSearchBar.DisplayState = .map

    /// The search text in the included `AMLSearchBar`
    @Published var searchText: String = ""

    
    public init(mapState: AMLMapViewState) {
        self.mapState = mapState
    }
    
    func search() {
        let text = searchText
        let searchOptions = Geo.SearchForTextOptions(area: .near(mapState.center))
        Amplify.Geo.search(for: text, options: searchOptions) { [weak self] result in
            switch result {
            case.success(let places):
                DispatchQueue.main.async {
                    self?.places = places
                    self?.mapState.features = AmplifyMapLibre.createFeatures(places)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func cancelSearch() {
        mapState.features = []
        places = []
    }
}

