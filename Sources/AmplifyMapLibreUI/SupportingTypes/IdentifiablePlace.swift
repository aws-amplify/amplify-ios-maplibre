//
// Copyright Amazon.com Inc. or its affiliates.
// All Rights Reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

import SwiftUI
import Amplify

/// An IdentifiablePlace and from a `Geo.Place` for use in SwiftUI views requiring `Identifiable` conformance.
/// - Important: The `id` property is generated on creation and associated with a `Geo.Place`.
@dynamicMemberLookup
public struct IdentifiablePlace: Identifiable {
    public let id = UUID()
    public let place: Geo.Place

    /// Create a IdentifiablePlace for SwiftUI views requiring `Identifiable` conformance.
    /// - Parameter place: The underlying `Geo.Place`
    public init(_ place: Geo.Place) {
        self.place = place
    }

    public subscript<T>(dynamicMember keyPath: KeyPath<Geo.Place, T>) -> T {
        return place[keyPath: keyPath]
    }
}
