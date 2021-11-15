//
// Copyright Amazon.com Inc. or its affiliates.
// All Rights Reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

import Foundation
import CoreLocation
import Mapbox
import SwiftUI

extension AMLMapView {
    /// View modifier to enable showing the user's location on the map.
    ///
    /// To access the user's locaiton, location access must be enabled in the app, and
    /// the user must choose to allow access.
    /// - Parameter showLocation: Enables showing the user's location on the map.
    /// - Returns: An instance of AMLMapView.
    public func showUserLocation(_ showLocation: Bool) -> AMLMapView {
        mapView.showsUserLocation = showLocation
        return self
    }
    
    /// View modifier to set the map's maximum and minimum zoom levels.
    ///
    /// Zoom Level Approximation Reference:
    /// - 0 -> The Earth
    /// - 3 -> A continent
    /// - 4 -> Large islands
    /// - 6 -> Large rivers
    /// - 10 -> Large roads
    /// - 15 -> Buildings
    ///
    /// - Parameter zoomLevels: A closed range of `Double` where the lower bound is the min and
    ///   the upper bound the max zoom level.
    /// - Important:
    /// The minimum allowable zoom level is 0 and the maximum allowable zoom level is 22.
    /// Any value set below 0 or above 22 will revert to 0 or 22 accordingly.
    /// - Returns: An instance of AMLMapView.
    public func allowedZoomLevels(_ zoomLevels: ClosedRange<Double>) -> AMLMapView {
        mapView.minimumZoomLevel = max(zoomLevels.lowerBound, 0)
        mapView.maximumZoomLevel = min(zoomLevels.upperBound, 22)
        return self
    }
    
    /// View modifier to set the map's maximum zoom level.
    ///
    /// Zoom Level Approximation Reference:
    /// - 0 -> The Earth
    /// - 3 -> A continent
    /// - 4 -> Large islands
    /// - 6 -> Large rivers
    /// - 10 -> Large roads
    /// - 15 -> Buildings
    ///
    /// - Parameter maxZoomLevel: The maximum zoom level allowed by the map.
    /// - Important:
    /// The maximum zoom level is 22. Any value set above 22 will revert to 22.
    /// - Returns: An instance of AMLMapView.
    public func maxZoomLevel(_ maxZoomLevel: Double) -> AMLMapView {
        mapView.maximumZoomLevel = min(maxZoomLevel, 22)
        return self
    }
    
    /// View modifier to set the map's minimum zoom level.
    ///
    /// Zoom Level Approximation Reference:
    /// - 0 -> The Earth
    /// - 3 -> A continent
    /// - 4 -> Large islands
    /// - 6 -> Large rivers
    /// - 10 -> Large roads
    /// - 15 -> Buildings
    ///
    /// - Parameter minZoomLevel: The minimum zoom level allowed by the map.
    /// - Important:
    ///  The minimum allowable zoom level is 0. Any value set below 0 revert to 0.
    /// - Returns: An instance of AMLMapView.
    public func minZoomLevel(_ minZoomLevel: Double) -> AMLMapView {
        mapView.minimumZoomLevel = max(minZoomLevel, 0)
        return self
    }
    
    /// Set map's attribution button to hidden or showing.
    /// - Parameter hide:`true` hides the button / `false` unhides the button
    /// - Returns: An instance of AMLMapView
    public func hideAttributionButton(_ hide: Bool) -> AMLMapView {
        mapView.attributionButton.isHidden = hide
        return self
    }
    
    public func annotationView<T: View>(_ view: T) -> AMLMapView {
        proxyDelegate.annotationImage = view.snapshot()
        return self
    }
    
    public func annotationImage(_ image: UIImage) -> AMLMapView {
        proxyDelegate.annotationImage = image
        return self
    }
    
    public func annotationTapped(_ implementation: @escaping (_ mapView: MGLMapView, _ feature: MGLPointFeature) -> Void) -> AMLMapView {
        proxyDelegate.annotationTapped = implementation
        return self
    }
    
    public func clusterTapped(_ implementation: @escaping (_ mapView: MGLMapView, _ feature: MGLPointFeatureCluster) -> Void) -> AMLMapView {
        proxyDelegate.clusterTapped = implementation
        return self
    }

    public func mapViewDidSelectAnnotation(
        _ implementation: @escaping (
            _ mapView: MGLMapView,
            _ annotation: MGLAnnotation
        ) -> Void
    ) -> AMLMapView {
        self.proxyDelegate.mapViewDidSelectAnnotation = implementation
        return self
    }
    
    public func mapViewAnnotationCanShowCallout(
        _ implementation: @escaping (
            _ mapView: MGLMapView,
            _ annotation: MGLAnnotation
        ) -> Bool
    ) -> AMLMapView {
        self.proxyDelegate.mapViewAnnotationCanShowCallout = implementation
        return self
    }
    
    public func compassPosition(_ position: MGLOrnamentPosition) -> AMLMapView {
        mapView.compassViewPosition = position
        return self
    }
}

public extension AMLMapView {
    static let blue = UIColor(red: 0.33, green: 0.48, blue: 0.90, alpha: 1.00)
    
    struct ClusteringBehavior {
        public init(
            shouldCluster: Bool = true,
            maximumZoomLevel: Int = 13,
            clusterColor: UIColor = AMLMapView.blue,
            clusterColorSteps: [Int: UIColor] = [:]
        ) {
            self.shouldCluster = shouldCluster
            self.maximumZoomLevel = maximumZoomLevel
            self.clusterColor = clusterColor
            self.clusterColorSteps = !clusterColorSteps.isEmpty ? clusterColorSteps : [50: clusterColor]
        }
        
        public var shouldCluster: Bool
        public var maximumZoomLevel: Int
        public var clusterColor: UIColor
        public var clusterColorSteps: [Int: UIColor]
    }
}
