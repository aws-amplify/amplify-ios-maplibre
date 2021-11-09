//
//  HostAppApp.swift
//  HostApp
//
//  Created by Saultz, Ian on 10/26/21.
//

import SwiftUI
import Amplify
import AWSLocationGeoPlugin
import AWSCognitoAuthPlugin

@main
struct HostAppApp: App {
    
    var body: some Scene {
        WindowGroup {
            ContentView()
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
