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
    
    public init(
        text: Binding<String>,
        onCommit: @escaping () -> Void,
        onCancel: @escaping () -> Void
    ) {
        _text = text
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
                .searchBarIconOverlay(isEditing: $isEditing, text: $text)
                .onTapGesture {
                    isEditing = true
                }
        }
    }
}

fileprivate extension View {
    func searchBarIconOverlay(
        isEditing: Binding<Bool>,
        text: Binding<String>
//        resultDisplayState: Binding<ResultDisplayState>,
//        displayMedium: Binding<ResultDisplayState.Location>
    ) -> some View {
      self.overlay(AMLSearchBarIconOverlay(isEditing: isEditing, text: text))
    }
}

struct SearchBar_Previews: PreviewProvider {
  static var previews: some View {
    AMLSearchBar(
      text: .constant(""),
      onCommit: {},
      onCancel: {}
    )
  }
}

fileprivate struct AMLSearchBarIconOverlay: View {
  @Binding var isEditing: Bool
  @Binding var text: String
  
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
        
      
//      if case .displayed = resultDisplayState {
//        Button(action: {
//          isEditing = false
//          displayMedium.toggle()
//          endEditing()
//        }) {
//          Image(systemName: displayMedium.imageName)
//            .font(.body.weight(.medium))
//            .foregroundColor(.primary)
//            .padding(.trailing, 8)
//        }
//        .padding(.trailing, 10)
//        .transition(.move(edge: .trailing))
//      }
      
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
