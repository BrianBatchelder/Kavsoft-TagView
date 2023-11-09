//
//  Tags.swift
//  TagView
//
//  Created by Brian Batchelder on 11/8/23.
//

import Foundation

class Tags: ObservableObject {
    @Published var tags: [ Tag ]
    
    var count: Int {
        return self.tags.count
    }
    
    var isEmpty: Bool {
        count == 0
    }
    
    init() {
        tags = []
    }
    
    convenience init(originalTags: Tags) {
        self.init()
        tags.append(contentsOf: originalTags.tags)
    }
    
    func add(_ tag: Tag) {
        tags.append(tag)
    }
    
    func remove(_ tag: Tag) {
        tags.removeAll(where: { $0.id == tag.id })
    }
    
    func insert(_ tag: Tag, at: Int) {
        tags.insert(tag, at: at)
    }
    
    func removeAll(name: String) {
        tags.removeAll(where: { $0.name == name })
    }
    
    func without(otherTags: Tags) -> Tags {
        let copyOfTags = Tags(originalTags: self)
        for otherTag in otherTags.tags {
            copyOfTags.remove(otherTag)
        }
        return copyOfTags
    }
}

//extension Tags: RandomAccessCollection {
//    typealias Element = <#type#>
//    
//    typealias Index = <#type#>
//    
//    typealias SubSequence = <#type#>
//    
//    typealias Indices = <#type#>
//}

// MARK: Preview
extension Tags {
    class func preview(names: [String]? = nil) -> Tags {
        let tagNames: [String] = names ?? [
            "SwiftUI", "Swift", "iOS", "Apple", "Xcode", "WWDC", "Android", "React", "Flutter", "App", "Indie", "Developer", "Objc", "C#", "C", "C++", "iPhone", "iPad", "Macbook", "iPadOS", "macOS", "zSwiftUI", "zSwift", "ziOS", "zApple", "zXcode", "zWWDC", "zAndroid", "zReact", "zFlutter", "zApp", "zIndie", "zDeveloper", "zObjc", "zC#", "zC", "zC++", "ziPhone", "ziPad", "zMacbook", "ziPadOS", "zmacOS", "aSwiftUI", "aSwift", "aiOS", "aApple", "aXcode", "aWWDC", "aAndroid",
        ]

        let preview = Tags()
        
        for tagName in tagNames {
            let tag = Tag(name: tagName)
            preview.add(tag)
        }
        return preview
    }
    
}
