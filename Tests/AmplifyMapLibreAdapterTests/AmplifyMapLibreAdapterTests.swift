//
// Copyright Amazon.com Inc. or its affiliates.
// All Rights Reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

import XCTest
@testable import AmplifyMapLibreAdapter
import Amplify
import MapLibre

final class AmplifyMapLibreAdapterTests: XCTestCase {
    var bounds: MLNCoordinateBounds!

    override func setUp() {
        let southwest = CLLocationCoordinate2D(latitude: 39.7382, longitude: -105.0042)
        let northeast = CLLocationCoordinate2D(latitude: 39.7682, longitude: -104.9765)
        bounds = MLNCoordinateBounds(sw: southwest, ne: northeast)
    }

    /// Test if register(sessionConfig:) registers AWSMapURLProtocol successfully.
    ///
    /// - Given: A URLSession configuration.
    /// - When:
    ///    - I invoke AWSMapURLProtocol.register(sessionConfig:)
    /// - Then:
    ///    - AWSMapURLProtocol is successfully registered to handle requests for the given URLSession.
    ///
    func testRegisterAWSMapURLProtocol() {
        let configuration = URLSessionConfiguration.default
        AWSMapURLProtocol.register(sessionConfig: configuration)
        dump(configuration.protocolClasses)
        XCTAssertEqual(configuration.protocolClasses?.count, 1)
        XCTAssertTrue(configuration.protocolClasses?.first == AWSMapURLProtocol.self)
    }

    /// Test if Geo.BoundingBox is correctly initiallized from MLNCoordinateBounds
    ///
    /// - Given: MLNCoordinateBounds
    /// - When:
    ///    - I invoke Geo.BoundingBox(bounds)
    /// - Then:
    ///    - An instance of Geo.BoundingBox is initialized with the given bounds.
    ///
    func testGeoBoundingBoxWithMLNCoordinateBounds() {
        let boundingBox = Geo.BoundingBox(bounds)
        XCTAssertEqual(boundingBox.northeast.latitude, bounds.ne.latitude)
        XCTAssertEqual(boundingBox.northeast.longitude, bounds.ne.longitude)
        XCTAssertEqual(boundingBox.southwest.latitude, bounds.sw.latitude)
        XCTAssertEqual(boundingBox.southwest.longitude, bounds.sw.longitude)
    }

    /// Test if Geo.SearchArea is correctly initialized from MLNCoordinateBounds.
    ///
    /// - Given: MLNCoordinateBounds
    /// - When:
    ///    - I invoke Geo.SearchArea.within(bounds)
    /// - Then:
    ///    - An instance of Geo.SearchArea is initialized with the given bounds.
    ///
    func testGeoSearchAreaWithMLNCoordinateBounds() {
        let searchArea = Geo.SearchArea.within(bounds)
        guard case .within(let boundingBox) = searchArea else {
            XCTFail("Failed to create Geo.SearchArea from MLNCoordinateBounds.")
            return
        }
        XCTAssertEqual(boundingBox.northeast.latitude, bounds.ne.latitude)
        XCTAssertEqual(boundingBox.northeast.longitude, bounds.ne.longitude)
        XCTAssertEqual(boundingBox.southwest.latitude, bounds.sw.latitude)
        XCTAssertEqual(boundingBox.southwest.longitude, bounds.sw.longitude)
    }

    /// Test if MLNPointFeature is correctly initialized with a title and coordinates.
    ///
    /// - Given: A title String and CLLocationCoordinate2D.
    /// - When:
    ///    - I invoke MLNPointFeature(title: title, coordinates: coordinates)
    /// - Then:
    ///    - An instance of MLNPointFeature is initialized with the given title and coordinates.
    ///
    func testMLNPointFeatureWithTitleAndCoordinates() {
        let title = "Test"
        let coordinates = CLLocationCoordinate2D(latitude: 39.7682, longitude: -104.9765)
        let feature = MLNPointFeature(title: title, coordinates: coordinates)
        XCTAssertEqual(feature.title, title)
        XCTAssertEqual(feature.coordinate.latitude, coordinates.latitude)
        XCTAssertEqual(feature.coordinate.longitude, coordinates.longitude)
    }
}
