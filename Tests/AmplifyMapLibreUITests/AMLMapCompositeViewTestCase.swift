//
// Copyright Amazon.com Inc. or its affiliates.
// All Rights Reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

import SwiftUI
import XCTest
import MapLibre
@testable import AmplifyMapLibreAdapter
@testable import AmplifyMapLibreUI

class AMLMapCompositeViewTestCase: XCTestCase {

    private func compositeView(with mapState: AMLMapViewState) -> AMLMapCompositeView {
        let viewModel = AMLMapCompositeViewModel(mapState: mapState)
        return AMLMapCompositeView(viewModel: viewModel)
    }

    func testShowUserLocation() {
        // User supplied map
        do {
            let mapView = MLNMapView()
            let mapState = AMLMapViewState(mapView: mapView)
            let map = compositeView(with: mapState)
                .showUserLocation(true)

            XCTAssertTrue(map.viewModel.mapSettings.showUserLocation)
        }
        // Framework generated map
        do {
            let map = AMLMapCompositeView()
                .showUserLocation(true)
            XCTAssertTrue(map.viewModel.mapSettings.showUserLocation)
        }
    }

    func testAllowedZoomLevels() {
        // User supplied map
        do {
            let mapView = MLNMapView()
            let mapState = AMLMapViewState(mapView: mapView)
            let map = compositeView(with: mapState)
                .allowedZoomLevels(5 ... 15)

            XCTAssertEqual(map.viewModel.mapSettings.minZoomLevel, 5)
            XCTAssertEqual(map.viewModel.mapSettings.maxZoomLevel, 15)
        }
        // Framework generated map
        do {
            let map = AMLMapCompositeView()
                .allowedZoomLevels(5 ... 15)

            XCTAssertEqual(map.viewModel.mapSettings.minZoomLevel, 5)
            XCTAssertEqual(map.viewModel.mapSettings.maxZoomLevel, 15)
        }
    }

    func testMaxZoomLevel() {
        // User supplied map
        do {
            let mapView = MLNMapView()
            let mapState = AMLMapViewState(mapView: mapView)
            let map = compositeView(with: mapState)
                .maxZoomLevel(3)

            XCTAssertEqual(map.viewModel.mapSettings.maxZoomLevel, 3)
        }
        // Framework generated map
        do {
            let map = AMLMapCompositeView()
                .maxZoomLevel(3)

            XCTAssertEqual(map.viewModel.mapSettings.maxZoomLevel, 3)
        }
    }

    func testMinZoomLevel() {
        // User supplied map
        do {
            let mapView = MLNMapView()
            let mapState = AMLMapViewState(mapView: mapView)
            let map = compositeView(with: mapState)
                .minZoomLevel(14)

            XCTAssertEqual(map.viewModel.mapSettings.minZoomLevel, 14)
        }
        // Framework generated map
        do {
            let map = AMLMapCompositeView()
                .minZoomLevel(14)

            XCTAssertEqual(map.viewModel.mapSettings.minZoomLevel, 14)
        }
    }

}
