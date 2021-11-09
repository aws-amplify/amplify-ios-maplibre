//
// Copyright Amazon.com Inc. or its affiliates.
// All Rights Reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

import SwiftUI

/// Internal child view for AMLMapControlView
struct AMLMapControlButton: View {
    /// On tap action.
    let action: () -> Void
    /// System name of button image.
    let systemName: String

    var body: some View {
        Button(action: action, label: {
            Image(systemName: systemName)
                .font(.title)
                .foregroundColor(.primary)
                .frame(width: 44, height: 44, alignment: .center)
        })
    }
}
