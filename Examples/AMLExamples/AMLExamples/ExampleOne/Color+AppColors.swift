//
// Copyright Amazon.com Inc. or its affiliates.
// All Rights Reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

import SwiftUI
import UIKit

extension Color {
    static let tertiaryBackground = Color(
        UIColor(
            dynamicProvider: {
                switch $0.userInterfaceStyle {
                case .dark: return .tertiarySystemGroupedBackground
                default: return .secondarySystemGroupedBackground
                }
            }
        )
    )

    static let quaternaryBackground = Color(
        UIColor(
            dynamicProvider: {
                switch $0.userInterfaceStyle {
                case .dark: return .quaternarySystemFill
                default: return .tertiarySystemGroupedBackground
                }
            }
        )
    )
}
