//
// Copyright Amazon.com Inc. or its affiliates.
// All Rights Reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

import Foundation
import Amplify
import Mapbox

public extension Geo.BoundingBox {
    /// Initialize a BoundingBox from a MGLCoordinateBounds
    /// - Parameter bounds: The CLLocationCoordinate2D to use to initialize the
    /// Location.
    init(_ bounds: MGLCoordinateBounds) {
        let southwest = Geo.Coordinates(bounds.sw)
        let northeast = Geo.Coordinates(bounds.ne)

        self.init(southwest: southwest, northeast: northeast)
    }
}
