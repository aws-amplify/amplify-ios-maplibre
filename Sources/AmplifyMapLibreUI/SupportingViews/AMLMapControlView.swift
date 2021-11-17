//
// Copyright Amazon.com Inc. or its affiliates.
// All Rights Reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

import SwiftUI

/// AMLMapControlView that displays zoom in, zoom out, and align north buttons.
public struct AMLMapControlView: View {
    /// The current zoom level of the map.
    @Binding var zoomValue: Double

    /// The current heading of the map.
    @Binding var headingValue: Double

    /// Create a new `AMLMapControlView` with three buttons to control zoom level and heading of the map.
    /// - Parameters:
    ///   - zoomValue: The current zoom level of the map.
    ///   - headingValue: The current heading of the map.
    public init(
        zoomValue: Binding<Double>,
        headingValue: Binding<Double>
    ) {
        _zoomValue = zoomValue
        _headingValue = headingValue
    }

    public var body: some View {
        VStack(spacing: 0) {
            AMLMapControlButton(
                action: zoomIn,
                systemName: "plus"
            )
                .accessibility(hint: Text("Zoom in on the map"))
                .accessibility(label: Text("Zoom in"))
                .accessibility(value: Text("Current zoom: \(zoomValue.accessibilityFormatted)"))

            Divider()
                .frame(width: 47)

            AMLMapControlButton(
                action: zoomOut,
                systemName: "minus"
            )
                .accessibility(hint: Text("Zoom out on the map"))
                .accessibility(label: Text("Zoom out"))
                .accessibility(value: Text("Current zoom: \(zoomValue.accessibilityFormatted)"))

            Divider()
                .frame(width: 47)

            AMLMapControlButton(
                action: alignNorth,
                systemName: "location.north.fill"
            )
                .accessibility(hint: Text("Align map so that top of screen is North"))
                .accessibility(label: Text("Align North"))
        }
        .background(Color(UIColor.secondarySystemBackground))
        .cornerRadius(7.5)
        .overlay(
            RoundedRectangle(cornerRadius: 7.5)
                    .stroke(Color.secondary, lineWidth: 0.5)
        )
    }

    private func zoomIn() { zoomValue += 1 }
    private func zoomOut() { zoomValue -= 1 }
    private func alignNorth() { headingValue = 0 }
}

fileprivate extension Double {
    var accessibilityFormatted: String {
        String(Int(self))
    }
}
