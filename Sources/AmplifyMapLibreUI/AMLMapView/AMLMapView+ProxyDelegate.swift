//
// Copyright Amazon.com Inc. or its affiliates.
// All Rights Reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

import SwiftUI
import MapLibre
import UIKit

extension AMLMapView {
    /// An object that holds user defined or default behavior implementations
    /// for actions taken with the underling `MLNMapView`.
    class ProxyDelegate {

        init() { }

        /// The implementation that gets executed when a feature is tapped on the map.
        var featureTapped: ((MLNMapView, MLNPointFeature) -> Void) = { mapView, pointFeature in

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
                ),
                feature: pointFeature
            )

            /// Add a callout view to the map.
            ///
            /// This method first checks if a callout view is already presented.
            /// If so, it removes it before add a new one.
            /// - Parameters:
            ///   - calloutView: The UIView to be presented as a callout view.
            ///   - mapView: The MLNMapView on which the callout view will be presented.
            func addCalloutView(_ calloutView: UIView, to mapView: MLNMapView) {
                if let existingCalloutView = mapView.subviews.first(where: { $0.tag == 42 }) {
                    mapView.willRemoveSubview(existingCalloutView)
                    existingCalloutView.removeFromSuperview()
                }

                calloutView.tag = 42
                mapView.addSubview(calloutView)
            }

            addCalloutView(calloutView, to: mapView)
        }

        /// The implementation that gets executed when a feature cluster is tapped on the map.
        var clusterTapped: ((MLNMapView, MLNPointFeatureCluster) -> Void) = { mapView, cluster in
            mapView.setCenter(
                cluster.coordinate,
                zoomLevel: min(15, mapView.zoomLevel + 2),
                direction: mapView.camera.heading,
                animated: true
            )
        }
    }
}
