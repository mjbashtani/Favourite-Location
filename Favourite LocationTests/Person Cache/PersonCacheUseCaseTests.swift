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

class PersonStoreSpy: PersonStore {
    enum ReceivedMessage: Equatable {
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
    
    func completeInsertionSuccessfully(at index: Int = 0) {
        insertionCompletions[index](nil)
    }
    
}

class PersonCacheUseCaseTests: XCTestCase {
    
    func test_init_doesNotMessageStoreUponCreation() {
        let (_, store) = makeSUT()
        XCTAssertTrue(store.messages.isEmpty)
    }
    
    func test_init_failsOnInsertaionError() {
        let (sut, store) = makeSUT()
        let error = anyNSError()
        expect(sut, toCompleteWithError: error) {
            store.completeInsertion(with: error)
        }
    }
    
    func test_save_succeedsOnSuccessfulCacheInsertion() {
        let (sut, store) = makeSUT()
        expect(sut, toCompleteWithError: nil) {
            store.completeInsertionSuccessfully()
        }
    }
    
    private func makeSUT() -> (sut: LocalPersonLoader, store: PersonStoreSpy) {
        let store = PersonStoreSpy()
        let sut = LocalPersonLoader(store: store)
        return (sut, store)
    }
    
    private func expect(_ sut: LocalPersonLoader, toCompleteWithError expectedError: NSError?, when action: () -> Void, file: StaticString = #file, line: UInt = #line) {
        let exp = expectation(description: "Wait for save completion")
        
        var receivedError: Error?
        sut.save(peapole: uniquePersons().models) { error in
            receivedError = error
            exp.fulfill()
        }
        
        action()
        wait(for: [exp], timeout: 1.0)
        
        XCTAssertEqual(receivedError as NSError?, expectedError, file: file, line: line)
    }
}

