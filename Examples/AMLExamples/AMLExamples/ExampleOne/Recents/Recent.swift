//
// Copyright Amazon.com Inc. or its affiliates.
// All Rights Reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

import SwiftUI

struct Recent: Identifiable, Equatable {
    let id = UUID()
    let index: Int
    let title: String
    let subtitle: String
    let imageSystemName: String
    let imageForegroundColor: Color
    let imageBackgroundColor: Color
}

extension Array where Element == Recent {
    static let mock: [Recent] = [
        .init(
            index: 0,
            title: "Dropped Pin",
            subtitle: "90210 Beverly Hills",
            imageSystemName: "mappin",
            imageForegroundColor: .white,
            imageBackgroundColor: .red
        ),
        .init(
            index: 1,
            title: "Coffee",
            subtitle: "New York",
            imageSystemName: "magnifyingglass",
            imageForegroundColor: .white,
            imageBackgroundColor: .gray
        ),
        .init(
            index: 2,
            title: "Home",
            subtitle: "Directions from My Location",
            imageSystemName: "arrow.turn.up.right",
            imageForegroundColor: .white,
            imageBackgroundColor: .init(
                red: 72 / 255,
                green: 72 / 255,
                blue: 74 / 255
            )
        )
    ]
}
