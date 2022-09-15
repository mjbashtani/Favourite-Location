//
//  AssignLocationComposer.swift
//  Favourite Location
//
//  Created by Mohammad Bashtani on 9/15/22.
//

import Foundation
import CoreLocation

final class AssignLocationComposer {
    static func composeAssignLocation(selectedLocation: CLLocationCoordinate2D, personLoader: PersonLoader, personCacher: PersonCacher, complitionHandler: @escaping () -> Void) -> AssignLocationViewController {
        let vm = AssignLocationViewModel(selectedLocation: .init(latitude: selectedLocation.latitude, longitude: selectedLocation.longitude),loadPersons: personLoader.load(completion: ))
        let vc = AssignLocationViewController(viewModel: vm)
        vm.locationsDidAssign = { persons in
            personCacher.save(peapole: persons, completion: {_ in
                complitionHandler()
            })
        }
        return vc
    }
}
