//
// Copyright Amazon.com Inc. or its affiliates.
// All Rights Reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

import SwiftUI
import Mapbox
import Amplify

/// Simple internal state machine representing the different stages of loading a map asynchronously.
struct MapCreationStateMachine {
    /// The current state.
    var state: State

    /// The underlying state cases.
    enum State {
        /// Async fetching should begin.
        case begin
        /// Fetching has completed successfully.
        case complete(MGLMapView)
        /// Fetching has completed unsuccessfully.
        case error(Geo.Error)
    }

    /// Transition to a new state based on a `Result<MGLMapView, Geo.Error>`
    /// - Parameters:
    ///   - input: The async operation's result.
    ///   - map: An optional `MGLMapView` that gets assigned if the `Result` was successful.
    mutating func transition(
        input: Result<MGLMapView, Geo.Error>,
        assign map: inout MGLMapView?
    ) {
        switch input {
        case .success(let mapView):
            map = mapView
            state = .complete(mapView)
        case .failure(let error):
            state = .error(error)
        }
    }
}
