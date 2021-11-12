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
                    y: mapView.center.y - height - 60,
                    width: width,
                    height: height
                )
            )
            calloutView.nameLabel.text = pointFeature.attributes["title"] as? String
            
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

class AMLCalloutUIView: UIView {
    let xButton = UIButton()
    let nameLabel = UILabel()
    let addressLineOne = UILabel()
    let addressLineTwo = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
//        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .white
        
        [xButton, nameLabel, addressLineOne, addressLineTwo]
            .forEach {
                $0.translatesAutoresizingMaskIntoConstraints = false
                addSubview($0)
            }
        
        nameLabel.numberOfLines = 0
        nameLabel.lineBreakMode = .byWordWrapping
        nameLabel.font = .systemFont(ofSize: 20, weight: .medium)
        nameLabel.textColor = .black
        [addressLineOne, addressLineTwo].forEach {
            $0.textColor = .secondaryLabel
        }
        
        let xMarkImage = UIImage(
            systemName: "xmark",
            withConfiguration: UIImage.SymbolConfiguration(pointSize: 25)
        )
        xButton.setImage(
            xMarkImage,
            for: .normal
        )
        xButton.tintColor = .secondaryLabel
        xButton.addTarget(self, action: #selector(xButtonTapped), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            xButton.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            xButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            xButton.widthAnchor.constraint(equalToConstant: 25),
            xButton.heightAnchor.constraint(equalToConstant: 25),
            
            nameLabel.topAnchor.constraint(equalTo: xButton.bottomAnchor, constant: 8),
            nameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            nameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            
            addressLineOne.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            addressLineOne.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            addressLineOne.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            
            addressLineTwo.topAnchor.constraint(equalTo: addressLineOne.bottomAnchor, constant: 8),
            addressLineTwo.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            addressLineTwo.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            addressLineTwo.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16)
        ])
        
        layer.borderWidth = 2.5
        layer.borderColor = UIColor.black.cgColor
        layer.cornerRadius = 12.5
        
        setTextValues()
    }
    
    private func setTextValues() {
        nameLabel.text = "Main Street Coffee and Bagel"
        addressLineOne.text = "Address 1"
        addressLineTwo.text = "Address 2"
    }
    
    @objc func xButtonTapped() {
        self.removeFromSuperview()
    }
    
    required init?(coder: NSCoder) { nil }
}
