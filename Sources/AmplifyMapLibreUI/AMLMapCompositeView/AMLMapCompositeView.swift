//
// Copyright Amazon.com Inc. or its affiliates.
// All Rights Reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

import SwiftUI
import CoreLocation
import Mapbox
import Amplify
import AmplifyMapLibreAdapter

/// `AMLMapView` including standard the view components:
/// `AMLSearchBar`, `AMLMapControlView`, and `AMLPlaceCellView`.
public struct AMLMapCompositeView: View {
    @ObservedObject var viewModel: AMLMapCompositeViewModel

    /// Create a new `AMLMapCompositeView`.
    ///
    /// To create a full user experience, this leverages
    /// - `AMLMapView`
    /// - `AMLSearchBar`
    /// - `AMLMapControlView`
    /// - `AMLPlaceCellView`
    ///
    /// For more layout customizability, use `AMLMapView` directly.
    /// - Parameter viewModel: The `AMLMapCompositeViewModel`
    /// that is configured with a `AMLMapViewState` object. Default implementations provided.
    public init(viewModel: AMLMapCompositeViewModel = .init()) {
        self.viewModel = viewModel
    }

    public var body: some View {
        if UIDevice.current.userInterfaceIdiom == .phone {
            phoneView()
        } else {
            padView()
        }
    }
}
