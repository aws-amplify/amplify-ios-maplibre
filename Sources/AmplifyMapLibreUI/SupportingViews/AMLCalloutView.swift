//
// Copyright Amazon.com Inc. or its affiliates.
// All Rights Reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

import SwiftUI

public struct AMLCalloutView: View {
    let xButtonAction: () -> Void
    
    public init(xButtonAction: @escaping () -> Void) {
        self.xButtonAction = xButtonAction
    }
    
    public var body: some View {
        VStack {
            HStack {
                Spacer()
                Button(action: { }, label: {
                    Image(systemName: "xmark")
                })
                    .foregroundColor(.secondary)
                    .frame(width: 20, height: 20)
            }
            .padding(.top, 8)
            .padding(.trailing, 8)
            
            VStack(alignment: .leading) {
                Text("Main Street Coffee and Bagel")
                    .fontWeight(.bold)
                Text("Address 1")
                    .font(.callout)
                Text("Address 2")
                    .font(.callout)
            }.padding([.leading, .trailing, .bottom])
        }
        .background(Color.white)
        .cornerRadius(12)
        .overlay(RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.gray, lineWidth: 4)
        )
        
    }
}
