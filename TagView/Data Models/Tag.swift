//
//  Tag.swift
//  TagView
//
//  Created by Brian Batchelder on 11/8/23.
//

import Foundation

class Tag: Identifiable, ObservableObject {
    @Published var name: String
    @Published var children: Array<Tag>
    @Published var parent: Tag?
    
    @Published var expanded = false {
        willSet {
            log("willSet expanded \(expanded)")
            self.objectWillChange.send()
        }
    }

    var isLeaf: Bool { self.children.count == 0 }
    var hasParent: Bool { self.parent != nil }
    
    let id = UUID()
    
    init(name: String, parent: Tag? = nil, children: [ Tag ] = []) {
        self.name = name
        self.parent = parent
        self.children = children

        if let parent = parent {
            parent.addChild(self)
        }
    }
    
    func addChild(_ child: Tag) {
        children.append(child)
    }
    
    func expandParents() {
        var parentTag = parent
        while parentTag != nil {
            parentTag!.expanded = true
            parentTag = parentTag!.parent
        }
    }
}

extension Tag: Equatable {
    static func == (lhs: Tag, rhs: Tag) -> Bool {
        return lhs.id == rhs.id
    }
}

extension Tag: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

// MARK: Preview
extension Tag {
    class func preview(name: String = UUID().uuidString) -> Tag {
        let preview = Tag(name: name)
        return preview
    }
}


