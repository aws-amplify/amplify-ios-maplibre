//
// Copyright Amazon.com Inc. or its affiliates.
// All Rights Reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

import SwiftUI

struct Favorite: Identifiable {
    let id = UUID()
    let systemImageName: String
    let imageForegroundColor: Color
    let imageBackgroundColor: Color
    let primaryText: String
    let secondaryText: String
}

extension Array where Element == Favorite {
    static func mock(count: Int) -> [Favorite] {
        (0..<count).map { _ in
                .init(
                    systemImageName: "house.fill",
                    imageForegroundColor: .white,
                    imageBackgroundColor: .cyan,
                    primaryText: "Home",
                    secondaryText: "Add"
                )
        }
    }

    static let mock: [Favorite] = [
        .init(
            systemImageName: "house.fill",
            imageForegroundColor: .white,
            imageBackgroundColor: .cyan,
            primaryText: "Home",
            secondaryText: "Add"
        ),
        .init(
            systemImageName: "briefcase.fill",
            imageForegroundColor: .blue,
            imageBackgroundColor: .quaternaryBackground,
            primaryText: "Work",
            secondaryText: "Add"
        ),
        .init(
            systemImageName: "mappin",
            imageForegroundColor: .white,
            imageBackgroundColor: .red,
            primaryText: "12 Main...",
            secondaryText: "5.1 mi"
        ),
        .init(
            systemImageName: "plus",
            imageForegroundColor: .blue,
            imageBackgroundColor: .quaternaryBackground,
            primaryText: "Add",
            secondaryText: ""
        )
    ]
}


