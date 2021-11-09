//
// Copyright Amazon.com Inc. or its affiliates.
// All Rights Reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

import Foundation
import CoreLocation

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
    /// - Parameter hide: `true` hides the button / `false` unhides the button
    /// - Returns: An instance of AMLMapView
    public func hideAttributionButton(_ hide: Bool) -> AMLMapView {
        mapView.attributionButton.isHidden = hide
        return self
    }
}
