//
// Copyright Amazon.com Inc. or its affiliates.
// All Rights Reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

import SwiftUI
import Mapbox
import UIKit

public extension AMLMapView {
    class ProxyDelegate {
        
        public init() { }
        
        var annotationImage: UIImage = UIImage.init(
            named: "AMLAnnotationView",
            in: Bundle.module,
            compatibleWith: nil
        )!
        
        var featureTapped: ((MGLMapView, MGLPointFeature) -> Void) = { mapView, pointFeature in
            
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
            /// This method first checks if a callout view is already presented. If so, it removes it before add a new one.
            /// - Parameters:
            ///   - calloutView: The UIView to be presented as a callout view.
            ///   - mapView: The MGLMapView on which the callout view will be presented.
            func addCalloutView(_ calloutView: UIView, to mapView: MGLMapView) {
                if let existingCalloutView = mapView.subviews
                    .first(where: { $0.tag == 42 })
                {
                    mapView.willRemoveSubview(existingCalloutView)
                    existingCalloutView.removeFromSuperview()
                }
                
                calloutView.tag = 42
                mapView.addSubview(calloutView)
            }
            
            addCalloutView(calloutView, to: mapView)
        }
        
        var clusterTapped: ((MGLMapView, MGLPointFeatureCluster) -> Void) = { mapView, cluster in
            mapView.setCenter(
                cluster.coordinate,
                zoomLevel: min(15, mapView.zoomLevel + 2),
                direction: mapView.camera.heading,
                animated: true
            )
        }
    }
}
