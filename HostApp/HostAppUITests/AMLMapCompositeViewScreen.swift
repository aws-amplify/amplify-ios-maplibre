//
// Copyright Amazon.com Inc. or its affiliates.
// All Rights Reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

import XCTest

struct AMLMapCompositeViewScreen: Screen {
    let app: XCUIApplication

    private enum Identifiers {
        static let mapCompositeViewButton = "amlmapcompositeview"
        static let mapView = "amlmapview"
        static let zoomInButton = "amlmapcontrolbutton_zoom_in"
        static let zoomOutButton = "amlmapcontrolbutton_zoom_out"
        static let alignNorthButton = "amlmapcontrolbutton_align_north"
        static let searchBar = "amlsearchbar"
        static let searchBarButtonCancel = "amlsearchbar_button_cancel"

    }

    func goToMapCompositeView() -> Self {
        let amlMapCompositeViewButton = app.buttons[Identifiers.mapCompositeViewButton]
        amlMapCompositeViewButton.tap()
        return self
    }

    func testMapControlButtons() -> Self {
        let mapView = app.otherElements[Identifiers.mapView]
        // Default starting zoom
        XCTAssertEqual(mapView.value as? String, "Zoom 15x")
        // Zoom in
        let zoomInButton = app.buttons[Identifiers.zoomInButton]
        zoomInButton.tap()
        // Zoom value updated
        XCTAssertEqual(mapView.value as? String, "Zoom 16x")

        let zoomOutButton = app.buttons[Identifiers.zoomOutButton]
        zoomOutButton.tap()
        zoomOutButton.tap()
        // After tapping zoom out button twice, accessibility value of mapview should reflect zoom level of 14.
        XCTAssertEqual(mapView.value as? String, "Zoom 14x")

        let alignNorthButton = app.buttons[Identifiers.alignNorthButton]
        XCTAssert(alignNorthButton.isHittable)
        // Can't really assert anything meaningful here as map alignment isn't accessible.
        return self
    }

    func testSearchField() -> Self {
        let searchBar = app.textFields[Identifiers.searchBar]
        let cancelButton = app.buttons[Identifiers.searchBarButtonCancel]
        // Cancel button should not be shown until the search bar is in focus / contains text
        XCTAssertFalse(cancelButton.isHittable)

        searchBar.tap()
        // Now the cancel button should be visible
        XCTAssertTrue(cancelButton.isHittable)

        let searchText = "coffee"
        searchBar.typeText(searchText)
        // Accessibility value should equal text in the search bar
        XCTAssertEqual(searchBar.value as? String, searchText)

        cancelButton.tap()
        // Value should be default "Search" after tapping cancel button
        XCTAssertEqual(searchBar.value as? String, "Search")

        searchBar.tap()
        searchBar.typeText(searchText)
        let goButton = app.buttons["Go"]
        goButton.tap()
        return self
    }
}
