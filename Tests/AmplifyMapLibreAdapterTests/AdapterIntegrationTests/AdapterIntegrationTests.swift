//
// Copyright Amazon.com Inc. or its affiliates.
// All Rights Reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

import Foundation
import XCTest
import Amplify
import AWSCognitoAuthPlugin
import AWSLocationGeoPlugin
import AmplifyMapLibreAdapter

let timeout = 30.0
let amplifyConfigurationFile = "testconfiguration/AWSLocationGeoPluginIntegrationTests-amplifyconfiguration"

class AdapterIntegrationTests: XCTestCase {
    override func setUp() {
        continueAfterFailure = false
        do {
            try Amplify.add(plugin: AWSCognitoAuthPlugin())
            try Amplify.add(plugin: AWSLocationGeoPlugin())
            //let configuration = try TestConfigHelper.retrieveAmplifyConfiguration(forResource: amplifyConfigurationFile)
            try Amplify.configure()
        } catch {
            XCTFail("Failed to initialize and configure Amplify: \(error)")
        }
    }

    func testCreateMap() {
        AmplifyMaplibre.createMap { map in
            print("boom")
            dump(map)
        }
    }
}
