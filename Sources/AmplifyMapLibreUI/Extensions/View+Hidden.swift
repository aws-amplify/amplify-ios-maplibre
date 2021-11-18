//
// Copyright Amazon.com Inc. or its affiliates.
// All Rights Reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

import SwiftUI

internal extension View {
    /// Set a `View`'s opacity to `0` (true) or `1` (false).
    ///
    /// Helpful when you want to hide a view based on a condition, but don't want to remove it from the view hierarchy.
    /// - Parameter hide: Whether the view is hidden or not.
    /// - Returns: `some View`
    @ViewBuilder func hidden(_ hide: Bool) -> some View {
        opacity(hide ? 0 : 1)
    }
}
