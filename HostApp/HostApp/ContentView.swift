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
        
    var body: some View {
        ZStack(alignment: .top) {
            Color(.secondarySystemBackground)
                .ignoresSafeArea()
            
            if displayState == .map {
                switch mapResult {
                case .success(let map):
                    AMLMapView(
                        mapView: map,
                        zoomLevel: $zoomLevel,
                        bounds: $bounds,
                        center: $center,
                        heading: $heading,
                        annotations: $viewModel.annotations
                    )
                        .mapViewAnnotationCanShowCallout { _, _ in
                            true
                        }
//                        .mapViewDidSelectAnnotation(didSelectAnnotation(_:_:))
                        
                        .edgesIgnoringSafeArea(.all)
                case .failure(let error):
                    Text("Error \(error.errorDescription)")
                case .none:
                    Text("something went wrong")
                        .onAppear {
                            AmplifyMapLibre.createMap {
                                mapResult = $0
                            }
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
                            compassAction: {
                                print(heading)
                                heading = 0
                            }
                        )
                    }
                    .padding(.trailing)
                } else {
                    List(viewModel.places) { place in
                        AMLPlaceCellView(place: .init(place))
                    }
                    .listStyle(InsetGroupedListStyle())
//                    AMLPlaceList(viewModel.places)
//                    .ignoresSafeArea()
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
