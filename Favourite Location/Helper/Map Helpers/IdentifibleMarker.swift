//
//  IdentifibleMarker.swift
//  Favourite Location
//
//  Created by Mohammad Bashtani on 9/13/22.
//

import GoogleMaps

class IdentifibleMarker: GMSMarker {
    let ownerID: String
    
    init(ownerID: String) {
        self.ownerID = ownerID
        super.init()
    }
}


