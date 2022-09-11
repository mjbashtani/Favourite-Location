//
//  PersonRetrieveCacheUseCaseTests.swift
//  Favourite LocationTests
//
//  Created by Mohammad Javad Bashtani on 6/20/1401 AP.
//

import XCTest
@testable import Favourite_Location

class PersonRetrieveCacheUseCaseTests: XCTestCase {
    
    func test_init_doesNotMessageStoreUponCreation() {
        let (_, store) = makeSUT()
        
        XCTAssertEqual(store.receivedMessages, [])
    }
    
    func test_load_requestsCacheRetrieval() {
        let (sut, store) = makeSUT()
        
        sut.load { _ in }
        
        XCTAssertEqual(store.receivedMessages, [.retrieve])
    }
    
    func test_load_failsOnRetrievalError() {
        let (sut, store) = makeSUT()
        let retrievalError = anyNSError()
        
        expect(sut, toCompleteWith: .failure(retrievalError), when: {
            store.completeRetrieval(with: retrievalError)
        })
    }
    
    func test_load_deliversNoImagesOnEmptyCache() {
        let (sut, store) = makeSUT()
        
        expect(sut, toCompleteWith: .success([]), when: {
            store.completeRetrievalWithEmptyCache()
        })
    }
    
    func test_load_deliversCachedImagesOnNonExpiredCache() {
        let persons = uniquePersons()
        let (sut, store) = makeSUT()
        expect(sut, toCompleteWith: .success(persons.models), when: {
            store.completeRetrieval(with: persons.local)
        })
    }
    
   
    
    // MARK: - Helpers
    
    private func makeSUT( file: StaticString = #file, line: UInt = #line) -> (sut: LocalPersonLoader, store: PersonStoreSpy) {
        let store = PersonStoreSpy()
        let sut = LocalPersonLoader(store: store)
        return (sut, store)
    }
    
    private func expect(_ sut: LocalPersonLoader, toCompleteWith expectedResult: LocalPersonLoader.LoadResult, when action: () -> Void, file: StaticString = #file, line: UInt = #line) {
        let exp = expectation(description: "Wait for load completion")
        
        sut.load { receivedResult in
            switch (receivedResult, expectedResult) {
            case let (.success(receivedPersons), .success(expectedPersons)):
                XCTAssertEqual(receivedPersons, expectedPersons, file: file, line: line)
            
            case let (.failure(receivedError as NSError), .failure(expectedError as NSError)):
                XCTAssertEqual(receivedError, expectedError, file: file, line: line)
                
            default:
                XCTFail("Expected result \(expectedResult), got \(receivedResult) instead", file: file, line: line)
            }
            
            exp.fulfill()
        }
        
        action()
        wait(for: [exp], timeout: 1.0)
    }

}
