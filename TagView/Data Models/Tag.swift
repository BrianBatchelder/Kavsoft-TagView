//
//  Tag.swift
//  TagView
//
//  Created by Brian Batchelder on 11/8/23.
//

import Foundation

class Tag: Identifiable {
    var name: String
    var children: [ Tag ]
    var parent: Tag?
    
    let id = UUID()
    
    init(name: String, parent: Tag? = nil, children: [ Tag ] = []) {
        self.name = name
        self.parent = parent
        self.children = children
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


