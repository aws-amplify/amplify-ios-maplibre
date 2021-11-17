//
// Copyright Amazon.com Inc. or its affiliates.
// All Rights Reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

import Amplify

extension Geo.Place {
    /// Internal initializer to create `Geo.Place` from `_Place`.
    internal init(_ place: _Place) {
        self.init(
            coordinates: place.coordinates,
            label: place.label,
            addressNumber: place.addressNumber,
            street: place.street,
            municipality: place.municipality,
            neighborhood: place.neighborhood,
            region: place.region,
            subRegion: place.subRegion,
            postalCode: place.postalCode,
            country: place.country
        )
    }
}
