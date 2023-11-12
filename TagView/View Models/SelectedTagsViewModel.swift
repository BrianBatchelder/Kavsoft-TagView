//
//  SelectedTagsViewModel.swift
//  TagView
//
//  Created by Brian Batchelder on 11/11/23.
//

import SwiftUI
import Combine

class SelectedTagsViewModel: ObservableObject {
    /// Selected tags
    @ObservedObject var selectedTags: Tags
    
    var countOfSelectedTags: Int { selectedTags.count }
    
    private var selectedTagsCancellable: AnyCancellable? = nil

    let id = UUID()

    init(selectedTags: Tags = Tags()) {
        self.selectedTags = selectedTags

        selectedTagsCancellable = selectedTags.objectWillChange.sink(receiveValue:{
            self.log(self.id,"selected tags changed")
            self.objectWillChange.send()
        })
    }
}

// MARK: Preview
extension SelectedTagsViewModel {
    class func createPreview() -> SelectedTagsViewModel {
        let previewTags = Tags.preview(length: 2)
        let previewModel = SelectedTagsViewModel(selectedTags: previewTags)

        return previewModel
    }
}
