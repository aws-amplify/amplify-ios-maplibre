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

/// `AMLMapView` including standard the view components: `AMLSearchBar`, `AMLMapControlView`, and `AMLPlaceCellView`.
public struct AMLMapCompositeView: View {
    typealias CreateMap = (@escaping (Result<MGLMapView, Geo.Error>) -> Void) -> Void
        
    /// The center coordinates of the currently displayed area of the map.
    @Binding var center: CLLocationCoordinate2D
    
    /// The coordinate bounds of the currently displayed area of the map.
    @Binding var bounds: MGLCoordinateBounds
    
    /// Current zoom level of the map.
    @Binding var zoomLevel: Double
    
    /// The current heading of the map in degrees.
    @Binding var heading: CLLocationDirection
    
    /// The user's current location.
    @Binding var userLocation: CLLocationCoordinate2D?
    
    /// Features that are displayed on the map.
    @Binding var features: [MGLPointFeature]
    
    /// The attribution string for the map data providers.
    @Binding var attribution: String?
    
    /// The display state of the composite view. Either `map` or `list`
    @Binding var displayState: AMLSearchBar.DisplayState
    
    /// The search text in the included `AMLSearchBar`
    @Binding var searchText: String
    
    /// The result of the asynchronous action to retrieve a `MGLMapView`.
    @State var mapResult: Result<MGLMapView, Geo.Error>?
    
    /// The clustering behavior of the map.
    let clusteringBehavior: AMLMapView.ClusteringBehavior

    /// The implementation used to create an `MGLMapView`.
    var createMap: CreateMap?
    
            
    /// `AMLMapView` including standard the view components: `AMLSearchBar`, `AMLMapControlView`, and `AMLPlaceCellView`.
    ///
    /// - Parameters:
    ///   - mapView: The underlying MGLMapView.
    ///   - zoomLevel: Current zoom level of the map. Default 14
    ///   - bounds: The coordinate bounds of the currently displayed area of the map.
    ///   - center: The center coordinates of the currently displayed area of the map.
    ///   - userLocation: The user's current location.
    ///   If this value exists, it will set `mapView.showsUserLocation` to true. (optional)
    ///   - annotations: Binding of annotations displayed on the map.
    ///   - attribution: The attribution string for the map data providers.
    ///   - displayState: The display state of the composite view. Either `map` or `list`.
    ///   - searchText: The search text in the included `AMLSearchBar`.
    public init(
        mapView: MGLMapView,
        zoomLevel: Binding<Double> = .constant(14),
        bounds: Binding<MGLCoordinateBounds> = .constant(MGLCoordinateBounds()),
        center: Binding<CLLocationCoordinate2D> = .constant(CLLocationCoordinate2D()),
        heading: Binding<CLLocationDirection> = .constant(0),
        userLocation: Binding<CLLocationCoordinate2D?> = .constant(nil),
        features: Binding<[MGLPointFeature]> = .constant([]),
        attribution: Binding<String?> = .constant(nil),
        clusteringBehavior: AMLMapView.ClusteringBehavior = .init(),
        displayState: Binding<AMLSearchBar.DisplayState> = .constant(.map),
        searchText: Binding<String> = .constant("")
    ) {
        _zoomLevel = zoomLevel
        _bounds = bounds
        _center = center
        _heading = heading
        _userLocation = userLocation
        _features = features
        _attribution = attribution
        
        _displayState = displayState
        _searchText = searchText
        self.clusteringBehavior = clusteringBehavior
        self.mapResult = .success(mapView)
    }
    
    /// `AMLMapView` including standard the view components: `AMLSearchBar`, `AMLMapControlView`, and `AMLPlaceCellView`.
    ///
    /// - Parameters:
    ///   - createMap: The implementation used to create an `MGLMapView`.
    ///     Default value is `AmplifyMapLibe.createMap`.
    ///   - zoomLevel: Current zoom level of the map. Default 14
    ///   - bounds: The coordinate bounds of the currently displayed area of the map.
    ///   - center: The center coordinates of the currently displayed area of the map.
    ///   - userLocation: The user's current location. If this value exists, it will set `mapView.showsUserLocation` to true. (optional). __Setting this to true will prompt the user for location permission__
    ///   - annotations: Binding of annotations displayed on the map.
    ///   - attribution: The attribution string for the map data providers.
    ///   - displayState: The display state of the composite view. Either `map` or `list`.
    ///   - searchText: The search text in the included `AMLSearchBar`.
    public init(
        createMap: @escaping (@escaping (Result<MGLMapView, Geo.Error>) -> Void) -> Void = AmplifyMapLibre.createMap,
        zoomLevel: Binding<Double> = .constant(14),
        bounds: Binding<MGLCoordinateBounds> = .constant(MGLCoordinateBounds()),
        center: Binding<CLLocationCoordinate2D> = .constant(CLLocationCoordinate2D()),
        heading: Binding<CLLocationDirection> = .constant(0),
        userLocation: Binding<CLLocationCoordinate2D?> = .constant(nil),
        features: Binding<[MGLPointFeature]> = .constant([]),
        attribution: Binding<String?> = .constant(nil),
        clusteringBehavior: AMLMapView.ClusteringBehavior = .init(),
        displayState: Binding<AMLSearchBar.DisplayState> = .constant(.map),
        searchText: Binding<String> = .constant("")
    ) {
        _zoomLevel = zoomLevel
        _bounds = bounds
        _center = center
        _heading = heading
        _userLocation = userLocation
        _features = features
        _attribution = attribution
        _displayState = displayState
        _searchText = searchText
        self.clusteringBehavior = clusteringBehavior
        self.createMap = createMap
    }
    
    @ObservedObject var viewModel = AMLMapCompositeViewModel()
    
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
                        switch mapResult {
                        case .success(let mapView):
                            AMLMapView(
                                mapView: mapView,
                                zoomLevel: $zoomLevel,
                                bounds: $bounds,
                                center: $center,
                                heading: $heading,
                                features: $viewModel.annotations
                            )
                                .edgesIgnoringSafeArea(.all)
                        case .failure(let error):
                            Text(error.errorDescription)
                        case .none:
                            AMLActivityIndicator()
                                .onAppear {
                                    createMap? { mapResult = $0 }
                                }
                        }
                    }.frame(width: proxy.size.width * 0.67)
                }
                
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
            }
        }
    }
    
    @ViewBuilder private func phoneView() -> some View {
        ZStack(alignment: .top) {
            Color(.secondarySystemBackground)
                .edgesIgnoringSafeArea(.all)
            if displayState == .map {
                switch mapResult {
                case .success(let mapView):
                    AMLMapView(
                        mapView: mapView,
                        zoomLevel: $zoomLevel,
                        bounds: $bounds,
                        center: $center,
                        heading: $heading,
                        features: $viewModel.annotations
                    )
                        .edgesIgnoringSafeArea(.all)
                case .failure(let error):
                    Text(error.errorDescription)
                case .none:
                    AMLActivityIndicator()
                        .onAppear {
                            createMap? { mapResult = $0 }
                        }
                }
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
                            zoomValue: zoomLevel,
                            zoomInAction: { zoomLevel += 1 },
                            zoomOutAction: { zoomLevel -= 1 },
                            compassAction: { heading = 0 }
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
        viewModel.annotations = []
    }
    
    func search() {
        viewModel.search(searchText, area: .near(center))
    }
}


/// An internal duplicate of `Geo.Place` that conforms to `Identifiable` for use in SwiftUI views.
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
