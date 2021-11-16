//
// Copyright Amazon.com Inc. or its affiliates.
// All Rights Reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

import SwiftUI
import Mapbox
import Amplify

/// Internal
struct MapCreationStateMachine {
    var state: State
    
    enum State {
        case begin
        case complete(MGLMapView)
        case error(Geo.Error)
    }
    
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
