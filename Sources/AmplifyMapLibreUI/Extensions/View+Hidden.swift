//
// Copyright Amazon.com Inc. or its affiliates.
// All Rights Reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

import SwiftUI

internal extension View {
    @ViewBuilder func hidden(_ hide: Bool) -> some View {
        opacity(hide ? 0 : 1)
    }
}
