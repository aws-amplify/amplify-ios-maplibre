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
        annotations: Binding<[MGLPointAnnotation]>,
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
        
        attribution.wrappedValue.map {
            self.mapView.attributionButton.setTitle($0, for: .normal)
        }
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
            let features = annotations.map { annotation -> MGLPointFeature in
                let feature = MGLPointFeature()
                feature.coordinate = annotation.coordinate
                feature.attributes["title"] = annotation.title
                return feature
            }
            clusterSource.shape = MGLShapeCollectionFeature.init(shapes: features)
        }
    }
    
    // TODO: Remove when layer approach is tested
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
        var mapViewAnnotationCanShowCallout: ((MGLMapView, MGLAnnotation) -> Bool)?
        var annotationImage: UIImage = .init(systemName: "mappin")!
    }
}

public struct AMLAnnotationView: View {
    public var body: some View {
        Image("AMLMapView")
    }
}

struct AMLAnnotationViewPreview: PreviewProvider {
    static var previews: some View {
        AMLAnnotationView()
    }
}
