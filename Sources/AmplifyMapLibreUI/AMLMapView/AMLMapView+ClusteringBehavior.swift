//
// Copyright Amazon.com Inc. or its affiliates.
// All Rights Reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

import SwiftUI
import UIKit

extension AMLMapView {
    /// Standard blue color used for features and feature clusters.
    static let blue = UIColor(red: 0.33, green: 0.48, blue: 0.90, alpha: 1.00)
    
    /// Define the map views clustering behavior.
    class ClusteringBehavior {
        
        /// Define custom clustering behavior.
        /// - Parameters:
        ///   - shouldCluster: Whether the features displayed on the map should cluster. Default is `true`.
        /// Corresponds to the `MGLShapeSourceOption` `.clustered`.
        ///   - maximumZoomLevel: Specifies the maximum zoom level at which to cluster points if clustering is enabled.
        ///   Corresponds to `MGLShapeSourceOption` `.maximumZoomLevelForClustering`.
        ///   - clusterColor: The fill color of the circle cluster. Sets the `MGLCircleStyleLayer` `circleColor` property.
        ///   - clusterColorSteps: Dictionary representation of cluster color steps where the `key` is the number of features in a cluster and the `value` is the color for that corresponding number.
        ///   - clusterRadius: Specifies the radius of each cluster if clustering is enabled. Corresponds to the `MGLShapeSourceOption` `.clusterRadius`.
        init(
            shouldCluster: Bool = true,
            maximumZoomLevel: Int = 13,
            clusterColor: UIColor = AMLMapView.blue,
            clusterNumberColor: UIColor = .white,
            clusterColorSteps: [Int: UIColor] = [:],
            clusterRadius: Int = 75
        ) {
            self.shouldCluster = shouldCluster
            self.maximumZoomLevel = maximumZoomLevel
            self.clusterColor = clusterColor
            self.clusterNumberColor = clusterNumberColor
            self.clusterColorSteps = !clusterColorSteps.isEmpty
            ? clusterColorSteps
            : [50: clusterColor]
            self.clusterRadius = clusterRadius
        }
        
        /// Whether the features displayed on the map should cluster. Default is `true`.
        /// Corresponds to the `MGLShapeSourceOption` `.clustered`.
        var shouldCluster: Bool
        
        /// Specifies the maximum zoom level at which to cluster points if clustering is enabled.
        /// Corresponds to `MGLShapeSourceOption` `.maximumZoomLevelForClustering`.
        var maximumZoomLevel: Int
        
        /// The fill color of the circle cluster.
        /// Sets the `MGLCircleStyleLayer` `circleColor` property.
        var clusterColor: UIColor
        
        /// The text color of the number displayed in the circle cluster.
        /// Sets the `MGLSymbolStyleLayer` `textColor` property.
        var clusterNumberColor: UIColor
        
        /// Dictionary representation of cluster color steps where the `key` is the number of features in a cluster and the `value` is the color for that corresponding number.
        var clusterColorSteps: [Int: UIColor]
        
        /// Specifies the radius of each cluster if clustering is enabled. Corresponds to the `MGLShapeSourceOption` `.clusterRadius`.
        var clusterRadius: Int
    }
}
