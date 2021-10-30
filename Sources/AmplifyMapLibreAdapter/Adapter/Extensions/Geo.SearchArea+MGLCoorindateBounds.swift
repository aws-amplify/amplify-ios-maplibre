//
//  File.swift
//  
//
//  Created by Ameter, Christopher on 10/30/21.
//

import Foundation
import Amplify
import Mapbox

public extension Geo.SearchArea  {
    /// Creates a SearchArea that only returns places within the provided
    /// MGLCoordinateBounds.
    /// - Parameter bounds: The bounds for the search area.
    /// - Returns: The SearchArea.
    static func within(_ bounds: MGLCoordinateBounds) -> Geo.SearchArea {
        .within(Geo.BoundingBox(bounds))
    }
}
