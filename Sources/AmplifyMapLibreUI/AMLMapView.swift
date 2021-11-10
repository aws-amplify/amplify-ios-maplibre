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
    @Binding var userLocation: CLLocationCoordinate2D?
    /// The attribution string for the map data providers.
    @Binding var attribution: String?
    /// Current zoom level of the map
    @Binding var zoomLevel: Double
    /// Annotations that are displayed on the map.
    @Binding var annotations: [MGLPointAnnotation]
    /// The current heading of the map in degrees.
    @Binding var heading: CLLocationDirection
    
    /// Initialize an instance of AMLMapView.
    ///
    /// A SwiftUI wrapper View around MGLMapView
    /// - Parameters:
    ///   - mapView: The underlying MGLMapView.
    ///   - zoomLevel: Current zoom level of the map. Default 14
    ///   - bounds: The coordinate bounds of the currently displayed area of the map.
    ///   - center: The center coordinates of the currently displayed area of the map.
    ///   - userLocation: The user's current location. If this value exists, it will set `mapView.showsUserLocation` to true. (optional)
    ///   - annotations: Binding of annotations displayed on the map.
    ///   - attribution: The attribution string for the map data providers.
    public init(
        mapView: MGLMapView,
        zoomLevel: Binding<Double> = .constant(14),
        bounds: Binding<MGLCoordinateBounds> = .constant(MGLCoordinateBounds()),
        center: Binding<CLLocationCoordinate2D> = .constant(CLLocationCoordinate2D()),
        heading: Binding<CLLocationDirection> = .constant(0),
        userLocation: Binding<CLLocationCoordinate2D?> = .constant(nil),
        annotations: Binding<[MGLPointAnnotation]>,
        attribution: Binding<String?> = .constant(nil)
    ) {
        self.mapView = mapView
        _bounds = bounds
        _center = center
        _userLocation = userLocation
        _attribution = attribution
        _zoomLevel = zoomLevel
        _annotations = annotations
        _heading = heading
        self.mapView.centerCoordinate = center.wrappedValue
        self.mapView.zoomLevel = zoomLevel.wrappedValue
        self.mapView.logoView.isHidden = true
        self.mapView.showsUserLocation = userLocation.wrappedValue != nil
        let camera = mapView.camera
        camera.heading = heading.wrappedValue
        self.mapView.setCamera(camera, animated: true)
        attribution.wrappedValue.map {
            self.mapView.attributionButton.setTitle($0, for: .normal)
        }
    }
    
    public func makeUIView(context: UIViewRepresentableContext<AMLMapView>) -> MGLMapView {
        mapView.delegate = context.coordinator
        return mapView
    }
    
    public func updateUIView(_ uiView: MGLMapView, context: UIViewRepresentableContext<AMLMapView>) {
        updateAnnotations()
        guard uiView.zoomLevel != zoomLevel else { return }
        uiView.setZoomLevel(zoomLevel, animated: true)
    }
    
    private func updateAnnotations() {
        mapView.annotations.flatMap(mapView.removeAnnotations(_:))
        mapView.addAnnotations(annotations)
    }
    
    public func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    let proxyDelegate: ProxyDelegate = .init()
}

extension AMLMapView {
    class ProxyDelegate {
        var mapViewDidSelectAnnotation: ((MGLMapView, MGLAnnotation) -> Void)?
    }
}
