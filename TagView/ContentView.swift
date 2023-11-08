//
//  ContentView.swift
//  TagView
//
//  Created by Balaji on 01/08/23.
//

import SwiftUI

struct ContentView: View {
    /// View Properties
    /// Sample Tags
    @State private var tags: [String] = [
        "SwiftUI", "Swift", "iOS", "Apple", "Xcode", "WWDC", "Android", "React", "Flutter", "App", "Indie", "Developer", "Objc", "C#", "C", "C++", "iPhone", "iPad", "Macbook", "iPadOS", "macOS", "zSwiftUI", "zSwift", "ziOS", "zApple", "zXcode", "zWWDC", "zAndroid", "zReact", "zFlutter", "zApp", "zIndie", "zDeveloper", "zObjc", "zC#", "zC", "zC++", "ziPhone", "ziPad", "zMacbook", "ziPadOS", "zmacOS", "aSwiftUI", "aSwift", "aiOS", "aApple", "aXcode", "aWWDC", "aAndroid",
    ]
    /// Selection
    @State var selectedTags: [String] = []
    /// Adding Matched Geometry Effect
    @Namespace private var animation
    var body: some View {
        VStack(spacing: 0) {
            // Selected Tags View
            SelectedTagsView(selectedTags: self.$selectedTags, animation: animation)
                .overlay(content: {
                    if selectedTags.isEmpty {
                        Text("Select More than 3 Tags")
                            .font(.callout)
                            .foregroundStyle(.gray)
                    }
                })
                .zIndex(1)

            // Unselected Tags View
            UnselectedTagsView(allTags: self.$tags, selectedTags: self.$selectedTags, animation: animation)
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
    ContentView()
}
