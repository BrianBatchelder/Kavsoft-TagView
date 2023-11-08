/***
 UnselectedTagsView.swift
 
 Created by Brian Batchelder on 11/7/23.
 Adapted from Kavsoft's ["SwiftUI Animated Tags View - Layout API - iOS 17 - Xcode 15"](https://www.patreon.com/posts/swiftui-animated-87032206)
*/

import SwiftUI

struct UnselectedTagsView: View {
    @Binding var allTags: [String]
    @Binding var selectedTags: [String]
    let animation: Namespace.ID
    
    var body: some View {
        ScrollView(.vertical) {
            TagLayout(alignment: .center, spacing: 10) {
                ForEach(allTags.filter { !selectedTags.contains($0) }, id: \.self) { tag in
                    TagView(tag:tag, color:.blue, icon:"plus")
                        .matchedGeometryEffect(id: tag, in: animation)
                        .onTapGesture {
                            withAnimation(.snappy) {
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
    @State var tags: [String] = [
        "SwiftUI", "Swift", "iOS", "Apple", "Xcode", "WWDC", "Android", "React", "Flutter", "App", "Indie", "Developer", "Objc", "C#", "C", "C++", "iPhone", "iPad", "Macbook", "iPadOS", "macOS", "zSwiftUI", "zSwift", "ziOS", "zApple", "zXcode", "zWWDC", "zAndroid", "zReact", "zFlutter", "zApp", "zIndie", "zDeveloper", "zObjc", "zC#", "zC", "zC++", "ziPhone", "ziPad", "zMacbook", "ziPadOS", "zmacOS", "aSwiftUI", "aSwift", "aiOS", "aApple", "aXcode", "aWWDC", "aAndroid",
    ]
    @State var selectedTags: [String] = [
        "SwiftUI", "Swift", "iOS", "Apple"
    ]
    /// Adding Matched Geometry Effect
    @Namespace  var animation

    return UnselectedTagsView(allTags: $tags, selectedTags: $selectedTags, animation: animation)
}
