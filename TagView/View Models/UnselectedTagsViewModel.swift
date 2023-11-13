//
//  UnselectedTagsViewModel.swift
//  TagView
//
//  Created by Brian Batchelder on 11/11/23.
//

import SwiftUI
import Combine

class UnselectedTagsViewModel: ObservableObject {
    /// All tags
    @ObservedObject private var allTags: Tags
    /// Selected tags
    @ObservedObject private var selectedTags: Tags
    
    var unselectedTags: [ Tag ] { allTags.tags.filter({ !selectedTags.tags.contains($0) }) }
    
    private var allTagsCancellable: AnyCancellable? = nil
    private var selectedTagsCancellable: AnyCancellable? = nil
    
    let id = UUID()
    
    init(allTags: Tags, selectedTags: Tags = Tags()) {
        self.allTags = allTags
        self.selectedTags = selectedTags
        
        allTagsCancellable = allTags.objectWillChange.sink(receiveValue: {           self.log(self.id,"all tags changed")
            self.objectWillChange.send()
        })
        selectedTagsCancellable = selectedTags.objectWillChange.sink(receiveValue:{
            self.log(self.id,"selected tags changed")
            self.objectWillChange.send()
        })
    }
    
    func insertSelectedTag(_ tag: Tag, at: Int) {
        log(id, "Inserting tag \(tag.name) at position \(at) in selectedTags list.")
        selectedTags.insert(tag, at: at)
    }
}

// MARK: Preview
extension UnselectedTagsViewModel {
    class func createPreview() -> UnselectedTagsViewModel {
        let previewModel = UnselectedTagsViewModel(allTags: Tags.preview())
        return previewModel
    }
}
