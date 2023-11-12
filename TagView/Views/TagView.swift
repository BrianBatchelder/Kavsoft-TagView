/***
 TagView.swift
 
 Created by Brian Batchelder on 11/7/23.
 Adapted from Kavsoft's ["SwiftUI Animated Tags View - Layout API - iOS 17 - Xcode 15"](https://www.patreon.com/posts/swiftui-animated-87032206)
*/

import SwiftUI

struct TagView: View {
    @State private var tag: Tag
    @State private var parentColor: Color
    @State private var leafColor: Color
    @State private var icon: String

    var body: some View {
        HStack(spacing: 10) {
            Text(tag.name)
                .font(.callout)
                .fontWeight(.semibold)
            Image(systemName: icon)
        }
        .frame(height: 35)
        .foregroundStyle(.white)
        .padding(.horizontal, 15)
        .background {
            Capsule()
                .fill(tag.isLeaf ? leafColor.gradient : parentColor.gradient)
        }
    }
    
    init(tag: Tag, parentColor: Color, leafColor: Color, icon: String) {
        self.tag = tag
        self.parentColor = parentColor
        self.leafColor = leafColor
        self.icon = icon
    }
}


#Preview {
    TagView(tag: Tag.preview(name:"Sample Tag"), parentColor: .green, leafColor: .blue, icon: "checkmark")
}
