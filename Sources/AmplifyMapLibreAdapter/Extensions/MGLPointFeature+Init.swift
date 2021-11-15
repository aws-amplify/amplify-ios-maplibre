//
// Copyright Amazon.com Inc. or its affiliates.
// All Rights Reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

import Foundation
import Mapbox

public extension MGLPointFeature {
    /// Initialize an MGLPointFeature with a given title and coordinates
    /// - Parameters:
    ///   - title: The feature title.
    ///   - coordinates: The feature coordinates.
    convenience init(title: String, coordinates: CLLocationCoordinate2D) {
        self.init()
        self.title = title
        self.coordinate = coordinates
    }
}
