//
// Copyright Amazon.com Inc. or its affiliates.
// All Rights Reserved.
//
// SPDX-License-Identifier: Apache-2.0
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
