//
// Copyright Amazon.com Inc. or its affiliates.
// All Rights Reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

import SwiftUI
import Mapbox

extension AMLMapView {
    /// Coordinator class for AMLMapView that manages MGLMapViewDelegate methods.
    final public class Coordinator: NSObject, MGLMapViewDelegate {
        var control: AMLMapView
        
        init(_ control: AMLMapView) {
            self.control = control
        }
        
        var features: [MGLPointFeature] = []
        
        public func mapView(_ mapView: MGLMapView, regionDidChangeWith reason: MGLCameraChangeReason, animated: Bool) {
            DispatchQueue.main.async {
                self.control.zoomLevel = mapView.zoomLevel
                self.control.bounds = mapView.visibleCoordinateBounds
                self.control.center = mapView.centerCoordinate
                self.control.heading = mapView.camera.heading
            }
        }
        
        public func mapView(_ mapView: MGLMapView, didUpdate userLocation: MGLUserLocation?) {
            control.userLocation = userLocation?.coordinate
        }
        
        public func mapView(_ mapView: MGLMapView, didFinishLoading style: MGLStyle) {
            if let source = style.sources.first as? MGLVectorTileSource {
                let attribution = source.attributionInfos.first
                control.attribution = attribution?.title.string ?? ""
            }
            
            setupRenderingLayers(for: style)
            setTapRecognizer()
        }
                
        public func mapView(_ mapView: MGLMapView, regionWillChangeAnimated animated: Bool) {
            if let calloutViewToRemove = mapView.subviews.first(where:  { $0.tag == 42 }) {
                mapView.willRemoveSubview(calloutViewToRemove)
                calloutViewToRemove.removeFromSuperview()
            }
        }
    }
}

// MARK: Private Configuration Methods
extension AMLMapView.Coordinator {
    private func setupRenderingLayers(for style: MGLStyle) {
        print("ClusteringBehavior", dump(control.clusteringBehavior))
        
        let shapeSource = MGLShapeSource.init(
            identifier: "cluster_source",
            shape: nil,
            options:
                [
                    .clustered: control.clusteringBehavior.shouldCluster,
                    .maximumZoomLevelForClustering: control.clusteringBehavior.maximumZoomLevel
                ]
        )
        
        let shapeLayer = MGLSymbolStyleLayer(identifier: "standard_style", source: shapeSource)
        
        style.setImage(
            control.proxyDelegate.annotationImage,
            forName: "annotation"
        )
        
        shapeLayer.iconImageName = NSExpression(forConstantValue: "annotation")
        shapeLayer.iconIgnoresPlacement = NSExpression(forConstantValue: true)
        shapeLayer.iconAllowsOverlap = NSExpression(forConstantValue: true)
        shapeLayer.predicate = NSPredicate(format: "cluster != YES")
        style.addSource(shapeSource)
        style.addLayer(shapeLayer)
        
        let circlesLayer = MGLCircleStyleLayer(identifier: "circle_layer", source: shapeSource)
        circlesLayer.circleRadius = NSExpression(
            forConstantValue: 50
        )
        
        circlesLayer.circleStrokeColor = NSExpression(forConstantValue: UIColor.white)
        circlesLayer.circleStrokeWidth = NSExpression(forConstantValue: 4)
        
        circlesLayer.circleColor = NSExpression(
            format: "mgl_step:from:stops:(point_count, %@, %@)",
            control.clusteringBehavior.clusterColor,
            control.clusteringBehavior.clusterColorSteps
        )
        
        circlesLayer.predicate = NSPredicate(format: "cluster == YES")
        style.addLayer(circlesLayer)

        let numbersLayer = MGLSymbolStyleLayer(identifier: "cluster_number_layer", source: shapeSource)
        
        numbersLayer.iconAllowsOverlap = NSExpression(forConstantValue: true)
        numbersLayer.iconIgnoresPlacement = NSExpression(forConstantValue: true)
        numbersLayer.text = NSExpression(format: "CAST(point_count, 'NSString')")
        numbersLayer.textColor = NSExpression(forConstantValue: UIColor.white)
        numbersLayer.predicate = NSPredicate(format: "cluster == YES")
        
//        style.addLayer(numbersLayer)
    }
    
    private func setTapRecognizer() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap(sender:)))
        control.mapView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc func handleTap(sender: UITapGestureRecognizer) {
        let location = sender.location(in: control.mapView)
        
        guard let tappedFeature = control.mapView.visibleFeatures(
            at: location,
            styleLayerIdentifiers: ["standard_style", "circle_layer"]
        ).first
        else { return }
        
        if let tappedCluster = tappedFeature as? MGLPointFeatureCluster {
            control.proxyDelegate.clusterTapped?(control.mapView, tappedCluster)
        } else if let tappedAnnotation = tappedFeature as? MGLPointFeature {
            control.proxyDelegate.annotationTapped?(control.mapView, tappedAnnotation)
        }
    }
}


extension View {
    func snapshot() -> UIImage {
        let controller = UIHostingController(rootView: self)
        let view = controller.view
        
        let targetSize = controller.view.intrinsicContentSize
        view?.bounds = CGRect(origin: .zero, size: targetSize)
        view?.backgroundColor = .clear
        
        let renderer = UIGraphicsImageRenderer(size: targetSize)
        
        return renderer.image { _ in
            view?.drawHierarchy(in: controller.view.bounds, afterScreenUpdates: true)
        }
    }
}
