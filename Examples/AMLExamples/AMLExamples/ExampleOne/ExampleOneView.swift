//
// Copyright Amazon.com Inc. or its affiliates.
// All Rights Reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

import SwiftUI
import AmplifyMapLibreUI

struct ExampleOneView: View {
    @StateObject var viewModel = ExampleOneViewModel()

    var body: some View {
        GeometryReader { proxy in
            ZStack {
                AMLMapView(mapState: viewModel.mapState)
                    .maxZoomLevel(17)
                    .edgesIgnoringSafeArea(.all)

                BottomSheetView(displayState: $viewModel.bottomSheetDisplayState) {
                    HStack {
                        AMLSearchBar(
                            text: $viewModel.searchBarText,
                            displayState: .constant(.map),
                            onEditing: { viewModel.bottomSheetDisplayState = .fullScreen },
                            onCommit: viewModel.search,
                            onCancel: viewModel.cancelSearch,
                            showDisplayStateButton: false
                        )
                        Image(systemName: "person.crop.circle.fill")
                            .font(.system(size: 28))
                    }
                    .padding([.leading, .trailing])

                    ScrollView(viewModel.scrollViewAxes, showsIndicators: false) {
                        if viewModel.displayPlacesInBottomSheetContent {
                            SearchResultsView(places: viewModel.places)
                        } else {
                            VStack(spacing: 28) {
                                FavoritesSectionView(
                                    moreTapped: {},
                                    minWidth: proxy.size.width,
                                    favorites: .mock
                                )

                                RecentsSectionView(
                                    moreTapped: {},
                                    recents: .mock
                                )
                            }
                        }
                    }
                    .padding()
                }
                .edgesIgnoringSafeArea(.all)
            }
        }
    }
}

struct ExampleOneView_Previews: PreviewProvider {
    static var previews: some View {
        ExampleOneView()
    }
}
