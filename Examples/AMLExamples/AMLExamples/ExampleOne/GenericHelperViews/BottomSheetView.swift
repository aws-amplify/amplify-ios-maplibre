//
// Copyright Amazon.com Inc. or its affiliates.
// All Rights Reserved.
//
// SPDX-License-Identifier: Apache-2.0
//


import SwiftUI

struct BottomSheetView<Content: View>: View {
    @GestureState private var translation: CGFloat = 0

    @Binding var displayState: BottomSheetDisplayState
    let minHeight: CGFloat
    let content: Content

    init(
        displayState: Binding<BottomSheetDisplayState>,
        minHeight: CGFloat = 70,
        @ViewBuilder content: () -> Content
    ) {
        self.minHeight = minHeight
        self.content = content()
        self._displayState = displayState
    }

    var body: some View {
        GeometryReader { proxy in
            VStack(spacing: 0) {
                GrabBarIndicator()
                    .padding(4)
                content
            }
            .frame(width: proxy.size.width, height: sheetHeight(for: proxy), alignment: .top)
            .background(Color(uiColor: .secondarySystemBackground))
            .cornerRadius(18)
            .frame(height: proxy.size.height, alignment: .bottom)
            .offset(y: max(sheetOffset(containerProxy: proxy) + translation, 0))
            .animation(
                .spring(response: 0.45, dampingFraction: 0.85, blendDuration: 0.05),
                value: displayState
            )
            .gesture(
                DragGesture().updating($translation) { value, state, _ in
                    state = value.translation.height
                }.onEnded { value in
                    displayState = newSheetPlacement(
                        for: value,
                        height: sheetHeight(for: proxy)
                    )
                }
            )
        }
    }

    private func sheetHeight(for geometryProxy: GeometryProxy) -> CGFloat {
        geometryProxy.size.height - 40
    }

    private func newSheetPlacement(
        for value: GestureStateGesture<DragGesture, CGFloat>.Value,
        height: CGFloat
    ) -> BottomSheetDisplayState {
        let fullScreenThreshold = height * 0.40
        let halfScreenThreshold = height * 0.85
        switch value.location.y {
        case ...fullScreenThreshold:
            return .fullScreen
        case ...halfScreenThreshold:
            endEditing()
            return .halfScreen
        default:
            endEditing()
            return .bottom
        }
    }

    private func sheetOffset(containerProxy: GeometryProxy) -> CGFloat {
        switch displayState {
        case .fullScreen:
            return 20
        case .halfScreen:
            return sheetHeight(for: containerProxy) * 0.68
        case .bottom:
            return sheetHeight(for: containerProxy) - minHeight
        }
    }

    private func endEditing() {
        UIApplication.shared.sendAction(
            #selector(UIResponder.resignFirstResponder),
            to: nil,
            from: nil,
            for: nil
        )
    }
}

enum BottomSheetDisplayState {
    case fullScreen
    case halfScreen
    case bottom
}

struct BottomSheetView_Previews: PreviewProvider {
    static var previews: some View {
        BottomSheetView(displayState: .constant(.halfScreen)) {
            Rectangle().fill(Color.red)
        }.edgesIgnoringSafeArea(.all)
    }
}
