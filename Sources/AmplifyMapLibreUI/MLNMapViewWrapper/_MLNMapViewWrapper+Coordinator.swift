//
// Copyright Amazon.com Inc. or its affiliates.
// All Rights Reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

import SwiftUI
import MapLibre

extension _MLNMapViewWrapper {
    /// Coordinator class for `_MLNMapViewWrapper` that manages MLNMapViewDelegate methods.
    final class Coordinator: NSObject, MLNMapViewDelegate {
        var control: _MLNMapViewWrapper

        init(_ control: _MLNMapViewWrapper) {
            self.control = control
        }

        func mapView(_ mapView: MLNMapView, regionDidChangeWith reason: MLNCameraChangeReason, animated: Bool) {
            DispatchQueue.main.async {
                self.control.zoomLevel = mapView.zoomLevel
                self.control.bounds = mapView.visibleCoordinateBounds
                self.control.center = mapView.centerCoordinate
                self.control.heading = mapView.camera.heading
            }
        }

        func mapView(_ mapView: MLNMapView, didUpdate userLocation: MLNUserLocation?) {
            control.userLocation = userLocation?.coordinate
        }

        func mapView(_ mapView: MLNMapView, didFinishLoading style: MLNStyle) {
            if let source = style.sources.first as? MLNVectorTileSource {
                let attribution = source.attributionInfos.first
                control.attribution = attribution?.title.string ?? ""
            }

            setupRenderingLayers(for: style)
            setTapRecognizer()
        }

        func mapView(_ mapView: MLNMapView, regionWillChangeAnimated animated: Bool) {
            if let calloutViewToRemove = mapView.subviews.first(where: { $0.tag == 42 }) {
                mapView.willRemoveSubview(calloutViewToRemove)
                calloutViewToRemove.removeFromSuperview()
            }
        }
    }
}

// MARK: Private Configuration Methods
extension _MLNMapViewWrapper.Coordinator {

    /// Add rendering layers to `MLNStyle`.
    ///
    /// - FeatureLayer: Features representing a point on the map.
    /// Sourced through `features` property of `_MLNMapViewWrapper`.
    ///     - Identifier: `"aml_feature_style_layer"`
    ///     - Uses source identifier: `"aml_location_source"`
    ///     - Rendered image identifier: `"aml_feature"`
    /// - ClusterCircleLayer: Cluster Features representing a cluster of features on the map.
    /// Clustering behavior determined by `ClusteringBehavior`.
    ///     - Identifier: `"aml_cluster_circle_layer"`
    ///     - Uses source identifier: `"aml_location_source"`
    /// - ClusterNumberLayer: Renders numbers representing the amount of features within a feature cluster.
    ///     - Identifier: `"aml_cluster_number_layer"`
    /// - Parameter style: The `MLNStyle` that the layers will be added to.
    private func setupRenderingLayers(for style: MLNStyle) {
        let locationSource = makeLocationSource()
        style.addSource(locationSource)
        let defaultImage = UIImage(
            named: "AMLFeatureView",
            in: Bundle.module,
            compatibleWith: nil
        )!
        style.setImage(defaultImage, forName: "aml_feature")

        let featureLayer = makeFeatureLayer(for: locationSource)
        style.addLayer(featureLayer)

        let clusterCircleLayer = makeClusterCircleLayer(for: locationSource)
        style.addLayer(clusterCircleLayer)

        let clusterNumberLayer = makeClusterNumberLayer(for: locationSource)
        style.addLayer(clusterNumberLayer)
    }

    /// Create the location source used to source features in the subsequent layers.
    /// - Returns: A `MLNShapeSource` with defined clustering options.
    private func makeLocationSource() -> MLNShapeSource {
        MLNShapeSource.init(
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

    /// Create the layer that renders features on the map.
    /// - Parameter source: The layer's source.
    /// - Returns: A `MLNSymbolStyleLayer` that will render features provided through the `source`.
    private func makeFeatureLayer(for source: MLNSource) -> MLNSymbolStyleLayer {
        let featureLayer = MLNSymbolStyleLayer(identifier: "aml_feature_style_layer", source: source)
        featureLayer.iconImageName = NSExpression(forConstantValue: "aml_feature")
        featureLayer.iconIgnoresPlacement = NSExpression(forConstantValue: true)
        featureLayer.iconAllowsOverlap = NSExpression(forConstantValue: true)
        featureLayer.predicate = NSPredicate(format: "cluster != YES")
        return featureLayer
    }

    /// Create the layer that renders feature clusters on the map.
    /// - Parameter source: The layer's source. Generally the same as the feature layer's `source`.
    /// - Returns: A `MLNCircleStyleLayer` that will render feature clusters provided through the `source`.
    /// Clustering behavior defined through `ClusteringBehavior`.
    private func makeClusterCircleLayer(for source: MLNSource) -> MLNCircleStyleLayer {
        let clusterCircleLayer = MLNCircleStyleLayer(identifier: "aml_cluster_circle_layer", source: source)
        clusterCircleLayer.circleRadius = NSExpression(
            forMLNInterpolating: .zoomLevelVariable,
            curveType: .exponential,
            parameters: NSExpression(forConstantValue: 10),
            stops: NSExpression(forConstantValue: [
                control.clusteringBehavior.maximumZoomLevel + 2: 20,
                control.clusteringBehavior.maximumZoomLevel + 4: 30,
                control.clusteringBehavior.maximumZoomLevel + 6: 40,
                control.clusteringBehavior.maximumZoomLevel + 8: 50,
                control.clusteringBehavior.maximumZoomLevel + 9: 60
            ])
        )
        clusterCircleLayer.circleStrokeColor = NSExpression(forConstantValue: UIColor.white)
        clusterCircleLayer.circleStrokeWidth = NSExpression(forConstantValue: 4)
        clusterCircleLayer.circleColor = NSExpression(
            forMLNStepping: NSExpression(forKeyPath: "point_count"),
            from: NSExpression(forConstantValue: control.clusteringBehavior.clusterColor),
            stops: NSExpression(forConstantValue: control.clusteringBehavior.clusterColorSteps)
        )
        clusterCircleLayer.predicate = NSPredicate(format: "cluster == YES")

        return clusterCircleLayer
    }

    /// Create the layer that renders numbers on the feature clusters on the map.
    /// - Parameter source: The layer's source. Generally the same as the cluster circle layer's `source`.
    /// - Returns: A `MLNSymbolStyleLayer` that renders numbers on feature clusters provided through the `source`.
    private func makeClusterNumberLayer(for source: MLNSource) -> MLNSymbolStyleLayer {
        let clusterNumberLayer = MLNSymbolStyleLayer(identifier: "aml_cluster_number_layer", source: source)
        clusterNumberLayer.text = NSExpression(format: "CAST(point_count, 'NSString')")
        clusterNumberLayer.textColor = NSExpression(forConstantValue: control.clusteringBehavior.clusterNumberColor)
        clusterNumberLayer.textFontNames = NSExpression(forConstantValue: ["Arial Bold"])
        clusterNumberLayer.predicate = NSPredicate(format: "cluster == YES")
        return clusterNumberLayer
    }

    /// Set a tap gesture recognizer whose action calls the implemention of `featureTapped` or `clusterTapped`.
    private func setTapRecognizer() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap(sender:)))
        control.mapView.addGestureRecognizer(tapGestureRecognizer)
    }

    /// Called by the `UITapGestureRecognizer`, this determines if a feature or feature cluster was tapped.
    ///
    /// If so, it will call the provided implementation of `featureTapped` or `clusterTapped`.
    ///
    /// - Important: You should never have to call this from your code.
    /// The action is called by the tap gesture recognizer.
    /// - Parameter sender: The `UITapGestureRecognizer`.
    @objc func handleTap(sender: UITapGestureRecognizer) {
        let location = sender.location(in: control.mapView)

        guard let tappedFeature = control.mapView.visibleFeatures(
            at: location,
            styleLayerIdentifiers: [
                "aml_feature_style_layer",
                "aml_cluster_circle_layer"
            ]
        ).first
        else { return }

        if let tappedCluster = tappedFeature as? MLNPointFeatureCluster {
            control.proxyDelegate.clusterTapped(control.mapView, tappedCluster)
        } else if let tappedFeature = tappedFeature as? MLNPointFeature {
            control.proxyDelegate.featureTapped(control.mapView, tappedFeature)
        }
    }
}
