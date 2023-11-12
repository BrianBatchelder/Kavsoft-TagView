//
//  ContentView.swift
//  TagView
//
//  Created by Balaji on 01/08/23.
//

import SwiftUI

struct SelectTagsView: View {    
    @StateObject private var viewModel: SelectTagsViewModel

    /// Adding Matched Geometry Effect
    @Namespace private var animation
    
    var body: some View {
        VStack(spacing: 0) {
            // Selected Tags View
            SelectedTagsView(selectedTags: viewModel.selectedTags, animation: animation)
                .overlay(content: {
                    if viewModel.countOfSelectedTags == 0 {
                        Text("Select More than 3 Tags")
                            .font(.callout)
                            .foregroundStyle(.gray)
                    }
                })
                .zIndex(1)

            // Unselected Tags View
            UnselectedTagsView(allTags: viewModel.allTags, selectedTags: viewModel.selectedTags, animation: animation)
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
                .disabled(viewModel.countOfSelectedTags < 3)
                .opacity(viewModel.countOfSelectedTags < 3 ? 0.5 : 1)
                .padding()
            }
            .background(.white)
            .zIndex(1)
        }
        .preferredColorScheme(.light)
    }
    
    init(allTags: Tags, selectedTags: Tags) {
        self._viewModel = StateObject(wrappedValue: SelectTagsViewModel(allTags: allTags, selectedTags: selectedTags))
    }
}

#Preview {
    @ObservedObject var tags = Tags.preview()
    @ObservedObject var selectedTags = Tags.preview(length: 2)

    return SelectTagsView(allTags: tags, selectedTags: selectedTags)
}
