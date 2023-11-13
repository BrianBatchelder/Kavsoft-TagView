//
//  Tags.swift
//  TagView
//
//  Created by Brian Batchelder on 11/8/23.
//

import Foundation
import Combine

struct CancellableByTag {
    var cancellable: AnyCancellable
    var tagId: UUID
}

class Tags: ObservableObject {
    @Published var tags: Array<Tag>
    
    var count: Int {
        return self.tags.count
    }
    
    var isEmpty: Bool {
        count == 0
    }

    let id = UUID()
    private var cancellables = [CancellableByTag]()

    init(names: [ String ]? = nil) {
        self.tags = [ Tag ]()
        if let names = names {
            log(id, "Adding names")
            add(names)
        }

        // forward changes to any tag to observers
        self.tags.forEach { tag in
            let cancellable = CancellableByTag(cancellable: tag.objectWillChange.sink(receiveValue: { _ in self.objectWillChange.send() }), tagId: tag.id)
            cancellables.append(cancellable)
        }

        log(id, "Initialized")
    }
    
    convenience init(originalTags: Tags) {
        self.init()
        self.tags.append(contentsOf: originalTags.tags)
        // REVISIT: Need to observe changes to each tag
    }
    
    convenience init(originalTags: [ Tag ]) {
        self.init()
        self.tags.append(contentsOf: originalTags)
        // REVISIT: Need to observe changes to each tag
    }
    
    func add(_ tag: Tag) {
        self.tags.append(tag)
        // REVISIT: Need to observe changes to tag
    }

    func add(_ tags: [ Tag ]) {
        self.tags.append(contentsOf: tags)
        // REVISIT: Need to observe changes to each tag
    }
    
    func add(_ tagName: String) {
        // REVISIT: Need to observe changes to each tag
        log(id, "Adding tag(s) named \(tagName)")
        // parse tag into parent and children (array of hierarchical tags)
        let tagLevels = Self.parse(name: tagName)
        if (tagLevels.count <= 1) {
            // root tag
            if getTag(name: tagName, parentTag: nil) != nil {
                return
            }
            let tag = Tag(name: tagName)
            add(tag)
            
            return
        }
        
        var parentTag: Tag? = nil
        for tagLevel in tagLevels {
            let tagLevel = String(tagLevel)
            if let tag = getTag(name: tagLevel, parentTag: parentTag) {
                log(id, "Tag \(tagName) already exists under parentTag \(parentTag == nil ? "root" : "\(parentTag!.name)")")
                parentTag = tag
                continue
            }
            
            log(id, "Creating tag \(tagLevel) under parent tag \(parentTag == nil ? "root" : "\(parentTag!.name)")")
            let tag = Tag(name: tagLevel, parent: parentTag)
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
        self.tags.removeAll(where: { $0.id == tag.id })
        // REVISIT: Need to stop observing changes to tag
    }
    
    func insert(_ tag: Tag, at: Int) {
        log(id, "Inserting tag \(tag.name) at position \(at).")
        self.tags.insert(tag, at: at)
        // REVISIT: Need to observe changes to tag
    }
    
    func removeAll(name: String) {
        self.tags.removeAll(where: { $0.name == name })
        // REVISIT: Need to stop observing changes to each tag
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
    
    func getTag(name: String, parentTag: Tag?) -> Tag? {
        if let parentTag = parentTag {
            log(id, "Looking for tag \(name) under parentTag \(parentTag.name)")
            return parentTag.children.filter({ $0.name == name }).first
        } else {
            log(id, "Looking for tag \(name) in root")
            return tags.filter({ $0.parent == nil && $0.name == name}).first
        }
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
        "Parent/Child 1", "Parent/Child 2/Grandchild", "SwiftUI", "Swift", "iOS", "Apple", "Xcode", "WWDC", "Android", "React", "Flutter", "App", "Indie", "Developer", "Objc", "C#", "C", "C++", "iPhone", "iPad", "Macbook", "iPadOS", "macOS", "zSwiftUI", "zSwift", "ziOS", "zApple", "zXcode", "zWWDC", "zAndroid", "zReact", "zFlutter", "zApp", "zIndie", "zDeveloper", "zObjc", "zC#", "zC", "zC++", "ziPhone", "ziPad", "zMacbook", "ziPadOS", "zmacOS", "aSwiftUI", "aSwift", "aiOS", "aApple", "aXcode", "aWWDC", "aAndroid",
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
