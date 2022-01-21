//
// Copyright Amazon.com Inc. or its affiliates.
// All Rights Reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

import SwiftUI

struct FavoritesSectionView: View {
    let moreTapped: () -> Void
    let minWidth: CGFloat
    let favorites: [Favorite]

    var body: some View {
        SectionView(title: "Favorites", moreTapped: moreTapped) {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 25) {
                    ForEach(favorites) {
                        FavoriteView(favorite: $0)
                    }
                }
                .frame(minWidth: minWidth, alignment: .leading)
                .padding(8)
                .background(Color.tertiaryBackground)
                .cornerRadius(8)
            }
        }
    }
}
