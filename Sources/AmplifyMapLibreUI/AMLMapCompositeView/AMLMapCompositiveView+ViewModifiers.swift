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

public extension AMLMapCompositeView {
    /// View modifier to enable showing the user's location on the map.
    ///
    /// To access the user's locaiton, location access must be enabled in the app, and
    /// the user must choose to allow access.
    /// - Parameter showLocation: Enables showing the user's location on the map.
    /// - Returns: An instance of `AMLMapCompositeView`.
    func showUserLocation(_ showLocation: Bool) -> AMLMapCompositeView {
        viewModel.mapSettings.showUserLocation = showLocation
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
    /// - Returns: An instance of `AMLMapCompositeView`.
    func allowedZoomLevels(_ zoomLevels: ClosedRange<Double>) -> AMLMapCompositeView {
        viewModel.mapSettings.minZoomLevel = max(zoomLevels.lowerBound, 0)
        viewModel.mapSettings.maxZoomLevel = min(zoomLevels.upperBound, 22)
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
    /// - Returns: An instance of `AMLMapCompositeView`.
    func maxZoomLevel(_ maxZoomLevel: Double) -> AMLMapCompositeView {
        viewModel.mapSettings.maxZoomLevel = min(maxZoomLevel, 22)
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
    /// - Returns: An instance of `AMLMapCompositeView`.
    func minZoomLevel(_ minZoomLevel: Double) -> AMLMapCompositeView {
        viewModel.mapSettings.minZoomLevel = max(minZoomLevel, 0)
        return self
    }

    /// Set map's attribution button to hidden or showing.
    /// - Parameter hide:`true` hides the button / `false` unhides the button
    /// - Returns: An instance of `AMLMapCompositeView`.
    func hideAttributionButton(_ hide: Bool) -> AMLMapCompositeView {
        viewModel.mapSettings.hideAttributionButton = hide
        return self
    }

    /// Provide an SwiftUI view that represents a point on a map.
    ///
    /// - Important: Because the underlying `MGLMapView` consumes `UIImage`s,
    ///   this method turns a `SwiftUI` view into a `UIImage`.
    ///   There may be hidden cost to using this. If you experience performance and / or
    ///   rendering issues, please use the `featureImage(_:)` view modifier instead.
    /// - Parameter view: The view to be displayed.
    /// - Returns: An instance of `AMLMapCompositeView`.
    func featureView<T: View>(_ view: () -> T) -> AMLMapCompositeView {
        viewModel.mapSettings.featureImage = view().snapshot()
        return self
    }

    /// Provide an UIImage that represents a point on a map.
    /// - Parameter image: The image to be displayed.
    /// - Returns: An instance of `AMLMapCompositeView`.
    func featureImage(_ image: () -> UIImage) -> AMLMapCompositeView {
        viewModel.mapSettings.featureImage = image()
        return self
    }

    /// Define the behavior when a feature is tapped.
    ///
    /// The default implementation pans the feature to the center of the screen and presents an `AMLCalloutView`.
    /// Defining an implementation here will override this behavior.
    ///
    /// - Parameter implementation: Closure provided a `MGLMapView` and `MGLPointFeature`.
    /// Define your desired behavior on the `mapView` using information from the `pointFeature` as needed.
    /// - Returns: An instance of `AMLMapCompositeView`.
    func featureTapped(
        _ implementation: @escaping (
            _ mapView: MGLMapView,
            _ pointFeature: MGLPointFeature
        ) -> Void
    ) -> AMLMapCompositeView {
        viewModel.mapSettings.proxyDelegate.featureTapped = implementation
        return self
    }

    /// Define the behavior when a feature cluster is tapped.
    ///
    /// The default implementation zooms in on the map.
    /// Defining an implementation here will override this behavior.
    ///
    /// - Parameter implementation: Closure provided a `MGLMapView` and `MGLPointFeatureCluster`.
    /// Define your desired behavior on the `mapView` using information from the `pointFeatureCluster` as needed.
    /// - Returns: An instance of `AMLMapCompositeView`.
    func featureClusterTapped(
        _ implementation: @escaping (
            _ mapView: MGLMapView,
            _ pointFeatureCluster: MGLPointFeatureCluster
        ) -> Void
    ) -> AMLMapCompositeView {
        viewModel.mapSettings.proxyDelegate.clusterTapped = implementation
        return self
    }

    /// Set the position of the compass on the `MGLMapView`.
    /// - Parameter position: `MGLOrnamentPosition` defining the location.
    /// - Returns: An instance of `AMLMapCompositeView`.
    func compassPosition(_ position: MGLOrnamentPosition) -> AMLMapCompositeView {
        viewModel.mapSettings.compassPosition = position
        return self
    }

    /// Set whether the map features should cluster.
    /// - Parameter shouldCluster: Features displayed on the map should cluster.
    /// Corresponds to the `MGLShapeSourceOption` `.clustered`.
    /// - Returns: An instance of `AMLMapCompositeView`.
    func shouldCluster(_ shouldCluster: Bool) -> AMLMapCompositeView {
        viewModel.mapSettings.clusteringBehavior.shouldCluster = shouldCluster
        return self
    }

    /// Specifies the maximum zoom level at which to cluster points if clustering is enabled.
    /// - Parameter maxZoom: The maximum zoom level of clustering.
    ///   Corresponds to `MGLShapeSourceOption` `.maximumZoomLevelForClustering`.
    /// - Returns: An instance of `AMLMapCompositeView`.
    func maximumClusterZoomLevel(_ maxZoom: Int) -> AMLMapCompositeView {
        viewModel.mapSettings.clusteringBehavior.maximumZoomLevel = maxZoom
        return self
    }

    /// Set the fill color of the circle cluster.
    /// - Parameter color: The fill color of the circle cluster.
    ///   Sets the `MGLCircleStyleLayer` `circleColor` property.
    /// - Returns: An instance of `AMLMapCompositeView`.
    func clusterColor(_ color: UIColor) -> AMLMapCompositeView {
        viewModel.mapSettings.clusteringBehavior.clusterColor = color
        return self
    }

    /// The text color of the number displayed in the circle cluster.
    /// - Parameter color: The color of text displaying the number within a cluster.
    ///   Sets the `MGLSymbolStyleLayer` `textColor` property.
    /// - Returns: An instance of `AMLMapCompositeView`.
    func clusterNumberColor(_ color: UIColor) -> AMLMapCompositeView {
        viewModel.mapSettings.clusteringBehavior.clusterNumberColor = color
        return self
    }

    /// Set colors for different cluster steps.
    /// - Parameter steps: Dictionary representation of cluster color steps where the
    /// `key` is the number of features in a cluster and the
    /// `value` is the color for that corresponding number
    /// - Returns: An instance of `AMLMapCompositeView`.
    func clusterColorSteps(_ steps: [Int: UIColor]) -> AMLMapCompositeView {
        viewModel.mapSettings.clusteringBehavior.clusterColorSteps = steps
        return self
    }

    /// Set the radius of each cluster if clustering is enabled.
    /// - Parameter radius: The cluster radius.
    ///   Corresponds to the `MGLShapeSourceOption` `.clusterRadius`.
    /// - Returns: An instance of `AMLMapCompositeView`.
    func clusterRadius(_ radius: Int) -> AMLMapCompositeView {
        viewModel.mapSettings.clusteringBehavior.clusterRadius = radius
        return self
    }
}
