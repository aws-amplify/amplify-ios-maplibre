//
// Copyright Amazon.com Inc. or its affiliates.
// All Rights Reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

import SwiftUI
import AmplifyMapLibreAdapter
import AmplifyMapLibreUI
import CoreLocation
import Mapbox
import Amplify

struct ContentView: View {

    @State private var center: CLLocationCoordinate2D = .init(
        latitude: 37.785834,
        longitude: -122.406417
    )
    
    @State private var bounds = MGLCoordinateBounds()
    @State private var zoomLevel: Double = 14
    @State private var heading: CLLocationDirection = 0
    @State private var mapResult: Result<MGLMapView, Geo.Error>?
    @State private var displayState = AMLSearchBar.DisplayState.map
    @State private var searchText = ""
    
    @ObservedObject var viewModel = ContentViewModel()
    @ObservedObject var vm = MyViewModel.init(showUserLocation: false, minZoomLevel: 0, maxZoomLevel: 15, hideAttributionButton: true, compassPosition: .bottomRight)
        
    var body: some View {
        ZStack(alignment: .top) {
            Color(.secondarySystemBackground)
                .ignoresSafeArea()
            
            if displayState == .map {
                //                AMLMapView(
                //                    zoomLevel: $zoomLevel,
                //                    bounds: $bounds,
                //                    center: $center,
                //                    heading: $heading,
                //                    features: $viewModel.annotations
                //                )
                
                AMLMapView(viewModel: vm)
//                    .featureTapped({ mapView, pointFeature in
//                        print("FEATURE TAPPED \(#line) - \(#fileID)")
//                        print(pointFeature)
//                    })
                    .edgesIgnoringSafeArea(.all)

//                AMLMapView(
//                    options: .init(
//                        zoomLevel: $zoomLevel,
//                        bounds: $bounds,
//                        center: $center,
//                        heading: $heading,
//                        features: $viewModel.annotations
//                    )
//                )
//                    .featureTapped({ mapView, pointFeature in
//                        print("Feature tapped at \(#line)")
//                        dump(pointFeature)
//                    })
//                switch mapResult {
//                case .success(let map):
//
//
//                case .failure(let error):
//                    Text("Error \(error.errorDescription)")
//                case .none:
//                    Text("something went wrong")
//                        .onAppear {
//                            AmplifyMapLibre.createMap {
//                                mapResult = $0
//                            }
//                        }
//                }
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
                            zoomValue: vm.zoomLevel,
                            zoomInAction: { vm.zoomLevel += 1 },
                            zoomOutAction: { vm.zoomLevel -= 1 },
                            compassAction: { vm.heading = 0 }
                        )
                    }
                    .padding(.trailing)
                } else {
                    
//                    List(vm.places) { place in
//                        AMLPlaceCellView(place: .init(place))
//                    }
//                    .listStyle(InsetGroupedListStyle())
//                    AMLPlaceList(viewModel.places)
//                    .ignoresSafeArea()
                }
                Spacer()
            }
        }
    }
    
    func cancelSearch() {
        vm.features = []
    }
    
    func search() {
        vm.search(searchText, area: .near(center))
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

extension ContentView {
    private func didSelectAnnotation(_ mapView: MGLMapView, _ annotation: MGLAnnotation) {
        let camera = MGLMapCamera(
            lookingAtCenter: annotation.coordinate,
            altitude: mapView.camera.altitude,
            pitch: mapView.camera.pitch,
            heading: mapView.camera.heading
        )
        mapView.fly(
            to: camera,
            withDuration: 0.5,
            peakAltitude: 3000,
            completionHandler: { mapView.selectAnnotation(annotation, animated: false, completionHandler: nil) }
        )
    }
}


extension Geo.Place {
    init(_ place: Place) {
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
