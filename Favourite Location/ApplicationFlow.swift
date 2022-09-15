//
//  ApplicationFlow.swift
//  Favourite Location
//
//  Created by Mohammad Bashtani on 9/15/22.
//

import Foundation
import UIKit
import CoreLocation

final class ApplicationFlow {
    internal init(personLoader: PersonLoader, locationFetcher: LocationFetcher, personCacher: PersonCacher) {
        self.personLoader = personLoader
        self.locationFetcher = locationFetcher
        self.personCasher = personCacher
    }
    
    private let personLoader: PersonLoader
    private let personCasher: PersonCacher
    private let locationFetcher: LocationFetcher
    weak var navigationController: UINavigationController?
    
    
    func start() -> UIViewController {
        let vc = ShowPersonLocationsComposer.composeShowPersonLocationUI(locationFetcher: locationFetcher, personLoader: personLoader)
        vc.onAddButtonTap = { [weak self] in
            guard let self = self else { return }
            vc.show(self.makeSelectLocationViewController(), sender: self)
        }
        let nav = UINavigationController(rootViewController: vc)
        self.navigationController = nav
        return nav
        
    }
    
    func makeSelectLocationViewController() -> SelectLocationViewController {
        let vc =  SelectLocationViewController(currentUserLocation: locationFetcher.lastFetchedLocation)
        vc.locationSelected = { loc in
            DispatchQueue.main.async {
                vc.show(self.makeAssignLocationViewController(selectedLocation: loc), sender: self)
            }
        }
        return vc
    }
    
    func makeAssignLocationViewController(selectedLocation: CLLocationCoordinate2D) -> AssignLocationViewController {
        let vc = AssignLocationComposer.composeAssignLocation(selectedLocation: selectedLocation, personLoader: personLoader, personCacher: personCasher) { [weak self] in
            DispatchQueue.main.async {
                self?.navigationController?.popToRootViewController(animated: true)
            }
        }
        vc.onAddButtonTap = {
            vc.showDetailViewController(self.makeEnterPersonInfoViewController {
                vc.refresh()
            }, sender: self)
        }
        return vc
    }
    
    func makeEnterPersonInfoViewController(completion: @escaping () -> Void) -> EnterPersonInfoViewController {
        EnterPersonInfoComposer.composeEnterPersonInfo(personLoader: personLoader, personCacher: personCasher, complitionHandler: { vc in
            DispatchQueue.main.async {
                vc.dismiss(animated: true)
                completion()
            }
        })
    }
}
