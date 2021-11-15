//
// Copyright Amazon.com Inc. or its affiliates.
// All Rights Reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

import Foundation
import CoreLocation
import Mapbox
import Amplify

public class AmplifyMapLibre {
    /// Creates an instance of MGLMapView configured to work with Amplify and Amazon
    /// Location Service using the default map
    /// - Parameter completionHandler: The completion handler.
    public class func createMap(completionHandler: @escaping Geo.ResultsHandler<MGLMapView>) {
        AWSMapURLProtocol.register(sessionConfig: MGLNetworkConfiguration.sharedManager.sessionConfiguration)
        Amplify.Geo.defaultMap { result in
            switch result {
            case .success(let map):
                completionHandler(.success(MGLMapView(frame: .zero, styleURL: map.styleURL)))
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
    }

    /// Creates an instance of MGLMapView configured to work with Amplify and Amazon
    /// Location Service using the specified MapStyle.
    /// - Parameter mapStyle: The MapStyle for the map. (optional, default: The MapStyle
    /// that corresponds to the default map in amplifyconfiguration.json)
    /// - Returns: An instance of MGLMapView.
    public class func createMap(_ mapStyle: Geo.MapStyle) -> MGLMapView {
        AWSMapURLProtocol.register(sessionConfig: MGLNetworkConfiguration.sharedManager.sessionConfiguration)
        return MGLMapView(frame: .zero, styleURL: mapStyle.styleURL)
    }

    /// Convert a Place array to an MGLPointFeature array that is ready to be displayed on a map.
    /// - Parameter places: Place array to convert.
    /// - Returns: MGLPointFeature array.
    public class func createFeatures(_ places: [Geo.Place]) -> [MGLPointFeature] {
        places.map(MGLPointFeature.init)
    }
}
