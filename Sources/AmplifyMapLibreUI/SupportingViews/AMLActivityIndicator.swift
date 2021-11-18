//
// Copyright Amazon.com Inc. or its affiliates.
// All Rights Reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

import SwiftUI

/// A SwiftUI Wrapper around `UIActivityIndicatorView`.
public struct AMLActivityIndicator: UIViewRepresentable {

    /// Binding that determines whether the acitivty indicator is animating.
    @Binding var isAnimating: Bool

    /// A SwiftUI Wrapper around `UIActivityIndicatorView`
    /// - Parameter isAnimating: Binding that determines whether the acitivty indicator is animating.
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
        if isAnimating {
            uiView.startAnimating()
        } else {
            uiView.stopAnimating()
        }
    }
}

/// SwiftUI preview for `AMLActivityIndicator`
public struct AMLActivityIndicator_Preview: PreviewProvider { // swiftlint:disable:this type_name
    public static var previews: some View {
        AMLActivityIndicator(isAnimating: .constant(true))
            .frame(width: 100, height: 100)
            .foregroundColor(.orange)
    }
}
