//
//  ExampleOneView.swift
//  AMLExamples
//
//  Created by Saultz, Ian on 1/20/22.
//

import SwiftUI
import AmplifyMapLibreUI

struct ExampleOneView: View {
    @State var displayType: BottomSheetDisplayState = .halfScreen
    @State var searchBarText: String = ""

    private var axis: Axis.Set {
        displayType == .fullScreen
        ? .vertical
        : []
    }

    var body: some View {
        ZStack {
            AMLMapView()
                .edgesIgnoringSafeArea(.all)
            BottomSheetView(displayType: $displayType) {
                HStack {
                    AMLSearchBar(
                        text: $searchBarText,
                        displayState: .constant(.map),
                        onCommit: { /* search */ },
                        onCancel: { /* end editing */ },
                        showDisplayStateButton: false
                    )
                    Image(systemName: "person.crop.circle.fill")
                        .font(.system(size: 28))
                }
                .padding([.leading, .trailing])

                ScrollView(axis, showsIndicators: false) {
                    VStack {
                        HStack {
                            Text("Favorites")
                                .font(.callout)
                                .fontWeight(.medium)
                                .foregroundColor(.secondary)
                            Spacer()
                            Button("More") {
                                // ...
                            }.font(.caption)

                        }

                        ScrollView(.horizontal, showsIndicators: false) {
                            favorites
                                .padding(4)
                                .background(Color.tertiaryBackground)
                                .frame(maxWidth: .infinity)
                                .cornerRadius(8)
                        }



                    }

                }
                .padding()
            }.edgesIgnoringSafeArea(.all)
        }
    }

    private var favorites: some View {
        HStack(spacing: 25) {
            ForEach(favoritesModel) {
                FavoriteView(model: $0)
            }
        }
    }

    let favoritesModel: [FavoriteView.Model] = [
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
            primaryText: "Point ...",
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



struct FavoriteView: View {
    let model: Model

    var body: some View {
        VStack {
            Button {
                /* Do thing */
            } label: {
                Image(systemName: model.systemImageName)
                    .font(.system(size: 24))
                    .foregroundColor(model.imageForegroundColor)
                    .padding()
                    .background(model.imageBackgroundColor)
                    .clipShape(Circle())

            }


            Text(model.primaryText)
            Text(model.secondaryText)
                .font(.caption)
                .foregroundColor(Color.secondary)
        }
    }
}

extension FavoriteView {
    struct Model: Identifiable {
        let id = UUID()
        let systemImageName: String
        let imageForegroundColor: Color
        let imageBackgroundColor: Color
        let primaryText: String
        let secondaryText: String
    }
}

struct ExampleOneView_Previews: PreviewProvider {
    static var previews: some View {
        ExampleOneView()
    }
}

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
