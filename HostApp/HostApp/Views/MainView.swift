//
//  MainView.swift
//  HostApp
//
//  Created by Saultz, Ian on 1/18/22.
//

import SwiftUI

struct MainView: View {
    var body: some View {
        NavigationView {
            List(ListRow.allCases) { row in
                NavigationLink(row.description) {
                    row.destinationView
                        .navigationBarTitle(
                            Text(row.description),
                            displayMode: .inline
                        )
                }
                .accessibilityIdentifier(row.a11yIdentifier)
            }
            .navigationTitle(Text("Map Options"))
            .accessibilityIdentifier("list")
        }
    }
}

extension MainView {
    struct ListRow: Identifiable {
        let id: String
        let a11yIdentifier: String
        let description: String
        let destinationView: AnyView

        static let allCases: [Self] = [
            .simpleAMLMapView,
            .customAMLMapView,
            .amlMapCompositeView
        ]

        static let simpleAMLMapView: Self = .init(
            id: "000",
            a11yIdentifier: "simple_amlmapview",
            description: "Simple AMLMapView",
            destinationView: AnyView(SimpleAMLMapView_View())
        )

        static let customAMLMapView: Self = .init(
            id: "002",
            a11yIdentifier: "custom_amlmapview",
            description: "Custom AMLMapView",
            destinationView: AnyView(AMLMapView_View())
        )

        static let amlMapCompositeView: Self = .init(
            id: "001",
            a11yIdentifier: "amlmapcompositeview",
            description: "AMLMapCompositeView",
            destinationView: AnyView(AMLMapCompositeView_View())
        )
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
