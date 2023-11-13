//
//  ObservedObjectArray.swift
//  TagView
//
//  Created by Brian Batchelder on 11/11/23.
//  Adapted from (https://stackoverflow.com/a/57920136)
//

import Combine
import SwiftUI

class ObservableArray<T>: ObservableObject {

    @Published var array:[T] = []
    var cancellables = [AnyCancellable]()

    init(array: [T]) {
        self.array = array

    }

    func observeChildrenChanges<U: ObservableObject>() -> ObservableArray<U> {
        let array2 = array as! [U]
        array2.forEach({
            let c = $0.objectWillChange.sink(receiveValue: { _ in self.objectWillChange.send() })

            // Important: You have to keep the returned value allocated,
            // otherwise the sink subscription gets cancelled
            self.cancellables.append(c)
        })
        return self as! ObservableArray<U>
    }


}
