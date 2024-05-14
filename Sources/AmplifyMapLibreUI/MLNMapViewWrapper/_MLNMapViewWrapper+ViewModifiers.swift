//
// Copyright Amazon.com Inc. or its affiliates.
// All Rights Reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

import Foundation
import CoreLocation
import MapLibre
import SwiftUI

extension _MLNMapViewWrapper {
    /// View modifier to enable showing the user's location on the map.
    ///
    /// To access the user's location, location access must be enabled in the app, and
    /// the user must choose to allow access.
    /// - Parameter showLocation: Enables showing the user's location on the map.
    /// - Returns: An instance of `_MLNMapViewWrapper`.
    func showUserLocation(_ showLocation: Bool) -> _MLNMapViewWrapper {
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
    /// - Returns: An instance of `_MLNMapViewWrapper`.
    func allowedZoomLevels(_ zoomLevels: ClosedRange<Double>) -> _MLNMapViewWrapper {
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
    /// - Returns: An instance of `_MLNMapViewWrapper`.
    func maxZoomLevel(_ maxZoomLevel: Double) -> _MLNMapViewWrapper {
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
    /// - Returns: An instance of `_MLNMapViewWrapper`.
    func minZoomLevel(_ minZoomLevel: Double) -> _MLNMapViewWrapper {
        mapView.minimumZoomLevel = max(minZoomLevel, 0)
        return self
    }

    /// Set the position of the compass on the `MLNMapView`.
    /// - Parameter position: `MLNOrnamentPosition` defining the location.
    /// - Returns: An instance of `_MLNMapViewWrapper`.
    func compassPosition(_ position: MLNOrnamentPosition) -> _MLNMapViewWrapper {
        mapView.compassViewPosition = position
        return self
    }

    /// Define the behavior when a feature is tapped.
    ///
    /// The default implementation pans the feature to the center of the screen and presents an `AMLCalloutView`.
    /// Defining an implementation here will override this behavior.
    ///
    /// - Parameter implementation: Closure provided a `MLNMapView` and `MLNPointFeature`.
    /// Define your desired behavior on the `mapView` using information from the `pointFeature` as needed.
    /// - Returns: An instance of `_MLNMapViewWrapper`.
    func featureTapped(
        _ implementation: @escaping (
            _ mapView: MLNMapView,
            _ pointFeature: MLNPointFeature
        ) -> Void
    ) -> _MLNMapViewWrapper {
        proxyDelegate.featureTapped = implementation
        return self
    }

    /// Define the behavior when a feature cluster is tapped.
    ///
    /// The default implementation zooms in on the map.
    /// Defining an implementation here will override this behavior.
    ///
    /// - Parameter implementation: Closure provided a `MLNMapView` and `MLNPointFeatureCluster`.
    /// Define your desired behavior on the `mapView` using information from the `pointFeatureCluster` as needed.
    /// - Returns: An instance of `_MLNMapViewWrapper`.
    func featureClusterTapped(
        _ implementation: @escaping (
            _ mapView: MLNMapView,
            _ pointFeatureCluster: MLNPointFeatureCluster
        ) -> Void
    ) -> _MLNMapViewWrapper {
        proxyDelegate.clusterTapped = implementation
        return self
    }
}
