//
// Copyright Amazon.com Inc. or its affiliates.
// All Rights Reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

import Foundation
import Amplify
import AWSLocationGeoPlugin
import AWSClientRuntime

extension AWSMapURLProtocol {
    struct GeoConfig {
        let regionName: String
        let credentialsProvider: CredentialsProvider
        let hostName: String

        init?() {
            guard let plugin = try? Amplify.Geo.getPlugin(for: "awsLocationGeoPlugin") as? AWSLocationGeoPlugin else {
                assertionFailure(AWSMapURLProtocolError.configurationError.localizedDescription)
                return nil
            }
            self.credentialsProvider = plugin.authService.getCredentialsProvider()
            self.regionName = plugin.pluginConfig.regionName
            self.hostName = "maps.geo.\(regionName).amazonaws.com"
        }
    }
}
