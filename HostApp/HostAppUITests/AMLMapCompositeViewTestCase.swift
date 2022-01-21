//
// Copyright Amazon.com Inc. or its affiliates.
// All Rights Reserved.
//
// SPDX-License-Identifier: Apache-2.0
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
