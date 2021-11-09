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
            control.userLocation = userLocation?.coordinate ?? .init()
        }
        
    }
}
