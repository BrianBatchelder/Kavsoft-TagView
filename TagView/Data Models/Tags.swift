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

    let id = UUID()

    init(names: [ String ]? = nil) {
        tags = []
        if let names = names {
            log(id, "Adding names")
            add(names)
        }
        log(id, "Initialized")
    }
    
    convenience init(originalTags: Tags) {
        self.init()
        tags.append(contentsOf: originalTags.tags)
    }
    
    convenience init(originalTags: [ Tag ]) {
        self.init()
        tags.append(contentsOf: originalTags)
    }
    
    func add(_ tag: Tag) {
        self.tags.append(tag)
    }

    func add(_ tags: [ Tag ]) {
        self.tags.append(contentsOf: tags)
    }
    
    func add(_ tagName: String) {
        // parse tag into parent and children (array of hierarchical tags)
        let tagLevels = Self.parse(name: tagName)
        if (tagLevels.count <= 1) {
            let tag = Tag(name: tagName)
            add(tag)
            
            return
        }
        
        var parentTag: Tag? = nil
        for tagLevel in tagLevels {
            let tag = Tag(name: String(tagLevel), parent: parentTag)
            add(tag)
            
            parentTag = tag
        }
    }
    
    func add(_ tagNames: [ String ]) {
        for tagName in tagNames {
            add(tagName)
        }
    }
    
    func remove(_ tag: Tag) {
        tags.removeAll(where: { $0.id == tag.id })
    }
    
    func insert(_ tag: Tag, at: Int) {
        log(id, "Inserting tag \(tag.name) at position \(at).")
//        objectWillChange.send()
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
    
    func rootTags() -> Tags {
        let childTags = tags.filter({ $0.parent != nil })
        log(id, "There are \(childTags.count) child tags.")
        return self.without(otherTags: Tags(originalTags: childTags))
    }
    
    func rootAndExpandedTags() -> Tags {
        let expandedTags = Tags()
        for rootTag in rootTags().tags {
            expandedTags.add(rootTag)
            if rootTag.expanded {
                expandedTags.add(rootTag.children)
            }
        }
        return expandedTags
    }
}

extension Tags {
    class func parse(name: String) -> [ Substring ] {
        var tags = [ Substring ]()
        
        tags = name.split(separator: "/")
        
        return tags
    }
}

// MARK: Preview
extension Tags {
    static let previewTagNames: [String] = [
        "Parent/Child", "SwiftUI", "Swift", "iOS", "Apple", "Xcode", "WWDC", "Android", "React", "Flutter", "App", "Indie", "Developer", "Objc", "C#", "C", "C++", "iPhone", "iPad", "Macbook", "iPadOS", "macOS", "zSwiftUI", "zSwift", "ziOS", "zApple", "zXcode", "zWWDC", "zAndroid", "zReact", "zFlutter", "zApp", "zIndie", "zDeveloper", "zObjc", "zC#", "zC", "zC++", "ziPhone", "ziPad", "zMacbook", "ziPadOS", "zmacOS", "aSwiftUI", "aSwift", "aiOS", "aApple", "aXcode", "aWWDC", "aAndroid",
    ]

    class func preview(names: [String]? = nil) -> Tags {
        if let names = names {
            return Tags(names: names)
        } else {
            return Tags(names: previewTagNames)
        }
    }

    class func preview(length: Int) -> Tags {
        let tags = Tags.preview()
        // get first "length" tags and return a new Tags object
        let tagNames = Array(tags.tags.map({ $0.name }).prefix(length))
        return Tags(names: tagNames)
    }
}
