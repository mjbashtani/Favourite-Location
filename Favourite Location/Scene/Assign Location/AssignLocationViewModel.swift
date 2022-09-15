//
//  AssignLocationViewModel.swift
//  Favourite Location
//
//  Created by Mohammad Bashtani on 9/15/22.
//

import Foundation


final class AssignLocationViewModel {
    enum State {
        case pending
        case loading
        case failed
        case loaded
    }
    private var persons: [Person] = []
    private var selectedPersonCount = 0
    private let selectedLocaton: Location
    var locationsDidAssign : (([Person]) -> Void)?
    let loadPersons: ((@escaping (Result<[Person], Error>) -> Void) -> Void)
    var onChange: ((State) -> Void)?
    var isAnyPersonSelected: ((Bool) -> Void)?
   
    
    var numberOfItems: Int {
        persons.count
    }
    
    
    init(selectedLocation: Location, loadPersons: @escaping ((@escaping (Result<[Person], Error>) -> Void) -> Void)) {
        self.loadPersons = loadPersons
        self.selectedLocaton = selectedLocation
    }
    
    
    func viewDidLoad() {
        isAnyPersonSelected?(selectedPersonCount > 0)
    }
    
    func viewDidAppear() {
        getPersons()
    }
    
    func refrsh() {
        getPersons()
    }
    
    private func getPersons() {
        onChange?(.loading)
        loadPersons { [weak self] result in
            DispatchQueue.main.async {
                if let persons = try? result.get() {
                    self?.persons = persons
                    self?.onChange?(.loaded)
                } else {
                    self?.onChange?(.failed)
                }
            }
        }
    }
    
    func titleForIndex(index: Int) -> String {
        persons.map {
            $0.firstName + " " + $0.lastName
        }[index]
    }
    
    func select(at index: Int) {
        selectedPersonCount += 1
        isAnyPersonSelected?(selectedPersonCount > 0)
    }
    
    func deselect(at index: Int) {
        selectedPersonCount -= 1
        isAnyPersonSelected?(selectedPersonCount > 0)
    }
    
    func locationAssigned(to indexes: [Int]) {
         indexes.forEach { index in
            persons[index].addLocation(selectedLocaton)
        }
                                                                    
        locationsDidAssign?(persons)
    }
    
}
