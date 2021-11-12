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
    @Binding var annotations: [MGLPointFeature]
    /// The current heading of the map in degrees.
    @Binding var heading: CLLocationDirection
    
    let clusteringBehavior: ClusteringBehavior
        
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
        annotations: Binding<[MGLPointFeature]> = .constant([]),
        attribution: Binding<String?> = .constant(nil),
        clusteringBehavior: ClusteringBehavior = .init()
    ) {
        self.clusteringBehavior = clusteringBehavior
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
        self.mapView.compassView.isHidden = true
    }
    
    public func makeUIView(context: UIViewRepresentableContext<AMLMapView>) -> MGLMapView {
        mapView.delegate = context.coordinator
        return mapView
    }
    
    public func updateUIView(_ uiView: MGLMapView, context: UIViewRepresentableContext<AMLMapView>) {
        if uiView.zoomLevel != zoomLevel {
            uiView.setZoomLevel(zoomLevel, animated: true)
        }
        if uiView.camera.heading != heading {
            let camera = uiView.camera
            camera.heading = heading
            uiView.setCamera(camera, animated: true)
        }
        
        if let clusterSource = mapView.style?.source(withIdentifier: "cluster_source") as? MGLShapeSource {
            clusterSource.shape = MGLShapeCollectionFeature.init(shapes: annotations)
        }
    }
    
    // TODO: Remove when layer approach is tested
    private func updateAnnotations() {
//        mapView.annotations.flatMap(mapView.removeAnnotations(_:))
//        mapView.addAnnotations(annotations)
    }
    
    public func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    let proxyDelegate: ProxyDelegate = .init()
}

extension AMLMapView {
    class ProxyDelegate {
        var mapViewDidSelectAnnotation: ((MGLMapView, MGLAnnotation) -> Void)?
        var mapViewAnnotationCanShowCallout: ((MGLMapView, MGLAnnotation) -> Bool)?
        var annotationImage: UIImage = UIImage.init(
            named: "AMLAnnotationView",
            in: Bundle.module,
            compatibleWith: nil
        )!
        
        var annotationTapped: ((MGLMapView, MGLPointFeature) -> Void)? = { mapView, pointFeature in

            mapView.setCenter(
                pointFeature.coordinate,
                zoomLevel: max(15, mapView.zoomLevel),
                direction: mapView.camera.heading,
                animated: true
            )
            
            let point = mapView.convert(pointFeature.coordinate, toPointTo: mapView)
            
            let width = min(UIScreen.main.bounds.width * 0.8, 400)
            let height = width * 0.4
            
            
            let calloutView = AMLCalloutUIView(
                frame: .init(
                    x: mapView.center.x - width / 2,
                    y: mapView.center.y - height - 40,
                    width: width,
                    height: height
                )
            )           
            
            
            calloutView.nameLabel.text =  pointFeature.attributes["label"] as? String
            calloutView.addressLineOne.text = pointFeature.attributes["addressLineOne"] as? String
            calloutView.addressLineTwo.text = pointFeature.attributes["addressLineTwo"] as? String
            
//            calloutView.nameLabel.text = pointFeature.attributes["title"] as? String
            
            func addCalloutView(_ calloutView: UIView, to mapView: MGLMapView) {
                if let existingCalloutView = mapView.subviews
                    .first(where:  { $0.tag == 42 })
                {
                    mapView.willRemoveSubview(existingCalloutView)
                    existingCalloutView.removeFromSuperview()
                }
                
                calloutView.tag = 42
                mapView.addSubview(calloutView)
            }
            
            addCalloutView(calloutView, to: mapView)
        }
        
        var clusterTapped: ((MGLMapView, MGLPointFeatureCluster) -> Void)?
    }
}
