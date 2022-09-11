//
//  PersonCacheHelper.swift
//  Favourite LocationTests
//
//  Created by Mohammad Javad Bashtani on 6/20/1401 AP.
//

import Foundation
@testable import Favourite_Location

func anyNSError() -> NSError {
    return NSError(domain: "any error", code: 0)
}

func uniquePerson() -> Person {
    .init(id: UUID().uuidString, firstName: "", lastName: "", location: .init(latitude: 0, longitude: 0))
}

func uniquePersons() -> (local: [LocalPerson], models: [Person]) {
    let persons = [uniquePerson()]
    return (persons.map {
        .init(id: $0.id, firstName: $0.firstName, lastName: $0.lastName, location: .init(latitude: $0.location.latitude, longitude: $0.location.longitude))
    }, persons)
}

