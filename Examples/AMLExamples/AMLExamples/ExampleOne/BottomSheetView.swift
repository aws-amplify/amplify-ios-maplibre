//
//  BottomSheetView.swift
//  AMLExamples
//
//  Created by Saultz, Ian on 1/20/22.
//

import SwiftUI

public enum BottomSheetDisplayState {
    case fullScreen
    case halfScreen
    case bottom
}

struct BottomSheetView<Content: View>: View {

    @Binding var displayType: BottomSheetDisplayState
    let minHeight: CGFloat
    let content: Content

    @GestureState private var translation: CGFloat = 0

    private func offset(proxy: GeometryProxy) -> CGFloat {
        switch displayType {
        case .fullScreen:
            return 20
        case .halfScreen:
            return sheetHeight(for: proxy) * 0.68
        case .bottom:
            return sheetHeight(for: proxy) - minHeight
        }
    }

    private var indicator: some View {
        RoundedRectangle(cornerRadius: 22)
            .fill(Color.primary.opacity(0.6))
            .frame(
                width: 30,
                height: 4
            ).onTapGesture {
                /* maybe do something here? */
            }
    }

    init(displayType: Binding<BottomSheetDisplayState>, minHeight: CGFloat = 70, @ViewBuilder content: () -> Content) {
        self.minHeight = minHeight
        self.content = content()
        self._displayType = displayType
    }

    var body: some View {
        GeometryReader { proxy in
            VStack(spacing: 0) {
                indicator.padding(4)
                content
            }
            .frame(width: proxy.size.width, height: sheetHeight(for: proxy), alignment: .top)
            .background(Color(uiColor: .secondarySystemBackground))
            .cornerRadius(22)
            .frame(height: proxy.size.height, alignment: .bottom)
            .offset(y: max(offset(proxy: proxy) + translation, 0))
            .animation(.interactiveSpring())
            .gesture(
                DragGesture().updating($translation) { value, state, _ in
                    state = value.translation.height
                }.onEnded { value in
                    determineSheetPlacement(
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

    private func determineSheetPlacement(for value: GestureStateGesture<DragGesture, CGFloat>.Value, height: CGFloat) {
        let fullScreenThreshold = height * 0.40
        let halfScreenThreshold = height * 0.85
        switch value.location.y {
        case ...fullScreenThreshold: displayType = .fullScreen
        case ...halfScreenThreshold: displayType = .halfScreen
        default: displayType = .bottom
        }
    }
}

struct BottomSheetView_Previews: PreviewProvider {
    static var previews: some View {
        BottomSheetView(displayType: .constant(.halfScreen)) {
            Rectangle().fill(Color.red)
        }.edgesIgnoringSafeArea(.all)
    }
}
