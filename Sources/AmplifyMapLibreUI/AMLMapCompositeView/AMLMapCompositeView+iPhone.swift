//
// Copyright Amazon.com Inc. or its affiliates.
// All Rights Reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

import SwiftUI

extension AMLMapCompositeView {
    /// Layout for iPhone.
    @ViewBuilder internal func phoneView() -> some View {
        ZStack(alignment: .top) {
            Color(.secondarySystemBackground)
                .edgesIgnoringSafeArea(.all)
            
            AMLMapView(
                mapState: viewModel.mapState,
                mapSettings: viewModel.mapSettings
            )
                .edgesIgnoringSafeArea(.all)
            
            if viewModel.displayState == .list {
                Color(.secondarySystemBackground)
                    .edgesIgnoringSafeArea(.all)
            }
            
            VStack(alignment: .center) {
                AMLSearchBar(
                    text: $viewModel.searchText,
                    displayState: $viewModel.displayState,
                    onCommit: viewModel.search,
                    onCancel: viewModel.cancelSearch
                )
                    .padding()
                
                if viewModel.displayState == .map {
                    HStack {
                        Spacer()
                        AMLMapControlView(
                            zoomValue: $viewModel.mapState.zoomLevel,
                            headingValue: $viewModel.mapState.heading
                        )
                    }
                    .padding(.trailing)
                }
                AMLPlaceList(viewModel.places)
                    .hidden(viewModel.displayState == .map)
                Spacer()
            }
        }
    }
}
