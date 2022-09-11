//
//  CodablePersonStore.swift
//  Favourite Location
//
//  Created by Mohammad Javad Bashtani on 6/20/1401 AP.
//

import Foundation

public class CodablePersonStore: PersonStore {
    
    private struct CodablePerson: Codable {
        let id: String
        let firstName: String
        let lastName: String
        let latidude: Double
        let longitude: Double
        
        init(_ person: LocalPerson) {
            id = person.id
            firstName = person.firstName
            lastName = person.lastName
            latidude = person.location.latitude
            longitude = person.location.longitude
        }
        
        var local: LocalPerson {
            return .init(id: self.id, firstName: self.firstName, lastName: self.lastName, location: .init(latitude: latidude, longitude: longitude))
        }
    }
    
    private let queue = DispatchQueue(label: "\(CodablePersonStore.self)Queue", qos: .userInitiated, attributes: .concurrent)
    private let storeURL: URL
    
     init(storeURL: URL) {
        self.storeURL = storeURL
    }
    
     func retrieve(completion: @escaping RetrievalCompletion) {
        let storeURL = self.storeURL
        queue.async {
            guard let data = try? Data(contentsOf: storeURL) else {
                return completion(.empty)
            }
            
            do {
                let decoder = JSONDecoder()
                let cache = try decoder.decode([CodablePerson].self, from: data)
                completion(.found(peapole: cache.map(\.local)))
            } catch {
                completion(.failure(error))
            }
        }
    }
    
     func insert(_ peapole: [LocalPerson], completion: @escaping InsertionCompletion) {
        let storeURL = self.storeURL
        queue.async(flags: .barrier) {
            do {
                let encoder = JSONEncoder()
                let cache = peapole.map(CodablePerson.init)
                let encoded = try encoder.encode(cache)
                try encoded.write(to: storeURL)
                completion(nil)
            } catch {
                completion(error)
            }
        }
    }
    
}
