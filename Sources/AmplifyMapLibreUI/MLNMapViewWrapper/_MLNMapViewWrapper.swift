//
// Copyright Amazon.com Inc. or its affiliates.
// All Rights Reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

import SwiftUI
import Amplify
import AWSLocationGeoPlugin
import MapLibre

/// SwiftUI Wrapper for MLNMapView.
internal struct _MLNMapViewWrapper: UIViewRepresentable { // swiftlint:disable:this type_name

    /// Underlying MLNMapView.
    let mapView: MLNMapView

    /// Current zoom level of the map
    @Binding var zoomLevel: Double

    /// The coordinate bounds of the currently displayed area of the map.
    @Binding var bounds: MLNCoordinateBounds

    /// The center coordinates of the currently displayed area of the map.
    @Binding var center: CLLocationCoordinate2D

    /// The current heading of the map in degrees.
    @Binding var heading: CLLocationDirection

    /// The user's current location.
    @Binding var userLocation: CLLocationCoordinate2D?

    /// Features that are displayed on the map.
    @Binding var features: [MLNPointFeature]

    /// The attribution string for the map data providers.
    @Binding var attribution: String?

    /// The clustering behavior of the map.
    let clusteringBehavior: AMLMapView.ClusteringBehavior

    /// Implementation definitions for user interactions with the map.
    let proxyDelegate: AMLMapView.ProxyDelegate // swiftlint:disable:this weak_delegate

    /// Create a `_MLNMapViewWrapper`.
    /// An internal SwiftUI wrapper View around MLNMapView.
    /// - Parameters:
    ///   - mapView: The underlying MLNMapView.
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
        mapView: MLNMapView,
        zoomLevel: Binding<Double>,
        bounds: Binding<MLNCoordinateBounds>,
        center: Binding<CLLocationCoordinate2D>,
        heading: Binding<CLLocationDirection>,
        userLocation: Binding<CLLocationCoordinate2D?>,
        showUserLocation: Bool,
        features: Binding<[MLNPointFeature]>,
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

        self.mapView.centerCoordinate = center.wrappedValue
        self.mapView.zoomLevel = zoomLevel.wrappedValue
        self.mapView.logoView.isHidden = true
        self.mapView.showsUserLocation = showUserLocation || userLocation.wrappedValue != nil
        self.mapView.style?.setImage(featureImage, forName: "aml_feature")
        self.mapView.attributionButton.isHidden = true

    }

    public func makeUIView(context: UIViewRepresentableContext<_MLNMapViewWrapper>) -> MLNMapView {
        mapView.delegate = context.coordinator
        return mapView
    }

    public func updateUIView(_ uiView: MLNMapView, context: UIViewRepresentableContext<_MLNMapViewWrapper>) {
        handleZoomUpdate(in: uiView)
        handleCameraUpdate(in: uiView)
        handleFeatureUpdate(in: uiView)
    }

    private func handleFeatureUpdate(in mapView: MLNMapView) {
        guard let clusterSource = mapView.style?
                .source(withIdentifier: "aml_location_source") as? MLNShapeSource
        else { return }
        clusterSource.shape = MLNShapeCollectionFeature.init(shapes: features)
    }

    private func handleCameraUpdate(in mapView: MLNMapView) {
        guard mapView.camera.heading != heading else { return }
        let camera = mapView.camera
        camera.heading = heading
        mapView.setCamera(camera, animated: true)
    }

    private func handleZoomUpdate(in mapView: MLNMapView) {
        guard mapView.zoomLevel != zoomLevel else { return }
        mapView.setZoomLevel(zoomLevel, animated: true)
    }

    public func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
}
