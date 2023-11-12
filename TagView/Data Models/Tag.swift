//
//  Tag.swift
//  TagView
//
//  Created by Brian Batchelder on 11/8/23.
//

import Foundation

class Tag: Identifiable, ObservableObject {
    var name: String
    var children: [ Tag ]
    var parent: Tag?
    
    @Published var expanded = false
    
    var isLeaf: Bool { self.children.count == 0 }

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


