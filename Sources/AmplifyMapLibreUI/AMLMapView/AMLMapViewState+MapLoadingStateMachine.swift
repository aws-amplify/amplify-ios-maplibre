//
// Copyright Amazon.com Inc. or its affiliates.
// All Rights Reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

import SwiftUI
import MapLibre
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
        case complete(MLNMapView)
        /// Fetching has completed unsuccessfully.
        case error(Geo.Error)
    }

    /// Transition to a new state based on a `Result<MLNMapView, Geo.Error>`
    /// - Parameters:
    ///   - input: The async operation's result.
    ///   - map: An optional `MLNMapView` that gets assigned if the `Result` was successful.
    mutating func transition(
        input: Result<MLNMapView, Geo.Error>,
        assign map: inout MLNMapView?
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
