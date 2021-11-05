//
//  File.swift
//  
//
//  Created by Ameter, Christopher on 11/5/21.
//

import Foundation
import AWSCore
import Amplify
import AWSLocationGeoPlugin

extension AWSMapURLProtocol {
    struct GeoConfig {
        let regionName: String
        let credentialsProvider: AWSCredentialsProvider
        let hostName: String
    
        init?() {
            guard let plugin = try? Amplify.Geo.getPlugin(for: "awsLocationGeoPlugin") as? AWSLocationGeoPlugin else {
                assertionFailure(AWSMapURLProtocolError.configurationError.localizedDescription)
                return nil
            }
            credentialsProvider = plugin.authService.getCredentialsProvider()
            regionName = plugin.pluginConfig.regionName
            hostName = "maps.geo.\(regionName).amazonaws.com"
        }
    }
}
