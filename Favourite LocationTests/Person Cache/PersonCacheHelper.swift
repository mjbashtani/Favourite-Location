//
//  PersonCacheHelper.swift
//  Favourite LocationTests
//
//  Created by Mohammad Javad Bashtani on 6/20/1401 AP.
//

import Foundation

func anyNSError() -> NSError {
    return NSError(domain: "any error", code: 0)
}

func uniquePerson() -> Person {
    .init(id: UUID().uuidString, firstName: "", lastName: "", location: .init(latitude: 0, longitude: 0))
}


