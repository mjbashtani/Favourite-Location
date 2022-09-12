//
//  PersonViewModel.swift
//  Favourite Location
//
//  Created by Mohammad Javad Bashtani on 6/21/1401 AP.
//

import Foundation

final class PersonCellViewModel {
    typealias Observer<T> = (T) -> Void
    let name: String
    let lastName: String
    var onSelection: Observer<Bool>?
    
    init(name: String, lastName: String) {
        self.name = name
        self.lastName = lastName
    }
    
    func select() {
        onSelection?(true)
    }
    
    func deselect() {
        onSelection?(false)
    }
}
