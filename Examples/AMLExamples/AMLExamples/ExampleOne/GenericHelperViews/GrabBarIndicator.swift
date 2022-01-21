//
// Copyright Amazon.com Inc. or its affiliates.
// All Rights Reserved.
//
// SPDX-License-Identifier: Apache-2.0
//


import SwiftUI

struct GrabBarIndicator: View {
    var body: some View {
        RoundedRectangle(cornerRadius: 22)
            .fill(Color.primary.opacity(0.6))
            .frame(
                width: 30,
                height: 4
            ).onTapGesture {
                /* maybe do something here? */
            }
    }
}
