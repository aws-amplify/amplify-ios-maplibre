//
//  ExampleOneView.swift
//  AMLExamples
//
//  Created by Saultz, Ian on 1/20/22.
//

import SwiftUI
import AmplifyMapLibreUI

struct ExampleOneView: View {
    @State var displayType: BottomSheetDisplayState = .fullScreen
    @State var searchBarText: String = ""
    
    private var axis: Axis.Set {
        displayType == .fullScreen
        ? .vertical
        : []
    }
    
    var body: some View {
        GeometryReader { proxy in
            ZStack {
                Color.brown
                    .edgesIgnoringSafeArea(.all)
                
                //            AMLMapView()
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
                        VStack(spacing: 28) {
                            FavoritesSectionView(
                                moreTapped: {},
                                minWidth: proxy.size.width,
                                favorites: favoritesModel
                            )
                            
                            RecentsSectionView(
                                moreTapped: {},
                                recents: [
                                    .init(
                                        index: 0,
                                        title: "Dropped Pin",
                                        subtitle: "90210 Beverly Hills",
                                        imageSystemName: "mappin",
                                        imageForegroundColor: .white,
                                        imageBackgroundColor: .red
                                    ),
                                    .init(
                                        index: 1,
                                        title: "Dropped Pin",
                                        subtitle: "90210 Beverly Hills",
                                        imageSystemName: "mappin",
                                        imageForegroundColor: .white,
                                        imageBackgroundColor: .red
                                    ),
                                    .init(
                                        index: 2,
                                        title: "Dropped Pin",
                                        subtitle: "90210 Beverly Hills",
                                        imageSystemName: "mappin",
                                        imageForegroundColor: .white,
                                        imageBackgroundColor: .red
                                    )
                                ]
                            )
                        }
                        
                    }
                    .padding()
                }
                .edgesIgnoringSafeArea(.all)
            }
            
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

struct SectionHeader: View {
    let title: String
    let moreTapped: () -> Void
    
    var body: some View {
        HStack {
            Text(title)
                .font(.callout)
                .fontWeight(.medium)
                .foregroundColor(.secondary)
            Spacer()
            Button("More") {
                moreTapped()
            }.font(.caption)
        }
    }
}

struct SectionView<Content: View>: View {
    let title: String
    let moreTapped: () -> Void
    let content: Content
    
    init(
        title: String,
        moreTapped: @escaping () -> Void,
        @ViewBuilder content: () -> Content
    ) {
        self.title = title
        self.moreTapped = moreTapped
        self.content = content()
    }
    
    var body: some View {
        VStack {
            SectionHeader(title: title, moreTapped: moreTapped)
            content
        }
    }
}

struct RecentsSectionView: View {
    let moreTapped: () -> Void
    let recents: [Recent]
    
    var body: some View {
        SectionView(title: "Recents", moreTapped: moreTapped) {
            
                    
            ForEach(recents) { recent in
                VStack(spacing: 0) {
                    HStack(spacing: 0) {
                        CircularSystemImageView(
                            font: .system(size: 16),
                            systemImageName: recent.imageSystemName,
                            foregroundColor: recent.imageForegroundColor,
                            backgroundColor: recent.imageBackgroundColor
                        )
                            .padding(8)
                        
                        VStack(alignment: .leading) {
                            Text(recent.title)
                                .font(.headline)
                            Text(recent.subtitle)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        
                        Spacer()
                    }
                    
                    if recent != recents.last { Divider() }
                }.background(Color.white)
                
            }
            
                
                
            
            
        }
    }
}

struct Recent: Identifiable, Equatable {
    let id = UUID()
    let index: Int
    let title: String
    let subtitle: String
    let imageSystemName: String
    let imageForegroundColor: Color
    let imageBackgroundColor: Color
}

struct FavoritesSectionView: View {
    let moreTapped: () -> Void
    let minWidth: CGFloat
    let favorites: [FavoriteView.Model]
    
    var body: some View {
        SectionView(title: "Favorites", moreTapped: moreTapped) {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 25) {
                    ForEach(favorites) {
                        FavoriteView(model: $0)
                    }
                }
                .frame(minWidth: minWidth, alignment: .leading)
                .padding(8)
                .background(Color.tertiaryBackground)
                .cornerRadius(8)
            }
        }
    }
}

struct CircularSystemImageView: View {
    let font: Font
    let systemImageName: String
    let foregroundColor: Color
    let backgroundColor: Color
    
    var body: some View {
        Image(systemName: systemImageName)
            .font(font)
            .foregroundColor(foregroundColor)
            .padding()
            .background(backgroundColor)
            .clipShape(Circle())
    }
}

struct FavoriteView: View {
    let model: Model
    
    var body: some View {
        VStack {
            Button {
                /* Do thing */
            } label: {
                CircularSystemImageView(
                    font: .system(size: 24),
                    systemImageName: model.systemImageName,
                    foregroundColor: model.imageForegroundColor,
                    backgroundColor: model.imageBackgroundColor
                )
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
