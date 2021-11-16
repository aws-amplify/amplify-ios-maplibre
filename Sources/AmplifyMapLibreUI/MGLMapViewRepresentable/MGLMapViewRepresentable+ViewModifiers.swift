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

extension MGLMapViewRepresentable {
    /// View modifier to enable showing the user's location on the map.
    ///
    /// To access the user's locaiton, location access must be enabled in the app, and
    /// the user must choose to allow access.
    /// - Parameter showLocation: Enables showing the user's location on the map.
    /// - Returns: An instance of `AMLMapView`.
    public func showUserLocation(_ showLocation: Bool) -> MGLMapViewRepresentable {
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
    /// - Returns: An instance of `AMLMapView`.
    public func allowedZoomLevels(_ zoomLevels: ClosedRange<Double>) -> MGLMapViewRepresentable {
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
    /// - Returns: An instance of `AMLMapView`.
    public func maxZoomLevel(_ maxZoomLevel: Double) -> MGLMapViewRepresentable {
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
    /// - Returns: An instance of `AMLMapView`.
    public func minZoomLevel(_ minZoomLevel: Double) -> MGLMapViewRepresentable {
        mapView.minimumZoomLevel = max(minZoomLevel, 0)
        return self
    }
    
    /// Set map's attribution button to hidden or showing.
    /// - Parameter hide:`true` hides the button / `false` unhides the button
    /// - Returns: An instance of `AMLMapView`.
    public func hideAttributionButton(_ hide: Bool) -> MGLMapViewRepresentable {
        mapView.attributionButton.isHidden = hide
        return self
    }
    
    /// Set the position of the compass on the `MGLMapView`.
    /// - Parameter position: `MGLOrnamentPosition` defining the location.
    /// - Returns: An instance of `AMLMapView`.
    public func compassPosition(_ position: MGLOrnamentPosition) -> MGLMapViewRepresentable {
        mapView.compassViewPosition = position
        return self
    }
    
    /// Provide an SwiftUI view that represents a point on a map.
    ///
    /// - Important: Because the underlying `MGLMapView` consumes `UIImage`s, this method turns a `SwiftUI` view into a `UIImage`.
    ///   There may be hidden cost to using this. If you experience performance and / or rendering issues, please use the `featureImage(_:)` view modifier instead.
    /// - Parameter view: The view to be displayed.
    /// - Returns: An instance of `AMLMapView`.
    public func featureView<T: View>(_ view: T) -> MGLMapViewRepresentable {
        viewModel.annotationImage = view.snapshot()
        return self
    }
    
    /// Provide an UIImage that represents a point on a map.
    /// - Parameter image: The image to be displayed.
    /// - Returns: An instance of `AMLMapView`.
    public func featureImage(_ image: UIImage) -> MGLMapViewRepresentable {
        viewModel.annotationImage = image
        return self
    }
    
    /// Define the behavior when a feature is tapped.
    ///
    /// The default implementation pans the feature to the center of the screen and presents an `AMLCalloutView`.
    /// Defining an implementation here will override this behavior.
    ///
    /// - Parameter implementation: Closure provided a `MGLMapView` and `MGLPointFeature`.
    /// Define your desired behavior on the `mapView` using information from the `pointFeature` as needed.
    /// - Returns: An instance of `AMLMapView`.
    public func featureTapped(
        _ implementation: @escaping (
            _ mapView: MGLMapView,
            _ pointFeature: MGLPointFeature
        ) -> Void
    ) -> MGLMapViewRepresentable {
        viewModel.featureTapped = implementation
        return self
    }
    
    /// Define the behavior when a feature cluster is tapped.
    ///
    /// The default implementation zooms in on the map.
    /// Defining an implementation here will override this behavior.
    ///
    /// - Parameter implementation: Closure provided a `MGLMapView` and `MGLPointFeatureCluster`.
    /// Define your desired behavior on the `mapView` using information from the `pointFeatureCluster` as needed.
    /// - Returns: An instance of `AMLMapView`.
    public func featureClusterTapped(
        _ implementation: @escaping (
            _ mapView: MGLMapView,
            _ pointFeatureCluster: MGLPointFeatureCluster
        ) -> Void
    ) -> MGLMapViewRepresentable {
        viewModel.clusterTapped = implementation
        return self
    }
    

}


