//
// Copyright Amazon.com Inc. or its affiliates.
// All Rights Reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

import Foundation
import Amplify
import MapLibre

public extension Geo.SearchArea {
    /// Creates a SearchArea that only returns places within the provided
    /// MLNCoordinateBounds.
    /// - Parameter bounds: The bounds for the search area.
    /// - Returns: The SearchArea.
    static func within(_ bounds: MLNCoordinateBounds) -> Geo.SearchArea {
        .within(Geo.BoundingBox(bounds))
    }
}
