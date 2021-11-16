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
    @ObservedObject var mapState: AMLMapViewState
    @ObservedObject var mapSettings = AMLMapViewSettings()
    @ObservedObject var viewModel: AMLMapCompositeViewModel
    
    /// The display state of the composite view. Either `map` or `list`
    @State var displayState: AMLSearchBar.DisplayState = .map
    
    /// The search text in the included `AMLSearchBar`
    @Binding var searchText: String

    public init(
        mapState: AMLMapViewState = .init(),
        searchText: Binding<String> = .constant(""),
        viewModel: AMLMapCompositeViewModel = .init()
    ) {
        _searchText = searchText
        self.viewModel = viewModel
        self.mapState = mapState
    }
    
    public var body: some View {
        if UIDevice.current.userInterfaceIdiom == .phone {
            phoneView()
        } else {
            padView()
        }
    }

    @ViewBuilder private func padView() -> some View {
        GeometryReader { proxy in
            ZStack(alignment: .top) {
                Color(.secondarySystemBackground)
                    .edgesIgnoringSafeArea(.all)

                HStack {
                    VStack {
                        AMLSearchBar(
                            text: $searchText,
                            displayState: $displayState,
                            onCommit: search,
                            onCancel: cancelSearch,
                            showDisplayStateButton: false
                        )
                            .padding()

                        AMLPlaceList(viewModel.places)
                            .frame(width: proxy.size.width * 0.33)

                        Spacer()
                    }

                    Group {
                        AMLMapView(mapState: mapState)
                            .edgesIgnoringSafeArea(.all)
                    }.frame(width: proxy.size.width * 0.67)
                }

                HStack {
                    Spacer()
                    AMLMapControlView(
                        zoomValue: $mapState.zoomLevel,
                        headingValue: $mapState.heading
                    )
                }
                .padding(.trailing)
            }
        }
    }

    @ViewBuilder private func phoneView() -> some View {
        ZStack(alignment: .top) {
            Color(.secondarySystemBackground)
                .edgesIgnoringSafeArea(.all)
            
            if displayState == .map {
                AMLMapView(mapState: mapState)
                    .edgesIgnoringSafeArea(.all)
            }

            VStack(alignment: .center) {
                AMLSearchBar(
                    text: $searchText,
                    displayState: $displayState,
                    onCommit: search,
                    onCancel: cancelSearch
                )
                    .padding()

                if displayState == .map {
                    HStack {
                        Spacer()
                        AMLMapControlView(
                            zoomValue: $mapState.zoomLevel,
                            headingValue: $mapState.heading
                        )
                    }
                    .padding(.trailing)
                } else {
                    AMLPlaceList(viewModel.places)
                }
                Spacer()
            }
        }
    }

    func cancelSearch() {
        viewModel.features = []
    }

    func search() {
        viewModel.search(searchText, area: .near(mapState.center))
    }
}

/// An internal duplicate of `Geo.Place` that conforms to `Identifiable` for use in SwiftUI views.
struct _Place: Identifiable {
    let id = UUID()
    /// The coordinates of the place. (required)
    let coordinates: Geo.Coordinates
    /// The full name and address of the place.
    let label: String?
    /// The numerical portion of the address of the place, such as a building number.
    let addressNumber: String?
    /// The name for the street or road of the place. For example, Main Street.
    let street: String?
    /// The name of the local area of the place, such as a city or town name. For example, Toronto.
    let municipality: String?
    /// The name of a community district.
    let neighborhood: String?
    /// The name for the area or geographical division, such as a province or state
    /// name, of the place. For example, British Columbia.
    let region: String?
    /// An area that's part of a larger region for the place.  For example, Metro Vancouver.
    let subRegion: String?
    /// A group of numbers and letters in a country-specific format, which accompanies
    /// the address for the purpose of identifying the place.
    let postalCode: String?
    /// The country of the place.
    let country: String?
    
    /// Initializer
    init(_ place: Geo.Place) {
        self.coordinates = place.coordinates
        self.label = place.label
        self.addressNumber = place.addressNumber
        self.street = place.street
        self.municipality = place.municipality
        self.neighborhood = place.neighborhood
        self.region = place.region
        self.subRegion = place.subRegion
        self.postalCode = place.postalCode
        self.country = place.country
    }
}

extension Geo.Place {
    init(_ place: _Place) {
        self.init(
            coordinates: place.coordinates,
            label: place.label,
            addressNumber: place.addressNumber,
            street: place.street,
            municipality: place.municipality,
            neighborhood: place.neighborhood,
            region: place.region,
            subRegion: place.subRegion,
            postalCode: place.postalCode,
            country: place.country
        )
    }
}
