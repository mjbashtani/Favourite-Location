//
//  LocationCacher.swift
//  Favourite Location
//
//  Created by Mohammad Bashtani on 9/14/22.
//

import Foundation

protocol PersonCacher {
    typealias SaveResult = Error?
    func save(peapole: [Person], completion: @escaping (SaveResult) -> Void)
}
