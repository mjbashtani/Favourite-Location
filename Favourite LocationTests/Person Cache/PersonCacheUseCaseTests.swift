//
//  PersonCacheUseCaseTests.swift
//  Favourite LocationTests
//
//  Created by Mohammad Javad Bashtani on 6/20/1401 AP.
//

import XCTest
@testable import Favourite_Location

class LocalPersonLoader {
    let store: PersonStore
    
    init(store: PersonStore) {
       self.store = store
   }
}

private extension Array where Element == Person {
    func toLocal() -> [LocalPerson] {
        return map { LocalPerson(firstName: $0.firstName, lastName: $0.lastName, location: $0.location.toLocal()) }
    }
}

private extension Array where Element == LocalPerson {
    func toModels() -> [Person] {
        return map { Person(firstName: $0.firstName, lastName: $0.lastName, location: $0.location.toModel()) }
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

class PersonStoreSpy: PersonStore {
    enum ReceivedMessage {
        case insert([LocalPerson])
    }
    private(set) var messages: [ReceivedMessage] = []
    private var insertionCompletions: [InsertionCompletion] = []
  
    func insert(_ peapole: [LocalPerson], completion: @escaping InsertionCompletion) {
        messages.append(.insert(peapole))
        insertionCompletions.append(completion)
    }
    
    func retrieve(completion: @escaping RetrievalCompletion) {
        
    }
    
    func completeInsertion(with error: Error, at index: Int = 0) {
        insertionCompletions[index](error)
    }
    
}

class PersonCacheUseCaseTests: XCTestCase {
    
    func test_init_doesNotMessageStoreUponCreation() {
        let store = PersonStoreSpy()
        _ = LocalPersonLoader(store: store)
        XCTAssertTrue(store.messages.isEmpty)
    }
    
    func test_init_failsOnInsertaionError() {
        let store = PersonStoreSpy()
        let sut = LocalPersonLoader(store: store)
        let error = anyNSError()
        let exceptaion = XCTestExpectation(description: "Wait for Insert completion")
      
    }

}

func anyNSError() -> NSError {
    return NSError(domain: "any error", code: 0)
}
