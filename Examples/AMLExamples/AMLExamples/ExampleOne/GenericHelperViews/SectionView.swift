//
// Copyright Amazon.com Inc. or its affiliates.
// All Rights Reserved.
//
// SPDX-License-Identifier: Apache-2.0
//


import SwiftUI

struct SectionView<Content: View>: View {
    let title: String
    let moreTapped: () -> Void
    let content: Content

    init(
        title: String,
        moreTapped: @escaping () -> Void,
        @ViewBuilder content: () -> Content
    ) {
        self.title = title
        self.moreTapped = moreTapped
        self.content = content()
    }

    var body: some View {
        VStack {
            SectionHeader(title: title, moreTapped: moreTapped)
            content
        }
    }
}
