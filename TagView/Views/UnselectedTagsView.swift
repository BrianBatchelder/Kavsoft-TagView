/***
 UnselectedTagsView.swift
 
 Created by Brian Batchelder on 11/7/23.
 Adapted from Kavsoft's ["SwiftUI Animated Tags View - Layout API - iOS 17 - Xcode 15"](https://www.patreon.com/posts/swiftui-animated-87032206)
*/

import SwiftUI

struct UnselectedTagsView: View {
    @StateObject private var viewModel: UnselectedTagsViewModel

    let animation: Namespace.ID
    
    let id = UUID()

    var body: some View {
        ScrollView(.vertical) {
            TagLayout(alignment: .center, spacing: 5) {
                ForEach(viewModel.unselectedTags.filter({$0.parent == nil || $0.parent!.expanded}), id: \.self) { tag in
                    // logV(id, tag.expanded ? "\(tag.name) is expanded" : "\(tag.name) is not expanded")
                    TagView(tag:tag, parentColor: .green, leafColor:.blue, icon:"plus")
                        .matchedGeometryEffect(id: tag.id, in: animation)
                        .onTapGesture {
                            withAnimation(.snappy) {
                                log(id, "UnselectedTagsView: select tag \(tag.name)")
                                if (tag.children.count == 0) {
                                    viewModel.insertSelectedTag(tag, at: 0)
                                } else {
                                    // expand or collapse view to show children
                                    // REVISIT: Isn't triggering a redraw
                                    log(id, "UnselectedTagsView: expand / collapse parent tag \(tag.name)")
                                    tag.expanded = !tag.expanded
                                }
                                
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
    
    init(allTags: Tags, selectedTags: Tags, animation: Namespace.ID) {
        self._viewModel = StateObject(wrappedValue: UnselectedTagsViewModel(allTags: allTags, selectedTags: selectedTags))
        self.animation = animation
    }
}

#Preview {
    @ObservedObject var tags = Tags.preview()
    @ObservedObject var selectedTags = Tags.preview(length: 4)
    /// Adding Matched Geometry Effect
    @Namespace  var animation

    return UnselectedTagsView(allTags: tags, selectedTags: selectedTags, animation: animation)
}
