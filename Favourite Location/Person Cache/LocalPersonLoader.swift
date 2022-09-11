//
//  LocalPersonLoader.swift
//  Favourite Location
//
//  Created by Mohammad Javad Bashtani on 6/20/1401 AP.
//

import Foundation

class LocalPersonLoader {
    let store: PersonStore
    
    init(store: PersonStore) {
       self.store = store
   }
}

private extension Array where Element == Person {
    func toLocal() -> [LocalPerson] {
        return map { LocalPerson(id: $0.id, firstName: $0.firstName, lastName: $0.lastName, location: $0.location.toLocal()) }
    }
}

private extension Array where Element == LocalPerson {
    func toModels() -> [Person] {
        return map { Person(id: $0.id, firstName: $0.firstName, lastName: $0.lastName, location: $0.location.toModel()) }
    }
}

private extension Location {
    func toLocal() -> LocalLocation {
        .init(latitude: self.latitude, longitude: self.longitude)
    }
}

private extension LocalLocation {
    func toModel() -> Location {
        .init(latitude: self.latitude, longitude: self.longitude)
    }
}

extension LocalPersonLoader {
    public typealias SaveResult = Error?
    
    func save(peapole: [Person], completion: @escaping (SaveResult) -> Void) {
        store.insert(peapole.toLocal(), completion: completion)
    }
}
