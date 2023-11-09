/***
 UnselectedTagsView.swift
 
 Created by Brian Batchelder on 11/7/23.
 Adapted from Kavsoft's ["SwiftUI Animated Tags View - Layout API - iOS 17 - Xcode 15"](https://www.patreon.com/posts/swiftui-animated-87032206)
*/

import SwiftUI

struct UnselectedTagsView: View {
    @ObservedObject var allTags: Tags
    @ObservedObject var selectedTags: Tags
    let animation: Namespace.ID
    
    var body: some View {
        ScrollView(.vertical) {
            TagLayout(alignment: .center, spacing: 5) {
                ForEach(allTags.without(otherTags: selectedTags).tags, id: \.self) { tag in
                    TagView(tag:tag, color:.blue, icon:"plus")
                        .matchedGeometryEffect(id: tag.id, in: animation)
                        .onTapGesture {
                            withAnimation(.snappy) {
                                BDBLog.log("UnselectedTagsView: select tag \(tag.name)")
                                selectedTags.insert(tag, at: 0)
                            }
                        }
                }
            }
            .padding(15)
        }
        .scrollClipDisabled(true)
//        .scrollIndicators(.hidden)
        .background(.black.opacity(0.05))
    }
}

#Preview {
    @ObservedObject var tags = Tags.preview()
    @ObservedObject var selectedTags = Tags.preview(names: [
        "SwiftUI", "Swift", "iOS", "Apple"
    ])
    /// Adding Matched Geometry Effect
    @Namespace  var animation

    return UnselectedTagsView(allTags: tags, selectedTags: selectedTags, animation: animation)
}
