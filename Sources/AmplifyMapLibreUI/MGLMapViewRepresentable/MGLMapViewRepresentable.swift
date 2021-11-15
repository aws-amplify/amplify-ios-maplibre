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
public struct MGLMapViewRepresentable: UIViewRepresentable {
    /// Underlying MGLMapView.
    let mapView: MGLMapView
    /// Current zoom level of the map
    @Binding var zoomLevel: Double
    /// The coordinate bounds of the currently displayed area of the map.
    @Binding var bounds: MGLCoordinateBounds
    /// The center coordinates of the currently displayed area of the map.
    @Binding var center: CLLocationCoordinate2D
    /// The current heading of the map in degrees.
    @Binding var heading: CLLocationDirection
    /// The user's current location.
    @Binding var userLocation: CLLocationCoordinate2D?
    /// Features that are displayed on the map.
    @Binding var features: [MGLPointFeature]
    /// The attribution string for the map data providers.
    @Binding var attribution: String?
    /// The clustering behavior of the map.
    let clusteringBehavior: ClusteringBehavior
        
    /// Initialize an instance of AMLMapView.
    ///
    /// A SwiftUI wrapper View around MGLMapView
    /// - Parameters:
    ///   - mapView: The underlying MGLMapView.
    ///   - zoomLevel: Current zoom level of the map. Default 14
    ///   - bounds: The coordinate bounds of the currently displayed area of the map.
    ///   - center: The center coordinates of the currently displayed area of the map.
    ///   - userLocation: The user's current location. If this value exists, it will set `mapView.showsUserLocation` to true. (optional). __Setting this to true will prompt the user for location permission__
    ///   - annotations: Binding of annotations displayed on the map.
    ///   - attribution: The attribution string for the map data providers.
    public init(
        mapView: MGLMapView,
        zoomLevel: Binding<Double> = .constant(14),
        bounds: Binding<MGLCoordinateBounds> = .constant(MGLCoordinateBounds()),
        center: Binding<CLLocationCoordinate2D> = .constant(CLLocationCoordinate2D()),
        heading: Binding<CLLocationDirection> = .constant(0),
        userLocation: Binding<CLLocationCoordinate2D?> = .constant(nil),
        features: Binding<[MGLPointFeature]> = .constant([]),
        attribution: Binding<String?> = .constant(nil),
        clusteringBehavior: ClusteringBehavior = .init(),
        proxyDelegate: ProxyDelegate = .init()
    ) {
        self.clusteringBehavior = clusteringBehavior
        self.mapView = mapView
        _bounds = bounds
        _center = center
        _userLocation = userLocation
        _attribution = attribution
        _zoomLevel = zoomLevel
        _features = features
        _heading = heading
        self.mapView.centerCoordinate = center.wrappedValue
        self.mapView.zoomLevel = zoomLevel.wrappedValue
        self.mapView.logoView.isHidden = true
        self.mapView.showsUserLocation = userLocation.wrappedValue != nil
        self.proxyDelegate = proxyDelegate
    }
    
    public func makeUIView(context: UIViewRepresentableContext<MGLMapViewRepresentable>) -> MGLMapView {
        mapView.delegate = context.coordinator
        return mapView
    }
    
    public func updateUIView(_ uiView: MGLMapView, context: UIViewRepresentableContext<MGLMapViewRepresentable>) {
        if uiView.zoomLevel != zoomLevel {
            uiView.setZoomLevel(zoomLevel, animated: true)
        }
        
        if uiView.camera.heading != heading {
            let camera = uiView.camera
            camera.heading = heading
            uiView.setCamera(camera, animated: true)
        }
        
        if let clusterSource = mapView.style?.source(withIdentifier: "aml_location_source") as? MGLShapeSource {
            clusterSource.shape = MGLShapeCollectionFeature.init(shapes: features)
        }
    }
        
    public func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    let proxyDelegate: ProxyDelegate
}
