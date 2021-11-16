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

struct AMLMapView_View: View {
    @State private var displayState = AMLSearchBar.DisplayState.map
    @State private var searchText = ""
    
    @ObservedObject var viewModel = AMLMapView_ViewModel()
    
    var body: some View {
        ZStack(alignment: .top) {
            Color(.secondarySystemBackground)
                .ignoresSafeArea()
            AMLMapView(
                mapState: viewModel.mapState
            )
                .allowedZoomLevels(5...15)
                .hideAttributionButton(true)
                .compassPosition(.bottomRight)
                .featureView(
                    Image(systemName: "paperplane.circle.fill")
                        .font(.largeTitle)
                        .frame(width: 100, height: 100, alignment: .center)
                )
                .shouldCluster(true)
                .clusterColor(.lightGray)
                .clusterColorSteps(
                    [
                        10: .yellow,
                        20: .green,
                        30: .red
                    ]
                )
                .clusterNumberColor(.systemPink)
                .onReceive(viewModel.mapState.$heading) {
                    print("Heading is now: \($0)")
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
                            zoomValue: $viewModel.mapState.zoomLevel,
                            headingValue: $viewModel.mapState.heading
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
        viewModel.search(searchText, area: .near(viewModel.mapState.center))
    }
}


struct AMLMapView_View_Previews: PreviewProvider {
    static var previews: some View {
        AMLMapView_View()
    }
}

//extension AMLMapView_View {
//    private func didSelectAnnotation(_ mapView: MGLMapView, _ annotation: MGLAnnotation) {
//        let camera = MGLMapCamera(
//            lookingAtCenter: annotation.coordinate,
//            altitude: mapView.camera.altitude,
//            pitch: mapView.camera.pitch,
//            heading: mapView.camera.heading
//        )
//        mapView.fly(
//            to: camera,
//            withDuration: 0.5,
//            peakAltitude: 3000,
//            completionHandler: { mapView.selectAnnotation(annotation, animated: false, completionHandler: nil) }
//        )
//    }
//}


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
