//
//  AmplifyMaplibre.swift
//  GeoTest
//
//  Created by Ameter, Christopher on 7/15/21.
//

import Foundation
import CoreLocation
import Mapbox
import Amplify


public class AmplifyMaplibre {
    /// Creates an instance of MGLMapView configured to work with Amplify and Amazon Location Service.
    /// - Parameter mapStyle: The MapStyle for the map. (optional, default: The MapStyle
    /// that corresponds to the default map in amplifyconfiguration.json)
    /// - Returns: An instance of MGLMapView.
    public class func createMap(_ mapStyle: Geo.MapStyle? = nil, completionHandler: @escaping Geo.ResultsHandler<MGLMapView>) {
        AWSMapURLProtocol.register(sessionConfig: MGLNetworkConfiguration.sharedManager.sessionConfiguration)

        //let styleURL = mapStyle?.styleURL ?? Amplify.Geo.getDefaultMap().styleURL∫
        if let mapStyle = mapStyle {
            completionHandler(.success(MGLMapView(frame: .zero, styleURL: mapStyle.styleURL)))
            return
        }
        
        Amplify.Geo.defaultMap { result in
            switch result {
            case .success(let map):
                completionHandler(.success(MGLMapView(frame: .zero, styleURL: map.styleURL)))
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
    }
    
    /// Convert a Place array to an MGLAnnotation array that is ready to be displayed on a map.
    /// - Parameter places: Place array to convert.
    /// - Returns: MGLAnnotation array.
    public class func createAnnotations(_ places: [Geo.Place]) -> [MGLPointAnnotation] {
        places.map { place in
            MGLPointAnnotation(title: place.label ?? "", coordinates: CLLocationCoordinate2D(place.coordinates))
        }
    }
}
