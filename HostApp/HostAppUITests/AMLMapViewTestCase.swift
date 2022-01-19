//
//  AMLMapViewTestCase.swift
//  HostAppUITests
//
//  Created by Saultz, Ian on 1/19/22.
//

import XCTest

final class AMLMapViewTestCase: UITestCase {
    func testMap() {
        _ = AMLMapViewScreen(app: app)
            .goToMapView()
            .testTapToZoom()
            .testAttributionFlow()
    }
}
