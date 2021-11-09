//
// Copyright Amazon.com Inc. or its affiliates.
// All Rights Reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

import SwiftUI

public struct AMLSearchBar: View {
    @State var isEditing = false
    @Binding var text: String
    let onCommit: () -> Void
    let onCancel: () -> Void
    @Binding var displayState: DisplayState
    
    public init(
        text: Binding<String>,
        displayState: Binding<DisplayState>,
        onCommit: @escaping () -> Void,
        onCancel: @escaping () -> Void
    ) {
        _text = text
        _displayState = displayState
        self.onCommit = onCommit
        self.onCancel = onCancel
    }
    
    public var body: some View {
        HStack {
            TextField("Search", text: $text, onCommit: onCommit)
                .keyboardType(.webSearch)
                .padding(7)
                .padding(.horizontal, 25)
                .background(Color(.systemBackground))
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .strokeBorder(
                            Color.secondary,
                            style: StrokeStyle(lineWidth: 1.0)
                        )
                )
                .cornerRadius(8)
                .searchBarIconOverlay(isEditing: $isEditing, text: $text, displayState: $displayState)
                .onTapGesture {
                    isEditing = true
                }
        }
    }
}

fileprivate extension View {
    func searchBarIconOverlay(
        isEditing: Binding<Bool>,
        text: Binding<String>,
        displayState: Binding<AMLSearchBar.DisplayState>
    ) -> some View {
        self.overlay(
            AMLSearchBarIconOverlay(
                isEditing: isEditing,
                text: text,
                displayState: displayState
            )
        )
    }
}

struct SearchBar_Previews: PreviewProvider {
    static var previews: some View {
        AMLSearchBar(
            text: .constant(""),
            displayState: .constant(.map),
            onCommit: {},
            onCancel: {}
        )
    }
}

fileprivate struct AMLSearchBarIconOverlay: View {
    @Binding var isEditing: Bool
    @Binding var text: String
    @Binding var displayState: AMLSearchBar.DisplayState
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
                .frame(
                    minWidth: 0,
                    maxWidth: .infinity,
                    alignment: .leading
                )
                .padding(.leading, 8)
            
            if isEditing {
                Button(action: {
                    text = ""
                    endEditing()
                }, label: {
                    Image(systemName: "multiply")
                        .font(.body.weight(.medium))
                        .foregroundColor(.primary)
                        .padding(.trailing, 8)
                })
            }
            
            Button(action: {
              isEditing = false
                displayState.toggle()
              endEditing()
            }) {
              Image(systemName: displayState.imageName)
                .font(.body.weight(.medium))
                .foregroundColor(.primary)
                .padding(.trailing, 8)
            }
            .padding(.trailing, 10)
            .transition(.move(edge: .trailing))
        }
    }
}

extension View {
    func endEditing() {
        UIApplication.shared.sendAction(
            #selector(UIResponder.resignFirstResponder),
            to: nil,
            from: nil,
            for: nil
        )
    }
}


public extension AMLSearchBar {
    struct DisplayState: Equatable {
        let imageName: String
        
        public static let map = DisplayState(imageName: "list.bullet")
        public static let list = DisplayState(imageName: "map")
        
        mutating func toggle() {            
            if self == .list { self = .map }
            else { self = .list }
        }
    }
}
