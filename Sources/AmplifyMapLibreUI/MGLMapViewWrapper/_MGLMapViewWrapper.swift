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
internal struct _MGLMapViewWrapper: UIViewRepresentable { // swiftlint:disable:this type_name
    
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
    
    /// The current pitch of the map.
    @Binding var pitch: CGFloat
    
    /// The user's current location.
    @Binding var userLocation: CLLocationCoordinate2D?
    
    /// Features that are displayed on the map.
    @Binding var features: [MGLPointFeature]
    
    /// The attribution string for the map data providers.
    @Binding var attribution: String?
    
    /// The clustering behavior of the map.
    let clusteringBehavior: AMLMapView.ClusteringBehavior
    
    /// Implementation definitions for user interactions with the map.
    let proxyDelegate: AMLMapView.ProxyDelegate // swiftlint:disable:this weak_delegate
    
    /// Create a `_MGLMapViewWrapper`.
    /// An internal SwiftUI wrapper View around MGLMapView.
    /// - Parameters:
    ///   - mapView: The underlying MGLMapView.
    ///   - zoomLevel: Current zoom level of the map.
    ///   - bounds: The coordinate bounds of the currently displayed area of the map.
    ///   - center: The center coordinates of the currently displayed area of the map.
    ///   - heading: The current heading of the map in degrees.
    ///   - userLocation: The user's current location.
    ///   If this value exists, it will set `mapView.showsUserLocation` to true. (optional).
    ///   __Setting a value here will prompt the user for location permission__
    ///   - features: Binding of features displayed on the map.
    ///   - attribution: The attribution string for the map data providers.
    ///   - featureImage: UIImage that represents a feature on the map.
    ///   - clusteringBehavior: The clustering behavior of the map.
    ///   - proxyDelegate: Implementation definitions for user interactions with the map.
    init(
        mapView: MGLMapView,
        zoomLevel: Binding<Double>,
        bounds: Binding<MGLCoordinateBounds>,
        center: Binding<CLLocationCoordinate2D>,
        heading: Binding<CLLocationDirection>,
        pitch: Binding<CGFloat>,
        userLocation: Binding<CLLocationCoordinate2D?>,
        showUserLocation: Bool,
        features: Binding<[MGLPointFeature]>,
        attribution: Binding<String?>,
        featureImage: UIImage,
        clusteringBehavior: AMLMapView.ClusteringBehavior,
        proxyDelegate: AMLMapView.ProxyDelegate
    ) {
        self.clusteringBehavior = clusteringBehavior
        self.mapView = mapView
        self.proxyDelegate = proxyDelegate
        _bounds = bounds
        _center = center
        _userLocation = userLocation
        _attribution = attribution
        _zoomLevel = zoomLevel
        _features = features
        _heading = heading
        _pitch = pitch
        
        self.mapView.centerCoordinate = center.wrappedValue
        self.mapView.zoomLevel = zoomLevel.wrappedValue
        self.mapView.logoView.isHidden = true
        self.mapView.showsUserLocation = showUserLocation || userLocation.wrappedValue != nil
        self.mapView.style?.setImage(featureImage, forName: "aml_feature")
        self.mapView.attributionButton.isHidden = true
        
        let camera = mapView.camera
        camera.pitch = pitch.wrappedValue
        self.mapView.setCamera(camera, animated: false)
    }
    
    public func makeUIView(context: UIViewRepresentableContext<_MGLMapViewWrapper>) -> MGLMapView {
        mapView.delegate = context.coordinator
        return mapView
    }
    
    public func updateUIView(_ uiView: MGLMapView, context: UIViewRepresentableContext<_MGLMapViewWrapper>) {
        handleZoomUpdate(in: uiView)
        handleCameraUpdate(in: uiView)
        handleFeatureUpdate(in: uiView)
    }
    
    private func handleFeatureUpdate(in mapView: MGLMapView) {
        guard let clusterSource = mapView.style?
                .source(withIdentifier: "aml_location_source") as? MGLShapeSource
        else { return }
        clusterSource.shape = MGLShapeCollectionFeature.init(shapes: features)
    }
    
    private func handleCameraUpdate(in mapView: MGLMapView) {
        let camera = mapView.camera
        guard camera.heading != heading || camera.pitch != pitch
        else { return }
        
        camera.heading = heading
        camera.pitch = pitch
        
        mapView.setCamera(camera, animated: true)
    }
    
    private func handleZoomUpdate(in mapView: MGLMapView) {
        guard mapView.zoomLevel != zoomLevel else { return }
        mapView.setZoomLevel(zoomLevel, animated: true)
    }
    
    public func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
}
