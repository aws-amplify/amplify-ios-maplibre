//
// Copyright Amazon.com Inc. or its affiliates.
// All Rights Reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

import SwiftUI

struct CircularSystemImageView: View {
    let font: Font
    let systemImageName: String
    let foregroundColor: Color
    let backgroundColor: Color

    var body: some View {
        Image(systemName: systemImageName)
            .font(font)
            .foregroundColor(foregroundColor)
            .padding()
            .background(backgroundColor)
            .clipShape(Circle())
    }
}
