//
//  SelectTagsViewModel.swift
//  TagView
//
//  Created by Brian Batchelder on 11/11/23.
//

import SwiftUI
import Combine

class SelectTagsViewModel: ObservableObject {
    /// All tags
    @ObservedObject var allTags: Tags
    /// Selected tags
    @ObservedObject var selectedTags: Tags
    
    var countOfSelectedTags: Int { selectedTags.count }
    
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
        
        log(id, "Initialized")
    }
}

// MARK: Preview
extension SelectTagsViewModel {
    class func createPreview() -> SelectTagsViewModel {
        let previewModel = SelectTagsViewModel(allTags: Tags.preview())
        return previewModel
    }
}
