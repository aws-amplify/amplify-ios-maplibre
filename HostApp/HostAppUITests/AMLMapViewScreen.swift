//
// Copyright Amazon.com Inc. or its affiliates.
// All Rights Reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

import XCTest

struct AMLMapViewScreen: Screen {
    let app: XCUIApplication

    private enum Identifiers {
        static let mapViewButton = "simple_amlmapview"
        static let mapView = "amlmapview"
        static let attributionButton = "amlmapview_attribution_button"
        static let attributionText = "amlmapview_attribution_text"
    }

    func goToMapView() -> Self {
        let amlMapViewButton = app.buttons[Identifiers.mapViewButton]
        amlMapViewButton.tap()
        return self
    }

    func testTapToZoom() -> Self {
        let mapView = app.otherElements[Identifiers.mapView]
        // Default starting zoom
        XCTAssertEqual(mapView.value as? String, "Zoom 15x")
        // Zoom in
        mapView.doubleTap()
        // Zoom value updated
        XCTAssertEqual(mapView.value as? String, "Zoom 16x")
        return self
    }

    func testAttributionFlow() -> Self {
        // Get attribution button
        let attributionButton = app.buttons[Identifiers.attributionButton]
        XCTAssert(attributionButton.exists)

        // Get attribution text
        let attributionText = app.staticTexts[Identifiers.attributionText]
        // Attribution text hidden until attribution button tapped
        XCTAssertFalse(attributionText.isHittable)

        // Tap attribution button to show attribution text
        attributionButton.tap()
        // Attribution text visible
        XCTAssertTrue(attributionText.isHittable)
        XCTAssertFalse(attributionButton.isHittable)

        // Tap attribution text to hide attribution text
        attributionText.tap()
        // Attribution button visible again.
        XCTAssertTrue(attributionButton.isHittable)
        XCTAssertFalse(attributionText.isHittable)
        return self
    }

}
