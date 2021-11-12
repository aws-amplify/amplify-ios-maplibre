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

public struct AMLMapCompositeView: View {
    
    let mapView: MGLMapView
    
    @Binding var center: CLLocationCoordinate2D
    @Binding var bounds: MGLCoordinateBounds
    @Binding var zoomLevel: Double
    @Binding var heading: CLLocationDirection
    @Binding var displayState: AMLSearchBar.DisplayState
    @Binding var searchText: String
    
    public init(
        center: Binding<CLLocationCoordinate2D>,
        bounds: Binding<MGLCoordinateBounds>,
        zoomLevel: Binding<Double>,
        heading: Binding<CLLocationDirection>,
        displayState: Binding<AMLSearchBar.DisplayState>,
        searchText: Binding<String>,
        mapView: MGLMapView
    ) {
        _center = center
        _bounds = bounds
        _zoomLevel = zoomLevel
        _heading = heading
        _displayState = displayState
        _searchText = searchText
        self.mapView = mapView
    }
    
    @ObservedObject var viewModel = AMLMapCompositeViewModel()
    
    public var body: some View {
        ZStack(alignment: .top) {
            backgroundColor()
            AMLMapView(
                mapView: mapView,
                zoomLevel: $zoomLevel,
                bounds: $bounds,
                center: $center,
                heading: $heading,
                annotations: $viewModel.annotations
            )
                .mapViewAnnotationCanShowCallout { _, _ in
                    true
                }
                .edgesIgnoringSafeArea(.all)
            
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
                            zoomValue: zoomLevel,
                            zoomInAction: { zoomLevel += 1 },
                            zoomOutAction: { zoomLevel -= 1 },
                            compassAction: { heading = 0 }
                        )
                    }
                    .padding(.trailing)
                } else {
                    AnyView(list())
                }
                Spacer()
            }
        }
    }
    
    @ViewBuilder func backgroundColor() -> some View {
        if #available(iOS 14, *) {
            Color(.secondarySystemBackground)
                .ignoresSafeArea()
        } else {
            Color(.secondarySystemBackground)
                .edgesIgnoringSafeArea([.top, .bottom])
        }
    }
    
    @ViewBuilder private func list() -> some View {
        if #available(iOS 14.0, *) {
            List(viewModel.places.map(_Place.init)) { place in
                AMLPlaceCellView(place: .init(place))
            }
            .listStyle(InsetGroupedListStyle())
        } else {
            List(viewModel.places.map(_Place.init)) { place in
                AMLPlaceCellView(place: .init(place))
            }
            .listStyle(GroupedListStyle())
        }
    }
    
    func cancelSearch() {
        viewModel.annotations = []
    }
    
    func search() {
        viewModel.search(searchText, area: .near(center))
    }
    
}


struct _Place: Identifiable {
    let id = UUID()
    /// The coordinates of the place. (required)
    public let coordinates: Geo.Coordinates
    /// The full name and address of the place.
    public let label: String?
    /// The numerical portion of the address of the place, such as a building number.
    public let addressNumber: String?
    /// The name for the street or road of the place. For example, Main Street.
    public let street: String?
    /// The name of the local area of the place, such as a city or town name. For example, Toronto.
    public let municipality: String?
    /// The name of a community district.
    public let neighborhood: String?
    /// The name for the area or geographical division, such as a province or state
    /// name, of the place. For example, British Columbia.
    public let region: String?
    /// An area that's part of a larger region for the place.  For example, Metro Vancouver.
    public let subRegion: String?
    /// A group of numbers and letters in a country-specific format, which accompanies
    /// the address for the purpose of identifying the place.
    public let postalCode: String?
    /// The country of the place.
    public let country: String?
    
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
