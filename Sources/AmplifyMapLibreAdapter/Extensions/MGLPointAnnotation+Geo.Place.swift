//
// Copyright Amazon.com Inc. or its affiliates.
// All Rights Reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

import Foundation
import Mapbox
import Amplify

public extension MGLPointAnnotation {
    /// Initialize an MGLPointAnnotation with the title and coordinates of a given Geo.Place
    /// - Parameter place: The Geo.Place from which to initialize the MGLPointAnnotation.
    convenience init(_ place: Geo.Place) {
        self.init()
        self.title = place.label
        self.coordinate = CLLocationCoordinate2D(place.coordinates)
    }
}
