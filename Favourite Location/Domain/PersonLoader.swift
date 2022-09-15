//
//  PersonLoader.swift
//  Favourite Location
//
//  Created by Mohammad Javad Bashtani on 6/20/1401 AP.
//

import Foundation

protocol PersonLoader {
    typealias Result = Swift.Result<[Person], Error>
    func load(completion: @escaping (Result) -> Void)
}
