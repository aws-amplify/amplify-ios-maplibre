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
        
        public func mapView(_ mapView: MGLMapView, regionDidChangeWith reason: MGLCameraChangeReason, animated: Bool) {
            DispatchQueue.main.async {
                self.control.zoomLevel = mapView.zoomLevel
                self.control.bounds = mapView.visibleCoordinateBounds
                self.control.center = mapView.centerCoordinate
            }
        }
        
        public func mapView(_ mapView: MGLMapView, didUpdate userLocation: MGLUserLocation?) {
            control.userLocation = userLocation?.coordinate
        }
        
        public func mapView(_ mapView: MGLMapView, didFinishLoading style: MGLStyle) {
            let source = style.sources.first as? MGLVectorTileSource
            let attribution = source?.attributionInfos.first
            control.attribution = attribution?.title.string ?? ""
        }
        
        public func mapView(_ mapView: MGLMapView, tapOnCalloutFor annotation: MGLAnnotation) {
            mapView.deselectAnnotation(annotation, animated: true)
        }
        
        public func mapView(_ mapView: MGLMapView, didSelect annotation: MGLAnnotation) {
            guard let didSelect = control.psuedoDelegate.mapViewDidSelectAnnotation else {
                // Depending on the method - some reasonable default implementation, or no action.
                return
            }
            didSelect(mapView, annotation)
        }
    }
}


//
//            let camera = MGLMapCamera(lookingAtCenter: annotation.coordinate, altitude: 200, pitch: 15, heading: 180)
//            mapView.fly(to: camera, withDuration: 1.5, peakAltitude: 3000, completionHandler: nil)
