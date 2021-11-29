//
// Copyright Amazon.com Inc. or its affiliates.
// All Rights Reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

import SwiftUI

/// Internal AttributionView for AMLMap
struct AMLMapAttributionView: View {

    @Binding var isAttributionTextDisplayed: Bool
    let attributionText: String?

    var body: some View {
        if  isAttributionTextDisplayed {
            Text(attributionText ?? "MapLibre Maps SDK for iOS")
                .font(.system(size: 12))
                .fixedSize(horizontal: false, vertical: true)
                .multilineTextAlignment(.center)
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 12.5)
                        .fill(Color.white)
                )
                .onTapGesture {
                    isAttributionTextDisplayed.toggle()
                }
                .padding()
                .padding(.bottom)
        } else {
            HStack {
                Spacer()
                Button {
                    isAttributionTextDisplayed.toggle()
                } label: {
                    Image(systemName: "info.circle")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 22, height: 22)
                        .padding()
                        .padding(.bottom)
                }
            }
        }
    }
}
