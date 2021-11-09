//
//  ContentView.swift
//  HostApp
//
//  Created by Saultz, Ian on 10/26/21.
//

import SwiftUI
import AmplifyMapLibreAdapter
import AmplifyMapLibreUI
import CoreLocation
import Mapbox
import Amplify

struct ContentView: View {
    
    @State private var center: CLLocationCoordinate2D = .init(latitude: 37.785834, longitude: -122.406417)
    @State private var bounds = MGLCoordinateBounds()
    @State private var zoomLevel: Double = 14
    
    @State private var mapResult: Result<MGLMapView, Geo.Error>?
    
    var body: some View {
        ZStack(alignment: .top) {
            switch mapResult {
            case .success(let map):
                AMLMapView(
                    mapView: map,
                    zoomLevel: $zoomLevel,
                    bounds: $bounds,
                    center: $center
                )
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
            
            HStack {
                Spacer()
                AMLMapControlView(
                    zoomValue: zoomLevel,
                    zoomInAction: { zoomLevel += 1 },
                    zoomOutAction: { zoomLevel -= 1 },
                    compassAction: {}
                )
            }
            .padding(.trailing)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
