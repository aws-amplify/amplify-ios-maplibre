//
// Copyright Amazon.com Inc. or its affiliates.
// All Rights Reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

import SwiftUI

struct RecentsSectionView: View {
    let moreTapped: () -> Void
    let recents: [Recent]

    var body: some View {
        SectionView(title: "Recents", moreTapped: moreTapped) {
            VStack {
                ForEach(recents) { recent in
                    RecentView(recent: recent, divider: {
                        if recent != recents.last {
                            Divider()
                        } else {
                            EmptyView()
                        }
                    })
                }
            }
            .padding(.top, 8)
            .background(Color.tertiaryBackground)
            .cornerRadius(8)
        }
    }
}
