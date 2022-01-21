//
// Copyright Amazon.com Inc. or its affiliates.
// All Rights Reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

import SwiftUI

struct FavoriteView: View {
    let favorite: Favorite

    var body: some View {
        VStack {
            Button {
                /* Do thing */
            } label: {
                CircularSystemImageView(
                    font: .system(size: 24),
                    systemImageName: favorite.systemImageName,
                    foregroundColor: favorite.imageForegroundColor,
                    backgroundColor: favorite.imageBackgroundColor
                )
            }

            Text(favorite.primaryText)
            Text(favorite.secondaryText)
                .font(.caption)
                .foregroundColor(Color.secondary)
        }
    }
}
