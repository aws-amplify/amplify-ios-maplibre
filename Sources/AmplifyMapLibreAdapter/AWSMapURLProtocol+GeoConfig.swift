//
// Copyright Amazon.com Inc. or its affiliates.
// All Rights Reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

import Foundation
import Amplify
import AWSLocationGeoPlugin
import InternalAmplifyCredentials
import SmithyIdentity

extension AWSMapURLProtocol {
    struct GeoConfig {
        let regionName: String
        let identityResolver: any AWSCredentialIdentityResolver
        let hostName: String

        init?() {
            guard let plugin = try? Amplify.Geo.getPlugin(for: "awsLocationGeoPlugin") as? AWSLocationGeoPlugin else {
                assertionFailure(AWSMapURLProtocolError.configurationError.localizedDescription)
                return nil
            }
            guard let credentiaslProvider = plugin.authService as? AWSAuthCredentialsProviderBehavior else {
                return nil
            }
            self.identityResolver = credentiaslProvider.getCredentialIdentityResolver()
            self.regionName = plugin.pluginConfig.regionName
            self.hostName = "maps.geo.\(regionName).amazonaws.com"
        }
    }
}
