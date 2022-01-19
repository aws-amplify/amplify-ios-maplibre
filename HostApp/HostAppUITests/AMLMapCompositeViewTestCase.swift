//
//  AMLMapCompositeViewTestCase.swift
//  HostAppUITests
//
//  Created by Saultz, Ian on 1/19/22.
//

import XCTest

final class AMLMapCompositeViewTestCase: UITestCase {
    func testMap() {
        _ = AMLMapCompositeViewScreen(app: app)
            .goToMapCompositeView()
            .testMapControlButtons()
            .testSearchField()
    }
}
