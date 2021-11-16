//
// Copyright Amazon.com Inc. or its affiliates.
// All Rights Reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

import SwiftUI
import Mapbox

extension MGLMapViewRepresentable {
    /// Coordinator class for AMLMapView that manages MGLMapViewDelegate methods.
    final public class Coordinator: NSObject, MGLMapViewDelegate {
        var control: MGLMapViewRepresentable
        
        init(_ control: MGLMapViewRepresentable) {
            self.control = control
        }
        
        //        var features: [MGLPointFeature] = []
        
        public func mapView(_ mapView: MGLMapView, regionDidChangeWith reason: MGLCameraChangeReason, animated: Bool) {
            DispatchQueue.main.async {
                self.control.viewModel.zoomLevel = mapView.zoomLevel
                self.control.viewModel.bounds = mapView.visibleCoordinateBounds
                self.control.viewModel.center = mapView.centerCoordinate
                self.control.viewModel.heading = mapView.camera.heading
            }
        }
        
        public func mapView(_ mapView: MGLMapView, didUpdate userLocation: MGLUserLocation?) {
            //            control.viewModel.userLocation = userLocation?.coordinate
        }
        
        public func mapView(_ mapView: MGLMapView, didFinishLoading style: MGLStyle) {
            if let source = style.sources.first as? MGLVectorTileSource {
                let attribution = source.attributionInfos.first
                //                control.viewModel.attribution = attribution?.title.string ?? ""
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
extension MGLMapViewRepresentable.Coordinator {
    private func setupRenderingLayers(for style: MGLStyle) {
        let locationSource = locationSource()
        style.addSource(locationSource)
        style.setImage(control.viewModel.annotationImage, forName: "annotation")
        
        let annotationLayer = annotationLayer(for: locationSource)
        style.addLayer(annotationLayer)
        
        let clusterCircleLayer = clusterCircleLayer(for: locationSource)
        style.addLayer(clusterCircleLayer)
        
        let clusterNumberLayer = clusterNumberLayer(for: locationSource)
        style.addLayer(clusterNumberLayer)
    }
    
    private func locationSource() -> MGLShapeSource {
        MGLShapeSource.init(
            identifier: "aml_location_source",
            shape: nil,
            options:
                [
                    .clustered: control.viewModel.clusteringBehavior.shouldCluster,
                    .maximumZoomLevelForClustering: control.viewModel.clusteringBehavior.maximumZoomLevel,
                    .clusterRadius: control.viewModel.clusteringBehavior.clusterRadius
                ]
        )
    }
    
    private func annotationLayer(for source: MGLSource) -> MGLSymbolStyleLayer {
        let annotationLayer = MGLSymbolStyleLayer(identifier: "aml_annotation_style_layer", source: source)
        annotationLayer.iconImageName = NSExpression(forConstantValue: "annotation")
        annotationLayer.iconIgnoresPlacement = NSExpression(forConstantValue: true)
        annotationLayer.iconAllowsOverlap = NSExpression(forConstantValue: true)
        annotationLayer.predicate = NSPredicate(format: "cluster != YES")
        return annotationLayer
    }
    
    private func clusterCircleLayer(for source: MGLSource) -> MGLCircleStyleLayer {
        let clusterCircleLayer = MGLCircleStyleLayer(identifier: "aml_cluster_circle_layer", source: source)
        
//        let clusterColorStops: [Double: Double] = [
//            control.viewModel.clusteringBehavior.maximumZoomLevel + 2: 20,
//            control.viewModel.clusteringBehavior.maximumZoomLevel + 4: 30,
//            control.viewModel.clusteringBehavior.maximumZoomLevel + 6: 40,
//            control.viewModel.clusteringBehavior.maximumZoomLevel + 8: 50,
//            control.viewModel.clusteringBehavior.maximumZoomLevel + 9: 60
//        ]
        
        clusterCircleLayer.circleRadius = NSExpression(
            format: "mgl_interpolate:withCurveType:parameters:stops:($zoomLevel, 'exponential', 10, %@)",
            [
                control.viewModel.clusteringBehavior.maximumZoomLevel + 2: 20,
                control.viewModel.clusteringBehavior.maximumZoomLevel + 4: 30,
                control.viewModel.clusteringBehavior.maximumZoomLevel + 6: 40,
                control.viewModel.clusteringBehavior.maximumZoomLevel + 8: 50,
                control.viewModel.clusteringBehavior.maximumZoomLevel + 9: 60
            ]
        )
        clusterCircleLayer.circleStrokeColor = NSExpression(forConstantValue: UIColor.white)
        clusterCircleLayer.circleStrokeWidth = NSExpression(forConstantValue: 4)
        clusterCircleLayer.circleColor = NSExpression(
            format: "mgl_step:from:stops:(point_count, %@, %@)",
            control.viewModel.clusteringBehavior.clusterColor,
            control.viewModel.clusteringBehavior.clusterColorSteps
        )
        clusterCircleLayer.predicate = NSPredicate(format: "cluster == YES")
        
        return clusterCircleLayer
    }
    
    private func clusterNumberLayer(for source: MGLSource) -> MGLSymbolStyleLayer {
        let clusterNumberLayer = MGLSymbolStyleLayer(identifier: "aml_cluster_number_layer", source: source)
        clusterNumberLayer.text = NSExpression(format: "CAST(point_count, 'NSString')")
        clusterNumberLayer.textColor = NSExpression(forConstantValue: UIColor.white)
        clusterNumberLayer.textFontNames = NSExpression(forConstantValue: ["Arial Bold"])
        clusterNumberLayer.predicate = NSPredicate(format: "cluster == YES")
        return clusterNumberLayer
    }
    
    private func setTapRecognizer() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap(sender:)))
        control.mapView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc func handleTap(sender: UITapGestureRecognizer) {
        let location = sender.location(in: control.mapView)
        
        guard let tappedFeature = control.mapView.visibleFeatures(
            at: location,
            styleLayerIdentifiers: ["aml_annotation_style_layer", "aml_cluster_circle_layer"]
        ).first
        else { return }
        
        if let tappedCluster = tappedFeature as? MGLPointFeatureCluster {
            control.viewModel.clusterTapped(control.mapView, tappedCluster)
        } else if let tappedAnnotation = tappedFeature as? MGLPointFeature {
            control.viewModel.featureTapped(control.mapView, tappedAnnotation)
        }
    }
}
