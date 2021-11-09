//
// Copyright Amazon.com Inc. or its affiliates.
// All Rights Reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

import SwiftUI
import XCTest
import Mapbox
@testable import AmplifyMapLibreAdapter
@testable import AmplifyMapLibreUI

final class AMLMapViewTestCase: XCTestCase {

    var mglMapView: MGLMapView!

    override func setUp() {
        mglMapView = .init()
    }

    // MARK: View Modifier Test Cases

    // public func showUserLocation(_ showLocation: Bool) -> AMLMapView
    func testShowUserLocation() {
        let mapView = AMLMapView(mapView: mglMapView)
        // `showUserLocation` defaults to false if `AMLMapView` is instantiated without a `userLocation`
        XCTAssertFalse(mapView.mapView.showsUserLocation)

        do {
            let mapView = mapView.showUserLocation(false)
            XCTAssertFalse(mapView.mapView.showsUserLocation)
        }

        do {
            let mapView = mapView.showUserLocation(true)
            XCTAssertTrue(mapView.mapView.showsUserLocation)
        }
    }

    // public func allowedZoomLevels(_ zoomLevels: ClosedRange<Double>) -> AMLMapView
    func testAllowedZoomLevels() {
        let mapView = AMLMapView(mapView: mglMapView)
        // Test default behavior
        XCTAssertEqual(mapView.mapView.minimumZoomLevel, 0)
        XCTAssertEqual(mapView.mapView.maximumZoomLevel, 22)

        // Test range with allowed lower and upper bounds
        do {
            let mapView = mapView.allowedZoomLevels(1.5...19)
            XCTAssertEqual(mapView.mapView.minimumZoomLevel, 1.5)
            XCTAssertEqual(mapView.mapView.maximumZoomLevel, 19)
        }

        // Test range with allowed lower bound and unallowed upper bound
        do {
            let mapView = mapView.allowedZoomLevels(2...40)
            XCTAssertEqual(mapView.mapView.minimumZoomLevel, 2)
            XCTAssertEqual(mapView.mapView.maximumZoomLevel, 22)
        }

        // Test range with unallowed lower bound and allowed upper bound
        do {
            let mapView = mapView.allowedZoomLevels(-4...20)
            XCTAssertEqual(mapView.mapView.minimumZoomLevel, 0)
            XCTAssertEqual(mapView.mapView.maximumZoomLevel, 20)
        }

        // Test range with unallowed lower and upper bounds
        do {
            let mapView = mapView.allowedZoomLevels(-4...23)
            XCTAssertEqual(mapView.mapView.minimumZoomLevel, 0)
            XCTAssertEqual(mapView.mapView.maximumZoomLevel, 22)
        }
    }

    // public func maxZoomLevel(_ maxZoomLevel: Double) -> AMLMapView
    func testMaxZoomLevel() {
        let mapView = AMLMapView(mapView: mglMapView)
            .maxZoomLevel(19)
        XCTAssertEqual(mapView.mapView.maximumZoomLevel, 19)

        do {
            let mapView = mapView.maxZoomLevel(24)
            XCTAssertEqual(mapView.mapView.maximumZoomLevel, 22)
        }
    }

    // public func minZoomLevel(_ minZoomLevel: Double) -> AMLMapView
    func testMinZoomLevel() {
        let mapView = AMLMapView(mapView: mglMapView)
            .minZoomLevel(4)
        XCTAssertEqual(mapView.mapView.minimumZoomLevel, 4)

        do {
            let mapView = mapView.minZoomLevel(-3)
            XCTAssertEqual(mapView.mapView.minimumZoomLevel, 0)
        }
    }
}

fileprivate extension Double {
    func rounded(places: Double) -> Double {
        let divisor = pow(10, places)
        return (self * divisor).rounded() / divisor
    }
}
