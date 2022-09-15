//
//  EnterPersonInfoComposer.swift
//  Favourite Location
//
//  Created by Mohammad Bashtani on 9/15/22.
//

import Foundation
import UIKit

final class EnterPersonInfoComposer {
    static func composeEnterPersonInfo(personLoader: PersonLoader, personCacher: PersonCacher, complitionHandler: @escaping (UIViewController) -> Void) -> EnterPersonInfoViewController {
        let vc = EnterPersonInfoViewController()
        vc.infoDidEnter = { info in
            let person = Person(id: UUID().uuidString, firstName: info.firstName, lastName: info.lastName, locations: [])
            personLoader.load { res in
                if var persons = try? res.get() {
                    persons.append(person)
                    personCacher.save(peapole: persons, completion: { _ in
                        complitionHandler(vc)
                    })
                }
            }
        }
        return vc
    }
}
