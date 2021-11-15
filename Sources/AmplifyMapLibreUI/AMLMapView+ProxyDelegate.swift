//
// Copyright Amazon.com Inc. or its affiliates.
// All Rights Reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

import SwiftUI
import Mapbox
import UIKit

extension AMLMapView {
    class ProxyDelegate {
        var mapViewDidSelectAnnotation: ((MGLMapView, MGLAnnotation) -> Void)?
        var mapViewAnnotationCanShowCallout: ((MGLMapView, MGLAnnotation) -> Bool)?
        var annotationImage: UIImage = UIImage.init(
            named: "AMLAnnotationView",
            in: Bundle.module,
            compatibleWith: nil
        )!
        
        // TODO: Break out implementation into smaller pieces
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
                ),
                feature: pointFeature
            )
                        
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
        
        var clusterTapped: ((MGLMapView, MGLPointFeatureCluster) -> Void)? = { mapView, cluster in
            mapView.setCenter(
                cluster.coordinate,
                zoomLevel: min(15, mapView.zoomLevel + 2),
                direction: mapView.camera.heading,
                animated: true
            )
        }
    }
}
