//
// Copyright Amazon.com Inc. or its affiliates.
// All Rights Reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

import SwiftUI

/// A Search Bar used to take location user search input.
public struct AMLSearchBar: View {

    /// Is the search bar currently being edited.
    @State var isEditing = false

    /// The text currently displayed in the search bar.
    @Binding var text: String

    /// Action called on user tapping search.
    let onCommit: () -> Void

    /// Action called on user tapping `x` button.
    let onCancel: () -> Void

    /// Displaying a map or list.
    @Binding var displayState: DisplayState

    /// Whether a display state button should be displayed. Default is true.
    let showDisplayStateButton: Bool

    /// A Search Bar used to take location user search input.
    /// - Parameters:
    ///   - text: Is the search bar currently being edited.
    ///   - displayState: The text currently displayed in the search bar.
    ///   - onCommit: Action called on user tapping search.
    ///   - onCancel: Displaying a map or list.
    ///   - showDisplayStateButton: Whether a display state button should be displayed. Default is true.
    public init(
        text: Binding<String>,
        displayState: Binding<DisplayState>,
        onCommit: @escaping () -> Void,
        onCancel: @escaping () -> Void,
        showDisplayStateButton: Bool = true
    ) {
        _text = text
        _displayState = displayState
        self.onCommit = onCommit
        self.onCancel = onCancel
        self.showDisplayStateButton = showDisplayStateButton
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
                .accessibility(label: Text("Place Search"))
                .accessibility(identifier: "amlsearchbar")
                .cornerRadius(8)
                .searchBarIconOverlay(
                    isEditing: $isEditing,
                    text: $text,
                    displayState: $displayState,
                    showDisplayStateButton: showDisplayStateButton
                )
                .onTapGesture {
                    isEditing = true
                }
        }
    }
}

public extension AMLSearchBar {
    /// Displaying a map or list.
    struct DisplayState: Equatable {
        /// The name of  the system image displayed in the `AMLSearchBar` button.
        let imageName: String

        /// Displaying a map.
        public static let map = DisplayState(imageName: "list.bullet")

        /// Displaying a list.
        public static let list = DisplayState(imageName: "map")

        /// Toggle state.
        mutating func toggle() {
            if self == .list { self = .map } else { self = .list }
        }

        /// Accessibility identifier for the button currently displayed.
        /// - Note: Value reflects the opposite of the current state.
        internal var accessibilityIdentifier: String {
            switch self {
            case .list: return "amlsearchbar_map_button"
            case .map: return "amlsearchbar_list_button"
            default: fatalError("Invalid State")
            }
        }

        /// Accessibility identifier for the button currently displayed.
        /// - Note: Value reflects the opposite of the current state.
        internal var accessibilityLabel: String {
            switch self {
            case .list: return "Show Map"
            case .map: return "Show List"
            default: fatalError("Invalid State")
            }
        }
    }
}

// MARK: Internal / Fileprivate Helper Views and Extensions
private extension View {
    func searchBarIconOverlay(
        isEditing: Binding<Bool>,
        text: Binding<String>,
        displayState: Binding<AMLSearchBar.DisplayState>,
        showDisplayStateButton: Bool
    ) -> some View {
        overlay(
            AMLSearchBarIconOverlay(
                isEditing: isEditing,
                text: text,
                displayState: displayState,
                showDisplayStateButton: showDisplayStateButton
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

private struct AMLSearchBarIconOverlay: View {
    @Binding var isEditing: Bool
    @Binding var text: String
    @Binding var displayState: AMLSearchBar.DisplayState
    let showDisplayStateButton: Bool

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
                .accessibility(hidden: true)

            if isEditing {
                Button(action: {
                    text = ""
                    endEditing()
                }, label: {
                    Image(systemName: "multiply")
                        .font(Font.body.weight(.medium))
                        .foregroundColor(.primary)
                        .padding(.trailing, 8)
                })
                    .accessibility(hint: Text("Deletes search text and brings focus back to map."))
                    .accessibility(label: Text("Cancel editing"))
                    .accessibility(identifier: "amlsearchbar_button_cancel")
            }

            if showDisplayStateButton {
                Button {
                    isEditing = false
                    displayState.toggle()
                    endEditing()
                } label: {
                    Image(systemName: displayState.imageName)
                        .font(Font.body.weight(.medium))
                        .foregroundColor(.primary)
                        .padding(.trailing, 8)
                }
                .padding(.trailing, 10)
                .accessibility(label: Text(displayState.accessibilityLabel))
                .accessibility(identifier: displayState.accessibilityIdentifier)
                .transition(.move(edge: .trailing))
            }
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
