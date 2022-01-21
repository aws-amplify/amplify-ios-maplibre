//
// Copyright Amazon.com Inc. or its affiliates.
// All Rights Reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

import SwiftUI

struct SectionHeader: View {
    let title: String
    let moreTapped: () -> Void

    var body: some View {
        HStack {
            Text(title)
                .font(.callout)
                .fontWeight(.medium)
                .foregroundColor(.secondary)
            Spacer()
            Button("More") {
                moreTapped()
            }.font(.caption)
        }
    }
}
