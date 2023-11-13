/***
 TagView.swift
 
 Created by Brian Batchelder on 11/7/23.
 Adapted from Kavsoft's ["SwiftUI Animated Tags View - Layout API - iOS 17 - Xcode 15"](https://www.patreon.com/posts/swiftui-animated-87032206)
*/

import SwiftUI

struct TagView: View {
    @ObservedObject private var tag: Tag
    @State private var parentColor: Color
    @State private var leafColor: Color
    @State private var parentIcon: String
    @State private var parentIconExpanded: String
    @State private var leafIcon: String

    var body: some View {
        HStack(spacing: 10) {
            Text(tag.name)
                .font(.callout)
                .fontWeight(.semibold)
            Image(systemName: tag.isLeaf ? leafIcon : tag.expanded ? parentIconExpanded : parentIcon)
        }
        .frame(height: 35)
        .foregroundStyle(.white)
        .padding(.horizontal, 15)
        .background {
            Capsule()
                .fill(tagColor().gradient)
                .if(tag.hasParent) { view in
                    view.stroke(tagColor(), style: StrokeStyle(lineWidth: 1, dash: [2]))
                }
        }
    }
    
    init(tag: Tag, parentColor: Color, leafColor: Color, parentIcon: String, parentIconExpanded: String, leafIcon: String) {
        self.tag = tag
        self.parentColor = parentColor
        self.leafColor = leafColor
        self.parentIcon = parentIcon
        self.parentIconExpanded = parentIconExpanded
        self.leafIcon = leafIcon
    }
    
    func tagColor() -> Color {
        return tag.isLeaf ? leafColor : parentColor
    }
}

extension View {
    @ViewBuilder func `if`<Content: View>(_ condition: Bool, transform: (Self) -> Content) -> some View {
        if condition {
            logV(UUID(), "transforming view")
            transform(self)
        } else {
            logV(UUID(), "not transforming view")
            self
        }
    }
}

#Preview {
    TagView(tag: Tag.preview(name:"Sample Tag"), parentColor: .green, leafColor: .blue, parentIcon: "chevron.down", parentIconExpanded: "chevron.up", leafIcon: "checkmark")
}
