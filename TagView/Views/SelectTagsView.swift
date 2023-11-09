//
//  ContentView.swift
//  TagView
//
//  Created by Balaji on 01/08/23.
//

import SwiftUI

struct SelectTagsView: View {
    /// All tags
    @ObservedObject var allTags: Tags
    /// Selected tags
    @ObservedObject var selectedTags: Tags
    
    /// Adding Matched Geometry Effect
    @Namespace private var animation
    var body: some View {
        VStack(spacing: 0) {
            // Selected Tags View
            SelectedTagsView(selectedTags: self.selectedTags, animation: animation)
                .overlay(content: {
                    if selectedTags.isEmpty {
                        Text("Select More than 3 Tags")
                            .font(.callout)
                            .foregroundStyle(.gray)
                    }
                })
                .zIndex(1)

            // Unselected Tags View
            UnselectedTagsView(allTags: self.allTags, selectedTags: self.selectedTags, animation: animation)
                .zIndex(0)

            // Continue button
            ZStack {
                Button(action: {}, label: {
                    Text("Continue")
                        .fontWeight(.semibold)
                        .padding(.vertical, 15)
                        .frame(maxWidth: .infinity)
                        .foregroundStyle(.white)
                        .background {
                            RoundedRectangle(cornerRadius: 12)
                                .fill(.pink.gradient)
                        }
                })
                /// Disabling until 3 or more tags selected
                .disabled(selectedTags.count < 3)
                .opacity(selectedTags.count < 3 ? 0.5 : 1)
                .padding()
            }
            .background(.white)
            .zIndex(1)
        }
        .preferredColorScheme(.light)
    }
}

#Preview {
    @ObservedObject var tags = Tags.preview()
    @ObservedObject var selectedTags = Tags.preview(names: [
        "SwiftUI", "Swift"
    ])

    return SelectTagsView(allTags: tags, selectedTags: selectedTags)
}
