//
//  TagViewApp.swift
//  TagView
//
//  Created by Balaji on 01/08/23.
//

import SwiftUI

@main
struct TagViewApp: App {
    @State private var tags: [String] = [
        "SwiftUI", "Swift", "iOS", "Apple", "Xcode", "WWDC", "Android", "React", "Flutter", "App", "Indie", "Developer", "Objc", "C#", "C", "C++", "iPhone", "iPad", "Macbook", "iPadOS", "macOS", "zSwiftUI", "zSwift", "ziOS", "zApple", "zXcode", "zWWDC", "zAndroid", "zReact", "zFlutter", "zApp", "zIndie", "zDeveloper", "zObjc", "zC#", "zC", "zC++", "ziPhone", "ziPad", "zMacbook", "ziPadOS", "zmacOS", "aSwiftUI", "aSwift", "aiOS", "aApple", "aXcode", "aWWDC", "aAndroid",
    ]
    @State private var selectedTags: [String] = []
    var body: some Scene {
        WindowGroup {
            SelectTagsView(allTags:$tags, selectedTags: $selectedTags)
        }
    }
}
