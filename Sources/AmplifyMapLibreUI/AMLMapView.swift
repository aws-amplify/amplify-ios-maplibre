//
// Copyright Amazon.com Inc. or its affiliates.
// All Rights Reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

import SwiftUI
import Amplify
import AWSLocationGeoPlugin
import Mapbox

/// SwiftUI Wrapper for MGLMapView.
public struct AMLMapView: UIViewRepresentable {
    /// Underlying MGLMapView.
    let mapView: MGLMapView
    /// The coordinate bounds of the currently displayed area of the map.
    @Binding var bounds: MGLCoordinateBounds
    /// The center coordinates of the currently displayed area of the map.
    @Binding var center: CLLocationCoordinate2D
    /// The user's current location.
    @Binding var userLocation: CLLocationCoordinate2D
    /// The attribution string for the map data providers.
    @Binding var attribution: String
    /// Current zoom level of the map
    @Binding var zoomLevel: Double
    
    /// Initialize an instance of AMLMapView.
    ///
    /// A SwiftUI wrapper View around MGLMapView
    /// - Parameters:
    ///   - mapView: The underlying MGLMapView.
    ///   - zoomLevel: Current zoom level of the map. Default 14
    ///   - bounds: The coordinate bounds of the currently displayed area of the map.
    ///   - center: The center coordinates of the currently displayed area of the map.
    ///   - userLocation: The user's current location.
    ///   - attribution: The attribution string for the map data providers.
    ///   - map: An instance of MGLMapView.  This can be passed to customize the
    ///   underlying map. (optional)
    public init(
        mapView: MGLMapView,
        zoomLevel: Binding<Double> = .constant(14),
        bounds: Binding<MGLCoordinateBounds> = .constant(MGLCoordinateBounds()),
        center: Binding<CLLocationCoordinate2D> = .constant(CLLocationCoordinate2D()),
        userLocation: Binding<CLLocationCoordinate2D> = .constant(CLLocationCoordinate2D()),
        attribution: Binding<String> = .constant("")
    ) {
        self.mapView = mapView
        _bounds = bounds
        _center = center
        _userLocation = userLocation
        _attribution = attribution
        _zoomLevel = zoomLevel
        self.mapView.centerCoordinate = center.wrappedValue
        self.mapView.zoomLevel = zoomLevel.wrappedValue
        self.mapView.logoView.isHidden = true
        self.mapView.showsUserLocation = true
    }
    
    public func makeUIView(context: UIViewRepresentableContext<AMLMapView>) -> MGLMapView {
        mapView.delegate = context.coordinator
        return mapView
    }
    
    public func updateUIView(_ uiView: MGLMapView, context: UIViewRepresentableContext<AMLMapView>) {
        guard uiView.zoomLevel != zoomLevel else { return }
        uiView.setZoomLevel(zoomLevel, animated: true)
    }
    
    public func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
}
