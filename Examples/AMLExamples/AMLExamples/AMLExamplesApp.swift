//
// Copyright Amazon.com Inc. or its affiliates.
// All Rights Reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

import SwiftUI
import Amplify
import AWSLocationGeoPlugin
import AWSCognitoAuthPlugin

@main
struct AMLExamplesApp: App {
    var body: some Scene {
        WindowGroup {
            ExampleOneView()
        }
    }

    init() {
        configureAmplify()
    }

    private func configureAmplify() {
        let authPlugin = AWSCognitoAuthPlugin()
        let geoPlugin = AWSLocationGeoPlugin()
        do {
            try Amplify.add(plugin: authPlugin)
            try Amplify.add(plugin: geoPlugin)
            try Amplify.configure()
        } catch {
            print("Error configuring Amplify \(error)")
        }
    }
}
