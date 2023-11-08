/***
 SelectedTagsView.swift
 
 Created by Brian Batchelder on 11/7/23.
 Adapted from Kavsoft's ["SwiftUI Animated Tags View - Layout API - iOS 17 - Xcode 15"](https://www.patreon.com/posts/swiftui-animated-87032206)
*/

import SwiftUI

struct SelectedTagsView: View {
    @Binding var selectedTags: [String]
    let animation: Namespace.ID
    
    var body: some View {
        ScrollView(.horizontal) {
            HStack(spacing: 12) {
                ForEach(selectedTags, id: \.self) { tag in
                    TagView(tag: tag, color:.pink, icon:"checkmark")
                        .matchedGeometryEffect(id: tag, in: animation)
                        .onTapGesture {
                            withAnimation(.snappy) {
                                selectedTags.removeAll(where: { $0 == tag })
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
}

#Preview {
    @State var selectedTags: [String] = [
        "SwiftUI", "Swift", "iOS", "Apple"
    ]
    @Namespace var animation

    return SelectedTagsView(selectedTags: $selectedTags, animation: animation)
}
