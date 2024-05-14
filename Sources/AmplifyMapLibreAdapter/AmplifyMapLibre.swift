//
// Copyright Amazon.com Inc. or its affiliates.
// All Rights Reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

import Foundation
import CoreLocation
import MapLibre
import Amplify
import AWSLocationGeoPlugin

public class AmplifyMapLibre {

    /// Creates an instance of MLNMapView configured to work with Amplify and Amazon
    /// Location Service using the default map
    @MainActor public class func createMap() async throws -> MLNMapView {
        AWSMapURLProtocol.register(sessionConfig: MLNNetworkConfiguration.sharedManager.sessionConfiguration)
        let map = try await Amplify.Geo.defaultMap()
        return MLNMapView(frame: .zero, styleURL: map.styleURL)
    }

    /// Creates an instance of MLNMapView configured to work with Amplify and Amazon
    /// Location Service using the specified MapStyle.
    /// - Parameter mapStyle: The MapStyle for the map. (optional, default: The MapStyle
    /// that corresponds to the default map in amplifyconfiguration.json)
    /// - Returns: An instance of MLNMapView.
    public class func createMap(_ mapStyle: Geo.MapStyle) -> MLNMapView {
        AWSMapURLProtocol.register(sessionConfig: MLNNetworkConfiguration.sharedManager.sessionConfiguration)
        return MLNMapView(frame: .zero, styleURL: mapStyle.styleURL)
    }

    /// Convert a Place array to an MLNPointFeature array that is ready to be displayed on a map.
    /// - Parameter places: Place array to convert.
    /// - Returns: MLNPointFeature array.
    public class func createFeatures(_ places: [Geo.Place]) -> [MLNPointFeature] {
        places.map(MLNPointFeature.init)
    }
}
