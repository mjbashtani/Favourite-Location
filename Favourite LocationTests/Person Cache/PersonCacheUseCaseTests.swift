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

class PersonStoreSpy: PersonStore {
    private(set) var messages: [Any] = []
    func deleteCachedPerson(completion: @escaping DeletionCompletion) {
        
    }
    
    func insert(_ peapole: [LocalPerson], timestamp: Date, completion: @escaping InsertionCompletion) {
        
    }
    
    func retrieve(completion: @escaping RetrievalCompletion) {
        
    }
    
    
}

class PersonCacheUseCaseTests: XCTestCase {
    
    func test_init_doesNotMessageStoreUponCreation() {
        let store = PersonStoreSpy()
        _ = LocalPersonLoader(store: store)
        XCTAssertTrue(store.messages.isEmpty)
    }

}
