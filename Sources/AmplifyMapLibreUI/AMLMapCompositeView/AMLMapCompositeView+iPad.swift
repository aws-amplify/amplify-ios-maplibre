//
// Copyright Amazon.com Inc. or its affiliates.
// All Rights Reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

import SwiftUI

extension AMLMapCompositeView {
    /// Split screen layout for iPad.
    @ViewBuilder internal func padView() -> some View {
        GeometryReader { proxy in
            ZStack(alignment: .top) {
                Color(.secondarySystemBackground)
                    .edgesIgnoringSafeArea(.all)
                
                HStack {
                    VStack {
                        AMLSearchBar(
                            text: $viewModel.searchText,
                            displayState: $viewModel.displayState,
                            onCommit: viewModel.search,
                            onCancel: viewModel.cancelSearch,
                            showDisplayStateButton: false
                        )
                            .padding()
                        
                        AMLPlaceList(viewModel.places)
                            .frame(width: proxy.size.width * 0.33)
                        
                        Spacer()
                    }
                    
                    Group {
                        AMLMapView(
                            mapState: viewModel.mapState,
                            mapSettings: viewModel.mapSettings
                        )
                            .edgesIgnoringSafeArea(.all)
                    }.frame(width: proxy.size.width * 0.67)
                }
                
                HStack {
                    Spacer()
                    AMLMapControlView(
                        zoomValue: $viewModel.mapState.zoomLevel,
                        headingValue: $viewModel.mapState.heading
                    )
                }
                .padding(.trailing)
            }
        }
    }
}
