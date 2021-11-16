//
// Copyright Amazon.com Inc. or its affiliates.
// All Rights Reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

import SwiftUI
import Mapbox

extension _MGLMapViewWrapper {
    /// Coordinator class for `_MGLMapViewWrapper` that manages MGLMapViewDelegate methods.
    final public class Coordinator: NSObject, MGLMapViewDelegate {
        var control: _MGLMapViewWrapper
        
        init(_ control: _MGLMapViewWrapper) {
            self.control = control
        }
        
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
extension _MGLMapViewWrapper.Coordinator {
    private func setupRenderingLayers(for style: MGLStyle) {
        let locationSource = locationSource()
        style.addSource(locationSource)
        let defaultImage = UIImage(
            named: "AMLFeatureView",
            in: Bundle.module,
            compatibleWith: nil
        )!
        style.setImage(defaultImage, forName: "aml_feature")
        
        let featureLayer = featureLayer(for: locationSource)
        style.addLayer(featureLayer)
        
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
                    .clustered: control.clusteringBehavior.shouldCluster,
                    .maximumZoomLevelForClustering: control.clusteringBehavior.maximumZoomLevel,
                    .clusterRadius: control.clusteringBehavior.clusterRadius
                ]
        )
    }
    
    private func featureLayer(for source: MGLSource) -> MGLSymbolStyleLayer {
        let featureLayer = MGLSymbolStyleLayer(identifier: "aml_feature_style_layer", source: source)
        featureLayer.iconImageName = NSExpression(forConstantValue: "aml_feature")
        featureLayer.iconIgnoresPlacement = NSExpression(forConstantValue: true)
        featureLayer.iconAllowsOverlap = NSExpression(forConstantValue: true)
        featureLayer.predicate = NSPredicate(format: "cluster != YES")
        return featureLayer
    }
    
    private func clusterCircleLayer(for source: MGLSource) -> MGLCircleStyleLayer {
        let clusterCircleLayer = MGLCircleStyleLayer(identifier: "aml_cluster_circle_layer", source: source)
        
        clusterCircleLayer.circleRadius = NSExpression(
            format: "mgl_interpolate:withCurveType:parameters:stops:($zoomLevel, 'exponential', 10, %@)",
            [
                control.clusteringBehavior.maximumZoomLevel + 2: 20,
                control.clusteringBehavior.maximumZoomLevel + 4: 30,
                control.clusteringBehavior.maximumZoomLevel + 6: 40,
                control.clusteringBehavior.maximumZoomLevel + 8: 50,
                control.clusteringBehavior.maximumZoomLevel + 9: 60
            ]
        )
        clusterCircleLayer.circleStrokeColor = NSExpression(forConstantValue: UIColor.white)
        clusterCircleLayer.circleStrokeWidth = NSExpression(forConstantValue: 4)
        clusterCircleLayer.circleColor = NSExpression(
            format: "mgl_step:from:stops:(point_count, %@, %@)",
            control.clusteringBehavior.clusterColor,
            control.clusteringBehavior.clusterColorSteps
        )
        clusterCircleLayer.predicate = NSPredicate(format: "cluster == YES")
        
        return clusterCircleLayer
    }
    
    private func clusterNumberLayer(for source: MGLSource) -> MGLSymbolStyleLayer {
        let clusterNumberLayer = MGLSymbolStyleLayer(identifier: "aml_cluster_number_layer", source: source)
        clusterNumberLayer.text = NSExpression(format: "CAST(point_count, 'NSString')")
        clusterNumberLayer.textColor = NSExpression(forConstantValue: control.clusteringBehavior.clusterNumberColor)
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
            styleLayerIdentifiers: ["aml_feature_style_layer", "aml_cluster_circle_layer"]
        ).first
        else { return }
        
        if let tappedCluster = tappedFeature as? MGLPointFeatureCluster {
            control.proxyDelegate.clusterTapped(control.mapView, tappedCluster)
        } else if let tappedFeature = tappedFeature as? MGLPointFeature {
            control.proxyDelegate.featureTapped(control.mapView, tappedFeature)
        }
    }
}