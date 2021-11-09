//
// Copyright Amazon.com Inc. or its affiliates.
// All Rights Reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

import SwiftUI

/// AMLMapControlView that displays zoom in, zoom out, and direction alignment buttons.
public struct AMLMapControlView: View {
    /// Action that is called when the zoom in button is tapped.
    let zoomInAction: () -> Void
    /// Action that is called when the zoom out button is tapped.
    let zoomOutAction: () -> Void
    /// Action that is called when the compass button is tapped.
    let compassAction: () -> Void
    /// The current zoom value of the map. This is used to set the accessibility value of the the zoom control buttons. Double value is truncated to Integer representation for the accessibility value.
    let zoomValue: Double
    
    /// Initialize a new instance of AMLMapControlView
    /// - Parameters:
    ///   - zoomValue: The current zoom value of the map. This is used to set the accessibility value of the the zoom control buttons. Double value is truncated to Integer representation for the accessibility value.
    ///   - zoomInAction: Action that is called when the zoom in button is tapped.
    ///   - zoomOutAction: Action that is called when the zoom out button is tapped.
    ///   - compassAction: Action that is called when the compass button is tapped.
    public init(
        zoomValue: Double,
        zoomInAction: @escaping () -> Void,
        zoomOutAction: @escaping () -> Void,
        compassAction: @escaping () -> Void
    ) {
        self.zoomValue = zoomValue
        self.zoomInAction = zoomInAction
        self.zoomOutAction = zoomOutAction
        self.compassAction = compassAction
    }
    
    public var body: some View {
        VStack(spacing: 0) {
            AMLMapControlButton(action: zoomInAction, systemName: "plus")
                .accessibility(hint: Text("Zoom in on the map"))
                .accessibility(label: Text("Zoom in"))
                .accessibility(value: Text("Current zoom: \(zoomValue.accessibilityFormatted)"))
            
            Divider()
                .frame(width: 47)
            
            AMLMapControlButton(action: zoomOutAction, systemName: "minus")
                .accessibility(hint: Text("Zoom out on the map"))
                .accessibility(label: Text("Zoom out"))
                .accessibility(value: Text("Current zoom: \(zoomValue.accessibilityFormatted)"))

            Divider()    
                .frame(width: 47)
            
            AMLMapControlButton(action: compassAction, systemName: "location.north.fill")
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
}

fileprivate extension Double {
    var accessibilityFormatted: String {
        String(Int(self))
    }
}
