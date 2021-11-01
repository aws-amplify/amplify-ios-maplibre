//
// Copyright Amazon.com Inc. or its affiliates.
// All Rights Reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

import Foundation
import XCTest
@testable import Amplify
import AWSCognitoAuthPlugin
import AWSLocationGeoPlugin
import AmplifyMapLibreAdapter

let timeout = 30.0
let amplifyConfigurationFile = "amplifyconfiguration"

enum IntegrationTestError: Error {
    case missingConfig
}

class AdapterIntegrationTests: XCTestCase {
    override func setUp() {
        continueAfterFailure = false
        do {
            try Amplify.add(plugin: AWSCognitoAuthPlugin())
            try Amplify.add(plugin: AWSLocationGeoPlugin())
            let configurationData = try retrieve(forResource: amplifyConfigurationFile)
            let configuration = try AmplifyConfiguration.decodeAmplifyConfiguration(from: configurationData)
            try Amplify.configure(configuration)
        } catch {
            XCTFail("Failed to initialize and configure Amplify: \(error)")
        }
    }
    
    private func retrieve(forResource: String) throws -> Data {
        guard let path = Bundle.module.path(forResource: forResource, ofType: "json") else {
            print("Could not retrieve configuration file: \(forResource)")
            throw IntegrationTestError.missingConfig
        }
        
        let url = URL(fileURLWithPath: path)
        
        return try Data(contentsOf: url)
    }

    func testCreateMap() {
        
        AmplifyMaplibre.createMap { result in
            print("boom")
            dump(map)
        }
    }
}
