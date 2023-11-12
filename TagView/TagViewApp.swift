//
//  TagViewApp.swift
//  TagView
//
//  Created by Balaji on 01/08/23.
//

import SwiftUI

@main
struct TagViewApp: App {
    @ObservedObject private var tags = Tags.preview()
    @ObservedObject private var selectedTags = Tags()
    
    var body: some Scene {
        WindowGroup {
            SelectTagsView(allTags:tags, selectedTags: selectedTags)
        }
    }
}
