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
import Combine

struct ContentView: View {
    @State private var displayState = AMLSearchBar.DisplayState.map
    @State private var searchText = ""
    
    @ObservedObject var viewModel = ContentViewModel()
    @ObservedObject var mapState = AMLMapViewState(
        center: CLLocationCoordinate2D(
            latitude: 37.785834,
            longitude: -122.406417
        )
    )
    
    var body: some View {
        ZStack(alignment: .top) {
            Color(.secondarySystemBackground)
                .ignoresSafeArea()
            AMLMapView(
                features: $viewModel.features,
                mapState: mapState
            )
                .clusterColor(.purple)
                .onReceive(mapState.$heading, perform: { heading in
                    print(heading)
                })
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
                            zoomValue: mapState.zoomLevel,
                            zoomInAction: { mapState.zoomLevel += 1 },
                            zoomOutAction: { mapState.zoomLevel -= 1 },
                            compassAction: { mapState.heading = 0 }
                        )
                    }
                    .padding(.trailing)
                } else {
                    List(viewModel.places) { place in
                        AMLPlaceCellView(place: .init(place))
                    }
                    .listStyle(InsetGroupedListStyle())
                    .ignoresSafeArea()
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
