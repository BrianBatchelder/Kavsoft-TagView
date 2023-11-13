/***
 SelectedTagsView.swift
 
 Created by Brian Batchelder on 11/7/23.
 Adapted from Kavsoft's ["SwiftUI Animated Tags View - Layout API - iOS 17 - Xcode 15"](https://www.patreon.com/posts/swiftui-animated-87032206)
*/

import SwiftUI

struct SelectedTagsView: View {
    @StateObject private var viewModel: SelectedTagsViewModel
    
    let animation: Namespace.ID
    
    let id = UUID()

    var body: some View {
        ScrollView(.horizontal) {
            HStack(spacing: 12) {
                ForEach(viewModel.selectedTags.tags) { tag in
                    TagView(tag: tag, parentColor: .pink, leafColor: .pink, parentIcon:"checkmark", parentIconExpanded:"checkmark", leafIcon:"checkmark")
                        .matchedGeometryEffect(id: tag.id, in: animation)
                        .onTapGesture {
                            withAnimation(.snappy) {
                                log(id, "SelectedTagsView: unselect tag \(tag.name)")
                                viewModel.selectedTags.remove(tag)
                                tag.expandParents()
                            }
                        }
                }
            }
            .padding(.horizontal, 15)
            .frame(height: 35)
            .padding(.vertical, 15)
        }
        .scrollClipDisabled(true)
//        .scrollIndicators(.hidden)
        .background(.white)
    }
    
    init(selectedTags: Tags, animation: Namespace.ID) {
        self._viewModel = StateObject(wrappedValue: SelectedTagsViewModel(selectedTags: selectedTags))
        self.animation = animation
    }
}

#Preview {
    @ObservedObject var selectedTags = Tags.preview(length: 4)
    @Namespace var animation

    return SelectedTagsView(selectedTags: selectedTags, animation: animation)
}
