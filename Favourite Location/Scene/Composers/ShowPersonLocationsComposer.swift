//
//  ShowPersonLocationsComposer.swift
//  Favourite Location
//
//  Created by Mohammad Bashtani on 9/15/22.
//

import Foundation

final class ShowPersonLocationsComposer {
    
    static func composeShowPersonLocationUI(locationFetcher: LocationFetcher, personLoader: PersonLoader) -> ShowPersonLocationViewController {
        let markerController = MarkerController()
        let mapViewController = GMMapViewController(markerController: markerController)
        let personListViewController = PersonListViewController()
        locationFetcher.userLocationUpdated = { [weak mapViewController, weak markerController] location  in
            DispatchQueue.main.async {
                mapViewController?.currentUserLocation = location
            }
            markerController?.currentLocation = location
        }
        mapViewController.onViewDidLoad = { [weak locationFetcher] in
            locationFetcher?.start()
        }
        markerController.mapView = mapViewController
        adaptPersonListViewControllerToPersonLoader(personListViewController, personLoader: personLoader, markerController: markerController)
        let containerView = ShowPersonLocationViewController()
        containerView.add(child: personListViewController, container: containerView.personListContainerView)
        containerView.add(child: mapViewController, container: containerView.mapContainerView)
        return containerView
        
    }
    
    private static func adaptPersonListViewControllerToPersonLoader(_ vc: PersonListViewController, personLoader: PersonLoader, markerController: MarkerController) {
        vc.loadData = { [personLoader, weak vc] in
            vc?.display(isLoading: true)
            personLoader.load { res in
                DispatchQueue.main.async {
                    vc?.display(isLoading: false)
                    if let persons = try? res.get() {
                        vc?.display(persons.map {
                            makeCellController(person: $0, markerController: markerController)
                        })
                        let selectedPersons = vc?.selectedIndexes.map(\.row).map {
                            persons[$0]
                        } ?? []
                        reloadMarkers(markerController: markerController, persons: selectedPersons)
                    }
                }
                
                
            }
            
        }
    }
    
    private static func reloadMarkers(markerController: MarkerController, persons: [Person]) {
        markerController.deleteAllMarkers()
        persons.forEach { person in
            person.locations.forEach { loc in
                markerController.addMarker(with: loc, id: person.id, title: person.firstName)
            }
        }
    }
    
    private static func makeCellController(person: Person, markerController: MarkerController) -> CellController {
        let vm = PersonCellViewModel(name: person.firstName, lastName: person.lastName)
        let personCellController = PersonCellController(viewModel: vm)
        personCellController.selection = { [weak markerController] in
            person.locations.forEach { location in
                markerController?.addMarker(with: location, id: person.id, title: person.firstName)
            }
        }
        
        personCellController.deselection = { [weak markerController] in
            markerController?.deleteMarker(with: person.id)
        }
        let cellController = CellController(id: person.id, personCellController)
        return cellController
    }
}
