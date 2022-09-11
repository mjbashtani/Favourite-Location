//
//  PersonStoreSpy.swift
//  Favourite LocationTests
//
//  Created by Mohammad Javad Bashtani on 6/20/1401 AP.
//

import Foundation
@testable import Favourite_Location

class PersonStoreSpy: PersonStore {
    enum ReceivedMessage: Equatable {
        case insert([LocalPerson])
        case retrieve
    }
    private(set) var receivedMessages: [ReceivedMessage] = []
    private var insertionCompletions: [InsertionCompletion] = []
    private var retrievalCompletions: [RetrievalCompletion] = []
    
    func insert(_ peapole: [LocalPerson], completion: @escaping InsertionCompletion) {
        receivedMessages.append(.insert(peapole))
        insertionCompletions.append(completion)
    }
    
    func retrieve(completion: @escaping RetrievalCompletion) {
        receivedMessages.append(.retrieve)
        retrievalCompletions.append(completion)
    }
    
    func completeInsertion(with error: Error, at index: Int = 0) {
        insertionCompletions[index](error)
    }
    
    func completeInsertionSuccessfully(at index: Int = 0) {
        insertionCompletions[index](nil)
    }
    
    func completeRetrieval(with error: Error ,at index: Int = 0) {
        retrievalCompletions[index](.failure(error))
    }
    
    func completeRetrievalWithEmptyCache(at index: Int = 0) {
        retrievalCompletions[index](.empty)
    }
    
    func completeRetrieval(with persons: [LocalPerson], at index: Int = 0) {
        retrievalCompletions[index](.found(peapole: persons))
    }
    
}
