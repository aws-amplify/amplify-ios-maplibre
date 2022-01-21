//
// Copyright Amazon.com Inc. or its affiliates.
// All Rights Reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

import SwiftUI

struct RecentView<DividerView: View>: View {
    let recent: Recent
    let divider: DividerView

    init(
        recent: Recent,
        @ViewBuilder divider: () -> DividerView
    ) {
        self.recent = recent
        self.divider = divider()
    }

    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                CircularSystemImageView(
                    font: .system(size: 16),
                    systemImageName: recent.imageSystemName,
                    foregroundColor: recent.imageForegroundColor,
                    backgroundColor: recent.imageBackgroundColor
                )
                    .padding(8)

                VStack(alignment: .leading) {
                    Text(recent.title)
                        .font(.headline)
                    Text(recent.subtitle)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }

                Spacer()
            }
            .padding(.bottom, 8)

            divider
        }
    }
}
