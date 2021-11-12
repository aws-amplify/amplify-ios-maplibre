//
// Copyright Amazon.com Inc. or its affiliates.
// All Rights Reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

import SwiftUI

public struct AMLActivityIndicator: UIViewRepresentable {
    @Binding var isAnimating: Bool
    
    public init(isAnimating: Binding<Bool> = .constant(true)) {
        _isAnimating = isAnimating
    }
    
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

struct AMLActivityIndicator_Preview: PreviewProvider {
    static var previews: some View {
        AMLActivityIndicator(isAnimating: .constant(true))
            .frame(width: 100, height: 100)
            .foregroundColor(.orange)
    }
}
