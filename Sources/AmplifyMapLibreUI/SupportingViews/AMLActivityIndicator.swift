//
// Copyright Amazon.com Inc. or its affiliates.
// All Rights Reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

import SwiftUI

public struct ActivityIndicator: UIViewRepresentable {
    @Binding var isAnimating: Bool
    
    public func makeUIView(context: Context) -> UIActivityIndicatorView {
        UIActivityIndicatorView()
    }
    
    public func updateUIView(
        _ uiView: UIActivityIndicatorView,
        context: Context
    ) {
        if self.isAnimating {
            uiView.startAnimating()
        } else {
            uiView.stopAnimating()
        }
    }
}

struct AcitivtyIndicator_Preview: PreviewProvider {
    static var previews: some View {
        ActivityIndicator(isAnimating: .constant(true))
            .frame(width: 100, height: 100)
            .foregroundColor(.orange)
    }
}
