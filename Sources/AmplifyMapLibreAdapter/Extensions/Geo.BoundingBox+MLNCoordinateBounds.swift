//
// Copyright Amazon.com Inc. or its affiliates.
// All Rights Reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

import Foundation
import Amplify
import MapLibre

public extension Geo.BoundingBox {
    /// Initialize a BoundingBox from a MLNCoordinateBounds
    /// - Parameter bounds: The CLLocationCoordinate2D to use to initialize the
    /// Location.
    init(_ bounds: MLNCoordinateBounds) {
        let southwest = Geo.Coordinates(bounds.sw)
        let northeast = Geo.Coordinates(bounds.ne)

        self.init(southwest: southwest, northeast: northeast)
    }
}
