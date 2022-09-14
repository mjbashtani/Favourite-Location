//
//  Person.swift
//  Favourite Location
//
//  Created by Mohammad Javad Bashtani on 6/20/1401 AP.
//

import Foundation

struct Person: Equatable, Hashable {
    let id: String
    let firstName: String
    let lastName: String
    let locations: [Location]
    
}
