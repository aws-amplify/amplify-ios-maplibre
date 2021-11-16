//
// Copyright Amazon.com Inc. or its affiliates.
// All Rights Reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

import SwiftUI
import UIKit

public extension MGLMapViewRepresentable {
    /// Standard blue color used for features and feature clusters.
    static let blue = UIColor(red: 0.33, green: 0.48, blue: 0.90, alpha: 1.00)
    
    /// Define the map views clustering behavior.
    struct ClusteringBehavior {
        
        /// Define custom clustering behavior.
        /// - Parameters:
        ///   - shouldCluster: Whether the features displayed on the map should cluster. Default is `true`.
        /// Corresponds to the `MGLShapeSourceOption` `.clustered`.
        ///   - maximumZoomLevel: Specifies the maximum zoom level at which to cluster points if clustering is enabled.
        ///   Corresponds to `MGLShapeSourceOption` `.maximumZoomLevelForClustering`.
        ///   - clusterColor: The fill color of the circle cluster. Sets the `MGLCircleStyleLayer` `circleColor` property.
        ///   - clusterColorSteps: Dictionary representation of cluster color steps where the `key` is the number of features in a cluster and the `value` is the color for that corresponding number.
        ///   - clusterRadius: Specifies the radius of each cluster if clustering is enabled. Corresponds to the `MGLShapeSourceOption` `.clusterRadius`.
        public init(
            shouldCluster: Bool = true,
            maximumZoomLevel: Int = 13,
            clusterColor: UIColor = MGLMapViewRepresentable.blue,
            clusterColorSteps: [Int: UIColor] = [:],
            clusterRadius: Int = 75
        ) {
            self.shouldCluster = shouldCluster
            self.maximumZoomLevel = maximumZoomLevel
            self.clusterColor = clusterColor
            self.clusterColorSteps = !clusterColorSteps.isEmpty ? clusterColorSteps : [50: clusterColor]
            self.clusterRadius = clusterRadius
        }
        
        /// Whether the features displayed on the map should cluster. Default is `true`.
        /// Corresponds to the `MGLShapeSourceOption` `.clustered`.
        public var shouldCluster: Bool
        
        /// Specifies the maximum zoom level at which to cluster points if clustering is enabled.
        /// Corresponds to `MGLShapeSourceOption` `.maximumZoomLevelForClustering`.
        public var maximumZoomLevel: Int
        
        /// The fill color of the circle cluster.
        /// Sets the `MGLCircleStyleLayer` `circleColor` property.
        public var clusterColor: UIColor
        
        /// Dictionary representation of cluster color steps where the `key` is the number of features in a cluster and the `value` is the color for that corresponding number.
        public var clusterColorSteps: [Int: UIColor]
        
        /// Specifies the radius of each cluster if clustering is enabled. Corresponds to the `MGLShapeSourceOption` `.clusterRadius`.
        public var clusterRadius: Int
    }
}
